import 'package:flutter/material.dart';
import 'package:myhospital/core/utils/timestamp_utils.dart';
import 'package:myhospital/features/appointments/views/appointment_details_page.dart';
import 'package:myhospital/theme/app_theme.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String doctorImage;
  final String doctorSpecialty;
  final DateTime timestamp;

  final String appointmentId;
  final bool fromHome;

  const AppointmentCard({
    super.key,
    required this.appointmentId,
    required this.doctorName,
    required this.doctorImage,
    required this.doctorSpecialty,
    required this.timestamp,
    this.fromHome = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AppointmentDetailsPage(
              appointmentId: appointmentId,
            ),
          ),
        );
      },
      child: Container(
        width: 310, // Set a fixed width for the card
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD2D6DB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 34,
                  backgroundImage: NetworkImage(doctorImage), // Doctor image
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    doctorName,
                    style: AppTheme.headline3,
                    maxLines: 1,
                  ),
                  Text(
                    toBeginningOfSentenceCase(doctorSpecialty),
                    style: AppTheme.bodyText2,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${TimestampUtils.formatShortDate(timestamp)} - ${TimestampUtils.formatTime(timestamp)}",
                        style: AppTheme.bodyText2,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              if (!fromHome) // Show the arrow icon only if the card is not from the home screen
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
