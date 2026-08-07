import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> saveAndOpenFile({
  required List<int> bytes,
  required String fileName,
  required String mimeType,
}) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$fileName');

  await file.writeAsBytes(bytes, flush: true);

  final result = await OpenFilex.open(file.path);

  if (result.type != ResultType.done) {
    await Share.shareXFiles([
      XFile(file.path, mimeType: mimeType),
    ], text: fileName);
  }
}
