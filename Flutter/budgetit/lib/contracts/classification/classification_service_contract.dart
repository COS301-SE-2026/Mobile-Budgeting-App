import 'package:budgetit/models/import/parsed_transaction.dart';

/// Assigns categories to imported transactions using keyword rules.
/// This is the fast, offline first pass of import classification: it matches
/// the transaction description against a keyword-to-category map. Anything it
/// cannot place is left for the AI classifier or the user.
///
/// {@category Classification}
abstract interface class ClassificationServiceContract {
  /// Categorises every element of [transactions] in place.
  /// Sets 'categoryId' and 'categoryName' on each match. Transactions whose
  /// 'categoryOverridden' flag is set are skipped, so a choice the user has
  /// already made is never overwritten.
  ///
  /// When no keyword matches, income transactions fall back to the
  /// "Other Income" category and expenses are left uncategorised, on the
  /// basis that a wrong expense category is more misleading than none.
  /// The list is neither copied nor reordered.
  void classifyAll(List<ParsedTransaction> transactions);

  /// The fraction of [transactions] that carry a category, from 0.0 to 1.0.
  /// Returns 0.0 for an empty list. Call after [classifyAll] to judge how
  /// much of an import still needs manual attention.
  double classificationRate(List<ParsedTransaction> transactions);
}
