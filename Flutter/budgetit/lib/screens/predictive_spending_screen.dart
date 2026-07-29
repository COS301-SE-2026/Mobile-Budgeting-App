import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:budgetit/services/analysis/background_anomaly_scanner.dart';
import 'package:budgetit/models/anomaly_result.dart';
import 'package:budgetit/models/spending_prediction.dart';
import 'package:budgetit/components/insight_widget.dart';

class PredictiveSpendingScreen extends StatefulWidget {
    const PredictiveSpendingScreen({super.key});

    @override
    State<PredictiveSpendingScreen> createState() => _PredictiveSpendingScreenState();

}

class _PredictiveSpendingScreenState extends State<PredictiveSpendingScreen> {
    @override
    void initState() {
        super.initState();
        WidgetsBinding.instance.addPostFrameCallback((_) {
            final scanner = context.read<BackgroundAnomalyScanner>();
            if (scanner.isStale()) scanner.scan();
        });
    }

    String _formatTime(DateTime dt) {
        final hour = dt.hour.toString().padLeft(2, '0');
        final minute = dt.minute.toString().padLeft(2, '0');
        return '$hour:$minute';

    }

    BudgetInsight _anomalyToInsight(AnomalyResult anomaly, MyColours colours) {
        return BudgetInsight(
            title: anomaly.title,
            body: anomaly.body,
            icon: _iconFor(anomaly.severity),
            accentColor: _colorFor(anomaly.severity, colours),
            severity: _insightSeverityFor(anomaly.severity),
        );
    }

    IconData _iconFor(AnomalySeverity severity) => switch (severity) {
        AnomalySeverity.high => Icons.warning_rounded,
        AnomalySeverity.medium => Icons.trending_up_rounded,
        AnomalySeverity.low => Icons.info_outline_rounded,
    };

    Color _colorFor(AnomalySeverity severity, MyColours colours) => switch (severity) {
        AnomalySeverity.high => colours.error,
        AnomalySeverity.medium => colours.warning,
        AnomalySeverity.low => colours.informational,
    };

    InsightSeverity _insightSeverityFor(AnomalySeverity severity) => switch (severity) {
        AnomalySeverity.high => InsightSeverity.alert,
        AnomalySeverity.medium => InsightSeverity.warning,
        AnomalySeverity.low => InsightSeverity.tip,
    };

    List<BudgetInsight> _fallbackInsights( //fallback if months <2 , 
        BackgroundAnomalyScanner scanner,
        MyColours colours,
    ){
        final insights = <BudgetInsight>[];

        insights.add(BudgetInsight(
            title: 'Building your financial picture',
            body: 'Add transaction across 2+ months and we\'ll start detecting unusual spending patterns automatically. ' ,
            icon: Icons.bar_chart_rounded,
            accentColor: colours.informational,
            severity: InsightSeverity.tip,
        ));

        final prediction = scanner.prediction;
        if(prediction != null){
            insights.add(BudgetInsight(
                title: 'Projected Spend for ${prediction.shortLabel}',
                body: 'Based on your spending thus far, you are on track to spend around '
                       ' R${prediction.predictedAmount.toStringAsFixed(2)} this month.',
                icon: Icons.trending_up_rounded,
                accentColor: colours.warning,
                severity: InsightSeverity.tip,
            ));
        }

        insights.add(BudgetInsight(
            title: 'Your data stays on your device',
            body: 'All analysis runs locally [no spending data ever leaves your phone]',
            icon: Icons.lock_outline_rounded,
            accentColor: colours.greenAccents,
            severity: InsightSeverity.tip,
        ));

        return insights;


    }

