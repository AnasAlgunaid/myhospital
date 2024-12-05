import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/doctors/models/speciality.dart';

class SpecialtiesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all specialties
  Future<List<Specialty>> fetchSpecialties() async {
    final specialtiesSnapshot =
        await _firestore.collection('specialties').get();
    return specialtiesSnapshot.docs
        .map((doc) =>
            Specialty.fromMap(doc.id, doc.data())) // Pass Firestore doc ID
        .toList();
  }

  /// Fetch a specific specialty by its `id` field
  Future<Specialty?> fetchSpecialtyBySpecialtyId(String specialtyId) async {
    final querySnapshot = await _firestore
        .collection('specialties')
        .where('id', isEqualTo: specialtyId) // Query by the `id` field
        .limit(1) // Ensure only one document is fetched
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return Specialty.fromMap(
          doc.id, doc.data()); // Use Firestore doc ID and data
    }
    return null; // Return null if no matching specialty is found
  }
}
