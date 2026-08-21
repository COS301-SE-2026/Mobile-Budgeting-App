import 'dart:convert';
import 'dart:math';
import 'package:flutter_gemma/flutter_gemma.dart';
import '../../models/import/candidate_row.dart';
import '../../models/import/statement_schema.dart';
import 'schema_discovery_service.dart';

class LlmSchemaClassifier implements SchemaClassifier {
  static const  int  _maxSampleRows = 4;
  static const int _maxDescriptionLength = 40;
  static const int _tokenBuffer = 64;
  static const int _modelMaxTokens = 2024;
  static const double _temperature =0.0;
  static const int _topK = 1;
  final Future<InferenceModel> Function() _modelProvider;

  LlmSchemaClassifier({ Future<InferenceModel> Function()? modelProvider}) 
  : _modelProvider = modelProvider ?? _defaultModelProvider;

  static const String _modelFileName = 'gemma3-1b-it-int4.task';
  static const String _modelUrl = 'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/$_modelFileName';

  static Future<InferenceModel> _defaultModelProvider() async {


    final installed = await FlutterGemma.isModelInstalled(_modelFileName);
    if( !installed) {
      await FlutterGemma.installModel(
        modelType: ModelType.gemmaIt,
        fileType: ModelFileType.task,
      ).fromNetwork(_modelUrl).install();
    }
    return FlutterGemma.getActiveModel(
      maxTokens: _modelMaxTokens,
      preferredBackend: PreferredBackend.cpu,
    );
  }

  @override
  Future<StatementSchema> classify(List<CandidateRow> sampleRows) async {
    if (sampleRows.isEmpty) {
      return const StatementSchema(signConvention: SignConvention.keywordBased);
    }

    final markers = sampleRows
        .map((r) => r.signMarker?.toUpperCase())
        .whereType<String>()
        .toSet();

    if (markers.contains('DEBIT') || markers.contains('CREDIT')) {
      return const StatementSchema(signConvention: SignConvention.separateDebitCredit);
    }
    if (markers.contains('CR') && !markers.contains('-')) {
      return const StatementSchema(signConvention: SignConvention.crSuffixMeansIncome);
    }
    if (markers.contains('-') && !markers.contains('CR')) {
      return const StatementSchema(signConvention: SignConvention.minusPrefixMeansExpense);
    }

    InferenceModel? model;


    try {
      final rows = sampleRows.length > _maxSampleRows ? sampleRows.sublist(0, _maxSampleRows)
      : sampleRows;

      model = await _modelProvider();
      final chat = await model.createChat(
        temperature: _temperature,
        randomSeed: 1,
        topK: _topK,
        maxOutputTokens: _tokenBuffer,
        systemInstruction: _systemInstruction,
      );

    
        await chat.addQueryChunk(
          Message.text(text: _buildPrompt(rows), isUser: true),
        );

        final response = await chat.generateChatResponse();
        final rawResponse = _extractResponseText(response);
        print('LlmSchemaClassifier raw response: $rawResponse');

        return _parseResponse(rawResponse);
    } catch (e) {
      print('LlmSchemaClassifier classify() failed: $e');

      return const StatementSchema(signConvention: SignConvention.keywordBased);

    } finally {
      await model?.close();
    }
  }


  static const String _systemInstruction = '''
      Classify a bank statement's sign convention. Return ONLY one JSON object, nothing else — no explanation, no markdown.

      Allowed signConvention values, exactly as spelled:
      crSuffixMeansIncome, minusPrefixMeansExpense, separateDebitCredit, signedAmount, keywordBased

      Rules:
      - CR suffix marks income, unmarked/no-CR is expense -> crSuffixMeansIncome
      - "-" marks expense, unmarked is income -> minusPrefixMeansExpense
      - explicit CREDIT/DEBIT or IN/OUT type markers -> separateDebitCredit
      - amount's own +/- sign carries the meaning -> signedAmount
      - no structural signal at all -> keywordBased

      Stop immediately after the closing brace.
      Example: rows show "200.00 CR" and "7.50" (no suffix) -> {"signConvention":"crSuffixMeansIncome","skipLinePatterns":[]}''';



String _buildPrompt(List<CandidateRow> rows) {
  final buffer = StringBuffer();



  buffer.writeln('Classify the bank statement sign convention.');
  buffer.writeln('Return JSON only.');
  buffer.writeln();
  buffer.writeln('Allowed values:');
  buffer.writeln('- crSuffixMeansIncome');
  buffer.writeln('- minusPrefixMeansExpense');
  buffer.writeln('- separateDebitCredit');
  buffer.writeln('- signedAmount');
  buffer.writeln('- keywordBased');
  buffer.writeln();
  buffer.writeln('The amount is absolute. Use signMarker and description only.');
  buffer.writeln();
  buffer.writeln('Rows:');

  for (var i = 0; i < rows.length; i++) {
    final row = rows[i];
    var description = row.description.trim();

    if (description.length > _maxDescriptionLength) {
      description = '${description.substring(0, _maxDescriptionLength)}...';
    }

    buffer.writeln(
      '${i + 1}. '
      'amount=${row.absAmount}; '
      'marker=${_quote(row.signMarker ?? '')}; '
      'description=${_quote(description)}',
    );
  }

  buffer.writeln();
  buffer.writeln('{"signConvention":"<allowed value>","skipLinePatterns":[]}');

  return buffer.toString();
}

