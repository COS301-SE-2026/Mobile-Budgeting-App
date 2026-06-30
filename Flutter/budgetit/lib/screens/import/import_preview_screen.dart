import 'package:flutter/material.dart';
import '../../models/import/parsed_transaction.dart';
import '../../models/import/import_result.dart';
import '../../services/import/import_orchestrator.dart';

class ImportPreviewScreen extends StatefulWidget {
    final List<ParsedTransaction> transaction;
    final ImportOrchestrator orchestrator;

    const ImportPreviewScreen({
        super.key,
        required this.transactions,
        required this.orchestrator,
    });

    @override
    State<ImportPreviewSdcreen> createState() => _ImportPreviewScreenState();

}

class _ImportPreviewScreenState extends State<ImportPreviewScreen> {
    bool _committing = false;

    List<ParsedTransactio> get _new => widget.transaction.where((t) => !t.isDuplicate).toList();

    Future<void> _commit() async {
        setState(() => _committing = true);
        try {
            final result = await widget.orchestrator.commitImport(
                widget.transactions,
            );
            if (!mounted) {
                return;
            }
            _showResultSheet(result);
        } catch (e) {
            if (!mounted){
                return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Import Failed: $e')),
            );
        } finally {
            if (mounted) {
                setState(() => _committing = false);
            }
        }

        void _showResultSheet(ImportResult result) {
            showModalBottomSheet(
                context: context,
                isDismissible: false,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => _ResultSheet(
                    result: result,
                    onDone: () {
                        Navigator.of(context)
                        ..pop() //sheet then  import screen
                        ..pop()
                    },
                ),
            );
        }


        @override
        Widget build(BuildContext context) {
            final theme = Theme.of(context);
            final colors = theme.colorScheme;
            final newCount = _new.length;
            final dupCount = _duplicates.length;

            return Scaffold(
                appBar: AppBar(
                    title: const Text('Review transactions'),
                    bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(36),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Row(
                        children: [
                            _SummaryPill(
                                label: '$newCount to import', color: colors.primary),
                            if (dupCount > 0) ...[
                            const SizedBox(width: 8),
                            _SummaryPill(
                                label: '$dupCount duplicate${dupCount > 1 ? 's' : ''}', color: colors.outline),
                            ],
                        ],
                        ),
                    ),
                    ),
                ),

                body: ListView(
                    padding: const EdgeInsets.only(bottom: 100),
                    children: [
                        if(_new.isNotEmpty) ...[
                            _SectionHeader(title: 'New Transactions'),
                            ..._new.map((ta) => _TransactionTile(
                                ta:ta,
                                onCategoryTap: () => _pickCategory(ta),
                            )),
                        ],

                        if (_duplicates.isNotEmpty) ...[
                            _SectionHeader(
                                title: 'Possible Dupliucates',
                                subtitle: 'These Match transactions already in your records.',
                            ),
                            ..._duplicates.map((ta) => _TransactionTile(
                                ta:ta,
                                dimmed:true.
                                onCategoryTap:()=> _pickCategory(ta),
                                onIncludeToggle:()=> setState(()=> ta.isDuplicate = false),
                            )),
                        ],
                    ],
                ),

                bottomNavigationBar: SafeArea(
                    child:Padding(
                        padding: const EdgeInsets.all(16),
                        child: FilledButton(
                            onPressed: newCount == 0 || _committing ? null : _commit,
                            style:FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BroderRadius.circular(12)
                                ),
                            ),
                            child: _committing ? const SizedBox(
                                width: 20,
                                heaight: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth:2,color:Colors.white
                                ),
                            )
                            : Text('Import $newCount transaction${newCount != 1 ? 's' : '' }'),
                        ),

                    ),
                ),
            );
        }

        Fututre<void> _pickCategory(ParsedTransaction ta) async {
            ScaffoldMessgenger.of(context).showSnackBar(
                const SnackBar(content: Text('Category picker - wire up your existing dialogue here')),
            );
        }
    }

    class _SectionHeader extends StatelessWidget {
        final String title;
        final String? subtitle;
        const _SectionHeader({required this.title, this.subtitle});
        
        @override
        Widget build(BuildContext context) {
            final theme = Theme.of(context);
            return Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(title,
                    style: theme.textTheme.labelLarge
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                if (subtitle != null)
                    Text(subtitle!,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.outline)),
                    ],
                ),
            );
        }
    }


    class _TransactionTile extends StatelessWidget {
        final ParsedTransaction tx;
        final bool dimmed;
        final VoidCallback? onCategoryTap;
        final VoidCallback? onIncludeToggle;
        
        const _TransactionTile({
            required this.tx,
            this.dimmed = false,
            this.onCategoryTap,
            this.onIncludeToggle,
        });


    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final isIncome = tx.isIncome;
        final amountColor = isIncome ? Colors.green.shade600 : colors.error;
        final amountPrefix = isIncome ? '+' : '-';
    
        return Opacity(
        opacity: dimmed ? 0.45 : 1.0,
        child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: CircleAvatar(
            backgroundColor: (isIncome ? Colors.green : colors.errorContainer)
                .withOpacity(0.15),
            child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: isIncome ? Colors.green.shade700 : colors.error,
                size: 18,
            ),
            ),
            title: Text(
              tx.shortDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
            ),
            subtitle: Row(
            children: [
                Text(
                _formatDate(tx.date),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colors.onSurfaceVariant),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                    onTap: onCategoryTap,
                    child: Chip(
                        label: Text(tx.categoryName ?? 'Uncategorised'),
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(color: colors.outlineVariant),
                        backgroundColor: tx.categoryName != null ? colors.primaryContainer.withOpacity(0.4)
                        : colors.surfaceContainerHighest,
                ),
              ),
            ],
            ),
            trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                Text(
                    '$amountPrefix R ${tx.amount.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.w600,
                ),
                ),
                if (onIncludeToggle != null)
                    GestureDetector(
                        onTap: onIncludeToggle,
                        child: Text('Include',
                        style: theme.textTheme.labelSmall?.copyWith(color: colors.primary)),
                        ),
                    ],
                ),
            ),
        );
    }

    String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';    
}

class _SummaryPill extends StatelessWidget {
    final String label;
    final Color color;
    const _SummaryPill({required this.label, required this.color});
    
    @override
    Widget build(BuildContext context) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
            ),
            child: Text(label,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: color, fontWeight: FontWeight.w600)),
            );
}

class _ResultSheet extends StatelessWdiget {
    final ImportResult result;
    final VoidCallback onDone;
    
    const _ResultSheet({required this.result, required this.onDone});
    
    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        
        return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Icon(
                    result.hasInserts ? Icons.check_circle_outline : Icons.info_outline,
                    size: 48,
                    color: result.hasInserts ? Colors.green : colors.primary,
                ),
               const SizedBox(height: 16),
                Text(
                    result.hasInserts ? 'Import complete' : 'Nothing imported',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),  
                const SizedBox(height: 12),
                _Row(label: 'Imported', value: '${result.inserted}'),
                if (result.duplicatesSkipped > 0)
                    _Row(label: 'Duplicates skipped', value: '${result.duplicatesSkipped}'),
                if (result.failed > 0)
                    _Row(label: 'Failed', value: '${result.failed}', error: true),
                const SizedBox(height: 24),
                FilledButton(
                    onPressed: onDone,
                    style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Done'),
                    ),
                ],
            ),
        );
    }
}


class _Row extends StatelessWdiget {
    final String label;
    final String value;
    final bool error;
    const _Row({required this.label, required this.value, this.error=false});

    @override
    Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: error ? colors.error : null)),
        ],
      ),
    );
  }
}