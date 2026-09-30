import 'dart:io';

/// Abstract interface for downloading models.
abstract interface class ModelDownloadAdapter {
  /// Downloads [source] into [destination].
  Future<void> download({required Uri source, required File destination});

  /// Releases held resources.
  void close();
}
