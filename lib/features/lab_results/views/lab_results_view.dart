import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhospital/core/utils/timestamp_utils.dart';
import 'package:myhospital/features/lab_results/models/lab_result.dart';
import 'package:myhospital/features/lab_results/provider/lab_results_provider.dart';
import 'package:myhospital/theme/app_theme.dart';

class LabResultsView extends ConsumerWidget {
  const LabResultsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labResults = ref.watch(userLabResultsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Results'),
      ),
      body: labResults.when(
        data: (results) {
          if (results.isEmpty) {
            return Center(
              child: Text(
                'No lab results found.',
                style: AppTheme.bodyText2,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return LabResultCard(result: result);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Failed to load lab results: $error',
            style: AppTheme.bodyText2.copyWith(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class LabResultCard extends StatelessWidget {
  const LabResultCard({
    super.key,
    required this.result,
  });

  final LabResult result;

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
              title: Text(result.testName, style: AppTheme.headline2),
              subtitle: Text(
                'Doctor: ${result.doctor.name}',
                style: AppTheme.bodyText3,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.testResult,
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
                      result.timestamp,
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
