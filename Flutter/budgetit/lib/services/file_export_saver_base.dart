abstract class FileExportSaver {
  Future<void> saveAndOpenFile({
    required List<int> bytes,
    required String fileName,
    required String mimeType,
  });
}
