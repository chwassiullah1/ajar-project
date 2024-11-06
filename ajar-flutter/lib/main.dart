import 'package:ajar/providers/authentication/forget_password_provider.dart';
import 'package:ajar/providers/authentication/login_provider.dart';
import 'package:ajar/providers/profile_updation/profile_updation_provider.dart';
import 'package:ajar/providers/onboarding/onboaring_provider.dart';
import 'package:ajar/providers/authentication/authentication_provider.dart';
import 'package:ajar/providers/authentication/registration_provider.dart';
import 'package:ajar/providers/profile_updation/update_password_provider.dart';
import 'package:ajar/screens/splash_screen/splash_screen.dart';
import 'package:ajar/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OnboardingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthenticationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RegistrationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ForgetPasswordProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UpdatePasswordProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileUpdationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Ajar',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
