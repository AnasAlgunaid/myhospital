import 'package:myhospital/features/doctors/models/doctor.dart';
import 'package:myhospital/features/doctors/repository/doctors_repository.dart';

class DoctorsController {
  final DoctorsRepository _repository;

  DoctorsController(this._repository);

  /// Get all doctors
  Stream<List<Doctor>> getDoctors() {
    return _repository.fetchDoctors();
  }

  /// Get a doctor by their `doctorId` field
  Future<Doctor?> getDoctorByDoctorId(String doctorId) async {
    return _repository
        .fetchDoctorByDoctorId(doctorId); // Updated to use the new method
  }
}
