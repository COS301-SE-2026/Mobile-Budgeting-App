enum AnomalySeverity {
    low,
    medium,
    high,
}

class AnomalyResult{
    final String? categoryName;
    final String? monthLabel;
    final double actualAmount;
    final double historicalAverage;
    final double zScore;
    final AnomalySeverity severity;
    final String title;
    final String body;

    const AnomalyResult({
        required this.categoryName,
        required this.monthLabel,
        required this.actualAmount,
        required this.historicalAverage,
        required this.zScore,
        required this.severity,
        required this.title,
        required this.body,
    });

    bool get isTotalSpendingAnomaly => categoryName == null;

    @override
    String toString() =>
        'AnomalyResult(category: $categoryName, month: $monthLabel, actual: $actualAmount, avg: $historicalAverage, z: $zScore, severity: $severity)';
        
}