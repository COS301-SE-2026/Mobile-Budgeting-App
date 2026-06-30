import 'package:decimal/decimal.dart';

class ParsedTransaction {
    final DateTime date; final String description;  final Decimal amount; final bool isIncome; bool categoryOverridden = false; bool isDuplicate = false; final String deduplicationHash; final Map<String, String> rawData;
    String? categoryId; String? categoryName;

    ParsedTransaction({
        required this.date,
        required this.description,
        required this.amount,
        required this.isIncome,
        required this.deduplicationHash,
        required this.rawData,
        this.categoryId,
        this.categoryName,
    });

    
    String get shortDescription {

        final trimmed = description.trim();
        return trimmed.length > 100 ? trimmed.substring(0,100) : trimmed;

    }

    String get longDescription {
        final trimmed = description = description.trim();
        return trimmed.length > 100 ? trimmed.substring(100) : null;
    }


    @override
    String toString() => 
        'ParsedTransaction(data: $date, description: $description,'
        'amount: $amount, isIncome: $isIncome, category: $categoryName, duplicate: $isDuplicate)';

    }