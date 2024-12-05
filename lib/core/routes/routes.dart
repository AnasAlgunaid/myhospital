import 'package:flutter/material.dart';
import 'package:myhospital/common/layout/app_bottom_navigation_bar.dart';
import 'package:myhospital/features/appointments/views/my_appointments_view.dart';
import 'package:myhospital/features/authentication/views/phone_login_view.dart';

class AppRoutes {
  static const String phoneLogin = '/phoneLogin';
  static const String phoneRegister = '/phoneRegister';
  static const String home = '/home';
  static const String myAppointments = '/myAppointments';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case phoneLogin:
        return MaterialPageRoute(builder: (_) => const PhoneLoginView());
      // case phoneRegister:
      //   return MaterialPageRoute(builder: (_) => const PhoneRegisterView());
      case home:
        return MaterialPageRoute(
          builder: (_) => const AppBottomNavigationBar(),
        );
      case myAppointments:
        return MaterialPageRoute(builder: (_) => const MyAppointmentsView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