    @override
    Widget build(BuildContext context) {
        context.watch<ThemeProvider>();
        final colours = MyColours();
        final scanner = context.watch<BackgroundAnomalyScanner>();
        final isDark = MyColours.isDark;
        final cardColor = isDark ? colours.primary: colours.background;
        final cardBorderColor = Colors.black;
        const cardBorderWidth = 3.0;
        const cardShadow = [BoxShadow(color: Colors.black, offset: Offset(4,4))];

        return Scaffold(
            backgroundColor: colours.background,
            appBar: AppBar(
                backgroundColor: colours.background,
                elevation: 0,
            leading: GestureDetector(
                //icon: Icon(Icons.arrow_back_ios_rounded, color: colours.textPrimary),
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.arrow_back_ios_rounded, color: colours.textPrimary),
            ),
            title: Text (
                'SPENDING INSIGHTS',
                style: TextStyle(
                    color:colours.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                    fontFamily: 'JetBrainsMono',
                ),
            ),
            actions: [
                if (scanner.isScanning)
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colours.secondary,
                        ),
                    ),
                )
                else
                    GestureDetector(
                        onTap: () => scanner.scan(),
                        child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Icon(Icons.refresh_rounded, color: colours.textPrimary),
                    ),
                      //  tooltip: 'Refresh Analysis',
                    ),
            ],
        ),
        body: RefreshIndicator(
            onRefresh: () => scanner.scan(),
            color: colours.secondary,
            backgroundColor: colours.primary,
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                        if (scanner.lastScanned != null)
                            Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text (
                                    'Last updated: ${_formatTime(scanner.lastScanned!)}',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: colours.textMuted,
                                        fontFamily: 'JetBrainsMono',
                                    ),
                                ),
                            ),

                        if(scanner.lastError != null)    
                            _NeoCard(
                                color: colours.error.withValues(alpha: 0.15),
                                borderColor: colours.error,
                                shadow: false,
                                child: Row(
                                    children: [
                                        Icon(Icons.error_outline, color: colours.error, size: 18),
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: Text(
                                                'Analysis Error: ${scanner.lastError}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: colours.error,
                                                    fontFamily: 'JetBrainsMono',
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                                ),

                                if(scanner.lastError != null) const SizedBox(height: 12),

                            _PredictionCard(
                                prediction: scanner.prediction,
                                colours: colours,
                                cardColor: cardColor,
                                borderColor: cardBorderColor,
                                borderWidth: cardBorderWidth,
                                shadow: cardShadow,
                            ),

                            const SizedBox(height: 24),
                            Text(
                                'ANOMALY DETECTION',
                                style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: colours.textMuted,
                                letterSpacing: 1.4,
                                fontFamily: 'JetBrainsMono',
                                ),
                            ),

                            const SizedBox(height: 4),
                            Text(
                                'Unusual spending patterns detected from your history.',
                                style: TextStyle(
                                    fontSize:12,
                                    color: colours.textPrimary.withValues(alpha: 0.7),
                                    fontFamily: 'JetBrainsMono',
                                ),
                            ),

                            const SizedBox(height: 14),

                            if (scanner.isScanning && scanner.anomalies.isEmpty)
                              _NeoCard(
                                color: cardColor,
                                borderColor: cardBorderColor,
                                shadow: true,
                                child: Column(
                                    children: [
                                        CircularProgressIndicator(
                                            color: colours.secondary,
                                            strokeWidth: 2,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                            'Analysing your spending',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: colours.textMuted,
                                                fontFamily: 'JetBrainsMono',
                                            ),
                                        ),
                                    ],
                                ),
                            )
                            else if(scanner.anomalies.isNotEmpty)
                                InsightWidget(
                                    insights: scanner.anomalies
                                        .map((a) => _anomalyToInsight(a, colours))
                                        .toList(),
                                )
                                else
                                    InsightWidget(
                                        insights: _fallbackInsights(scanner, colours),
                                    ),
                                const SizedBox(height: 24),

                                _HowItWorksCard(
                                    colours: colours,
                                    cardColor: cardColor,
                                    borderColor: cardBorderColor,
                                ),

                                const SizedBox(height: 20),
                            

                        ],
                    ),
                ),
            ),
        );
    }

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

    static Color colorFor(AnomalySeverity severity, MyColours colours) {
        return switch (severity) {
            AnomalySeverity.high => colours.redColor,
            AnomalySeverity.medium => Colors.orangeAccent,
            AnomalySeverity.low => colours.tertiary,
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
    final MyColours colours;
    final Color cardColor;
    final Color borderColor;
    final double borderWidth;
    final List<BoxShadow> shadow;
    const _PredictionCard({required this.prediction, required this.colours, required this.cardColor, required this.borderColor, required this.borderWidth, required this.shadow});

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
                                color: colours.textPrimary.withValues(alpha: 0.7),
                                size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                                'SPENDING PREDICTION',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: colours.textMuted,
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
                                color: colours.textPrimary,
                                fontFamily: 'SpaceGrotesk',
                            ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                            'Add transactions for at least 2 months to see your '
                            'spending prediction.',
                            style: TextStyle(
                                fontSize: 12,
                                color: colours.textPrimary.withValues(alpha: 0.6),
                                height: 1.5,
                                fontFamily: 'JetBrainsMono',
                            ),
                        ),
                    ] else ...[
                        Text(
                            prediction!.label.toUpperCase(),
                            style: TextStyle(
                                fontSize: 11,
                                color: colours.textMuted,
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
                                color: colours.textPrimary,
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
                                color: colours.textPrimary.withValues(alpha: 0.6),
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
                                        color: colours.textMuted,
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
                                            child: Container(color: colours.secondary),
                                        ),
                                    ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                    '${(prediction!.confidence * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: colours.textPrimary,
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
                                color: colours.textMuted,
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
    final MyColours colours;
    const _EmptyAnomaliesCard({ required this.colours});

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: colours.primary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colours.textPrimary.withValues(alpha: 0.15)),
            ),
            child: Column(
                children: [
                    Icon(
                        Icons.check_circle_outline_rounded,
                        size: 36,
                        color: colours.greenAccents,
                    ),
                    const SizedBox(height: 12),
                    Text(
                        'No anomalies detected',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colours.textPrimary,
                            fontFamily: 'SpaceGrotesk',
                        ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                        'Your spending looks consistent with your historical patterns.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: colours.textPrimary.withValues(alpha: 0.6),
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
    final MyColours colours;
    const _LoadingCard({required this.colours});

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
                color: colours.primary,
                borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
                children: [
                    CircularProgressIndicator(color: colours.secondary, strokeWidth: 2),
                    const SizedBox(height: 14),
                    Text(
                        'Analysing your spending',
                        style: TextStyle(
                            fontSize: 12,
                            color: colours.textMuted,
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
    final MyColours colours;
    const _ErrorCard({ 
        required this.error, 
        required this.colours
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: colours.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colours.error.withValues(alpha: 0.4)),
            ),
            child: Row(
                children: [
                    Icon(Icons.error_outline, color: colours.error, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(
                            'Analysis error: $error',
                            style: TextStyle(
                                fontSize: 12,
                                color: colours.error,
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
    final MyColours colours;
    final Color cardColor;
    final Color borderColor;
    const _HowItWorksCard({required this.colours, required this.cardColor, required this.borderColor});

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
                            color: colours.textMuted,
                            letterSpacing: 1.4,
                            fontFamily: 'JetBrainsMono',
                        ),
                    ),
                    const SizedBox(height: 14),
                    _InfoRow(
                        icon: Icons.storage_rounded,
                        text: 'All analysis runs on your device — no data leaves your phone.',
                        colours: colours,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                        icon: Icons.query_stats_rounded,
                        text: 'Anomalies are detected using z-score statistical analysis on your monthly spending history.',
                        colours: colours,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                        icon: Icons.trending_up_rounded,
                        text: 'Predictions use linear regression on your last 6 months of data.',
                        colours: colours,
                    ),
                ],
            ),
        );
    }
}

class _InfoRow extends StatelessWidget {
    final IconData icon;
    final String text;
    final MyColours colours;
    const _InfoRow({
        required this.icon,
        required this.text,
        required this.colours,
    });

    @override
    Widget build(BuildContext context) {
        return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Icon(icon, size: 15, color: colours.textMuted),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                        text,
                        style: TextStyle(
                            fontSize: 12,
                            color: colours.textPrimary.withValues(alpha: 0.65),
                            height: 1.5,
                            fontFamily: 'JetBrainsMono',
                        ),
                    ),
                ),
            ],
        );
    }
}