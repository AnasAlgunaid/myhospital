import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhospital/features/appointments/providers/appointment_provider.dart';
import 'package:myhospital/common/widgets/appointment_card.dart';
import 'package:myhospital/common/widgets/appointment_loading_card.dart';
import 'package:myhospital/features/appointments/views/booking_appointment_page.dart';
import 'package:myhospital/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class MyAppointmentsView extends ConsumerStatefulWidget {
  const MyAppointmentsView({super.key});

  @override
  ConsumerState<MyAppointmentsView> createState() => _MyAppointmentsViewState();
}

class _MyAppointmentsViewState extends ConsumerState<MyAppointmentsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming Appointments Tab
          _buildAppointmentList(
            context,
            ref,
            isUpcoming: true,
          ),
          // Past Appointments Tab
          _buildAppointmentList(
            context,
            ref,
            isUpcoming: false,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const BookingAppointmentPage(),
            ),
          );
        },
        label: const Text('Book Appointment'),
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add, size: 24),
        // Borde radius
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99),
        ),
        splashColor: Colors.transparent,
        extendedTextStyle: AppTheme.headline4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAppointmentList(BuildContext context, WidgetRef ref,
      {required bool isUpcoming}) {
    final userAppointments = ref.watch(userAppointmentsProvider);

    return userAppointments.when(
      data: (appointments) {
        final filteredAppointments = appointments
            .where((appointment) => isUpcoming
                ? appointment.timestamp.isAfter(DateTime.now())
                : appointment.timestamp.isBefore(DateTime.now()))
            .toList();

        if (filteredAppointments.isEmpty) {
          return Center(
            child: Text(
              isUpcoming
                  ? 'No upcoming appointments.'
                  : 'No past appointments. ',
              style: AppTheme.bodyText2,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: filteredAppointments.length,
          itemBuilder: (context, index) {
            final appointment = filteredAppointments[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: AppointmentCard(
                appointmentId: appointment.appointmendId,
                doctorName: appointment.doctor.name,
                doctorImage: appointment.doctor.photoUrl,
                doctorSpecialty: appointment.doctor.specialty.name,
                timestamp: appointment.timestamp,
              ),
            );
          },
        );
      },
      loading: () => ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 3, // Display 3 shimmer placeholders
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: const AppointmentLoadingCard(),
            ),
          );
        },
      ),
      error: (error, stack) => Center(
        child: Text(
          'Failed to load appointments: $error',
          style: AppTheme.bodyText2.copyWith(color: Colors.red),
        ),
      ),
    );
  }
}
