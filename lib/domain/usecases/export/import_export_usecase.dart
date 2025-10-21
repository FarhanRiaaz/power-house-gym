import 'package:finger_print_flutter/core/base_usecase.dart';
import 'package:finger_print_flutter/data/service/report/export/export_data_service_impl.dart';

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


class ImportDataUseCase extends UseCase<List<List<String>>, String> {
  final DataUtilityService _dataUtilityService;

  ImportDataUseCase(this._dataUtilityService);
  @override
  Future<List<List<String>>> call({required String params}) async {
    return await _dataUtilityService.importNewMembers(params);
  }
}