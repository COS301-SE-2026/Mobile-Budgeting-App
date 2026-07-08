// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import 'web_file_downloader_platform.dart';

class WebFileDownloaderImpl extends WebFileDownloader {
  @override
  void downloadBytes({
    required List<int> bytes,
    required String fileName,
    required String mimeType,
  }) {
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}