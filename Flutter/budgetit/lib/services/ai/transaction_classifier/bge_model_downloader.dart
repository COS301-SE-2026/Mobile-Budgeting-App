import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:huggingface_downloader/huggingface_downloader.dart';
import 'package:path_provider/path_provider.dart';

/// Downloads and installs the BGE small English embedding model from the
/// Hugging Face Hub into the application documents directory.
class BgeModelDownloader {
  static const String _repoId = 'BAAI/bge-small-en-v1.5';
  static const String _modelDirName = 'bge-small-en-v1.5';

  /// Written only after every required file has downloaded in full, so an
  /// interrupted download is never mistaken for an installed model.
  static const String _markerFileName = '.install-complete';

  /// Remote repository path -> flat local filename.
  ///
  /// The ONNX weights live under `onnx/` in the repository but are stored flat
  /// on disk because [BgeOnnxEmbedder] expects `<modelPath>/model.onnx`.
  static const Map<String, String> _requiredFiles = <String, String>{
    'onnx/model.onnx': 'model.onnx',
    'tokenizer.json': 'tokenizer.json',
    'vocab.txt': 'vocab.txt',
  };

  static Future<void>? _inFlight;

  /// Absolute path to the directory holding the installed model files.
  static Future<String> get modelPath async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/models/bge/$_modelDirName';
  }

  /// Whether a download is currently running.
  static bool get isDownloading => _inFlight != null;

  /// Whether a complete model installation is present on disk.
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
  /// Concurrent calls share a single download. Throws if the download fails;
  /// callers are expected to surface that to the user.
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

    final downloader = HuggingFaceDownloader();

    try {
      for (final entry in _requiredFiles.entries) {
        await downloader.downloadFile(
          repoId: _repoId,
          remoteFile: entry.key,
          localFile: File('$path/${entry.value}'),
          progress: (file, received, total) {
            if (total <= 0) {
              return;
            }
            final percent = (received / total * 100).toStringAsFixed(0);
            debugPrint('BGE: $file -> $percent%');
          },
        );
      }

      await marker.writeAsString(DateTime.now().toIso8601String());
    } finally {
      downloader.close();
    }
  }

  /// Clears cached download state. Test-only.
  @visibleForTesting
  static void resetForTesting() => _inFlight = null;
}
