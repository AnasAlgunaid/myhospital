import 'package:flutter/material.dart';
import 'package:myhospital/theme/app_theme.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String photoUrl;
  final double rating;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.photoUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(photoUrl),
        ),
        title: Text(
          name,
          style: AppTheme.bodyText1,
        ),
        subtitle: Text(
          specialty,
          style: AppTheme.bodyText2,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber),
            Text(rating.toString(), style: AppTheme.bodyText2),
          ],
        ),
      ),
    );
  }
}
