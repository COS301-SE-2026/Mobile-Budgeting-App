import 'package:decimal/decimal.dart';
import '../../models/import/parsed_transaction.dart';

class DuplicateDetector {

    final  List<ExistingTransaction> _existing;

    late final Set<String> _existingHashes; 

    DuplicateDetector(this._existing){
        _existingHashes = _existing.map((e)=> e.duplicateHash).toSet();
    }

    void flagDuplicates(List<ParsedTransaction> parsed){
        for(final ta in parsed) {
            ta.isDuplicate = _isDuplicate(ta);
        }
    }

    bool _isDuplicate(ParsedTransaction ta){
        if(_existingHashes.contains(ta.deduplicationHash)){
            return true;
        }

        for(final existing in _existing){
            if(existing.amount != ta.amount) {
                continue;
            }
            final diff = ta.date.difference(existing.date).inDays.abs();
            if(diff<=3){
                return true;
            }
        }
        return false;
    }

    List<ParsedTransaction> filterDuplicates(List<ParsedTransaction> parsed) => parsed.where((t) => !t.isDuplicate).toList();
}

class ExistingTransaction {
    final DateTime date;
    final Decimal amount;
    final String deduplicationHash;

    const ExistingTransaction({
        required this.date,
        required this.amount,
        required this.deduplicationHash,
    });
}