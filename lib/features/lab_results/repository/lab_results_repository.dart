import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/lab_results/models/lab_result.dart';
import 'package:myhospital/features/doctors/repository/doctors_repository.dart';

class LabResultsRepository {
  final FirebaseFirestore _firestore;
  final DoctorsRepository _doctorsRepository;

  LabResultsRepository(this._firestore, this._doctorsRepository);

  Future<List<LabResult>> fetchUserLabResults(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('lab_results')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return await Future.wait(snapshot.docs.map((doc) async {
        final labResultData = doc.data();
        final doctorId = labResultData['doctorId'];

        // Fetch doctor details using DoctorsRepository
        final doctor = await _doctorsRepository.fetchDoctorByDoctorId(doctorId);

        if (doctor == null) {
          throw Exception(
              'Doctor not found for lab result ${labResultData['id']}');
        }

        return LabResult.fromFirestore(
          id: doc.id,
          data: labResultData,
          doctor: doctor,
        );
      }).toList());
    } catch (e) {
      throw Exception('Failed to fetch lab results: $e');
    }
  }
}
