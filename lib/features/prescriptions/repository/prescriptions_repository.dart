import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/prescriptions/models/prescription.dart';
import 'package:myhospital/features/doctors/repository/doctors_repository.dart';

class PrescriptionsRepository {
  final FirebaseFirestore _firestore;
  final DoctorsRepository _doctorsRepository;

  PrescriptionsRepository(this._firestore, this._doctorsRepository);

  Future<List<Prescription>> fetchUserPrescriptions(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('prescriptions')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return await Future.wait(snapshot.docs.map((doc) async {
        final prescriptionData = doc.data();
        final doctorId = prescriptionData['doctorId'];

        // Fetch doctor details using DoctorsRepository
        final doctor = await _doctorsRepository.fetchDoctorByDoctorId(doctorId);

        if (doctor == null) {
          throw Exception(
              'Doctor not found for prescription ${prescriptionData['prescriptionId']}');
        }

        return Prescription.fromFirestore(
          prescriptionId: doc.id,
          data: prescriptionData,
          doctor: doctor,
        );
      }).toList());
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch prescriptions: $e');
    }
  }
}
