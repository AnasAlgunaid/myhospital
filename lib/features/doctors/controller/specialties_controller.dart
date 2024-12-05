import 'package:myhospital/features/doctors/models/speciality.dart';
import 'package:myhospital/features/doctors/repository/specialties_repository.dart';

class SpecialtiesController {
  final SpecialtiesRepository _repository;

  SpecialtiesController(this._repository);

  /// Get all specialties
  Future<List<Specialty>> getSpecialties() {
    return _repository.fetchSpecialties();
  }

  /// Get a specialty by its `id` field
  Future<Specialty?> getSpecialtyBySpecialtyId(String specialtyId) {
    return _repository.fetchSpecialtyBySpecialtyId(
        specialtyId); // Updated to use the new method
  }
}
