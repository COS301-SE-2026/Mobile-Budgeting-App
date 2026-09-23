import 'package:decimal/decimal.dart';
import '../../models/import/parsed_transaction.dart';

class DuplicateDetector {
    final List<ExistingTransaction> _existing;
    late final Map<String, int> _unmatched;

    DuplicateDetector(this._existing){
        _unmatched = <String, int>{};
        for (final e in _existing) {
            _unmatched.update(e.deduplicationHash, (v) => v + 1, ifAbsent: () => 1);
        }
    }

    void flagDuplicates(List<ParsedTransaction> parsed){
        for(final ta in parsed) {
            ta.isDuplicate = _isDuplicate(ta);
        }
    }

    bool _isDuplicate(ParsedTransaction ta){
        final spare = _unmatched[ta.deduplicationHash] ?? 0;
        if (spare > 0) {
            _unmatched[ta.deduplicationHash] = spare - 1;
            return true;
        }

        final description = ta.description.toLowerCase().trim();
        for(final existing in _existing){
            if(existing.amount != ta.amount) continue;
            if(existing.description != description) continue;
            if(ta.date.difference(existing.date).inDays.abs() > 3) continue;
            return true;
        }
        return false;
    }

    List<ParsedTransaction> filterDuplicates(List<ParsedTransaction> parsed) => parsed.where((t) => !t.isDuplicate).toList();
}

class ExistingTransaction {
    final DateTime date;
    final Decimal amount;
    final String description;
    final String deduplicationHash;

    const ExistingTransaction({
        required this.date,
        required this.amount,
        required this.description,
        required this.deduplicationHash,
    });
}
