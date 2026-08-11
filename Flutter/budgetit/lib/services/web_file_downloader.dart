import 'web_file_downloader_platform.dart';
import 'web_file_downloader_stub.dart'
    if (dart.library.html) 'web_file_downloader_web.dart';

export 'web_file_downloader_platform.dart';

WebFileDownloader createWebFileDownloader() {
  return WebFileDownloaderImpl();
}