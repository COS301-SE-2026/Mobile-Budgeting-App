class SpendingPrediction {
    final int year;
    final int month;
    final double predictedAmount;
    final double lowerBound;
    final double upperBound;
    final double confidence;
    final int monthsUsed;

    bool get isReliable => monthsUsed >=2; //reliable if minimum 2 months history used.

    const SpendingPrediction({
        required this.year,
        required this.month,
        required this.predictedAmount,
        required this.lowerBound,
        required this.upperBound,
        required this.confidence,
        required this.monthsUsed,
    });

    String get label {
        const months = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
        ];
        return '${months[month-1]} $year'; //month and year
    }

    String get shortLabel {
        const months = [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        return months[month-1]; //just month
    }

    @override
    String toString() =>
        'SpendingPrediction($label, predicted: $predictedAmount, range: [$lowerBound, $upperBound], confidence: $confidence)';
        

}