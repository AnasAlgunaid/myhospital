import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/doctors/controller/doctors_controller.dart';
import 'package:myhospital/features/doctors/models/doctor.dart';
import 'package:myhospital/features/doctors/repository/doctors_repository.dart';
import 'package:myhospital/features/doctors/repository/specialties_repository.dart';

// Specialties Repository Provider
final specialtiesRepositoryProvider = Provider((ref) {
  return SpecialtiesRepository();
});

// Doctors Repository Provider
final doctorsRepositoryProvider = Provider((ref) {
  final specialtiesRepository = ref.read(specialtiesRepositoryProvider);

  return DoctorsRepository(FirebaseFirestore.instance, specialtiesRepository);
});

// Doctors Controller Provider
final doctorsControllerProvider = Provider((ref) {
  final repository = ref.read(doctorsRepositoryProvider);
  return DoctorsController(repository);
});

// Fetch All Doctors Provider
final doctorsProvider = StreamProvider<List<Doctor>>((ref) {
  final controller = ref.read(doctorsControllerProvider);
  return controller.getDoctors();
});

// Fetch Doctor by ID Provider
final doctorByIdProvider =
    FutureProvider.family<Doctor?, String>((ref, doctorId) async {
  final controller = ref.read(doctorsControllerProvider);
  return controller.getDoctorByDoctorId(doctorId);
});
