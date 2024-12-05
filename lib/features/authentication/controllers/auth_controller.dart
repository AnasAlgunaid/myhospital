import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class AuthController {
  final AuthRepository _authRepository = AuthRepository();

  /// Sends an OTP to the provided phone number
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException error) onError,
  }) async {
    try {
      // Delegate the sendOtp call to AuthRepository
      await _authRepository.sendOtp(
        phoneNumber: phoneNumber,
        onCodeSent: onCodeSent,
        onError: (FirebaseAuthException error) {
          // Handle FirebaseAuthException here, if needed
          onError(error);
        },
      );
    } catch (e) {
      // Log unexpected errors
      print('Unexpected error in sendOtp: $e');
      onError(FirebaseAuthException(
        code: 'unexpected_error',
        message: 'An unexpected error occurred.',
      ));
    }
  }

  /// Verifies the OTP and signs in the user
  Future<User?> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      // Delegate the verifyOtp call to AuthRepository
      return await _authRepository.verifyOtp(
        verificationId: verificationId,
        otp: otp,
      );
    } catch (e) {
      // Log and throw unexpected errors
      print('Unexpected error in verifyOtp: $e');
      throw FirebaseAuthException(
        code: 'unexpected_error',
        message: 'An unexpected error occurred during OTP verification.',
      );
    }
  }

  /// Checks if the user exists in the database
  Future<bool> checkUserExists(String uid) async {
    try {
      return await _authRepository.checkUserExists(uid);
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }
}
