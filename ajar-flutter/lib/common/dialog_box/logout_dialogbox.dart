// ignore_for_file: use_build_context_synchronously

import 'package:ajar/common/snakbar/custom_snakbar.dart';
import 'package:ajar/providers/authentication/authentication_provider.dart';
import 'package:ajar/screens/splash_start_onboarding_screens/starting_screen/starting_screen.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final authProvider = Provider.of<AuthenticationProvider>(context);
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Return true to confirm logout
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: fMainColor),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!authProvider.isLoading) {
                final statusCode = await authProvider.logout();

                Navigator.of(context).pop(); // Close the dialog

                if (statusCode == 200) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StartingScreen(),
                    ),
                  );
                  showCustomSnackBar(
                      context, "Logout successfully!", Colors.green);
                } else {
                  showCustomSnackBar(
                    context,
                    "Logout failed. Please try again",
                    Colors.red,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: authProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.red,
                      strokeWidth: 2.0,
                    ),
                  )
                : const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      );
    },
  ); // Ensure false is returned if dialog is dismissed
}