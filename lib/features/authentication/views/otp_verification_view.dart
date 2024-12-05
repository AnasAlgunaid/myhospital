import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhospital/features/authentication/views/phone_register_view.dart';
import 'package:myhospital/features/current_user/providers/user_provider.dart';
import 'package:myhospital/theme/app_theme.dart';
import 'package:pinput/pinput.dart';
import '../controllers/auth_controller.dart';
import 'package:myhospital/core/utils/toast_helper.dart';

class OtpVerificationView extends ConsumerStatefulWidget {
  final String verificationId;
  final bool isRegister; // True if verifying registration
  final String? name;
  final String phoneNumber;

  const OtpVerificationView({
    super.key,
    required this.verificationId,
    this.isRegister = false,
    this.name,
    required this.phoneNumber,
  });

  @override
  OtpVerificationViewState createState() => OtpVerificationViewState();
}

class OtpVerificationViewState extends ConsumerState<OtpVerificationView> {
  final AuthController _authController = AuthController();
  bool _isLoading = false;
  String _otp = ''; // Store OTP entered by the user

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Verify OTP using AuthController
      final user = await _authController.verifyOtp(
        verificationId: widget.verificationId,
        otp: _otp.trim(),
      );

      if (user != null) {
        // Check if user is already registered in Firestore
        final userExists = await _authController.checkUserExists(user.uid);

        if (userExists) {
          // User is already registered
          if (mounted) {
            ToastHelper.showSuccessToast(
              context: context,
              title: 'Welcome Back!',
              description: 'You are logged in successfully.',
            );
            // Set the user ID in userIdProvider after login
            ref.read(userIdProvider.notifier).update((state) => user.uid);

            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home', // Replace with your actual Home route name
              (route) =>
                  false, // This removes all previous routes from the stack
            );
          }
        } else {
          // User is not registered, redirect to Register Page
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PhoneRegisterView(
                  phoneNumber: widget.phoneNumber,
                ),
              ),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'invalid-verification-code') {
        errorMessage = 'Invalid OTP. Please check the code and try again.';
      } else if (e.code == 'session-expired') {
        errorMessage = 'The OTP has expired. Please request a new one.';
      }

      if (mounted) {
        ToastHelper.showErrorToast(
          context: context,
          title: 'Verification Error',
          description: errorMessage,
        );
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showErrorToast(
          context: context,
          title: 'Unexpected Error',
          description: e.toString(),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text("OTP Sent", style: AppTheme.headline1),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the 6-digit that we have sent via the phone number to ${widget.phoneNumber}',
                    style: AppTheme.bodyText2,
                  ),
                  const SizedBox(height: 16),
                  Pinput(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: AppTheme.headline1.copyWith(fontSize: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.grayColor),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: AppTheme.headline1.copyWith(fontSize: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: AppTheme.primaryColor, width: 2),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: AppTheme.headline1.copyWith(fontSize: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.primaryColor),
                      ),
                    ),
                    onCompleted: (pin) {
                      setState(() {
                        _otp = pin; // Store the OTP when completed
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Resend Code",
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _otp.isEmpty ? null : _verifyOtp,
                            child: const Text('Verify OTP'),
                          ),
                        ),
                  const SizedBox(
                      height: 12), // Add space between button and label
                  Text(
                    "By signing in, you are accepting our Terms & Conditions and Privacy Policy.",
                    style: AppTheme.bodyText3,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
