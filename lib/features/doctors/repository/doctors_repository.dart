import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/doctors/models/doctor.dart';
import 'specialties_repository.dart';

class DoctorsRepository {
  final FirebaseFirestore _firestore;
  final SpecialtiesRepository _specialtiesRepository;

  DoctorsRepository(this._firestore, this._specialtiesRepository);

  Stream<List<Doctor>> fetchDoctors() {
    return _firestore
        .collection('doctors')
        .snapshots()
        .asyncMap((snapshot) async {
      // Map each document in the snapshot to a Doctor object
      return await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data();
        final specialtyId = data['specialtyId'];

        // Fetch Specialty details
        final specialty = await _specialtiesRepository
            .fetchSpecialtyBySpecialtyId(specialtyId);
        if (specialty == null) {
          throw Exception('Specialty not found for doctor ${doc.id}');
        }

        return Doctor.fromMap(doc.id, data, specialty);
      }).toList());
    });
  }

  Future<Doctor?> fetchDoctorByDoctorId(String doctorId) async {
    final querySnapshot = await _firestore
        .collection('doctors')
        .where('doctorId', isEqualTo: doctorId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    final doc = querySnapshot.docs.first;
    final data = doc.data();
    final specialtyId = data['specialtyId'];

    // Fetch Specialty details
    final specialty =
        await _specialtiesRepository.fetchSpecialtyBySpecialtyId(specialtyId);
    if (specialty == null) {
      throw Exception('Specialty not found for doctor $doctorId');
    }

    return Doctor.fromMap(doc.id, data, specialty);
  }
}
