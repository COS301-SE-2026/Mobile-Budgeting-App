enum SignConvention {
  crSuffixMeansIncome,
  minusPrefixMeansExpense,
  separateDebitCredit,
  signedAmount,

  keywordBased,
}

class StatementSchema {
  final SignConvention signConvention;
  final List<String> skipLinePatterns;

  const StatementSchema({
    required this.signConvention,
    this.skipLinePatterns = const [],
  });

  Map<String, dynamic> toJson() => {
        'signConvention': signConvention.name,
        'skipLinePatterns': skipLinePatterns,
      };

  factory StatementSchema.fromJson(Map<String, dynamic> json) {
    return StatementSchema(
      signConvention: SignConvention.values.firstWhere(
        (e) => e.name == json['signConvention'],
        orElse: () => SignConvention.keywordBased,
      ),
      skipLinePatterns: (json['skipLinePatterns'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  @override
  String toString() =>
      'StatementSchema (signConvention: $signConvention, skip: $skipLinePatterns)';
}