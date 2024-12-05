import 'package:flutter/material.dart';
import 'package:myhospital/theme/app_theme.dart';

class AppointmentLoadingCard extends StatelessWidget {
  const AppointmentLoadingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Same width as AppointmentCard
      decoration: BoxDecoration(
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
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                border: Border.all(
                  color: AppTheme.primaryColor,
                  width: 1.5,
                ),
                color: Colors.grey.shade300, // Placeholder color
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 16,
                  color: Colors.grey.shade300, // Placeholder for doctor name
                ),
                const SizedBox(height: 4),
                Container(
                  width: 90,
                  height: 14,
                  color:
                      Colors.grey.shade300, // Placeholder for doctor specialty
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color:
                          Colors.grey.shade300, // Placeholder for calendar icon
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 90,
                      height: 14,
                      color:
                          Colors.grey.shade300, // Placeholder for date and time
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
