// ignore_for_file: use_build_context_synchronously

import 'package:ajar/common/buttons/custom_gradient_button.dart';
import 'package:ajar/common/snakbar/custom_snakbar.dart';
import 'package:ajar/common/text_form_fields/custom_text_form_field.dart';
import 'package:ajar/providers/profile_updation/profile_updation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../../providers/authentication/authentication_provider.dart';

class DrivingLicenseInfoComplete extends StatelessWidget {
  const DrivingLicenseInfoComplete({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Consumer2<ProfileUpdationProvider, AuthenticationProvider>(
      builder: (context, profileUpdationProvider, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Driving License",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Form(
                  key: profileUpdationProvider.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        "Enter your information exactly as it appears on your license",
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isDarkMode ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              label: 'First Name',
                              controller:
                                  profileUpdationProvider.firstNameController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 3) {
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
                                  profileUpdationProvider.lastNameController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 3) {
                                  return 'Please enter your\nlast name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      CustomTextFormField(
                        label: 'Country',
                        controller: profileUpdationProvider.countryController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'Please enter your country name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      CustomTextFormField(
                        label: 'State',
                        controller: profileUpdationProvider.stateController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'Please enter your state';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      CustomTextFormField(
                        label: 'License Number',
                        controller:
                            profileUpdationProvider.licenseNumberController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'Please enter your license number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => _selectDate(context,
                            profileUpdationProvider.dateofbirthController),
                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            label: 'Date of Birth',
                            controller:
                                profileUpdationProvider.dateofbirthController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your date of birth';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => _selectDate(context,
                            profileUpdationProvider.epirationDateController),
                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            label: 'Expiration Date',
                            controller:
                                profileUpdationProvider.epirationDateController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter license expiration date';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomGradientButton(
                        text: "Update",
                        onPressed: () async {
                          if (profileUpdationProvider
                              .validateDrivingLicenseForm()) {
                            final statusCode =
                                await authProvider.updateDrivingLicense(
                              profileUpdationProvider.firstNameController.text
                                  .trim(),
                              profileUpdationProvider.lastNameController.text
                                  .trim(),
                              profileUpdationProvider.countryController.text
                                  .trim(),
                              profileUpdationProvider.stateController.text
                                  .trim(),
                              profileUpdationProvider
                                  .licenseNumberController.text
                                  .trim(),
                              profileUpdationProvider.dateofbirthController.text
                                  .trim(),
                              profileUpdationProvider
                                  .epirationDateController.text
                                  .trim(),
                            );
                    
                            // Handle navigation based on status code
                            if (statusCode == 200) {
                              showCustomSnackBar(context,
                                  "License Details are Added!", Colors.green);
                              Navigator.pop(context);
                            } else if (statusCode == 401) {
                              showCustomSnackBar(
                                  context,
                                  "You must be at least 18 years old.",
                                  Colors.red);
                            } else if (statusCode == 402) {
                              showCustomSnackBar(
                                  context,
                                  "Expiration date must be in the future.",
                                  Colors.red);
                            } else if (statusCode == 400) {
                              showCustomSnackBar(
                                  context, "Validation Failed!", Colors.red);
                            } else {
                              showCustomSnackBar(
                                  context,
                                  "Updation failed. Please try again.",
                                  Colors.red);
                            }
                          }
                        },
                        isLoading: authProvider.isLoading,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      // Format the date to 'yyyy-MM-dd'
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }
}
