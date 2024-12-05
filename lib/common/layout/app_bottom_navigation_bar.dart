import 'package:flutter/material.dart';
import 'package:myhospital/core/constants/app_icons.dart';
import 'package:myhospital/features/appointments/views/booking_appointment_page.dart';
import 'package:myhospital/features/appointments/views/my_appointments_view.dart';
import 'package:myhospital/features/current_user/views/profile_view.dart';
import 'package:myhospital/features/home/views/home_view.dart';
import 'package:myhospital/theme/app_theme.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const MyAppointmentsView(),
    const ProfileView(),
  ];

  void _onTap(int index) {
    if (index == 1) {
      // Push the BookingAppointmentPage when the "Book" tab is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BookingAppointmentPage()),
      );
    } else {
      // Switch tabs for other indices
      setState(() {
        _currentIndex = index == 1
            ? _currentIndex
            : index > 1
                ? index - 1
                : index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex > 0 ? _currentIndex + 1 : _currentIndex,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.grayColor,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: AppIcons.homeIcon(color: AppTheme.grayColor),
            activeIcon: AppIcons.homeIcon(color: AppTheme.primaryColor),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: AppIcons.addIcon(color: AppTheme.grayColor),
            activeIcon: AppIcons.addIcon(color: AppTheme.primaryColor),
            label: "Book",
          ),
          BottomNavigationBarItem(
            icon: AppIcons.calendarIcon(color: AppTheme.grayColor),
            activeIcon: AppIcons.calendarIcon(color: AppTheme.primaryColor),
            label: "Appointments",
          ),
          BottomNavigationBarItem(
            icon: AppIcons.userIcon(color: AppTheme.grayColor),
            activeIcon: AppIcons.userIcon(color: AppTheme.primaryColor),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
