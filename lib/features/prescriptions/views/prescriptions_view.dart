import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhospital/core/utils/timestamp_utils.dart';
import 'package:myhospital/features/prescriptions/models/prescription.dart';
import 'package:myhospital/features/prescriptions/provider/prescriptions_provider.dart';

import 'package:myhospital/theme/app_theme.dart';

class PrescriptionsView extends ConsumerWidget {
  const PrescriptionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prescriptions = ref.watch(userPrescriptionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescriptions'),
        centerTitle: true,
      ),
      body: prescriptions.when(
        data: (results) {
          if (results.isEmpty) {
            return Center(
              child: Text(
                'No prescriptions found.',
                style: AppTheme.bodyText2,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final prescription = results[index];
              return PrescriptionCard(prescription: prescription);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Failed to load prescriptions: $error',
            style: AppTheme.bodyText2.copyWith(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard({
    super.key,
    required this.prescription,
  });

  final Prescription prescription;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(prescription.medicineName, style: AppTheme.headline2),
              subtitle: Text(
                'Doctor: ${prescription.doctor.name}',
                style: AppTheme.bodyText3,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prescription.dosage,
                  style: AppTheme.bodyText2,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    TimestampUtils.formatDateAndTime(
                      prescription.timestamp,
                    ),
                    style: AppTheme.bodyText2.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
