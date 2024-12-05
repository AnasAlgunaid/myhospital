import 'package:flutter/material.dart';
import 'package:myhospital/core/constants/app_constants.dart';
import 'package:myhospital/theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.buttonText,
    this.onButtonPressed,
    this.horizontalPadding = AppConstants.defaultPadding,
  });
  final String title;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Text(
            title,
            style: AppTheme.headline3,
          ),
          const Spacer(),
          if (buttonText != null)
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0),
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: onButtonPressed,
              child: const Text("Show all"),
            ),
        ],
      ),
    );
  }
}
