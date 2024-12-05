import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhospital/common/bottom_sheets/confirm_bottom_sheet.dart';
import 'package:myhospital/core/constants/app_constants.dart';
import 'package:myhospital/core/utils/timestamp_utils.dart';
import 'package:myhospital/core/utils/toast_helper.dart';
import 'package:myhospital/features/appointments/models/appointment.dart';
import 'package:myhospital/features/appointments/providers/appointment_provider.dart';
import 'package:myhospital/theme/app_theme.dart';

class AppointmentDetailsPage extends ConsumerWidget {
  final String appointmentId;

  const AppointmentDetailsPage({
    super.key,
    required this.appointmentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentDetails =
        ref.watch(appointmentDetailsProvider(appointmentId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding * 2,
          ),
          child: appointmentDetails.when(
            data: (appointment) {
              if (appointment == null) {
                return Center(
                  child: Text(
                    'Appointment not found.',
                    style: AppTheme.bodyText2,
                  ),
                );
              }

              // UI for displaying appointment details
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Doctor Details Section
                          _buildDoctorDetails(context, appointment),
                          const SizedBox(height: 12),

                          Divider(color: Colors.grey.shade300),

                          const SizedBox(height: 12),

                          // Appointment Details Section
                          _buildSectionTitle('Appointment Details'),

                          const SizedBox(height: 16),
                          _buildDetailRow(
                            context,
                            label: 'Date',
                            value: TimestampUtils.formatDate(
                                appointment.timestamp),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            context,
                            label: 'Time',
                            value: TimestampUtils.formatTime(
                                appointment.timestamp),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  if (_isUpcomingAppointment(appointment.timestamp))
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await _cancelAppointment(
                                ref, appointment, context);
                            if (result) {
                              ToastHelper.showSuccessToast(
                                context: context,
                                title: 'Appointment Cancelled',
                                description:
                                    'Your appointment has been successfully cancelled.',
                              );
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.errorColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.cancel_outlined),
                              const SizedBox(width: 8),
                              Text(
                                'Cancel Appointment',
                                style: AppTheme.buttonTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text(
                'Failed to load appointment details. Please try again later. $error',
                style: AppTheme.bodyText2.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Doctor Details Section
  Widget _buildDoctorDetails(BuildContext context, appointment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(appointment.doctor.photoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                appointment.doctor.name,
                style: AppTheme.headline1,
              ),
              const SizedBox(height: 4),
              Text(
                appointment.doctor.specialty.name,
                style: AppTheme.bodyText1.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('Doctor Profile'),
        const SizedBox(height: 8),
        Text(
          appointment.doctor.profile,
          style: AppTheme.bodyText2,
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.headline2,
    );
  }

  // Detail Row
  Widget _buildDetailRow(BuildContext context,
      {required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: AppTheme.bodyText1.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: AppTheme.bodyText2,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  // Check if Appointment is Upcoming
  bool _isUpcomingAppointment(DateTime timestamp) {
    return timestamp.isAfter(DateTime.now());
  }

  // Cancel Appointment Handler
  Future<bool> _cancelAppointment(
      WidgetRef ref, Appointment appointment, BuildContext context) async {
    // Show confirmation bottom sheet
    bool confirmed = await showConfirmBottomSheet(
      context: context,
      title: "Confirm Cancel",
      message: "Are you sure you want to cancel this appointment?",
      primaryBtnText: "Cancel Appointment",
      secondaryBtnText: "Keep it",
      primaryBtnColor: AppTheme.errorColor,
    );
    if (!confirmed) return false;

    try {
      // Use the controller to cancel the appointment
      final controller = ref.read(appointmentControllerProvider);
      await controller.cancelAppointment(appointment.appointmendId);

      // Invalidate userAppointmentsProvider
      ref.invalidate(userAppointmentsProvider);

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to cancel appointment: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }
}
