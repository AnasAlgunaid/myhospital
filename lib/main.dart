import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhospital/core/routes/routes.dart';
import 'package:myhospital/theme/app_theme.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Hospital',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.phoneLogin,
      theme: AppTheme.lightTheme,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
