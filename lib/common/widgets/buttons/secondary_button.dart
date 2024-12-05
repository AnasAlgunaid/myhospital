import 'package:flutter/material.dart';
import 'package:myhospital/theme/app_theme.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.gray200,
        foregroundColor: AppTheme.blackColor,
      ),
      child: Text(
        text,
      ),
    );
  }
}
