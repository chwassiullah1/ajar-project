import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool get obscurePassword => _obscurePassword;
  GlobalKey<FormState> get formKey => _formKey;
  // Add FocusNodes for both fields
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();


  LoginProvider() {
    // Attach listeners to FocusNodes to clear error when field is focused
    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        // Clear the email field error
        emailController.clear(); // Optional: Clear text on focus if desired
        notifyListeners();
      }
    });

    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        // Clear the password field error
        passwordController.clear(); // Optional: Clear text on focus if desired
        notifyListeners();
      }
    });
  }
  // Toggle password visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool validateForm() {
    return _formKey.currentState!.validate();
  }

  // Dispose the controllers
  void disposeControllers() {
    passwordController.dispose();
    emailController.dispose();
    notifyListeners();
  }
}
