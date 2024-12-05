import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhospital/common/widgets/text_banner.dart';
import 'package:myhospital/common/widgets/feature_card.dart';
import 'package:myhospital/common/widgets/scrollable_banners.dart';
import 'package:myhospital/common/widgets/section_title.dart';
import 'package:myhospital/core/constants/app_constants.dart';
import 'package:myhospital/core/constants/app_icons.dart';
import 'package:myhospital/features/appointments/views/home_appointments_list.dart';
import 'package:myhospital/features/appointments/views/my_appointments_view.dart';
import 'package:myhospital/features/banners/providers/banner_provider.dart';
import 'package:myhospital/features/current_user/providers/user_provider.dart';
import 'package:myhospital/features/doctors/providers/doctors_provider.dart';
import 'package:myhospital/features/lab_results/views/lab_results_view.dart';
import 'package:myhospital/features/medical_reports/views/medical_reports_view.dart';
import 'package:myhospital/features/prescriptions/views/prescriptions_view.dart';
import 'package:myhospital/theme/app_theme.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  Future<void> _refreshContent() async {
    try {
      // Await both refresh operations to ensure they complete
      await Future.wait([
        ref.refresh(userProvider.future),
        ref.refresh(bannersProvider.future),
        ref.refresh(doctorsProvider.future),
      ]);
    } catch (e) {
      // Handle any errors that might occur during refresh
      print('Error refreshing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userProvider);
    final banners = ref.watch(bannersProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          edgeOffset: 0,
          color: AppTheme.primaryColor,
          onRefresh: _refreshContent,
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(), // Ensure pull-to-refresh works even without enough content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          currentUser.when(
                            data: (user) {
                              final firstName =
                                  user?.name.split(' ').first ?? 'User';
                              return Text(
                                "Hi $firstName!",
                                style: AppTheme.headline1,
                              );
                            },
                            loading: () => Text(
                              "Hi there!",
                              style: AppTheme.headline1,
                            ),
                            error: (error, stack) => Text(
                              "Hi there!",
                              style: AppTheme.headline1,
                            ),
                          ),
                          Text(
                            "May you always be in a good condition",
                            style: AppTheme.bodyText2,
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SectionTitle(
                  title: "My Appointments",
                  buttonText: "View all",
                  onButtonPressed: () {},
                ),
                const HomeAppointmentsList(),
                const SizedBox(height: 16),
                banners.when(
                  data: (bannerList) {
                    final validBanners = bannerList
                        .where((banner) => banner.imageUrl.isNotEmpty)
                        .toList();

                    if (validBanners.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitle(
                          title: "News",
                          onButtonPressed: () {},
                        ),
                        ScrollableBanners(
                          banners: bannerList,
                        ),
                      ],
                    );
                  },
                  loading: () => const ScrollableBanners(
                    banners: [],
                    isLoading: true,
                  ),
                  error: (error, stack) => Center(
                    child: Text(
                      "Failed to load banners: $error",
                      style: AppTheme.bodyText2.copyWith(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    FeatureCard(
                      icon: AppIcons.calendarIcon(
                        color: const Color(0xFF254EDB),
                        size: 32,
                      ),
                      title: "Appointments",
                      subtitle: "View and manage your appointments",
                      backgroundColor: const Color(0xFFF5F8FF),
                      iconBackgroundColor: const Color(0xFFC6D3F1),
                      iconBorderColor: const Color(0xFFA0B6EA),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyAppointmentsView(),
                          ),
                        );
                      },
                    ),
                    FeatureCard(
                      icon: AppIcons.testTubeIcon(
                        color: const Color(0xFF16B364),
                        size: 32,
                      ),
                      title: "Lab Results",
                      subtitle: "View and manage your lab results",
                      backgroundColor: const Color(0xFFEDFCF2),
                      iconBackgroundColor: const Color(0xFFD3F8DF),
                      iconBorderColor: const Color(0xFFAAF0C4),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LabResultsView(),
                          ),
                        );
                      },
                    ),
                    FeatureCard(
                      icon: AppIcons.medicineIcon(
                        color: const Color(0xFFEF6820),
                        size: 32,
                      ),
                      title: "Prescriptions",
                      subtitle: "View and manage your prescriptions",
                      backgroundColor: const Color(0xFFFEF6EE),
                      iconBackgroundColor: const Color(0xFFFEE4E2),
                      iconBorderColor: const Color(0xFFF9DBAF),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrescriptionsView(),
                          ),
                        );
                      },
                    ),
                    FeatureCard(
                      icon: AppIcons.reportIcon(
                        color: const Color(0xFFF04438),
                        size: 32,
                      ),
                      title: "Medical Reports",
                      subtitle: "View and manage your medical reports",
                      backgroundColor: const Color(0xFFFEF3F2),
                      iconBackgroundColor: const Color(0xFFFEE4E2),
                      iconBorderColor: const Color(0xFFFECDCA),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MedicalReportsView(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(AppConstants.defaultPadding),
                  child: TextBanner(
                    title: "Do you want help?",
                    subtitle: "Talk to us",
                    color: AppTheme.primaryColor,
                    hyperlink: "https://algunaid.com/",
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
