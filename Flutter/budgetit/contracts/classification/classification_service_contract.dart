import 'package:budgetit/models/import/parsed_transaction.dart';

abstract interface class ClassificationServiceContract {
  void classifyAll(List<ParsedTransaction> transactions);

  double classificationRate(List<ParsedTransaction> transactions);
}
