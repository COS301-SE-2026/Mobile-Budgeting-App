import 'dart:io';

import 'package:budgetit/config/app_config.dart';
import 'package:budgetit/services/ai/transaction_classifier/dio_model_download_adapter.dart';
import 'package:budgetit/services/ai/transaction_classifier/model_download_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Downloads and installs the fine tuned embedding model
final class FineTunedBgeModelDownloader {
  static const String _modelDirName = 'bge-small-en-finetuned-v0.1';

  static const String _markerFileName = '.install-complete';

  /// S3 file name to local file name.
  static const Map<String, String> _requiredFiles = <String, String>{
    'model.onnx': 'model.onnx',
    'tokenizer.json': 'tokenizer.json',
    'vocab.txt': 'vocab.txt',
  };

  static Future<void>? _inFlight;

  /// Absolute path to the folder containing the model files.
  static Future<String> get modelPath async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/models/bge/$_modelDirName';
  }

  /// Whether a download is currently running.
  static bool get isDownloading => _inFlight != null;

  /// Whether a completed model install is present on disk.
  static Future<bool> isModelInstalled() async {
    final path = await modelPath;

    if (!await Directory(path).exists()) {
      return false;
    }

    if (!await File('$path/$_markerFileName').exists()) {
      return false;
    }

    return File('$path/model.onnx').exists();
  }

  /// Downloads the model if it is not already installed.
  ///
  /// Multiple calls share a single download. Throws if the download fails.
  ///
  static Future<void> ensureModelDownloaded() {
    return _inFlight ??= _download().whenComplete(() => _inFlight = null);
  }

  static Future<void> _download() async {
    if (await isModelInstalled()) {
      return;
    }

    final path = await modelPath;
    final localDir = Directory(path);
    await localDir.create(recursive: true);

    final marker = File('$path/$_markerFileName');
    if (await marker.exists()) {
      await marker.delete();
    }

    final ModelDownloadAdapter downloader = DioModelDownloadAdapter();

    try {
      for (final entry in _requiredFiles.entries) {
        final source = Uri.parse('${AppConfig.bgeModelBaseUrl}/${entry.key}');

        await downloader.download(
          source: source,
          destination: File('$path/${entry.value}'),
        );
      }

      await marker.writeAsString(DateTime.now().toIso8601String());
    } finally {
      downloader.close();
    }
  }

  /// Clears download state. Testing only.
  @visibleForTesting
  static void resetForTesting() => _inFlight = null;
}
