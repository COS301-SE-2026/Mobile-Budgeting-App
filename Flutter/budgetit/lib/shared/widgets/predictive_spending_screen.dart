import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:budgetit/services/analysis/anomaly_detection_service.dart';
import 'package:budgetit/services/analysis/predictive_spending_service.dart';
import 'package:budgetit/services/analysis/transaction_history_service.dart';
import 'package:budgetit/models/anomaly_result.dart';
import 'package:budgetit/models/spending_prediction.dart';
import 'package:budgetit/shared/widgets/insight_widget.dart';

class PredictiveSpendingScreen extends StatefulWidget {
  const PredictiveSpendingScreen({super.key});

    @override
    State<PredictiveSpendingScreen> createState() => _PredictiveSpendingScreenState();

}

class _PredictiveSpendingScreenState extends State<PredictiveSpendingScreen> {
  static const int _historyMonths = 6;
  late Future<_SpendingInsightsData> _insightsFuture;
  bool _insightsFutureLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_insightsFutureLoaded) return;

    _insightsFuture = _loadInsights(context.read<AppDatabase>());
    _insightsFutureLoaded = true;
  }

  Future<_SpendingInsightsData> _loadInsights(AppDatabase database) async {
    final historyService = TransactionHistoryService(database);
    final anomalyService = AnomalyDetectionService();
    final predictiveService = PredictiveSpendingService();
    final history = await historyService.getNonEmptyMonthlyHistory(
      monthsBack: _historyMonths,
    );
    final anomalies = anomalyService.detect(history);

    final now = DateTime.now();
    final currentMonthSummary = await historyService.getSummaryForMonth(
      now.year,
      now.month,
    );
    final prediction = predictiveService.predictCurrentMonth(
      history,
      currentMonthActual: currentMonthSummary.totalExpenses,
      dayOfMonth: DateTime(now.year, now.month + 1, 0).day,
    );

    return _SpendingInsightsData(anomalies: anomalies, prediction: prediction);
  }

  BudgetInsight _anomalyToInsight(AnomalyResult anomaly, BuildContext context) {
    return BudgetInsight(
      title: anomaly.title,
      body: anomaly.body,
      icon: _iconFor(anomaly.severity),
      accentColor: _colorFor(anomaly.severity, context),
      severity: _insightSeverityFor(anomaly.severity),
      transactionDescription: anomaly.transactionDescription,
      transactionCategory: anomaly.transactionCategory,
      transactionAmount: anomaly.transactionAmount,
      transactionDate: anomaly.transactionDate,
    );
  }

  IconData _iconFor(AnomalySeverity severity) => switch (severity) {
    AnomalySeverity.high => Icons.warning_rounded,
    AnomalySeverity.medium => Icons.trending_up_rounded,
    AnomalySeverity.low => Icons.info_outline_rounded,
  };

  Color _colorFor(AnomalySeverity severity, BuildContext context) =>
      switch (severity) {
        AnomalySeverity.high => context.colours.error,
        AnomalySeverity.medium => context.colours.warning,
        AnomalySeverity.low => context.colours.informational,
      };

  InsightSeverity _insightSeverityFor(AnomalySeverity severity) =>
      switch (severity) {
        AnomalySeverity.high => InsightSeverity.alert,
        AnomalySeverity.medium => InsightSeverity.warning,
        AnomalySeverity.low => InsightSeverity.tip,
      };

  List<BudgetInsight> _fallbackInsights(SpendingPrediction? prediction) {
    final insights = <BudgetInsight>[];

    insights.add(
      BudgetInsight(
        title: 'Building your financial picture',
        body:
            'Add transaction across 2+ months and we\'ll start detecting unusual spending patterns automatically. ',
        icon: Icons.bar_chart_rounded,
        accentColor: context.colours.informational,
        severity: InsightSeverity.tip,
      ),
    );

    if (prediction != null) {
      insights.add(
        BudgetInsight(
          title: 'Projected Spend for ${prediction.shortLabel}',
          body:
              'Based on your spending thus far, you are on track to spend around '
              ' R${prediction.predictedAmount.toStringAsFixed(2)} this month.',
          icon: Icons.trending_up_rounded,
          accentColor: context.colours.warning,
          severity: InsightSeverity.tip,
        ),
      );
    }

    insights.add(
      BudgetInsight(
        title: 'Your data stays on your device',
        body:
            'All analysis runs locally [no spending data ever leaves your phone]',
        icon: Icons.lock_outline_rounded,
        accentColor: context.colours.greenAccents,
        severity: InsightSeverity.tip,
      ),
    );

    return insights;

    //context.context.colours
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;
    final cardColor = isDark
        ? context.colours.blendedprimary
        : context.colours.secondary;
    final cardTextColor = isDark
        ? context.colours.secondary
        : context.colours.background;
    final sectionTextColor = isDark
        ? context.colours.textPrimary
        : context.colours.secondary;
    final cardBorderColor = Colors.black;
    const cardBorderWidth = 3.0;
    const cardShadow = [BoxShadow(color: Colors.black, offset: Offset(4, 4))];

    return Scaffold(
      backgroundColor: context.colours.background,
      appBar: AppBar(
        backgroundColor: context.colours.background,
        elevation: 0,
        leading: GestureDetector(
          //icon: Icon(Icons.arrow_back_ios_rounded, color: context.colours.textPrimary),
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: context.colours.textPrimary,
          ),
        ),
        title: Text(
          'SPENDING INSIGHTS',
          style: TextStyle(
            color: context.colours.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.2,
            fontFamily: 'JetBrainsMono',
          ),
        ),
      ),
      body: FutureBuilder<_SpendingInsightsData>(
        future: _insightsFuture,
        builder: (context, snapshot) {
          final data = snapshot.data;
          final anomalies = data?.anomalies ?? const <AnomalyResult>[];
          final prediction = data?.prediction;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (snapshot.hasError) ...[
                  _NeoCard(
                    color: context.colours.error.withValues(alpha: 0.15),
                    borderColor: context.colours.error,
                    shadow: false,
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: context.colours.error,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Could not load spending insights.',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.colours.error,
                              fontFamily: 'JetBrainsMono',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                _PredictionCard(
                  context: context,
                  prediction: prediction,
                  cardColor: cardColor,
                  borderColor: cardBorderColor,
                  borderWidth: cardBorderWidth,
                  shadow: cardShadow,
                  cardTextColor: cardTextColor,
                ),
                const SizedBox(height: 24),
                Text(
                  'ANOMALY DETECTION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: sectionTextColor,
                    letterSpacing: 1.4,
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Unusual spending patterns detected from your history.',
                  style: TextStyle(
                    fontSize: 12,
                    color: sectionTextColor.withValues(alpha: 0.75),
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
                const SizedBox(height: 14),
                if (snapshot.connectionState == ConnectionState.waiting)
                  _NeoCard(
                    color: cardColor,
                    borderColor: cardBorderColor,
                    shadow: true,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: cardTextColor,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                else if (anomalies.isNotEmpty)
                  InsightWidget(
                    insights: anomalies
                        .map((a) => _anomalyToInsight(a, context))
                        .toList(),
                  )
                else
                  InsightWidget(insights: _fallbackInsights(prediction)),
                const SizedBox(height: 24),
                _HowItWorksCard(
                  context: context.colours,
                  cardColor: cardColor,
                  cardTextColor: cardTextColor,
                  borderColor: cardBorderColor,
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SpendingInsightsData {
  final List<AnomalyResult> anomalies;
  final SpendingPrediction? prediction;

  const _SpendingInsightsData({
    required this.anomalies,
    required this.prediction,
  });
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*class AnomalyDetectionServiceHelpers {
    static IconData iconFor(AnomalySeverity severity) {
        return switch (severity) {
            AnomalySeverity.high => Icons.warning_rounded,
            AnomalySeverity.medium => Icons.trending_up_rounded,
            AnomalySeverity.low => Icons.info_outline_rounded,
        };
    }

    static Color colorFor(AnomalySeverity severity, dynamic context.colours) {
        return switch (severity) {
            AnomalySeverity.high => context.colours.redColor,
            AnomalySeverity.medium => Colors.orangeAccent,
            AnomalySeverity.low => context.colours.tertiary,
        };
    }

    static InsightSeverity insightSeverityFor(AnomalySeverity severity) {
        return switch (severity) {
            AnomalySeverity.high => InsightSeverity.alert,
            AnomalySeverity.medium => InsightSeverity.warning,
            AnomalySeverity.low => InsightSeverity.tip,
        };
    }
}
*/

class _NeoCard extends StatelessWidget{
    final Widget child;
    final Color color;
    final Color borderColor;
    final bool shadow;

    const _NeoCard({
        required this.child,
        required this.color,
        required this.borderColor,
        required this.shadow,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: color,
                border: Border.all(color: borderColor, width: 3),
                boxShadow: shadow ? const [BoxShadow(color: Colors.black, offset: Offset(4,4))] : null,
            ),
            child: child,
        );
    }
}


class _PredictionCard extends StatelessWidget {
  final SpendingPrediction? prediction;
  final dynamic context;
  final Color cardColor;
  final Color cardTextColor;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow> shadow;
  const _PredictionCard({
    required this.prediction,
    required this.context,
    required this.cardColor,
    required this.cardTextColor,
    required this.borderColor,
    required this.borderWidth,
    required this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_graph_rounded,
                color: cardTextColor.withValues(alpha: 0.7),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'SPENDING PREDICTION',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: cardTextColor.withValues(alpha: 0.65),
                  letterSpacing: 1.4,
                  fontFamily: 'JetBrainsMono',
                ),
              ),
            ],
          ),

                    const SizedBox(height: 20),
                    if (prediction == null) ...[
                        Text(
                            'Not enough data yet',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: cardTextColor,
                                fontFamily: 'SpaceGrotesk',
                            ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                            'Add transactions for at least 2 months to see your '
                            'spending prediction.',
                            style: TextStyle(
                                fontSize: 12,
                                color: cardTextColor.withValues(alpha: 0.75),
                                height: 1.5,
                                fontFamily: 'JetBrainsMono',
                            ),
                        ),
                    ] else ...[
                        Text(
                            prediction!.label.toUpperCase(),
                            style: TextStyle(
                                fontSize: 11,
                                color: cardTextColor.withValues(alpha: 0.65),
                                letterSpacing: 1.2,
                                fontFamily: 'JetBrainsMono',
                            ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                            'R${prediction!.predictedAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                color: cardTextColor,
                                height: 1,
                                fontFamily: 'SpaceGrotesk',
                            ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                            'Range: R${prediction!.lowerBound.toStringAsFixed(0)} '
                            '– R${prediction!.upperBound.toStringAsFixed(0)}', 
                            style: TextStyle(
                                fontSize: 12,
                                color: cardTextColor.withValues(alpha: 0.75),
                                fontFamily: 'JetBrainsMono',
                            ),
                        ),
                        const SizedBox(height: 20),
            
                        Row(
                            children: [
                                Text(
                                    'CONFIDENCE',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: cardTextColor.withValues(alpha: 0.65),
                                        letterSpacing: 1.2,
                                        fontFamily: 'JetBrainsMono',
                                    ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: Container(
                                        height: 8,
                                        decoration: BoxDecoration( border: Border.all(color: Colors.black, width: 2)),
                                    
                                        child: FractionallySizedBox(
                                            alignment: Alignment.centerLeft,
                                            widthFactor: prediction!.confidence,
                                            child: Container(color: cardTextColor),
                                        ),
                                    ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                    '${(prediction!.confidence * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: cardTextColor,
                                        fontFamily: 'JetBrainsMono',
                                    ),
                                ),
                            ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                            'Based on ${prediction!.monthsUsed} month'
                            '${prediction!.monthsUsed != 1 ? 's' : ''} of history',
                            style: TextStyle(
                                fontSize: 11,
                                color: cardTextColor.withValues(alpha: 0.65),
                                fontFamily: 'JetBrainsMono',
                            ),
                        ),
                    ],
                ],
            ),
        );
    }
}



class _EmptyAnomaliesCard extends StatelessWidget {
    final dynamic context;
    const _EmptyAnomaliesCard({ required this.context});

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: context.colours.primary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.colours.textPrimary.withValues(alpha: 0.15)),
            ),
            child: Column(
                children: [
                    Icon(
                        Icons.check_circle_outline_rounded,
                        size: 36,
                        color: context.colours.greenAccents,
                    ),
                    const SizedBox(height: 12),
                    Text(
                        'No anomalies detected',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: context.colours.textPrimary,
                            fontFamily: 'SpaceGrotesk',
                        ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                        'Your spending looks consistent with your historical patterns.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: context.colours.textPrimary.withValues(alpha: 0.6),
                            height: 1.5,
                            fontFamily: 'JetBrainsMono',
                        ),
                    ),
                ],
            ),
        );
    }
}

