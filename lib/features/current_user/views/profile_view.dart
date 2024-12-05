import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myhospital/common/bottom_sheets/confirm_bottom_sheet.dart';
import 'package:myhospital/common/widgets/buttons/primary_button.dart';
import 'package:myhospital/core/constants/app_icons.dart';
import 'package:myhospital/features/current_user/models/user_model.dart';
import 'package:myhospital/features/current_user/providers/user_provider.dart';
import 'package:myhospital/core/utils/toast_helper.dart';
import 'package:myhospital/theme/app_theme.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    ref.read(userProvider.future).then((user) {
      if (user != null) {
        setState(() {
          _nameController.text = user.name;
          _dobController.text = user.dateOfBirth;
          _selectedGender = user.gender[0].toUpperCase() +
              user.gender.substring(1).toLowerCase();
        });
      }
    });
  }

  void _saveChanges(UserModel userModel) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ToastHelper.showErrorToast(
        context: context,
        title: 'Error',
        description: 'User not logged in.',
      );
      return;
    }

    if (_nameController.text.trim().isEmpty ||
        _dobController.text.trim().isEmpty ||
        _selectedGender == null) {
      ToastHelper.showErrorToast(
        context: context,
        title: 'Invalid Input',
        description: 'Please fill all fields correctly.',
      );
      return;
    }

    final updatedUser = UserModel(
      uid: userModel.uid,
      name: _nameController.text.trim(),
      phoneNumber: userModel.phoneNumber,
      nationalId: userModel.nationalId,
      dateOfBirth: _dobController.text.trim(),
      gender: _selectedGender!,
    );

    try {
      final controller = ref.read(userControllerProvider);
      await controller.updateUserProfile(userId, updatedUser);
      ref.invalidate(userProvider);
      if (mounted) {
        ToastHelper.showSuccessToast(
          context: context,
          title: 'Success',
          description: 'Profile updated successfully.',
        );
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showErrorToast(
          context: context,
          title: 'Error',
          description: 'Failed to update profile.',
        );
      }
    }
  }

  void _logOut() async {
    bool confirmed = await showConfirmBottomSheet(
      context: context,
      title: "Confirm Logout",
      message: "Are you sure you want to logout?",
      primaryBtnText: "Logout",
      secondaryBtnText: "Cancel",
      primaryBtnColor: AppTheme.errorColor,
    );
    if (!confirmed) return;
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/phoneLogin', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: AppIcons.logoutIcon(color: AppTheme.errorColor),
            onPressed: _logOut,
          ),
        ],
      ),
      body: user.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text("No user data found."));
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name Field
                  Text("Full Name", style: AppTheme.bodyText2),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: "Enter your full name",
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date of Birth Field
                  Text("Date of Birth", style: AppTheme.bodyText2),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "DD/MM/YYYY",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(user.dateOfBirth),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now().subtract(
                              const Duration(days: 365 * 18),
                            ),
                          );
                          if (picked != null) {
                            setState(() {
                              _dobController.text =
                                  "${picked.day}/${picked.month}/${picked.year}";
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Gender Dropdown
                  Text("Gender", style: AppTheme.bodyText2),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a gender';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),

                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: "Save Changes",
                    onPressed: () => _saveChanges(user),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Failed to load user data: $error',
            style: AppTheme.bodyText2.copyWith(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
