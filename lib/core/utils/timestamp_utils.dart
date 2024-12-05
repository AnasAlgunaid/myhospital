import 'package:intl/intl.dart';

class TimestampUtils {
  // Format Date
  static String formatDate(DateTime timestamp) {
    return DateFormat('EEEE, d MMMM yyyy')
        .format(timestamp); // e.g., "13 November 2024"
  }

  static String formatShortDate(DateTime timestamp) {
    return DateFormat('EE, d MMM ')
        .format(timestamp); // e.g., "13 November 2024"
  }

  // Format Time
  static String formatTime(DateTime timestamp) {
    return DateFormat('h:mm a').format(timestamp); // e.g., "10:30 AM"
  }

  // Format Time
  static String formatDateAndTime(DateTime timestamp) {
    return DateFormat('EEEE, d MMMM yyyy h:mm a')
        .format(timestamp); // e.g., "10:30 AM"
  }
}
