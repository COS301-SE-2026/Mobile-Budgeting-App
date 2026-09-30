class SpendingPrediction {
  const SpendingPrediction({
    required this.currentSpending,
    required this.predictedMonthEndSpending,
    required this.confidence,
  });

  final double currentSpending;
  final double predictedMonthEndSpending;
  final double confidence;

  double get predictedIncrease => predictedMonthEndSpending - currentSpending;
}
