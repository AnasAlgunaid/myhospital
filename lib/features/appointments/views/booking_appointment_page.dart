import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:myhospital/core/utils/toast_helper.dart';
import 'package:myhospital/features/appointments/models/appointment.dart';
import 'package:myhospital/features/appointments/providers/appointment_provider.dart';
import 'package:myhospital/features/appointments/views/appointment_confirmation_page.dart';
import 'package:myhospital/features/current_user/providers/user_provider.dart';
import 'package:myhospital/features/doctors/models/doctor.dart';
import 'package:myhospital/features/doctors/models/speciality.dart';
import 'package:myhospital/features/doctors/providers/doctors_provider.dart';
import 'package:myhospital/features/doctors/providers/specialties_provider.dart';
import 'package:myhospital/features/doctors/views/doctor_card.dart';
import 'package:myhospital/features/doctors/views/specialty_card.dart';

import 'package:myhospital/theme/app_theme.dart';

class BookingAppointmentPage extends ConsumerStatefulWidget {
  const BookingAppointmentPage({super.key});

  @override
  ConsumerState<BookingAppointmentPage> createState() =>
      _BookingAppointmentPageState();
}

class _BookingAppointmentPageState
    extends ConsumerState<BookingAppointmentPage> {
  int currentStep = 0;
  Specialty? selectedSpecialty;
  Doctor? selectedDoctor;
  String? selectedDate;
  String? selectedSlot;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate line length dynamically
    const stepCount = 4;
    const stepSize = 48.0; // Diameter of each step (circle/rRectangle)
    final lineLength = (screenWidth - (stepCount * stepSize)) / (stepCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            // Horizontal Steps Indicator using EasyStepper with dynamic line length
            SizedBox(
              height: 75,
              child: EasyStepper(
                activeStep: currentStep,
                steppingEnabled: false,
                stepShape: StepShape.rRectangle,
                stepBorderRadius: 15,
                stepRadius: stepSize / 3,
                showLoadingAnimation: false,
                finishedStepBorderColor: AppTheme.primaryColor,
                activeStepBorderColor: Theme.of(context).primaryColor,
                activeStepIconColor: AppTheme.primaryColor,
                finishedStepIconColor: Colors.white,
                finishedStepBackgroundColor: AppTheme.primaryColor,
                activeStepBorderType: BorderType.normal,
                borderThickness: 3,
                activeStepTextColor: AppTheme.primaryColor,
                finishedStepTextColor: AppTheme.primaryColor,
                lineStyle: LineStyle(
                  lineType: LineType.normal,
                  finishedLineColor: AppTheme.primaryColor,
                  unreachedLineColor: Colors.grey,
                  lineLength: lineLength, // Dynamic line length
                ),
                showTitle: true,
                steps: const [
                  EasyStep(
                    icon: Icon(Icons.category),
                    title: "Specialty",
                  ),
                  EasyStep(
                    icon: Icon(Icons.person),
                    title: "Doctor",
                  ),
                  EasyStep(
                    icon: Icon(Icons.access_time),
                    title: "Slot",
                  ),
                  EasyStep(
                    icon: Icon(Icons.check),
                    title: "Confirm",
                  ),
                ],
                onStepReached: (index) {
                  if (index < currentStep || _canNavigateToStep(index)) {
                    setState(() {
                      currentStep = index;
                    });
                  } else {
                    _showError(context, "Complete the previous step first.");
                  }
                },
              ),
            ),

            Expanded(
              child: _buildStepContent(),
            ),
          ],
        ),
      ),
    );
  }

  bool _canNavigateToStep(int index) {
    if (index == 1 && selectedSpecialty != null) return true;
    if (index == 2 && selectedDoctor != null) return true;
    if (index == 3 && selectedDate != null && selectedSlot != null) return true;
    return false;
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildStepWithTitle(
          title: "Choose a Specialty",
          content: _buildSpecialtyStep(),
        );
      case 1:
        return _buildStepWithTitle(
          title: "Choose a Doctor",
          content: _buildDoctorStep(),
        );
      case 2:
        return _buildStepWithTitle(
          title: "Choose Time",
          content: _buildSlotStep(),
        );
      case 3:
        return _buildStepWithTitle(
          title: "Confirm Appointment",
          content: _buildConfirmationStep(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStepWithTitle({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: AppTheme.headline1,
          ),
        ),
        Expanded(child: content),
      ],
    );
  }

  Widget _buildSpecialtyStep() {
    final specialtiesAsync = ref.watch(specialtiesProvider);

    return Stack(
      children: [
        specialtiesAsync.when(
          data: (specialties) {
            if (specialties.isEmpty) {
              return Center(
                child: Text(
                  "No specialties available.",
                  style: AppTheme.bodyText3,
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 16, // Horizontal spacing between items
                  mainAxisSpacing: 16, // Vertical spacing between items
                  childAspectRatio: 0.8,
                ),
                padding: const EdgeInsets.all(16),
                itemCount: specialties.length,
                itemBuilder: (context, index) {
                  final specialty = specialties[index];
                  return SpecialtyCard(
                    specialty: specialty,
                    isSelected: selectedSpecialty?.id == specialty.id,
                    onTap: () {
                      setState(() {
                        selectedSpecialty = specialty;
                        selectedDoctor = null;
                      });
                    },
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text("Error: $error")),
        ),
        // Floating Continue Button
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white.withOpacity(0.9), // Background to avoid overlap
            child: ElevatedButton(
              onPressed: selectedSpecialty != null
                  ? () {
                      setState(() {
                        currentStep = 1; // Move to the next step
                      });
                    }
                  : null, // Disable button if no specialty selected
              style: ElevatedButton.styleFrom(
                minimumSize:
                    const Size(double.infinity, 50), // Full-width button
                backgroundColor: AppTheme.primaryColor,
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorStep() {
    if (selectedSpecialty == null) {
      return const Center(child: Text("Please select a specialty first."));
    }

    final doctorsAsync = ref.watch(doctorsProvider);

    return Stack(
      children: [
        doctorsAsync.when(
          data: (doctors) {
            final filteredDoctors = doctors
                .where((doctor) =>
                    doctor.specialty.id == selectedSpecialty?.id &&
                    doctor.slots.isNotEmpty)
                .toList();

            if (filteredDoctors.isEmpty) {
              return Center(
                child: Text(
                  "No doctors available for this specialty.",
                  style: AppTheme.bodyText3,
                ),
              );
            }

            return Padding(
              padding:
                  const EdgeInsets.only(bottom: 80.0), // Space for the button
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = filteredDoctors[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: DoctorCard(
                      doctor: doctor,
                      isSelected: selectedDoctor?.doctorId == doctor.doctorId,
                      onTap: () {
                        setState(() {
                          selectedDoctor = doctor;
                        });
                      },
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text("Error: $error")),
        ),
        // Floating Continue Button
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white.withOpacity(0.9), // Background to avoid overlap
            child: ElevatedButton(
              onPressed: selectedDoctor != null
                  ? () {
                      setState(() {
                        currentStep = 2; // Move to the next step
                      });
                    }
                  : null, // Disable button if no doctor selected
              style: ElevatedButton.styleFrom(
                minimumSize:
                    const Size(double.infinity, 50), // Full-width button
                backgroundColor: AppTheme.primaryColor,
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlotStep() {
    if (selectedDoctor == null) {
      return const Center(
        child: Text(
          "Please select a doctor first.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    // Extract and filter available slots after the current time
    final availableDates = getAvailableDates(selectedDoctor!);

    // Check if there are any available dates
    if (availableDates.isEmpty) {
      return const Center(
        child: Text(
          "No available dates.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    // Order the available dates
    availableDates.sort();

    // Ensure selectedDate is initialized
    selectedDate ??= availableDates.first;

    return Stack(
      children: [
        // Scrollable content
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 140.0), // Space for button
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Information
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DoctorCard(
                  doctor: selectedDoctor!,
                  onTap: () {}, // No action needed
                  isVertical: true,
                  profileMaxLines: 20,
                ),
              ),
              // Date Timeline
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: AppTheme.primaryColor,
                    ),
                  ),
                  child: EasyTheme(
                    data: EasyTheme.of(context).copyWith(
                      dayBackgroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          // return the background color of the selected day
                          return AppTheme.primaryColor;
                        } else if (states.contains(WidgetState.disabled)) {
                          // return the background color of the disabled day
                          return Colors.grey.shade100;
                        }
                        // return the background color of the normal day
                        return Colors.white;
                      }),
                      currentDayBackgroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          // return the background color of the selected day
                          return AppTheme.primaryColor;
                        } else if (states.contains(WidgetState.disabled)) {
                          // return the background color of the disabled day
                          return Colors.grey.shade100;
                        }
                        // return the background color of the normal day
                        return Colors.white;
                      }),
                      currentDayBorder:
                          WidgetStateProperty.resolveWith((states) {
                        return const BorderSide(color: AppTheme.primaryColor);
                      }),
                      currentDayForegroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppTheme.whiteColor;
                        } else {
                          return AppTheme.primaryColor;
                        }
                      }),
                    ),
                    child: EasyDateTimeLinePicker(
                      focusedDate: DateTime.parse(selectedDate!),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.parse(availableDates.last),
                      onDateChange: (date) {
                        setState(() {
                          selectedDate =
                              date.toIso8601String().split('T').first;
                          selectedSlot =
                              null; // Reset slot selection on date change
                        });
                      },
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Available Appointments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Check if slots exist for the selected date
              if (!selectedDoctor!.slots.containsKey(selectedDate!) ||
                  selectedDoctor!.slots[selectedDate!]!.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "No available slots for this date.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedDoctor!.slots[selectedDate!]!
                        .where((slot) => slot.available)
                        .map(
                          (slot) => ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedSlot = slot.time;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedSlot == slot.time
                                  ? AppTheme.primaryColor
                                  : Colors.transparent,
                              side: const BorderSide(
                                color: AppTheme.primaryColor,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              slot.time,
                              style: TextStyle(
                                color: selectedSlot == slot.time
                                    ? Colors.white
                                    : AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
        // Fixed "Continue" button
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.white.withOpacity(0.9), // Background to avoid overlap
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: selectedSlot != null
                  ? () {
                      setState(() {
                        currentStep = 3; // Move to the next step
                      });
                    }
                  : null, // Enable only if a slot is selected
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppTheme.primaryColor,
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Confirmation Details Card
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    label: "Specialty:",
                    value: selectedSpecialty?.name ?? "Not selected",
                    icon: Icons.category,
                  ),
                  const Divider(height: 24, color: AppTheme.gray200),
                  _buildDetailRow(
                    label: "Doctor:",
                    value: selectedDoctor?.name ?? "Not selected",
                    icon: Icons.person,
                  ),
                  const Divider(height: 24, color: AppTheme.gray200),
                  _buildDetailRow(
                    label: "Date:",
                    value: selectedDate ?? "Not selected",
                    icon: Icons.calendar_today,
                  ),
                  const Divider(height: 24, color: AppTheme.gray200),
                  _buildDetailRow(
                    label: "Time:",
                    value: selectedSlot ?? "Not selected",
                    icon: Icons.access_time,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Confirm Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: () {
                _bookSlot();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text(
                'Confirm Appointment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 28,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.bodyText2.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// Filter available slots for future dates and times
  List<String> getAvailableDates(Doctor selectedDoctor) {
    final now = DateTime.now();

    // Extract unique dates where slots are available after now
    final availableDates = selectedDoctor.slots.entries
        .where((entry) {
          final date = entry.key; // Extract the date as a string
          final slots = entry.value;

          // Check if at least one slot on this date is in the future
          return slots.any((slot) {
            if (!slot.available) return false;

            // Combine date and time to form a full DateTime object
            try {
              final slotDateTime = DateTime.parse("$date ${slot.time}");
              return slotDateTime.isAfter(now);
            } catch (e) {
              print("Error parsing slot datetime: $e");
              return false;
            }
          });
        })
        .map((entry) => entry.key) // Map back to the date string
        .toSet()
        .toList();

    // Sort dates in ascending order
    availableDates.sort();
    return availableDates;
  }

  void _bookSlot() async {
    if (selectedSpecialty == null ||
        selectedDoctor == null ||
        selectedDate == null ||
        selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please complete all steps before booking."),
        ),
      );
      return;
    }

    try {
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (mounted) Navigator.pop(context); // Close loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in.")),
        );
        return;
      }

      final appointmentRepository = ref.read(appointmentRepositoryProvider);
      final appointmentController = ref.read(appointmentControllerProvider);
      final selectedDoctorId = selectedDoctor!.doctorId;

      // Check if the selected slot is still available
      final availableSlot = selectedDoctor!.slots[selectedDate]?.firstWhere(
        (slot) => slot.time == selectedSlot,
        orElse: () => Slot(time: selectedSlot!, available: false),
      );

      if (availableSlot == null || !availableSlot.available) {
        if (mounted) Navigator.pop(context); // Close loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("The selected slot is no longer available.")),
        );
        return;
      }

      // Create a unique appointment ID
      final appointmentId =
          FirebaseFirestore.instance.collection('appointments').doc().id;

      // Prepare the appointment data
      final appointment = Appointment(
        id: appointmentId,
        appointmendId: appointmentId,
        userId: user.uid,
        doctor: selectedDoctor!,
        timestamp: DateTime.parse(
            '$selectedDate ${availableSlot.time}'), // Combine date and time
      );

      // Save appointment in Firestore
      await appointmentController.addAppointment(appointment);

      // Update the doctor's slot availability
      await appointmentRepository.updateSlotAvailability(
        doctorId: selectedDoctorId,
        date: selectedDate!,
        slotTime: selectedSlot!,
        available: false,
      );

      // Invalidate the userProvider to trigger a refresh
      ref.invalidate(userProvider);

      // Close the loading indicator
      if (mounted) {
        Navigator.pop(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AppointmentConfirmationPage(appointment: appointment),
          ),
        );
      }

      // Reset state
      setState(() {
        currentStep = 0;
        selectedSpecialty = null;
        selectedDoctor = null;
        selectedDate = null;
        selectedSlot = null;
      });
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading indicator
        ToastHelper.showErrorToast(
          context: context,
          title: "Error",
          description: "Failed to book appointment: $e",
        );
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ToastHelper.showErrorToast(
      context: context,
      title: "Error",
      description: message,
    );
  }
}
