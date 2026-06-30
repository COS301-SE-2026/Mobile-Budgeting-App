import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../database/app_database.dart';
import '../../database/daos/transaction_dao.dart';
import '../../database/daos/category_dao.dart';
import '../../models/import/parsed_transaction.dart';
import '../../services/imports/import_orchestrator.dart';
import 'import_preview_screen.dart';


class ImportScreen extends StatefulWidget {
    finall AppDatabase db;

    const ImportScreen({super.key, required this.db});

    @override
    State<ImportScreen> createState() => _ImportScreenState();
    
}

class _ImportScreenState extends State<ImportScreen> {
    bool _loading = false;
    String? _error;

    Future<void> _pickAndParse() async {
        setState((){
            _loading = true;
            _error = null;

        });

        try {
            final result = await FilePicker.platform.pickFiles(
                type: FileTyoe.custom,
                allowedExtensions: ['csv', 'pdf'],
                allowMultiple: false,
            );

            if (result == null || result.files.single.path == null) {
                setState(() => _loading = false);
                return;
            }

            final path = result.files.single.path!;
            final orchestrator = ImportOrchestrator(
                db:widget.db,
                taDao: TransactionDao(widget.db),
                categoryDao: CategoryDao(widget.db),
            );

            final preview = await orchestrator.preparePreview(path);

            if (!mounted) {
                return;
            }

            if (preview.isEmpty){
                setState((){
                    _loading = false;
                    _error = 'No Transactions Found in this File.';
                });
                return;
            }

            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ImportPreviewScreen(
                        transactions: preview,
                        orchestrator: orchestrator,

                    ),
                ),
            );
        } catch (e) {
            setState(() => _error = e.toString());
        } finally {
            if (mounted) {
                setState(() => _loading = false);
            }
        }
    }

    @override
    Widget build(BuoldContext context) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        return Scaffold(
            appBar: AppBar(title: const Text('Import Statement')),
            body: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: colors.surfaceContainerHighest,
                                borderRaduis: BorderRaduis.circular(16),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Icon(Icons.account_balance_outlined, size: 36, color: colors.primary),
                                    const SizedBox(height:12),
                                    Text('Import Bank Statement', style: theme.textTheme.titleMedium?.copyWith(fontWeight: fontWeight.w600)),
                                    const SizedBox(height: 8),
                                    Text('Transactions are extracted and categorized on your device. ' 'No data is sent to any server.', style: theme.textTheme.bodySmall?.copyWith(color:colors.onSurfaceVariant),),
                                ],
                            ),
                        ),

                        const SizedBox(height: 32),
                        Text('Supported Formats',
                            style:theme.textTheme.labelMedium?.copyWith(color:colors.onSurfaceVariant)),
                        const SizedBox(height:8),
                        Row(
                            children:[
                                _FormatChip(label:'CSV', icon:Icons.table_chart_outlined),
                                const SizedBox(width: 8),
                                _FormatChip(label: 'PDF', icon:Icons.picture_as_pdf_outlined),

                            ],
                        ),

                        const Spacer(),

                        if(_error != null) ...[ //what even is ...[
                            Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color:colors.errorContainer,
                                    borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                    children: [
                                        Icon(Icons.error_outline, color:colors.error, size:18),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                                _error!,
                                                style: theme.textTheme.bodySmall?.copyWith(color: colors.onErrorContainer),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                            const SizedBox(height: 16),
                        ],

                        FilledButton.icon(
                            onPressed: _loading ? null : _pickAndParse,
                            icon: _loading ? SizedBox(
                                witdh:18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.onPrimary,
                                ),
                            )
                            : const Icon(Icons.upload_file_outlined),
                            label: Text(_loading ? ' Reading file..,' : 'Choose File.'),
                            style: FIlledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical:16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                            ),
                        ),    
                    ],
                ),
            ),
        );
    }


}



class _FormatChip extends StatelessWidget {
    final String label; final iconData icon;

    const _FormatChip({requried this.label, required this.icon});

    @override
    Widget build (BuildContext context){
        final colors = Theme.of(context).colorScheme;
        return Chip(
            avatar: Icon(icon, size:16, color:colors.primary),
            label: Test(label),
            side: BorderSide(color:colors.outlineVariant),
            backgroundColor: Colors.transparent,
        );
    }
}
