import 'package:myhospital/features/appointments/models/appointment.dart';
import 'package:myhospital/features/appointments/repositories/appointment_repository.dart';

class AppointmentController {
  final AppointmentRepository repository;

  AppointmentController(this.repository);

  Future<List<Appointment>> getUserAppointments(String userId) async {
    return await repository.fetchUserAppointments(userId);
  }

  Future<Appointment?> getAppointmentDetails(String appointmentId) async {
    return await repository.fetchAppointmentDetails(appointmentId);
  }

  Future<void> addAppointment(
    Appointment appointmentt,
  ) async {
    // Proceed with adding the appointment
    await repository.addAppointment(appointmentt);
  }

  Future<void> cancelAppointment(String appointmentId) async {
    await repository.cancelAppointment(appointmentId);
  }
}
