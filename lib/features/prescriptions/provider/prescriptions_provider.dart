import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/doctors/providers/doctors_provider.dart';
import 'package:myhospital/features/prescriptions/controller/prescriptions_controller.dart';
import 'package:myhospital/features/prescriptions/models/prescription.dart';
import 'package:myhospital/features/current_user/providers/user_provider.dart';
import 'package:myhospital/features/prescriptions/repository/prescriptions_repository.dart';

// Repository Provider
final prescriptionsRepositoryProvider =
    Provider<PrescriptionsRepository>((ref) {
  final doctorsRepository = ref.read(doctorsRepositoryProvider);
  return PrescriptionsRepository(FirebaseFirestore.instance, doctorsRepository);
});

// Controller Provider
final prescriptionsControllerProvider =
    Provider<PrescriptionsController>((ref) {
  final repository = ref.read(prescriptionsRepositoryProvider);
  return PrescriptionsController(repository);
});

// User Prescriptions Provider
final userPrescriptionsProvider =
    FutureProvider<List<Prescription>>((ref) async {
  final user = await ref.watch(userProvider.future);
  if (user == null) throw Exception("User not logged in");

  final controller = ref.read(prescriptionsControllerProvider);
  return controller.getUserPrescriptions(user.uid);
});
