import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhospital/features/doctors/controller/specialties_controller.dart';
import 'package:myhospital/features/doctors/models/speciality.dart';
import 'package:myhospital/features/doctors/repository/specialties_repository.dart';

final specialtiesRepositoryProvider =
    Provider((ref) => SpecialtiesRepository());

final specialtiesControllerProvider = Provider(
  (ref) => SpecialtiesController(ref.read(specialtiesRepositoryProvider)),
);

final specialtiesProvider = FutureProvider<List<Specialty>>((ref) async {
  final controller = ref.read(specialtiesControllerProvider);
  return controller.getSpecialties();
});

final specialtyByIdProvider =
    FutureProvider.family<Specialty?, String>((ref, specialtyId) async {
  final controller = ref.read(specialtiesControllerProvider);
  return controller.getSpecialtyBySpecialtyId(specialtyId);
});
