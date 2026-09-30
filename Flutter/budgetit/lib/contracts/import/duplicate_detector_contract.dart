import 'package:budgetit/models/import/parsed_transaction.dart';

/// Flags parsed transactions that already exist in the database.
///
/// A transaction is a duplicate when either its deduplication hash matches a
/// stored row, or a stored row shares its amount and description and falls
/// within three days either side of its date.
///
/// Hash matches are consumed one for one, so a statement that legitimately
/// repeats an identical line is only flagged for the occurrences that genuinely
///  already exist.
///
/// Instances are single-use: matching state is consumed as flagging proceeds,
/// so construct a fresh detector for each import.
///
/// {@category Import}
abstract interface class DuplicateDetectorContract {
  /// Sets the duplicate flag on every element of [parsed], in place.
  ///
  /// The list is neither copied nor reordered. Call once per detector.
  void flagDuplicates(List<ParsedTransaction> parsed);

  /// Returns the elements of [parsed] not flagged as duplicates, in their
  /// original order.
  ///
  /// Does not flag anything itself, instead it calls [flagDuplicates] first,
  ///  or every element will be returned.
  List<ParsedTransaction> filterDuplicates(List<ParsedTransaction> parsed);
}
