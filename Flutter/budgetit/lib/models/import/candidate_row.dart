import 'package:decimal/decimal.dart';

class CandidateRow {
  final DateTime date;
  final Decimal absAmount;
  final String description;
  final String? signMarker;
  final String rawSource;

  const CandidateRow({
    required this.date,
    required this.absAmount,
    required this.description,
    required this.rawSource,
    this.signMarker,
  });

  @override
  String toString() =>
      'CandidateRow(date: $date, amount: $absAmount, marker: $signMarker, '
      'desc: $description)';
}