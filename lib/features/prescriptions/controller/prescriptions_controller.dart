import 'package:myhospital/features/prescriptions/models/prescription.dart';
import 'package:myhospital/features/prescriptions/repository/prescriptions_repository.dart';

class PrescriptionsController {
  final PrescriptionsRepository repository;

  PrescriptionsController(this.repository);

  Future<List<Prescription>> getUserPrescriptions(String userId) async {
    return await repository.fetchUserPrescriptions(userId);
  }
}
