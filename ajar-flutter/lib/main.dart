import 'package:ajar/common/no_internet_connection/no_internet_connection_screen.dart';
import 'package:ajar/providers/authentication/forget_password_provider.dart';
import 'package:ajar/providers/authentication/login_provider.dart';
import 'package:ajar/providers/booking/booking_provider.dart';
import 'package:ajar/providers/google_service_providers/google_service_provider.dart';
import 'package:ajar/providers/profile_updation/profile_updation_provider.dart';
import 'package:ajar/providers/onboarding/onboaring_provider.dart';
import 'package:ajar/providers/authentication/authentication_provider.dart';
import 'package:ajar/providers/authentication/registration_provider.dart';
import 'package:ajar/providers/profile_updation/update_password_provider.dart';
import 'package:ajar/providers/vehicles/vehicle_provider.dart';
import 'package:ajar/screens/splash_start_onboarding_screens/splash_screen/splash_screen.dart';
import 'package:ajar/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool connected = await InternetConnection().hasInternetAccess;

  if (connected) {
    runApp(const MyApp());
  } else {
    runApp(const NoConnectionScreen());
  }
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ForgetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => UpdatePasswordProvider()),
        ChangeNotifierProvider(create: (_) => ProfileUpdationProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => GoogleServiceProvider()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Ajar',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}
