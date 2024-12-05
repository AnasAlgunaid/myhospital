import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/doctors/providers/doctors_provider.dart';
import 'package:myhospital/features/lab_results/controller/lab_results_controller.dart';
import 'package:myhospital/features/lab_results/models/lab_result.dart';
import 'package:myhospital/features/current_user/providers/user_provider.dart';
import 'package:myhospital/features/lab_results/repository/lab_results_repository.dart';

// Repository Provider
final labResultsRepositoryProvider = Provider<LabResultsRepository>((ref) {
  final doctorsRepository = ref.read(doctorsRepositoryProvider);
  return LabResultsRepository(FirebaseFirestore.instance, doctorsRepository);
});

// Controller Provider
final labResultsControllerProvider = Provider<LabResultsController>((ref) {
  final repository = ref.read(labResultsRepositoryProvider);
  return LabResultsController(repository);
});

// User Lab Results Provider
final userLabResultsProvider = FutureProvider<List<LabResult>>((ref) async {
  final user = await ref.watch(userProvider.future);
  if (user == null) throw Exception("User not logged in");

  final controller = ref.read(labResultsControllerProvider);
  return controller.getUserLabResults(user.uid);
});
