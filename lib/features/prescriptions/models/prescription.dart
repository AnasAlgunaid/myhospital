import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/doctors/models/doctor.dart';

class Prescription {
  final String prescriptionId;
  final String userId;
  final String doctorId;
  final String medicineName;
  final String dosage;
  final DateTime timestamp;
  final Doctor doctor;

  Prescription({
    required this.prescriptionId,
    required this.userId,
    required this.doctorId,
    required this.medicineName,
    required this.dosage,
    required this.timestamp,
    required this.doctor,
  });

  factory Prescription.fromFirestore({
    required String prescriptionId,
    required Map<String, dynamic> data,
    required Doctor doctor,
  }) {
    return Prescription(
      prescriptionId: prescriptionId,
      userId: data['userId'] ?? '',
      doctorId: data['doctorId'] ?? '',
      medicineName: data['medicineName'] ?? '',
      dosage: data['dosage'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      doctor: doctor,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'prescriptionId': prescriptionId,
      'userId': userId,
      'doctorId': doctorId,
      'medicineName': medicineName,
      'dosage': dosage,
      'timestamp': timestamp,
    };
  }
}
