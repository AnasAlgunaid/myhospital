import 'package:myhospital/features/medical_reports/models/medical_report.dart';
import 'package:myhospital/features/medical_reports/repository/medical_reports_repository.dart';

class MedicalReportsController {
  final MedicalReportsRepository repository;

  MedicalReportsController(this.repository);

  Future<List<MedicalReport>> getUserMedicalReports(String userId) async {
    return await repository.fetchUserMedicalReports(userId);
  }
}
