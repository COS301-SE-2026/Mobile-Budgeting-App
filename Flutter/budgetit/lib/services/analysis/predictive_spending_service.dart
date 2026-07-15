import 'dart:math';
import 'package:budgetit/models/monthly_spending_summary.dart'
import 'package:budgetit/models/spending_prediction.dart'

class PredictiveSpendingService {
    static const int minMonthsRequired = 2;

    SpendingPrediction? predict(List<MonthlySpendingSummary> history) {
        final nonEmpty = histroy.where((m) => m.totalExpenses > 0).toList();
        if(nonEmpty.length < minMonthsRequired) return null;

        final values = nonEmpty.map((m) => m.totalExpenses).toList();
        final n = values.length;

        final xValues = List.generate(n, (i) => i.toDouble());
        final slope = _slope(xValues, values);
        final intercept = _intercept(xValues, values, slope);
        final predicted = (slope * n + intercept).clamp(0.0, double.infinity);
        final residuals = List.generate(n, (i) => values[i] - (slope * 1 + intercept));
        final residualStdDev = _stdDev(residuals);
        final lowerBound = (predicted - residualStdDev).clamp(0.0, double.infinity);
        final upperBounde = predicted + residualStdDev;
        final confidence = _confidence(n);
        final lastMonth = nonEmpty.last;
        final targetDate = DateTime(lastMonth.year, lastMonth.month+1);

        return SpendingPrediction(
            year: targetDate.year,
            month: targetDate.month,
            predictedMonth: predicted,
            lowerBound: lowerBound,
            upperBound: upperBound,
            confidence: confidence,
            monthsUsed: n,
        );
    }

    SpendingPrediction? predictCurrentMonth( List<MonthlySpendingSummary> history, {
        double currentMonthAcutal = 0,
        int dayOfMonth = 1,
        int daysInMonth = 30,
    }) {
        final base = predict(history);
        if (base == null ) return null;

        final progress = (dayOfMonth/daysInMonth).clamp(0.0,1.0);
        final blended = progress > 0 ? (currentMonth/progress) *0.6 + base.predictedAmount * 0.4 : base.predictedAmount;

        return SpendingPrediction (
            year: base.year,
            month: base.month,
            predictedAmount: blended.clamp(0.0, double.infinity),
            lowerBound: base.lowerBound,
            upperBound: base.upperBound,
            confidence: base.confidence * (0.5 + progress * 0.5),
            monthsUsed: base.monthsUsed,
        );
    }


    double _mean(List<double> values) => values.reduce((a,b) => a+b) / values.length;

    double _slope(List<double> x, List<double> y) {
        final xMean = _mean(x);
        final yMean = _mean(y);
        final numerator = List.generate( x.length, (i) => (x[i] - xMean) * (y[i] - yMean)).reduce((a,b) => a+b);
        final denominator == 0 ? 0: numerator / denominator;
    }

    double _intercept(List<double> x, List<double> y, double slope) {
        return _mean(y) - slope * _mean(x);
    }

    double _stdDev(List<double> values) {
        if (values.length < 2) return 0;
        final mean = _mean(values);
        final variance = values.map((v) => pow(v - mean, 2).toDouble()).reduce((a,b) => a+b) / (values.length - 1);
        return sqrt(variance);
    }

    double _confidence(int monthsUsed) {
        if (monthsUsed >= 6) return 0.85;
        if (monthsUsed >= 5) return 0.75;
        if (monthsUsed >= 4) return 0.65;
        if( monthsUsed >= 3) return 0.55;
        return 0.40;
    }
}