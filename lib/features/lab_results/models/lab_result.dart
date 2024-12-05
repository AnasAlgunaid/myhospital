import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/doctors/models/doctor.dart';

class LabResult {
  final String id;
  final String userId;
  final String testName;
  final String testResult;
  final DateTime timestamp;
  final String doctorId;
  final Doctor doctor; // Full doctor details

  LabResult({
    required this.id,
    required this.userId,
    required this.testName,
    required this.testResult,
    required this.timestamp,
    required this.doctorId,
    required this.doctor,
  });

  factory LabResult.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
    required Doctor doctor,
  }) {
    return LabResult(
      id: id,
      userId: data['userId'] ?? '',
      testName: data['testName'] ?? '',
      testResult: data['testResult'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      doctorId: data['doctorId'] ?? '',
      doctor: doctor,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'testName': testName,
      'testResult': testResult,
      'timestamp': timestamp,
      'doctorId': doctorId,
    };
  }
}
