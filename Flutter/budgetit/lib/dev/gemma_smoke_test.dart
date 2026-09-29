import 'package:flutter_gemma/flutter_gemma.dart';

const String _modelUrl =
    'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/'
    'gemma3-1b-it-int4.task';

Future<void> runGemmaSmokeTest() async {
  print('Gemma smoke test: checking if model is already installed...');

  final alreadyInstalled = await FlutterGemma.isModelInstalled(
    'Gemma3-1B-IT_multi-prefill-seq_q4_ekv4096.litertlm',
  );

  if (!alreadyInstalled) {
    print('Gemma smoke test: downloading model (this can take a while)...');
    await FlutterGemma.installModel(
      modelType: ModelType.gemmaIt,
      fileType: ModelFileType.task,
      )
        .fromNetwork(_modelUrl)
        .withProgress((progress) => print('Gemma smoke test: $progress%'))
        .install();
    print('Gemma smoke test: download complete.');
  } else {
    print('Gemma smoke test: model already installed, skipping download.');
  }

  print('Gemma smoke test: loading model...');
  final model = await FlutterGemma.getActiveModel(
    maxTokens: 1024,
    preferredBackend: PreferredBackend.cpu,
  );
  print('Gemma smoke test: model loaded.');

  final chat = await model.createChat();
  await chat.addQueryChunk(Message.text(
    text: 'Reply with exactly one word: hello.',
    isUser: true,
  ));

  print('Gemma smoke test: generating response...');
  final response = await chat.generateChatResponse();
  print('Gemma smoke test: RESPONSE = "$response"');

  await model.close();
  print('Gemma smoke test: done.');
}