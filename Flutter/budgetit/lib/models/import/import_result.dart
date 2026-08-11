/* 
/|||this file is to store results.|||||--||
|||results of import process.||||||||||
/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\/\/ 
*/

class ImportResult { final int totalParsed; final int inserted;  final int duplicatesSkipped;  final int failed;   final Map<String, String> errors;

    const ImportResult({
        required this.totalParsed, required this.inserted, required this.duplicatesSkipped, required this.failed, this.errors = const{},  
    });

    bool get isFullSucess => failed == 0 && duplicatesSkipped == 0;
    bool get hasInserts => inserted > 0;

    @override
    String toString() =>
    'ImportResult(parsed: $totalParsed, inserted: $inserted,'
    'duplicates: $duplicatesSkipped, failed: $failed)';
    
}