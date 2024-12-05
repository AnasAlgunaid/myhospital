import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AppIcons {
  const AppIcons._();

  // Use huge icons for the app
  static Widget homeIcon({required Color color, double size = 24}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedHome03,
      color: color,
      size: size,
    );
  }

  static Widget reportIcon({required Color color, double size = 24}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedTask02,
      color: color,
      size: size,
    );
  }

  static Widget calendarIcon({required Color color, double size = 24}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedCalendar03,
      color: color,
      size: size,
    );
  }

  static Widget timeIcon({required Color color, double size = 24}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedTime04,
      color: color,
      size: size,
    );
  }

  static Widget userIcon({required Color color, double size = 24}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedUser,
      color: color,
      size: size,
    );
  }

  static Widget doctorIcon({required Color color, double size = 24}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedDoctor01,
      color: color,
      size: size,
    );
  }

  static Widget specialtyIcon({required Color color, double size = 24}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedUserAccount,
      color: color,
      size: size,
    );
  }

  static Widget cancelIcon({required Color color, double size = 24}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedCancelCircle,
      color: color,
      size: size,
    );
  }

  static Widget testTubeIcon({required Color color, double size = 24}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedTestTube01,
      color: color,
      size: size,
    );
  }

  static Widget medicineIcon({required Color color, double size = 24}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedMedicineBottle01,
      color: color,
      size: size,
    );
  }

  static Widget addIcon({required Color color, double size = 24}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedAddSquare,
      color: color,
      size: size,
    );
  }

  static Widget logoutIcon({required Color color, double size = 24}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedLogout05,
      color: color,
      size: size,
    );
  }
}
