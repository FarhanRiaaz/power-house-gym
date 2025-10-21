import 'package:finger_print_flutter/core/base_usecase.dart';
import 'package:finger_print_flutter/data/service/report/export/export_data_service_impl.dart';

/// Use Case responsible for reading member data from an external file
/// (e.g., Excel/CSV) and saving it to the database.
///
/// Type: int (Number of records imported)
/// Params: String (The file path for the source file)
class ImportDataUseCase extends UseCase<int, String> {
  final DataUtilityService _dataUtilityService;

  ImportDataUseCase(this._dataUtilityService);

  @override
  Future<int> call({required String params}) async {
    return _dataUtilityService.importNewMembers(params);
  }
}


class ImportDataUseCase extends UseCase<int, String> {
  final DataUtilityService _dataUtilityService;

  ImportDataUseCase(this._dataUtilityService);

  @override
  Future<int> call({required String params}) async {
    return _dataUtilityService.importNewMembers(params);
  }
}