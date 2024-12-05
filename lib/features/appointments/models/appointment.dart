import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/doctors/models/doctor.dart';

class Appointment {
  final String id;
  final String
      appointmendId; // Explicit `id` field in the appointments collection
  final String userId; // ID of the user booking the appointment
  final Doctor doctor; // Doctor object with full details
  final DateTime timestamp; // Combined date and time for the appointment

  Appointment({
    required this.id,
    required this.appointmendId,
    required this.userId,
    required this.doctor,
    required this.timestamp,
  });

  /// Factory method to create an Appointment object from Firestore data
  factory Appointment.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
    required Doctor doctor,
  }) {
    return Appointment(
      id: id,
      appointmendId: data['appointmendId'] ?? '', // Explicit `id` field
      userId: data['userId'] ?? '',
      doctor: doctor, // Pass the full Doctor object
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  /// Converts the Appointment object into a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'appointmendId': appointmendId,
      'userId': userId,
      'doctorId': doctor.doctorId, // Use the Doctor's unique `id` field
      'timestamp': timestamp,
    };
  }
}
