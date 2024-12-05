import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/doctors/providers/doctors_provider.dart';
import 'package:myhospital/features/medical_reports/controller/medical_reports_controller.dart';
import 'package:myhospital/features/medical_reports/models/medical_report.dart';
import 'package:myhospital/features/current_user/providers/user_provider.dart';
import 'package:myhospital/features/medical_reports/repository/medical_reports_repository.dart';

// Repository Provider
final medicalReportsRepositoryProvider =
    Provider<MedicalReportsRepository>((ref) {
  final doctorsRepository = ref.read(doctorsRepositoryProvider);
  return MedicalReportsRepository(
      FirebaseFirestore.instance, doctorsRepository);
});

// Controller Provider
final medicalReportsControllerProvider =
    Provider<MedicalReportsController>((ref) {
  final repository = ref.read(medicalReportsRepositoryProvider);
  return MedicalReportsController(repository);
});

// User Medical Reports Provider
final userMedicalReportsProvider =
    FutureProvider<List<MedicalReport>>((ref) async {
  final user = await ref.watch(userProvider.future);
  if (user == null) throw Exception("User not logged in");

  final controller = ref.read(medicalReportsControllerProvider);
  return controller.getUserMedicalReports(user.uid);
});
