import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/doctors/models/doctor.dart';

class MedicalReport {
  final String medicalReportId;
  final String userId;
  final String doctorId;
  final String reportTitle;
  final String reportContent;
  final DateTime timestamp;
  final Doctor doctor; // Full doctor details

  MedicalReport({
    required this.medicalReportId,
    required this.userId,
    required this.doctorId,
    required this.reportTitle,
    required this.reportContent,
    required this.timestamp,
    required this.doctor,
  });

  factory MedicalReport.fromFirestore({
    required String medicalReportId,
    required Map<String, dynamic> data,
    required Doctor doctor,
  }) {
    return MedicalReport(
      medicalReportId: medicalReportId,
      userId: data['userId'] ?? '',
      doctorId: data['doctorId'] ?? '',
      reportTitle: data['reportTitle'] ?? '',
      reportContent: data['reportContent'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      doctor: doctor,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'medicalReportId': medicalReportId,
      'userId': userId,
      'doctorId': doctorId,
      'reportTitle': reportTitle,
      'reportContent': reportContent,
      'timestamp': timestamp,
    };
  }
}
