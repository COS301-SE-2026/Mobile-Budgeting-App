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
        reutrn BudgetInsight(
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
        AnomalySeverity.low => colors.informational,
    };

    InsightSeverity _insightSeverityFor(AnomalySeverity severity) => swithc (severity) {
        AnomalySeverity.high => InsightSeverity.alert,
        AnomalySeverity.medium => InsightSeverity.warning,
        AnomalySeverity.low => InsightSeverity.tip,
    };

    @override
    Widget build(BuildContext context) {
        context.watch<ThemeProvider>();
        final colours = MyColours();
        final scanner = context.watch<BackgroundAnomalyScanner>();

        return Scaffold(
            backgroundColor: colours.background,
            appBar: AppBar(
                backgroundColor: colours.background,
                elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded, color: colours.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
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
                    IconButton(
                        icon: Icon(Icons.refresh_rounded, color: colours.textPrimary),
                        onPressed: () => scanner.scan(),
                        tooltip: 'Refresh Analysis',
                    ),
            ],
        ),
        body: RefreshIndicator(
            onRefresh: () => scanner.scan(),
            color: colours.secondary,
            backgroundColor: colours.primary,
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symetric(horizontal: 20, vertical: 16),
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
                            _ErrorCard(error: scanner.lastError!, colours: colours),
                            _PredictionCard(
                                prediction: scanner.prediction,
                                colours: colours,
                            ),

                            const SizedBox(height: 28),
                            Text(
                                'ANOMALY DETECTION',
                                style: TextStyle(
                                fontSize: 12,
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
                                    fontSize:13,
                                    color: colours.textPrimary.withValues(alpha: 0.7),
                                    fontFamily: 'JetBrainsMono',
                                ),
                            ),

                            const SizedBox(height: 16),

                            if (scanner.isScanning && scanner.anomalies.isEmpty)
                              _LoadingCard(colours: colours)
                            else if(scanner.anomalies.isEmpty)
                              _EmptyAnomaliesCard(colours: colours)
                            else
                              InsightWidget(
                                insights: scanner.anomalies
                                    .map((a) => _anomalyToInsight(a))
                                    .toList(),
                              ),
                              const SizedBox(height: 28),

                              _HowItWorksCard(colours: colours),

                              const SizedBox(height: 20),
                            

                        ],
                    ),
                ),
            ),
        );
    }

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
class AnomalyDetectionServiceHelpers {
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



class _PredictionCard extends StatelessWidget {
    final SpendingPrediction? prediction;
    final MyColours colours;
    const _PredictionCard({required this.prediction, required this.colours});

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: colours.navBarColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colours.textPrimary.withValues(alpha: 0.15)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                        children: [
                            Icon(
                                Icons.auto_graph_rounded,
                                color: colours.textPrimary.withValues(alpha: 0.7),
                                size: 18,
                            ),
                            const SizedBox(width: 10),
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
                                fontSize: 22,
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
                                fontSize: 13,
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
                                fontSize: 42,
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
                                fontSize: 13,
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
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                            value: prediction!.confidence,
                                            backgroundColor:
                                            colours.textPrimary.withValues(alpha: 0.1),
                                            color: colours.secondary,
                                            minHeight: 6,
                                        ),
                                    ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                    '${(prediction!.confidence * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: colours.navBarColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colours.cardText.withValues(alpha: 0.15)),
            ),
            child: Column(
                children: [
                    Icon(
                        Icons.check_circle_outline_rounded,
                        size: 40,
                        color: colours.tertiary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                        'No anomalies detected',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colours.textPrimary,
                        ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                        'Your spending looks consistent with your historical patterns.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            color: colours.textPrimary.withValues(alpha: 0.6),
                            height: 1.5,
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
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: colours.navBarColor,
                borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
                children: [
                    CircularProgressIndicator(color: colours.secondary, strokeWidth: 2),
                    const SizedBox(height: 12),
                    Text(
                        'Analysing your spending...',
                        style: TextStyle(
                            fontSize: 13,
                            color: colours.textPrimary.withValues(alpha: 0.6),
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
                color: colours.redColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colours.redColor.withValues(alpha: 0.3)),
            ),
            child: Row(
                children: [
                    Icon(Icons.error_outline, color: colours.redColor, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(
                            'Analysis error: $error',
                            style: TextStyle(
                                fontSize: 12,
                                color: colours.redColor,
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
    const _HowItWorksCard({required this.colours});

    @override
    Widget build(BuildContext context){
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: colours.navBarColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colours.cardText.withValues(alpha: 0.1)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'How this works',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colours.textPrimary,
                        ),
                    ),
                    const SizedBox(height: 10),
                    _HowItWorksRow(
                        icon: Icons.storage_rounded,
                        text: 'All analysis runs on your device — no data leaves your phone.',
                        colours: colours,
                    ),
                    const SizedBox(height: 8),
                    _HowItWorksRow(
                        icon: Icons.query_stats_rounded,
                        text: 'Anomalies are detected using z-score statistical analysis on your monthly spending history.',
                        colours: colours,
                    ),
                    const SizedBox(height: 8),
                    _HowItWorksRow(
                        icon: Icons.trending_up_rounded,
                        text: 'Predictions use linear regression on your last 6 months of data.',
                        colours: colours,
                    ),
                ],
            ),
        );
    }
}

class _HowItWorksRow extends StatelessWidget {
    final IconData icon;
    final String text;
    final MyColours colours;
    const _HowItWorksRow({
        required this.icon,
        required this.text,
        required this.colours,
    });

    @override
    Widget build(BuildContext context) {
        return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Icon(icon, size: 16, color: colours.textPrimary.withValues(alpha: 0.5)),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                        text,
                        style: TextStyle(
                            fontSize: 12,
                            color: colours.textPrimary.withValues(alpha: 0.6),
                            height: 1.5,
                        ),
                    ),
                ),
            ],
        );
    }
}