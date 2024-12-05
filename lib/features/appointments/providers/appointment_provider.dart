import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/appointments/controllers/appointment_controller.dart';
import 'package:myhospital/features/appointments/repositories/appointment_repository.dart';
import 'package:myhospital/features/doctors/providers/doctors_provider.dart';
import 'package:myhospital/features/current_user/providers/user_provider.dart';
import 'package:myhospital/features/appointments/models/appointment.dart';

// Repository Provider
final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final doctorsRepository = ref.read(doctorsRepositoryProvider);

  return AppointmentRepository(FirebaseFirestore.instance, doctorsRepository);
});

// Service Provider
final appointmentControllerProvider = Provider<AppointmentController>((ref) {
  final repository = ref.read(appointmentRepositoryProvider);
  return AppointmentController(repository);
});

// User Appointments Provider
final userAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final repository = ref.read(appointmentRepositoryProvider);
  final user = await ref.watch(userProvider.future);

  if (user == null) throw Exception("User not logged in");

  return repository.fetchUserAppointments(user.uid);
});

// Specific Appointment Provider
final appointmentDetailsProvider =
    FutureProvider.family<Appointment?, String>((ref, appointmentId) async {
  final controller = ref.watch(appointmentControllerProvider);
  return controller.getAppointmentDetails(appointmentId);
});
