import 'package:flutter/material.dart';
import 'package:myhospital/theme/app_theme.dart';
import 'package:myhospital/features/doctors/models/speciality.dart';

class SpecialtyCard extends StatelessWidget {
  final Specialty specialty;
  final bool isSelected;
  final VoidCallback onTap;

  const SpecialtyCard({
    super.key,
    required this.specialty,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.whiteColor
                    : AppTheme.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.medical_information_outlined,
                size: 32,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              specialty.name,
              style: AppTheme.headline4.copyWith(
                color: isSelected ? AppTheme.whiteColor : AppTheme.blackColor,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                specialty.description,
                style: AppTheme.bodyText3.copyWith(
                  color: isSelected ? AppTheme.whiteColor : AppTheme.grayColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
