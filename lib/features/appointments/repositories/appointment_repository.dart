import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myhospital/features/appointments/models/appointment.dart';
import 'package:myhospital/features/doctors/repository/doctors_repository.dart';

class AppointmentRepository {
  final FirebaseFirestore _firestore;
  final DoctorsRepository _doctorsRepository;

  AppointmentRepository(this._firestore, this._doctorsRepository);

  // Fetch all appointments for a user
  Future<List<Appointment>> fetchUserAppointments(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: false)
          .get();

      return await Future.wait(snapshot.docs.map((doc) async {
        final appointmentData = doc.data();
        final doctorId = appointmentData['doctorId'];

        // Fetch doctor details using DoctorsRepository
        final doctor = await _doctorsRepository.fetchDoctorByDoctorId(doctorId);

        if (doctor == null) {
          throw Exception(
              'Doctor not found for appointment ${appointmentData['id']}');
        }

        return Appointment.fromFirestore(
          id: doc.id,
          data: appointmentData,
          doctor: doctor,
        );
      }).toList());
    } catch (e) {
      throw Exception('Failed to fetch appointments: $e');
    }
  }

  // Fetch details of a specific appointment
  Future<Appointment?> fetchAppointmentDetails(String appointmentId) async {
    try {
      final querySnapshot = await _firestore
          .collection('appointments')
          .where('appointmendId',
              isEqualTo: appointmentId) // Query by `id` field
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      final appointmentData = doc.data();
      final doctorId = appointmentData['doctorId'];

      // Fetch doctor details using DoctorsRepository
      final doctor = await _doctorsRepository.fetchDoctorByDoctorId(doctorId);
      if (doctor == null) {
        throw Exception('Doctor not found for appointment $appointmentId');
      }

      return Appointment.fromFirestore(
          id: doc.id, data: appointmentData, doctor: doctor);
    } catch (e) {
      throw Exception('Failed to fetch appointment details: $e');
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      // Query the appointment document
      final querySnapshot = await _firestore
          .collection('appointments')
          .where('appointmendId', isEqualTo: appointmentId)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Appointment not found');
      }

      // Get the appointment data
      final appointmentDoc = querySnapshot.docs.first;
      final appointmentData = appointmentDoc.data();

      // Extract required fields
      final doctorId = appointmentData['doctorId'];
      final date = appointmentData['timestamp']
          .toDate()
          .toString()
          .split(' ')[0]; // Extract the date (e.g., "2024-12-01")
      final slotTime = appointmentData['timestamp']
          .toDate()
          .toString()
          .split(' ')[1]
          .substring(0, 5); // Extract the time (e.g., "14:30")

      // Update the slot availability
      final doctorQuery = await _firestore
          .collection('doctors')
          .where('doctorId', isEqualTo: doctorId)
          .limit(1)
          .get();

      if (doctorQuery.docs.isNotEmpty) {
        final doctorDoc = doctorQuery.docs.first;
        final doctorData = doctorDoc.data();
        final slots = doctorData['slots'] as Map<String, dynamic>;

        // Update the slot availability for the given date and time
        if (slots.containsKey(date)) {
          final updatedSlots = slots.map((key, value) {
            if (key == date) {
              final updatedSlotList = (value as List<dynamic>).map((slot) {
                if (slot['time'] == slotTime) {
                  return {
                    ...slot,
                    'available': true, // Set the slot back to available
                  };
                }
                return slot;
              }).toList();
              return MapEntry(key, updatedSlotList);
            }
            return MapEntry(key, value);
          });

          // Save the updated slots back to the doctor's document
          await doctorDoc.reference.update({'slots': updatedSlots});
        }
      }

      // Delete the appointment document
      await appointmentDoc.reference.delete();
    } catch (e) {
      throw Exception('Failed to cancel appointment: $e');
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .set(appointment.toFirestore());
    } catch (e) {
      throw Exception("Failed to add appointment: $e");
    }
  }

  Future<void> updateSlotAvailability({
    required String doctorId, // Use the doctorId field
    required String date,
    required String slotTime,
    required bool available,
  }) async {
    try {
      // Query the doctors collection to find the document with the given doctorId
      final querySnapshot = await _firestore
          .collection('doctors')
          .where('doctorId', isEqualTo: doctorId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("Doctor with doctorId $doctorId not found");
      }

      // Get the document reference for the matched doctor
      final doctorRef = querySnapshot.docs.first.reference;

      // Fetch the current doctor data
      final doctorData = querySnapshot.docs.first.data();
      final slots = doctorData['slots'] as Map<String, dynamic>;

      // Update the slots for the given date and time
      final updatedSlots = slots.map((key, value) {
        if (key == date) {
          final updatedSlotList = (value as List<dynamic>).map((slot) {
            if (slot['time'] == slotTime) {
              return {
                ...slot,
                'available': available,
              };
            }
            return slot;
          }).toList();
          return MapEntry(key, updatedSlotList);
        }
        return MapEntry(key, value);
      });

      // Update the doctor document with the modified slots
      await doctorRef.update({'slots': updatedSlots});
    } catch (e) {
      throw Exception("Failed to update slot availability: $e");
    }
  }
}
