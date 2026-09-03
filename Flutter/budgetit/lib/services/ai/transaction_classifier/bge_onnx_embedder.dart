import 'dart:typed_data';

import 'package:bert_tokenizer/bert_tokenizer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';

import 'text_embedder.dart';
import 'vector_similarity.dart';

final class BgeOnnxEmbedder implements TextEmbedder {
  static const String _modelAsset =
      'assets/models/bge-small-en-v1.5/model.onnx';

  static const String _vocabAsset = 'assets/models/bge-small-en-v1.5/vocab.txt';

  static const int _maximumSequenceLength = 96;

  final OnnxRuntime _runtime = OnnxRuntime();

  OrtSession? _session;
  BertTokenizer? _tokenizer;

  @override
  String get modelVersion => 'bge-small-en-v1.5-base-1';

  @override
  int get embeddingSize => 384;

  bool get isInitialized => _session != null && _tokenizer != null;

  List<String> get inputNames => _session?.inputNames ?? const [];

  List<String> get outputNames => _session?.outputNames ?? const [];

  @override
  Future<void> initialize() async {
    if (isInitialized) {
      return;
    }

    final vocabulary = await rootBundle.loadString(_vocabAsset);

    _tokenizer = BertTokenizer.fromStringContent(vocabulary);

    _session = await _runtime.createSessionFromAsset(_modelAsset);

    // These diagnostic messages confirm the actual exported ONNX contract.
    // They can be removed after the integration has been verified.
    // ignore: avoid_print
    print('BGE input names: ${_session!.inputNames}');
    // ignore: avoid_print
    print('BGE output names: ${_session!.outputNames}');

    try {
      final inputInfo = await _session!.getInputInfo();
      final outputInfo = await _session!.getOutputInfo();

      // ignore: avoid_print
      print('BGE input info: $inputInfo');
      // ignore: avoid_print
      print('BGE output info: $outputInfo');
    } catch (error) {
      // Input/output metadata is diagnostic only.
      // ignore: avoid_print
      print('BGE metadata inspection unavailable: $error');
    }
  }

  @override
  Future<Float32List> embed(String text) async {
    final results = await embedBatch([text]);
    return results.single;
  }

  @override
  Future<List<Float32List>> embedBatch(List<String> texts) async {
    if (!isInitialized) {
      throw StateError(
        'BgeOnnxEmbedder.initialize() must be called before embedding.',
      );
    }

    if (texts.isEmpty) {
      return const [];
    }

    final results = <Float32List>[];

    // @Donny: Please note
    // This first implementation processes one item at a time.
    // Proper model batching can be added after correctness is verified.
    for (final text in texts) {
      results.add(await _embedSingle(text));
    }

    return results;
  }

  Future<Float32List> _embedSingle(String text) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty) {
      throw ArgumentError.value(text, 'text', 'Text cannot be empty.');
    }

    final tokenizer = _tokenizer!;
    final session = _session!;

    final encoded = tokenizer.prepareNerInput(
      cleanText,
      _maximumSequenceLength,
    );

    final createdInputs = <OrtValue>[];
    final outputs = <String, OrtValue>{};

    try {
      final inputs = <String, OrtValue>{};

      if (session.inputNames.contains('input_ids')) {
        final value = await OrtValue.fromList(
          Int64List.fromList(encoded.inputIds),
          [1, _maximumSequenceLength],
        );
        createdInputs.add(value);
        inputs['input_ids'] = value;
      }

      if (session.inputNames.contains('attention_mask')) {
        final value = await OrtValue.fromList(
          Int64List.fromList(encoded.inputMask),
          [1, _maximumSequenceLength],
        );
        createdInputs.add(value);
        inputs['attention_mask'] = value;
      }

      if (session.inputNames.contains('token_type_ids')) {
        final value = await OrtValue.fromList(
          Int64List.fromList(encoded.segmentIds),
          [1, _maximumSequenceLength],
        );
        createdInputs.add(value);
        inputs['token_type_ids'] = value;
      }

      if (inputs.isEmpty) {
        throw StateError(
          'None of the expected BERT inputs were found. '
          'Actual inputs: ${session.inputNames}',
        );
      }

      outputs.addAll(await session.run(inputs));

      if (outputs.isEmpty) {
        throw StateError('The ONNX model returned no outputs.');
      }

      final output = _selectEmbeddingOutput(outputs);
      final flattened = await output.asFlattenedList();

      final vector = _extractSentenceVector(
        values: flattened,
        shape: output.shape,
      );

      if (vector.length != embeddingSize) {
        throw StateError(
          'Expected $embeddingSize embedding values, '
          'but received ${vector.length}.',
        );
      }

      return l2Normalize(vector);
    } finally {
      for (final value in outputs.values) {
        await value.dispose();
      }

      for (final value in createdInputs) {
        await value.dispose();
      }
    }
  }

  OrtValue _selectEmbeddingOutput(Map<String, OrtValue> outputs) {
    const preferredNames = [
      'sentence_embedding',
      'last_hidden_state',
      'token_embeddings',
    ];

    for (final name in preferredNames) {
      final output = outputs[name];

      if (output != null) {
        return output;
      }
    }

    return outputs.values.first;
  }

  Float32List _extractSentenceVector({
    required List<dynamic> values,
    required List<int> shape,
  }) {
    final numericValues = values.cast<num>();

    if (shape.length == 3 && shape.last == embeddingSize) {
      // Shape: [batch, sequenceLength, 384].
      // The first 384 values are token zero, the CLS token.
      return Float32List.fromList(
        numericValues
            .take(embeddingSize)
            .map((value) => value.toDouble())
            .toList(),
      );
    }

    if (shape.length == 2 && shape.last == embeddingSize) {
      // Shape: [batch, 384]. Pooling happened inside the model.
      return Float32List.fromList(
        numericValues
            .take(embeddingSize)
            .map((value) => value.toDouble())
            .toList(),
      );
    }

    throw StateError(
      'Unsupported ONNX output shape $shape. '
      'Expected [batch, sequenceLength, $embeddingSize] '
      'or [batch, $embeddingSize].',
    );
  }

  @override
  Future<void> dispose() async {
    await _session?.close();
    _session = null;
    _tokenizer = null;
  }
}
