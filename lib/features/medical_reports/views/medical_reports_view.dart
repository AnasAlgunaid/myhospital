import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhospital/core/utils/timestamp_utils.dart';
import 'package:myhospital/features/medical_reports/provider/medical_reports_provider.dart';
import 'package:myhospital/theme/app_theme.dart';

class MedicalReportsView extends ConsumerWidget {
  const MedicalReportsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicalReports = ref.watch(userMedicalReportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Reports'),
        centerTitle: true,
      ),
      body: medicalReports.when(
        data: (reports) {
          if (reports.isEmpty) {
            return Center(
              child: Text(
                'No medical reports found.',
                style: AppTheme.bodyText2,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title:
                            Text(report.reportTitle, style: AppTheme.headline2),
                        subtitle: Text(
                          'Isuued by: ${report.doctor.name}',
                          style: AppTheme.bodyText3,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.reportContent,
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
                                report.timestamp,
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
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Failed to load medical reports: $error',
            style: AppTheme.bodyText2.copyWith(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
