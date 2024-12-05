import 'package:flutter/material.dart';
import 'package:myhospital/core/utils/url_launcher_utils.dart';
import 'package:myhospital/theme/app_theme.dart';

class TextBanner extends StatelessWidget {
  const TextBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.hyperlink,
  });
  final String title;
  final String subtitle;
  final Color color;
  final String hyperlink;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launchHyperlink(hyperlink);
      },
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.headline2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
