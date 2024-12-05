import 'package:myhospital/features/lab_results/models/lab_result.dart';
import 'package:myhospital/features/lab_results/repository/lab_results_repository.dart';

class LabResultsController {
  final LabResultsRepository repository;

  LabResultsController(this.repository);

  Future<List<LabResult>> getUserLabResults(String userId) async {
    return await repository.fetchUserLabResults(userId);
  }
}
