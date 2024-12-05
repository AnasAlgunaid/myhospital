import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/medical_reports/models/medical_report.dart';
import 'package:myhospital/features/doctors/repository/doctors_repository.dart';

class MedicalReportsRepository {
  final FirebaseFirestore _firestore;
  final DoctorsRepository _doctorsRepository;

  MedicalReportsRepository(this._firestore, this._doctorsRepository);

  Future<List<MedicalReport>> fetchUserMedicalReports(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('medical_reports')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return await Future.wait(snapshot.docs.map((doc) async {
        final medicalReportData = doc.data();
        final doctorId = medicalReportData['doctorId'];

        // Fetch doctor details using DoctorsRepository
        final doctor = await _doctorsRepository.fetchDoctorByDoctorId(doctorId);

        if (doctor == null) {
          throw Exception(
              'Doctor not found for medical report ${medicalReportData['medicalReportId']}');
        }

        return MedicalReport.fromFirestore(
          medicalReportId: doc.id,
          data: medicalReportData,
          doctor: doctor,
        );
      }).toList());
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch medical reports: $e');
    }
  }
}
