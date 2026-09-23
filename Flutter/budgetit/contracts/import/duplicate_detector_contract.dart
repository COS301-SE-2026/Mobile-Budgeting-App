import 'package:budgetit/models/import/parsed_transaction.dart';

abstract interface class DuplicateDetectorContract {
  void flagDuplicates(List<ParsedTransaction> parsed);
  List<ParsedTransaction> filterDuplicates(List<ParsedTransaction> parsed);
}
