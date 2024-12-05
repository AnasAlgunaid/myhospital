import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myhospital/core/constants/app_constants.dart';
import 'package:myhospital/core/utils/toast_helper.dart';
import 'package:myhospital/theme/app_theme.dart';

class PhoneRegisterView extends StatefulWidget {
  final String phoneNumber;
  const PhoneRegisterView({super.key, required this.phoneNumber});

  @override
  PhoneRegisterViewState createState() => PhoneRegisterViewState();
}

class PhoneRegisterViewState extends State<PhoneRegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? _selectedGender;
  bool _isLoading = false;

  // Error state variables
  bool _hasNameError = false;
  bool _hasNationalIdError = false;
  bool _hasDobError = false;

  void _register() async {
    // Validate inputs
    setState(() {
      _hasNameError = _nameController.text.trim().isEmpty;
      _hasNationalIdError =
          !_isValidNationalId(_nationalIdController.text.trim());
      _hasDobError = !_isValidDate(_dobController.text.trim());
    });

    if (_hasNameError ||
        _hasNationalIdError ||
        _hasDobError ||
        _selectedGender == null) {
      ToastHelper.showErrorToast(
        context: context,
        title: "Invalid Input",
        description: "Please fill all fields correctly.",
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Save user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': _nameController.text.trim(),
          'phoneNumber': widget.phoneNumber,
          'nationalId': _nationalIdController.text.trim(),
          'dateOfBirth': _dobController.text.trim(),
          'gender': _selectedGender,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Redirect to Home Page
        if (mounted) {
          ToastHelper.showSuccessToast(
            context: context,
            title: "Registration Successful",
            description: "Your account has been created successfully.",
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home', // Replace with your actual Home route name
            (route) => false, // This removes all previous routes from the stack
          );
        }
      } else {
        ToastHelper.showErrorToast(
          context: context,
          title: "Error",
          description: "User is not logged in. Please try again.",
        );
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showErrorToast(
          context: context,
          title: "Registration Failed",
          description: e.toString(),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isValidNationalId(String nationalId) {
    return nationalId.length == 10 && RegExp(r'^[0-9]+$').hasMatch(nationalId);
  }

// Ensure DOB validation checks
  bool _isValidDate(String dob) {
    try {
      final parts = dob.split('/');
      final date = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
      return date.isBefore(DateTime.now());
    } catch (_) {
      return false;
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
                      text: "Register",
                      style: AppTheme.headline1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please enter the form to continue registration",
                    style: AppTheme.bodyText2,
                  ),
                  const SizedBox(height: 32),
                  // Full Name
                  Text(
                    "Full Name",
                    style: AppTheme.bodyText2,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Enter your full name",
                      errorText: _hasNameError ? "Full name is required" : null,
                      errorStyle:
                          AppTheme.bodyText2.copyWith(color: Colors.red),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color:
                              _hasNameError ? Colors.red : AppTheme.grayColor,
                        ),
                      ),
                    ),
                    onChanged: (_) {
                      setState(() {
                        _hasNameError = false; // Reset error state
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // National ID
                  Text(
                    "National ID",
                    style: AppTheme.bodyText2,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nationalIdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter your National ID",
                      errorText: _hasNationalIdError
                          ? "National ID must be 10 numeric digits"
                          : null,
                      errorStyle:
                          AppTheme.bodyText2.copyWith(color: Colors.red),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _hasNationalIdError
                              ? Colors.red
                              : AppTheme.grayColor,
                        ),
                      ),
                    ),
                    onChanged: (_) {
                      setState(() {
                        _hasNationalIdError = false; // Reset error state
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Date of Birth
                  Text(
                    "Date of Birth",
                    style: AppTheme.bodyText2,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "DD/MM/YYYY",
                      errorText:
                          _hasDobError ? "Date of Birth is required" : null,
                      errorStyle:
                          AppTheme.bodyText2.copyWith(color: Colors.red),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _dobController.text =
                                  "${picked.day}/${picked.month}/${picked.year}";
                              _hasDobError = false; // Reset error state
                            });
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _hasDobError ? Colors.red : AppTheme.grayColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Gender
                  Text(
                    "Gender",
                    style: AppTheme.bodyText2,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.grayColor),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                    ],
                    value: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _register,
                            child: const Text("Register"),
                          ),
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
