import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhospital/common/widgets/buttons/primary_button.dart';
import 'package:myhospital/common/widgets/buttons/secondary_button.dart';
import 'package:myhospital/theme/app_theme.dart';

class ConfirmBottomSheet extends ConsumerWidget {
  const ConfirmBottomSheet({
    super.key,
    required this.title,
    required this.message,
    required this.primaryBtnText,
    required this.secondaryBtnText,
    this.primaryBtnColor = AppTheme.primaryColor,
  });

  final String title;
  final String message;
  final String primaryBtnText;
  final String secondaryBtnText;
  final Color primaryBtnColor;

  // Pop function
  void pop(BuildContext context, bool value) {
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: AppTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                Text(
                  message,
                  style: AppTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: primaryBtnText,
                        backgroundColor: primaryBtnColor,
                        onPressed: () {
                          pop(context, true);
                        },
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    SizedBox(
                      width: double.infinity,
                      child: SecondaryButton(
                        text: secondaryBtnText,
                        onPressed: () {
                          pop(context, false);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<bool> showConfirmBottomSheet({
  required BuildContext context,
  required String title,
  required String message,
  required String primaryBtnText,
  required String secondaryBtnText,
  Color primaryBtnColor = AppTheme.primaryColor,
}) async {
  final bool? result = await showModalBottomSheet<bool>(
    context: context,
    builder: (BuildContext context) {
      return ConfirmBottomSheet(
        title: title,
        message: message,
        primaryBtnText: primaryBtnText,
        secondaryBtnText: secondaryBtnText,
        primaryBtnColor: primaryBtnColor,
      );
    },
  );

  // Return true if the user pressed the primary button, otherwise return false
  return result ?? false;
}
