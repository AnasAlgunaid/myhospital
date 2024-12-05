import 'package:flutter/material.dart';
import 'package:myhospital/theme/app_theme.dart';

class FeatureCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color iconBorderColor;
  final void Function()? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.iconBackgroundColor,
    required this.iconBorderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: iconBorderColor,
                    width: 1.5,
                  ),
                ),
                child: icon,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTheme.headline3,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: AppTheme.bodyText3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
