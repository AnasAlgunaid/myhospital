import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A utility function to safely launch URLs.
Future<void> launchHyperlink(String hyperlink) async {
  if (hyperlink.isNotEmpty) {
    final uri = Uri.tryParse(hyperlink);

    // Check if the URI is valid and has an http/https scheme
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        } else {
          debugPrint('Cannot launch URL: $hyperlink');
        }
      } catch (e) {
        debugPrint('Error launching URL: $e');
      }
    } else {
      debugPrint('Invalid URL: $hyperlink');
    }
  } else {
    debugPrint('Empty hyperlink provided.');
  }
}
