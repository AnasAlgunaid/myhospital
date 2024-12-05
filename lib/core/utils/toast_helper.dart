import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:myhospital/theme/app_theme.dart';

class ToastHelper {
  static void showErrorToast({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      backgroundColor: AppTheme.errorColor,
      foregroundColor: AppTheme.whiteColor,
      showIcon: false,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(title, style: const TextStyle(color: AppTheme.whiteColor)),
      description: RichText(
        text: TextSpan(
          text: description,
          style: const TextStyle(color: AppTheme.whiteColor),
        ),
      ),
    );
  }

  static void showSuccessToast({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: AppTheme.whiteColor,
      showIcon: false,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(title, style: const TextStyle(color: AppTheme.whiteColor)),
      description: RichText(
        text: TextSpan(
          text: description,
          style: const TextStyle(color: AppTheme.whiteColor),
        ),
      ),
    );
  }
}
