import 'package:flutter/material.dart';
import 'package:myhospital/theme/app_theme.dart';
import 'package:myhospital/features/doctors/models/doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isVertical;
  final int profileMaxLines;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.isSelected = false,
    required this.onTap,
    this.isVertical = false,
    this.profileMaxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    var content = isVertical
        ? [
            CircleAvatar(
              radius: 44,
              backgroundImage: NetworkImage(doctor.photoUrl),
            ),
            const SizedBox(height: 16),
            Text(
              doctor.name,
              style: AppTheme.headline3.copyWith(
                color: isSelected ? AppTheme.whiteColor : AppTheme.blackColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              doctor.specialty.name,
              style: AppTheme.bodyText3.copyWith(
                color: isSelected ? AppTheme.whiteColor : AppTheme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              doctor.profile,
              style: AppTheme.bodyText3.copyWith(
                color: isSelected
                    ? AppTheme.whiteColor
                    : AppTheme.blackColor.withOpacity(0.6),
              ),
              maxLines: profileMaxLines,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ]
        : [
            CircleAvatar(
              radius: 36,
              backgroundImage: NetworkImage(doctor.photoUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    doctor.name,
                    style: AppTheme.headline3.copyWith(
                      color: isSelected
                          ? AppTheme.whiteColor
                          : AppTheme.blackColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialty.name,
                    style: AppTheme.bodyText3.copyWith(
                      color: isSelected
                          ? AppTheme.whiteColor
                          : AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    doctor.profile,
                    style: AppTheme.bodyText3.copyWith(
                      color: isSelected
                          ? AppTheme.whiteColor
                          : AppTheme.blackColor.withOpacity(0.6),
                    ),
                    maxLines: profileMaxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ];

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
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: isVertical
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: content,
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: content,
              ),
      ),
    );
  }
}
