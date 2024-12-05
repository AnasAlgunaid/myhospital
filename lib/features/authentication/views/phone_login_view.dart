import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhospital/core/constants/app_constants.dart';
import 'package:myhospital/core/utils/toast_helper.dart';
import 'package:myhospital/theme/app_theme.dart';
import '../controllers/auth_controller.dart';
import 'otp_verification_view.dart';

class PhoneLoginView extends StatefulWidget {
  const PhoneLoginView({super.key});

  @override
  PhoneLoginViewState createState() => PhoneLoginViewState();
}

class PhoneLoginViewState extends State<PhoneLoginView> {
  final TextEditingController _phoneController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _hasError = false; // To track validation error

  void _sendOtp() async {
    setState(() {
      _hasError = false; // Reset error state before validation
    });

    try {
      String phoneNumber = _phoneController.text.trim();
      phoneNumber =
          phoneNumber[0] == '0' ? phoneNumber.substring(1) : phoneNumber;

      if (!phoneNumber.startsWith('5') || phoneNumber.length != 9) {
        setState(() {
          _hasError = true; // Trigger error state for TextField
        });
        ToastHelper.showErrorToast(
          context: context,
          title: "Invalid Phone Number",
          description:
              "Please enter a valid phone number starting with 5 and 9 digits long.",
        );
        return;
      }

      phoneNumber = '+966$phoneNumber';

      await _authController.sendOtp(
        phoneNumber: phoneNumber,
        onCodeSent: (String verificationId) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpVerificationView(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
              ),
            ),
          );
        },
        onError: (FirebaseAuthException error) {
          ToastHelper.showErrorToast(
            context: context,
            title: "Error Sending OTP",
            description: error.message ??
                'An unexpected error occurred while sending the OTP.',
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ToastHelper.showErrorToast(
          context: context,
          title: "Unexpected Error",
          description: "An unexpected error occurred. Please try again.",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: "Welcome to",
                      style: AppTheme.headline1,
                      children: <TextSpan>[
                        TextSpan(
                          text: ' MyHospital',
                          style: AppTheme.headline1.copyWith(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Please enter your phone number to continue",
                    style: AppTheme.bodyText2,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('+966'),
                      ),
                      prefixIconConstraints: const BoxConstraints(),
                      hintText: "512345678",
                      errorText: _hasError
                          ? 'Invalid phone number'
                          : null, // Error text shown conditionally
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _sendOtp,
                      child: const Text('Send OTP'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "By signing in, you are accepting our Terms & Conditions and Privacy Policy.",
                    style: AppTheme.bodyText3,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
