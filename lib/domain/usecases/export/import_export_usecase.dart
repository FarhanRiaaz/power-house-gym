import 'package:finger_print_flutter/core/base_usecase.dart';
import 'package:finger_print_flutter/data/service/report/export/export_data_service_impl.dart';

class ImportDataParams {
  final List<List<String>> csvData;
  final CsvImportType type;

  ImportDataParams({required this.csvData, required this.type});
}


/// Use Case responsible for reading member data from an external file
/// (e.g., Excel/CSV) and saving it to the database.
///
/// Type: int (Number of records imported)
/// Params: String (The file path for the source file)
class ExportDataUseCase extends UseCase<void, void> {
  final DataUtilityService _dataUtilityService;

  ExportDataUseCase(this._dataUtilityService);

  @override
  Future<void> call({required void params}) async {
    return _dataUtilityService.exportData();
  }
}


class ImportDataUseCase extends UseCase<int, ImportDataParams> {
  final DataUtilityService _dataUtilityService;

  ImportDataUseCase(this._dataUtilityService);
  @override
  Future<int> call({required ImportDataParams params}) async {
    return await _dataUtilityService.insertBatchFromCsv(params);
  }
}