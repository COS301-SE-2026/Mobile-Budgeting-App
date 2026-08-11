class SpendingFeatures {
  const SpendingFeatures({
    required this.currentSpending,
    required this.averageDailySpending,
    required this.previousMonthSpending,
    required this.threeMonthAverage,
    required this.transactionCount,
    required this.daysElapsed,
    required this.daysRemaining,
  });

  final double currentSpending;
  final double averageDailySpending;
  final double previousMonthSpending;
  final double threeMonthAverage;
  final int transactionCount;
  final int daysElapsed;
  final int daysRemaining;

  List<double> toModelInput() {
    return [
      currentSpending,
      averageDailySpending,
      previousMonthSpending,
      threeMonthAverage,
      transactionCount.toDouble(),
      daysElapsed.toDouble(),
      daysRemaining.toDouble(),
    ];
  }
}
