import 'file_export_saver_base.dart';

FileExportSaver createFileExportSaver() => _UnsupportedFileExportSaver();

class _UnsupportedFileExportSaver implements FileExportSaver {
  @override
  Future<void> saveAndOpenFile({
    required List<int> bytes,
    required String fileName,
    required String mimeType,
  }) {
    throw UnsupportedError(
      'Local file saving is not supported on this platform.',
    );
  }
}