  static String _quote(String value) => jsonEncode(value);  

  String _extractResponseText(Object response) {
    if (response is TextResponse) {
      return response.token;
    }
    throw FormatException(
      'Expected TextResponse but received ${response.runtimeType}',
    );
  }

  StatementSchema _parseResponse(String response) {
    try {
      final jsonObject = _extractJsonObject(response);
      final decoded = jsonDecode(jsonObject);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('LLM response is not a JSON object');
      }
      final signConventionValue = decoded['signConvention'];
      if (signConventionValue is! String) {
        throw const FormatException( 'Missing signConvention in LLM response');
      }
      final signConvention = _parseSignConvention(signConventionValue);
      final skipLinePatterns = _parseSkipLinePatterns(decoded['skipLinePatterns']);

      return StatementSchema(
        signConvention: signConvention,
        skipLinePatterns: skipLinePatterns,
      );
    } catch (_) {
      return const StatementSchema(signConvention: SignConvention.keywordBased);
    }
  }

  String _extractJsonObject(String response) {
    var cleaned = response.trim();
    cleaned = cleaned.replaceAll(
      RegExp(r'^```(?:json)?\s*', caseSensitive: false),
      '',
    );

    cleaned = cleaned.replaceAll( RegExp(r'\s*```$'), '');
    cleaned = cleaned.trim();

    try {
      final decoded = jsonDecode(cleaned);
      if (decoded is Map<String, dynamic>) {
        return jsonEncode(decoded);
      }
    } catch (_) {
    }

    final start = cleaned.indexOf('{');
    if (start < 0) {
      throw const FormatException('No JSON object found');
    }

    var depth = 0;
    var inString = false;
    var escaped = false;
    for (var i = start; i < cleaned.length; i++) {
      final char = cleaned[i];
      if (escaped) {
        escaped = false;
        continue;
      }
      if (char == '\\' && inString) {
        escaped = true;
        continue;
      }

      if (char == '"') {
        inString = !inString;
        continue;
      }

      if (inString) {
        continue;
      }

      if (char == '{') {
        depth++;
      } else if (char == '}') {
        depth--;

        if (depth == 0) {
          return cleaned.substring(start, i + 1);
        }
      }
    }

    throw const FormatException('NOt terminated JSON object in LLM response');
  }


  static const Map<String, SignConvention> _aliases = {
    'cr': SignConvention.crSuffixMeansIncome,
    'minus': SignConvention.minusPrefixMeansExpense,
    'signed': SignConvention.signedAmount,
    'keyword': SignConvention.keywordBased,
    'debitcredit': SignConvention.separateDebitCredit,
    'creditdebit': SignConvention.separateDebitCredit,
  };

  SignConvention _parseSignConvention(String value) {
    final normalised = value.trim();
    for (final convention in SignConvention.values) {
      if (convention.name == normalised) {
        return convention;
      }
    }
    final key = normalised.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    final alias = _aliases[key];
    if(alias != null) return alias;
    throw FormatException('Unknown sign convention returned by LLM: $value');

  }

  List<String> _parseSkipLinePatterns(Object? value) {
    if (value == null) {
      return const [];
    }

    if (value is! List) {
      throw const FormatException(
        'skipLinePatterns must be a JSON array',
      );
    }

    return value
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .take(20)
        .toList(growable: false);
  }
}