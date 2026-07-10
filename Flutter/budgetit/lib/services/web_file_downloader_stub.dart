import 'web_file_downloader_platform.dart';

class WebFileDownloaderImpl implements WebFileDownloader {
  @override
  void downloadBytes({
    required List<int> bytes,
    required String fileName,
    required String mimeType,
  }) {
    throw UnsupportedError(
      'Web file download is only supported on Flutter Web.',
    );
  }
}