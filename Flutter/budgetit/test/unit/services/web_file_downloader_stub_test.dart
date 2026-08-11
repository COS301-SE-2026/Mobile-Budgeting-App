import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/services/web_file_downloader_stub.dart';

void main() {
  group('WebFileDownloaderImpl (non-web stub)', () {
    test('downloadBytes throws UnsupportedError', () {
      final downloader = WebFileDownloaderImpl();
      expect(() => downloader.downloadBytes( bytes: [1, 2, 3], fileName: 'statement.csv', mimeType: 'text/csv'), throwsA(isA<UnsupportedError>()));
    });

    test('error message explains web-only support', () {
      final downloader = WebFileDownloaderImpl();
      try {
        downloader.downloadBytes(
          bytes: const [],
          fileName: 'empty.csv',
          mimeType: 'text/csv',
        );
        fail('Expected UnsupportedError to be thrown');
      } on UnsupportedError catch (e) {
        expect(e.message, contains('Flutter Web'));
      }
    });

    test('throws regardless of input size or mime type', () {
      final downloader = WebFileDownloaderImpl();
      final bigBytes = List<int>.generate(10000, (i) => i % 256);

      expect(() => downloader.downloadBytes( bytes: bigBytes, fileName: 'big_report.pdf', mimeType: 'application/pdf'), throwsUnsupportedError);
    });
  });
}
