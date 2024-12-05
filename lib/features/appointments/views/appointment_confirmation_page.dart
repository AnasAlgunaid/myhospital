import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:myhospital/theme/app_theme.dart';
import 'package:myhospital/features/appointments/models/appointment.dart';

class AppointmentConfirmationPage extends StatelessWidget {
  final Appointment appointment;

  const AppointmentConfirmationPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment Confirmed"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Success Icon
              const Icon(
                Icons.check_circle,
                color: AppTheme.primaryColor,
                size: 100,
              ),
              const SizedBox(height: 20),

              // Success Message
              Text(
                "Appointment Confirmed!",
                style: AppTheme.headline1.copyWith(
                  color: AppTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "You have successfully booked an appointment.",
                style: AppTheme.bodyText1.copyWith(
                  color: AppTheme.blackColor.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              _buildDetailRow(
                icon: Icons.category,
                label: "Specialty:",
                value: appointment.doctor.specialty.name,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.person,
                label: "Doctor:",
                value: appointment.doctor.name,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.calendar_today,
                label: "Date:",
                value: appointment.timestamp
                    .toLocal()
                    .toIso8601String()
                    .split('T')
                    .first,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.access_time,
                label: "Time:",
                value: appointment.timestamp
                    .toLocal()
                    .toIso8601String()
                    .split('T')
                    .last
                    .split('.')
                    .first,
              ),
              const Spacer(),

              // Add to Calendar Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _addToCalendar(appointment),
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: const Text("Add to Calendar"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Back to Home Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back to Home",
                    style: AppTheme.headline4.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.bodyText2.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addToCalendar(Appointment appointment) {
    final event = Event(
      title: 'Appointment with ${appointment.doctor.name}',
      description:
          'Specialty: ${appointment.doctor.specialty.name}\nDoctor: ${appointment.doctor.name}',
      location: 'Hospital',
      startDate: appointment.timestamp,
      endDate: appointment.timestamp.add(const Duration(minutes: 30)),
      allDay: false,
    );

    Add2Calendar.addEvent2Cal(event).then((success) {
      if (success) {
        print('Event added to calendar');
      } else {
        print('Could not add event to calendar');
      }
    });
  }
}
