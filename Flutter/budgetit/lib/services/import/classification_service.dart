import '../models/parsed_transaction.dart';
import '../utils/keyword_mapper.dart';

class ClassificationService { 

    final Map<String, String> _categoryNameToId;

    ClassificationService(this,_categoryNameToId);


    void classifyAll ( List<ParsedTransaction> transactions) { //this is to classify all the tranactions in place. 
        for (final transaction in transactions) {
            if ( transaction.categoryOverridden) continue;
            _classifyOne(transaction);
        }
    }

    
    void _classifyOne( ParsedTransaction pt) {
        final keywordMatch = KeywordMapper.classify(pt.description);
        if (keywordMatch != null) {
            final id = _categoryNameToId[keywordMatch];
            if (id != null) {
                pt.categoryId = id;
                pt.categoryName = keywordMatch;
                return;
            }
        }

        if (pt.isIncome) { //this is income/expense classification, it is to say  if perhaps no  keyword match was found, meaning that keyword match didnt work and that now that we must use income and /or expense for classification of transaction due to a lack of keyword matching in such a case where the keywords dont match according to the keyword mapper that was made above, the keyword mapper maps keywords to categories and if the keyword mapper doesnt find a match for a keywoprd in the tranaction description that links to a a ctegory, then use this classification method. also all code here is classification methods for transactios that are to be imported in the app during usages of the app.
            _assignFallback(pt, 'Other Income'); 
            } else { 
                pt.categoryId = null; pt.categoryName = null;
                }
    }

    void _assignFallback(ParsedTransaction pt, String categoryName) { //this is to assgin fallback category to a transaction if no ketywprd match was made.  
        final id = _categoryNameToID[categoryName];
        if ( id != null) { 
            pt. category = id; pt.categoryName = categoryName;
        }
    }


    double classificationRate(List<ParsedTransaction> transactions) { 
        if (transactions.isEmpty) {
            return 0;
            }
        final classified = transactions.where((t) => t.categoryId != null).length;  
        return classified/transactions.length;

    }

}