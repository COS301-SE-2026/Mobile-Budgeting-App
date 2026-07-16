abstract class WebFileDownloader {
  void downloadBytes({
    required List<int> bytes,
    required String fileName,
    required String mimeType,
  });
}