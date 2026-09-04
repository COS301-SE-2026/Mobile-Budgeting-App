import 'dart:io';

import 'package:budgetit/services/ai/transaction_classifier/bge_model_downloader.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.flutter.io/path_provider');

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('bge_test_');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'getApplicationDocumentsDirectory') {
        return tempDir.path;
      }
      return null;
    });

    BgeModelDownloader.resetForTesting();
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);

    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  /// Writes the files a complete installation is expected to contain.
  Future<String> installFakeModel({bool complete = true}) async {
    final path = await BgeModelDownloader.modelPath;
    await Directory(path).create(recursive: true);
    await File('$path/model.onnx').writeAsBytes(<int>[1, 2, 3]);
    await File('$path/vocab.txt').writeAsString('[PAD]\n[UNK]\n');

    if (complete) {
      await File('$path/.install-complete').writeAsString('done');
    }

    return path;
  }

  group('BgeModelDownloader', () {
    test('is not downloading at rest', () {
      expect(BgeModelDownloader.isDownloading, isFalse);
    });

    test('modelPath resolves under the documents directory', () async {
      final path = await BgeModelDownloader.modelPath;

      expect(path, startsWith(tempDir.path));
      expect(path, endsWith('/models/bge/bge-small-en-v1.5'));
    });

    test('isModelInstalled is false when nothing is on disk', () async {
      expect(await BgeModelDownloader.isModelInstalled(), isFalse);
    });

    test('isModelInstalled is true for a complete installation', () async {
      await installFakeModel();

      expect(await BgeModelDownloader.isModelInstalled(), isTrue);
    });

    test('isModelInstalled is false when the marker is missing', () async {
      await installFakeModel(complete: false);

      expect(await BgeModelDownloader.isModelInstalled(), isFalse);
    });

    test('isModelInstalled is false when model.onnx is missing', () async {
      final path = await installFakeModel();
      await File('$path/model.onnx').delete();

      expect(await BgeModelDownloader.isModelInstalled(), isFalse);
    });

    test('ensureModelDownloaded is a no-op when already installed', () async {
      await installFakeModel();

      await expectLater(BgeModelDownloader.ensureModelDownloaded(), completes);
      expect(BgeModelDownloader.isDownloading, isFalse);
    });

    test('concurrent calls share one in-flight download', () async {
      await installFakeModel();

      final first = BgeModelDownloader.ensureModelDownloaded();
      final second = BgeModelDownloader.ensureModelDownloaded();

      expect(identical(first, second), isTrue);
      await Future.wait<void>([first, second]);
    });

    test(
      'downloads the model from the Hub',
      () async {
        await BgeModelDownloader.ensureModelDownloaded();

        final path = await BgeModelDownloader.modelPath;
        expect(await File('$path/model.onnx').length(), greaterThan(100000000));
        expect(await BgeModelDownloader.isModelInstalled(), isTrue);
      },
      skip: 'Network + 133 MB. Run manually with --run-skipped.',
      timeout: const Timeout(Duration(minutes: 10)),
    );
  });
}
