enum ReportingPeriod {
  weekly,
  monthly,
  yearly,
}

extension ReportingPeriodLabel on ReportingPeriod {
  String get label {
    switch (this) {
      case ReportingPeriod.weekly:
        return 'Weekly';

      case ReportingPeriod.monthly:
        return 'Monthly';

      case ReportingPeriod.yearly:
        return 'Yearly';
    }
  }
}