class _LoadingCard extends StatelessWidget {
    final dynamic context;
    const _LoadingCard({required this.context});

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
                color: context.colours.primary,
                borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
                children: [
                    CircularProgressIndicator(color: context.colours.secondary, strokeWidth: 2),
                    const SizedBox(height: 14),
                    Text(
                        'Analysing your spending',
                        style: TextStyle(
                            fontSize: 12,
                            color: context.colours.textMuted,
                            fontFamily: 'JetBrainsMono',
                        ),
                    ),
                ],
            ),
        );
    }
}

class _ErrorCard extends StatelessWidget {
    final String error;
    final dynamic context;
    const _ErrorCard({ 
        required this.error, 
        required this.context
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: context.colours.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.colours.error.withValues(alpha: 0.4)),
            ),
            child: Row(
                children: [
                    Icon(Icons.error_outline, color: context.colours.error, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(
                            'Analysis error: $error',
                            style: TextStyle(
                                fontSize: 12,
                                color: context.colours.error,
                                fontFamily: 'JetBrainsMono',
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}


class _HowItWorksCard extends StatelessWidget {
  final dynamic context;
  final Color cardColor;
  final Color cardTextColor;
  final Color borderColor;
  const _HowItWorksCard({
    required this.context,
    required this.cardColor,
    required this.cardTextColor,
    required this.borderColor,
  });

    @override
    Widget build(BuildContext context){
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: cardColor,
                
                border: Border.all(color: borderColor, width: 3),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4,4))],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'HOW THIS WORKS',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: cardTextColor.withValues(alpha: 0.65),
                            letterSpacing: 1.4,
                            fontFamily: 'JetBrainsMono',
                        ),
                    ),
                    const SizedBox(height: 14),
                    _InfoRow(
                        icon: Icons.storage_rounded,
                        text: 'All analysis runs on your device — no data leaves your phone.',
                        context: context.colours,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                        icon: Icons.query_stats_rounded,
                        text: 'Anomalies are detected using z-score statistical analysis on your monthly spending history.',
                        context: context.colours,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                        icon: Icons.trending_up_rounded,
                        text: 'Predictions use linear regression on your last 6 months of data.',
                        context: context.colours,
                    ),
                ],
            ),
        );
    }
}

class _InfoRow extends StatelessWidget {
    final IconData icon;
    final String text;
    final dynamic context;
    const _InfoRow({
        required this.icon,
        required this.text,
        required this.context,
    });

  @override
  Widget build(BuildContext context) {
// AI used to help with this part
    final effectiveTextColor = Theme.of(context).brightness == Brightness.dark
        ? context.colours.secondary
        : context.colours.cardText;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: effectiveTextColor.withValues(alpha: 0.65)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: effectiveTextColor.withValues(alpha: 0.75),
              height: 1.5,
              fontFamily: 'JetBrainsMono',
            ),
          ),
        ),
      ],
    );
  }
}
