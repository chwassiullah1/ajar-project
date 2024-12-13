// ignore_for_file: use_build_context_synchronously

import 'package:ajar/common/buttons/custom_gradient_button.dart';
import 'package:ajar/common/slide_page_routes/slide_page_route.dart';
import 'package:ajar/common/snakbar/custom_snakbar.dart';
import 'package:ajar/common/text_form_fields/custom_text_form_field.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/authentication/authentication_provider.dart';
import '../../../providers/authentication/registration_provider.dart';
import 'package:country_picker/country_picker.dart';

import '../opt_verification_screen/opt_verification_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Consumer2<RegistrationProvider, AuthenticationProvider>(
        builder: (context, registrationProvider, authProvider, child) {
      return Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.07),
                    child: Form(
                      key: registrationProvider.registerFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: size.height * 0.05),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Welcome to ",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              children: const [
                                TextSpan(
                                  text: "Ajar",
                                  style: TextStyle(
                                    color: fMainColor,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Create an account by filling your details to start a journey with us.",
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  label: 'First Name',
                                  controller:
                                      registrationProvider.firstNameController,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 3) {
                                      return 'Please enter your\nfirst name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextFormField(
                                  label: 'Last Name',
                                  controller:
                                      registrationProvider.lastNameController,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 3) {
                                      return 'Please enter your\nlast name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            label: 'Email',
                            controller: registrationProvider.emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          customPhoneNumberTextFormField(
                              context, registrationProvider),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            label: 'Password',
                            controller: registrationProvider.passwordController,
                            obscureText: registrationProvider.obscurePassword,
                            isPasswordField: true,
                            toggleVisibility:
                                registrationProvider.togglePasswordVisibility,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              } else if (value.length < 8) {
                                return 'Password must be at least\n8 characters long';
                              } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                                return 'Password must contain at least\none lowercase letter';
                              } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return 'Password must contain at least\none uppercase letter';
                              } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return 'Password must contain at\nleastone number';
                              } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                  .hasMatch(value)) {
                                return 'Password must contain at least\none special character';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "We’ll text you a OTP code to your email address to confirm your account.",
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomGradientButton(
                            text: "Sign Up",
                            onPressed: () async {
                              if (registrationProvider.validateForm()) {
                                final statusCode =
                                    await authProvider.registerUser(
                                  email: registrationProvider
                                      .emailController.text
                                      .toLowerCase()
                                      .trim(),
                                  phone:
                                      registrationProvider.getFullPhoneNumber(),
                                  password: registrationProvider
                                      .passwordController.text
                                      .trim(),
                                  firstName: registrationProvider
                                      .firstNameController.text,
                                  lastName: registrationProvider
                                      .lastNameController.text,
                                );

                                // Handle navigation based on status code
                                if (statusCode == 200) {
                                  // Navigate to OTP verification screen
                                  Navigator.of(context).pushReplacement(
                                    SlidePageRoute(
                                      page: OptVerificationScreen(
                                        email: registrationProvider
                                            .emailController.text
                                            .toLowerCase()
                                            .trim(),
                                      ),
                                    ),
                                  );
                                  registrationProvider.clearFields();
                                } else if (statusCode == 409) {
                                  // Show user already exists error
                                  showCustomSnackBar(context,
                                      "User already exists!", Colors.orange);
                                } else if (statusCode == 400) {
                                  // Handle other errors
                                  showCustomSnackBar(
                                      context, "Validation error!", Colors.red);
                                } else {
                                  // Handle other errors
                                  showCustomSnackBar(
                                      context,
                                      "Registration failed. Please try again.",
                                      Colors.red);
                                }
                              }
                            },
                            isLoading: authProvider.isLoading,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "By signing up, you agree to Ajar's ",
                                style: TextStyle(
                                  fontSize: size.width * 0.035,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                children: [
                                  TextSpan(
                                    text: "term of service and privacy policy.",
                                    style: TextStyle(
                                      fontSize: size.width * 0.035,
                                      color: fMainColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  TextFormField customPhoneNumberTextFormField(
      BuildContext context, RegistrationProvider registrationProvider) {
    // Determine the current brightness
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return TextFormField(
      cursorColor: fMainColor,
      controller: registrationProvider.phoneController,
      maxLength: 15,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 16,
        color: isDarkMode ? Colors.white : Colors.grey.shade900,
      ),
      onChanged: (value) {
        registrationProvider.phoneController.text = value;
      },
      validator: (value) {
        // Phone number validation
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        return null; // Return null if the input is valid
      },
      decoration: InputDecoration(
        fillColor: isDarkMode ? fdarkBlue : Colors.grey[200],
        filled: true,
        counterText: '',
        hintText: 'Phone Number',
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.grey.shade900,
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none),
        prefixIcon: Container(
          padding: const EdgeInsets.fromLTRB(8.0, 14.0, 8.0, 12.0),
          child: InkWell(
            onTap: () {
              showCountryPicker(
                context: context,
                countryListTheme: CountryListThemeData(
                    backgroundColor:
                        isDarkMode ? fdarkBlue : Colors.grey.shade300,
                    borderRadius: BorderRadius.zero,
                    bottomSheetHeight: 400),
                onSelect: (Country country) {
                  registrationProvider.selectCountry(country);
                },
              );
            },
            child: Text(
              //textAlign: TextAlign.center,
              ' +${registrationProvider.selectedCountry.phoneCode}',
              style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.grey.shade900),
            ),
          ),
        ),
      ),
    );
  }
}

  // void _registerWithGoogle(BuildContext context) async {
  //   final googleSignInService = GoogleSignInService();
  //   final googleUser = await googleSignInService.signInWithGoogle();

  //   if (googleUser != null) {
  //     final email = googleUser.email;
  //     final displayName = googleUser.displayName;
  //     final googleIdToken = await googleUser.authentication;

  //     // Send this data to the backend for further processing
  //     final registrationProvider =
  //         Provider.of<AuthenticationController>(context, listen: false);
  //     final response = await registrationProvider.registerWithGoogle(
  //       email: email,
  //       displayName: displayName!,
  //       idToken: googleIdToken.idToken!,
  //     );

  //     if (response!['statusCode'] == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Signed in successfully!')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(response['message'])),
  //       );
  //     }
  //   }
  // }