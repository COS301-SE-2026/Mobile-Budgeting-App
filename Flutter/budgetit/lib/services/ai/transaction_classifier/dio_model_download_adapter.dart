import 'dart:io';

import 'package:budgetit/services/ai/transaction_classifier/model_download_adapter.dart';
import 'package:dio/dio.dart';

/// Downloads model files using Dio.
final class DioModelDownloadAdapter implements ModelDownloadAdapter {
  /// Create new adapter , optionally with existing dio client
  DioModelDownloadAdapter({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  Future<void> download({
    required Uri source,
    required File destination,
  }) async {
    await _dio.downloadUri(source, destination.path);
  }

  @override
  void close() {
    _dio.close();
  }
}
