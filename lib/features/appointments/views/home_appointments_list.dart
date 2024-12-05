import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhospital/common/widgets/appointment_card.dart';
import 'package:myhospital/common/widgets/appointment_loading_card.dart';
import 'package:myhospital/features/appointments/providers/appointment_provider.dart';
import 'package:myhospital/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class HomeAppointmentsList extends ConsumerWidget {
  const HomeAppointmentsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAppointments = ref.watch(userAppointmentsProvider);
    return SizedBox(
      height: 120, // Set a fixed height for the cards
      child: userAppointments.when(
        data: (appointments) {
          // Filter only upcoming appointments
          final upcomingAppointments = appointments
              .where(
                (appointment) => appointment.timestamp.isAfter(DateTime.now()),
              )
              .toList();

          if (upcomingAppointments.isEmpty) {
            return Center(
              child: Text(
                'No upcoming appointments.',
                style: AppTheme.bodyText2,
              ),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16.0),
            itemCount: upcomingAppointments.length,
            itemBuilder: (context, index) {
              final appointment = upcomingAppointments[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: AppointmentCard(
                  appointmentId: appointment.appointmendId,
                  doctorName: appointment.doctor.name,
                  doctorImage: appointment.doctor.photoUrl,
                  doctorSpecialty: appointment.doctor.specialty.name,
                  timestamp: appointment.timestamp,
                  fromHome: true,
                ),
              );
            },
          );
        },
        loading: () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 16.0),
          itemCount: 3, // Display 3 shimmer placeholders
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: const AppointmentLoadingCard(),
              ),
            );
          },
        ),
        error: (error, stack) {
          print(error);
          return Center(
            child: Text(
              'Failed to load appointments: $error',
              style: AppTheme.bodyText2.copyWith(color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
