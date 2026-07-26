import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/monthly_spending_summary.dart';
import '../../models/anomaly_result.dart';

class AnomalyDetectionService {
    static const int minMonthsRequired = 2;

    static const double _lowThreshold  = 1.5;
    static const double _mediumThreshold = 2.0;
    static const double highThreshold = 2.5;

    List<AnomalyResult> detect(List<MonthlySpendingSummary> history) {
        if (history.length < minMonthsRequired) {
            return [];
        }

        final anomalies = <AnomalyResult>[];

        anomalies.addAll(_detectTotalSpendingAnomalies(history));
        anomalies.addAll(_detectCategoryAnomalies(history));
        anomalies.sort((a,b) => b.zScore.compareTo(a.zScore));
        return anomalies;
    }

    List<AnomalyResult> _detectTotalSpendingAnomalies( List<MonthlySpendingSummary> history) {
        final results = <AnomalyResult>[];
        final baseline = history.sublist(0, history.length - 1);
        final current = history.last;

        if(baseline.isEmpty){
            return results;
        }

        final values=baseline.map((m) => m.totalExpenses).toList();
        final mean=_mean(values);
        final stdDev=_stdDev(values,mean);
        if(stdDev==0){
            return results;
        }
        final z=(current.totalExpenses-mean)/stdDev;
        if(z>=_lowThreshold){
            final severity=_severityFromZ(z);
            results.add(AnomalyResult(categoryName:null,monthLabel:current.label,actualAmount:current.totalExpenses,historicalAverage:mean,zScore:z,severity:severity,title: _totalSpendingTitle(severity,current.totalExpenses,mean),body:_totalSpendingBody(current,mean,z)));
        }
        return results;
    }


    List<AnomalyResult> _detectCategoryAnomalies(List<MonthlySpendingSummary> history) {
        final results = <AnomalyResult>[];
        final baseline = history.sublist(0, history.length - 1);
        final current = history.last;
        for(final category in current.expensesByCategory.keys) {
            final baselineValues = baseline.map((m) => m.expensesByCategory[category] ?? 0.0).toList();

            if(baselineValues.every((v) => v == 0)) {
                continue;
            }

            final mean = _mean(baselineValues);
            final stdDev = _stdDev(baselineValues, mean);

            if(stdDev==0){
                continue;
            }

            final currentAmount = current.expensesByCategory[category] ?? 0;
            final z = (currentAmount - mean) / stdDev;
            if (z >= _lowThreshold) {
                final severity = _severityFromZ(z);
                results.add(AnomalyResult(
                    categoryName: category,
                    monthLabel: current.label,
                    actualAmount: currentAmount,
                    historicalAverage: mean,
                    zScore: z,
                    severity: severity,
                    title: _categoryTitle(severity, category),
                    body: _categoryBody(category, currentAmount, mean, current.label),
                ));
            }
        }

        return results;
    }


    double _mean(List<double> values) {
        if (values.isEmpty) {
            return 0;
        }
        return values.reduce((a,b) => a + b) /values.length;
    }

    double _stdDev(List<double> values, double mean) {
        if (values.length < 2) {
            return 0;
        }
        final variance = values.map((v) => pow(v - mean, 2)).reduce((a,b) => a + b) / (values.length - 1);
        return sqrt(variance);
    }

    AnomalySeverity _severityFromZ(double z) {
        if (z >= _highThreshold) return AnomalySeverity.high;
        if (z >= _mediumThreshold) return AnomalySeverity.medium;
        return AnomalySeverity.low;
    }
    

    String _totalSpendingTitle(
        AnomalySeverity severity,
        double actual,
        double avg,
    ) {
        final pct = (((actual - avg) / avg) * 100).toStringAsFixed(0);
        return switch (severity) {
            AnomalySeverity.high => 'Spending spike detected - $pct% above normal',
            AnomalySeverity.medium => 'Spending is notably higher than usual',
            AnomalySeverity.low => 'Spending is slightly above your average',
        };
    }


    String _totalSpendingBody(
        MonthlySpendingSummary current,
        double avg,
        double z,
    ) {
        final actualStr = 'R${current.totalExpenses.toStringAsFixed(2)}';
        final avgStr = 'R${avg.toStringAsFixed(2)}';

        return 'You spent $actualStr in ${current.label}, compared to your average of $avgStr. '
                'This is  ${z.toStringAsFixed(1)} standard deviations above your typical spending.';
    }

    String _categoryTitle(AnomalySeverity severity, String category) {
        return switch (severity) {
            AnomalySeverity.high => 'Unusal $category spending',
            AnomalySeverity.medium => '$category spending is higher than normal',
            AnomalySeverity.low => '$category spending increased this month',
        };
    }

    String _categoryBody(
        String category,
        double actual,
        double avg,
        String monthLabel,
    ) {
        final actualStr = 'R${actual.toStringAsFixed(2)}';
        final avgStr = 'R${avg.toStringAsFixed(2)}';
        final pct = avg > 0 ? '${(((actual - avg)/avg)*100).toStringAsFixed(0)}% '
        : '';
        return 'Your $category spending in $monthLabel was $actualStr  ${pct}higher than your usual $avgStr. ';
    }

      static String severityLabel(AnomalySeverity severity) {
        return switch (severity) {
        AnomalySeverity.high => 'alert',
        AnomalySeverity.medium => 'warning',
        AnomalySeverity.low => 'tip',
        };
    }

    static Color severityColour(AnomalySeverity severity) {
        return switch (severity) {
            AnomalySeverity.high => Colors.redAccent,
            AnomalySeverity.medium => Colors.orangeAccent,
            AnomalySeverity.low => Colors.blueAccent,

        };
    }

    static IconData severityIcon( AnomalySeverity severity) {
        return switch (severity) {
            AnomalySeverity.high => Icons.warning_rounded,
            AnomalySeverity.medium => Icons.trending_up_rounded,
            AnomalySeverity.low => Icons.info_outline_rounded,
        };
    }
}


