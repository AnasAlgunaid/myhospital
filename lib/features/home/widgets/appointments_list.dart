import 'package:flutter/material.dart';
import 'package:myhospital/theme/app_theme.dart';

class AppointmentsList extends StatelessWidget {
  const AppointmentsList({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace this with actual data from Firestore
    final appointments = [
      {
        "date": "2024-12-01",
        "time": "09:30 AM",
        "doctor": "Dr. Ahmed Ali",
        "specialty": "Cardiologist",
      },
      {
        "date": "2024-12-02",
        "time": "10:00 AM",
        "doctor": "Dr. Sara Ahmed",
        "specialty": "Dermatologist",
      }
    ];

    return appointments.isEmpty
        ? Text(
            'No upcoming appointments.',
            style: AppTheme.bodyText2,
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    "${appointment['doctor']} (${appointment['specialty']})",
                    style: AppTheme.bodyText1,
                  ),
                  subtitle: Text(
                    "Date: ${appointment['date']}, Time: ${appointment['time']}",
                    style: AppTheme.bodyText3,
                  ),
                ),
              );
            },
          );
  }
}
