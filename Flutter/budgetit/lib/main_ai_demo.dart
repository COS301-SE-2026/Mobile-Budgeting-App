import 'package:flutter/material.dart';

import 'services/ai/transaction_classifier/bge_onnx_embedder.dart';
import 'services/ai/transaction_classifier/transaction_classification_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AiClassifierDemoApp());
}

class AiClassifierDemoApp extends StatelessWidget {
  const AiClassifierDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Transaction Classifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const AiClassifierDemoScreen(),
    );
  }
}

class AiClassifierDemoScreen extends StatefulWidget {
  const AiClassifierDemoScreen({super.key});

  @override
  State<AiClassifierDemoScreen> createState() => _AiClassifierDemoScreenState();
}

class _AiClassifierDemoScreenState extends State<AiClassifierDemoScreen> {
  final _transactionController = TextEditingController(
    text: 'UBER TRIP HELP.UBER.COM',
  );

  final _categoriesController = TextEditingController(
    text: 'Groceries, Transport, Entertainment, Rent',
  );

  late final BgeOnnxEmbedder _embedder;
  late final TransactionClassificationService _service;

  bool _initializing = true;
  bool _classifying = false;
  String? _error;
  TransactionClassificationResult? _result;

  @override
  void initState() {
    super.initState();

    _embedder = BgeOnnxEmbedder();
    _service = TransactionClassificationService(embedder: _embedder);

    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _service.initialize();

      if (!mounted) {
        return;
      }

      setState(() {
        _initializing = false;
      });
    } catch (error, stackTrace) {
      debugPrint('BGE initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      setState(() {
        _initializing = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _classify() async {
    final names = _categoriesController.text
        .split(',')
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    if (names.isEmpty) {
      setState(() {
        _error = 'Enter at least one category.';
      });
      return;
    }

    setState(() {
      _classifying = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await _service.classify(
        shortDescription: _transactionController.text,
        categories: [
          for (var index = 0; index < names.length; index++)
            ClassificationCategory(
              id: 'demo-category-$index',
              name: names[index],
            ),
        ],
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _result = result;
        _classifying = false;
      });
    } catch (error, stackTrace) {
      debugPrint('Classification failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      setState(() {
        _classifying = false;
        _error = error.toString();
      });
    }
  }

  @override
  void dispose() {
    _transactionController.dispose();
    _categoriesController.dispose();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Transaction Classifier')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Base model: ${_embedder.modelVersion}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(_initializing ? 'Loading the 133 MB model…' : 'Model ready'),
          const SizedBox(height: 24),
          TextField(
            controller: _transactionController,
            decoration: const InputDecoration(
              labelText: 'Transaction description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _categoriesController,
            decoration: const InputDecoration(
              labelText: 'Categories separated by commas',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _initializing || _classifying || _error != null
                ? null
                : _classify,
            icon: _classifying
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome),
            label: Text(_classifying ? 'Classifying…' : 'Classify transaction'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(_error!),
              ),
            ),
          ],
          if (_result != null) ...[
            const SizedBox(height: 24),
            Text(
              'Best suggestion: '
              '${_result!.bestMatch?.categoryName ?? 'None'}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            for (final score in _result!.rankedCategories)
              Card(
                child: ListTile(
                  title: Text(score.categoryName),
                  subtitle: Text(
                    'Similarity: '
                    '${score.similarity.toStringAsFixed(6)}',
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
