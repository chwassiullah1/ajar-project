// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:ajar/common/buttons/custom_gradient_button.dart';
import 'package:ajar/common/check_boxes/checkbox_with_title.dart';
import 'package:ajar/common/snakbar/custom_snakbar.dart';
import 'package:ajar/common/text_form_fields/custom_text_form_field.dart';
import 'package:ajar/models/vehicle/vehicle_model.dart';
import 'package:ajar/providers/vehicles/vehicle_provider.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/get_vehicle_details_custom_widgets.dart';
import 'package:ajar/screens/vehicle_screens/vehicle_hosts_screen/image_carousel.dart';
import 'package:ajar/utils/image_croper/image_picker_service.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:ajar/widgets/bullet_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // For date formatting

class CustomStepperForm extends StatefulWidget {
  const CustomStepperForm({super.key});

  @override
  State<CustomStepperForm> createState() => _CustomStepperFormState();
}

class _CustomStepperFormState extends State<CustomStepperForm> {
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _vehicleRegistraionNumberController =
      TextEditingController();
  final TextEditingController _vehicleLicenseNumberController =
      TextEditingController();
  final TextEditingController _vehicleEngineSizeController =
      TextEditingController();
  final TextEditingController _vehicleSeatsCapcityController =
      TextEditingController();
  final TextEditingController _vehicleMileageController =
      TextEditingController();
  final TextEditingController _vehicleColorController = TextEditingController();

  final TextEditingController _vehicleDesctiptionController =
      TextEditingController();

  final TextEditingController _vehicleReasonController =
      TextEditingController();

  final TextEditingController _pickedDatesController = TextEditingController();

  final TextEditingController _pickedVehicleLocationController =
      TextEditingController();
  final TextEditingController _vehicleVinController = TextEditingController();
  final TextEditingController _vehiclePricePerDayController =
      TextEditingController();
  final TextEditingController _addressCityController = TextEditingController();

  final TextEditingController _driverPriceController = TextEditingController();

  bool _deliveryCheckbox = false; // Track checkbox state
  final TextEditingController _deliveryChargesController =
      TextEditingController();

  int _currentStep = 0;
  final int _totalSteps = 9;

  // Progress for the Linear Progress Indicator
  double get _progress => (_currentStep + 1) / _totalSteps;

  // Step names for the popup modal
  final List<String> _stepNames = [
    'Vehicle Location Selction',
    'Vehicle Identification Number',
    'Vehicle Details',
    'Vehicle Features Selection',
    'Availability & Pricing',
    'Upload Photos',
    'Reason and Description',
    'Safety & Quality',
    'Submit Your Listing',
  ];

  String? selectedDriverOption = "Without Driver"; // Default value
  bool isAvailable = true;

  final List<String> driverOptions = [
    "Only with driver",
    "Driver available on Demand",
    "Without Driver"
  ];

  DateTimeRange? _selectedDateRange;

  // Form keys for each step
  final GlobalKey<FormState> carDetailsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> profilePictureFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> vehicleLocationFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> vinFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> reasonAndDescriptionFormKey =
      GlobalKey<FormState>();
  final GlobalKey<FormState> priceAndAvailabiltyFormKey =
      GlobalKey<FormState>();

  bool _isAc = false;
  bool _isGps = false;
  bool _isUsb = false;
  bool _isCharger = false; // Selected by default
  bool _isSunroof = false; // Selected by default
  bool _isBluetooth = false; // Selected by default
  bool _isPushButtonStart = false; // Selected by default

  final double latitude = 31.5204;
  final double longitude = 74.3587;

  String startDate = "";
  String endDate = "";

  final TextEditingController _selectedVehicleType = TextEditingController();
  final TextEditingController _selectedTransmissionType =
      TextEditingController();
  final TextEditingController _selectedFuelType = TextEditingController();

  String formatDateRangeInFile(DateTimeRange dateRange) {
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    startDate = dateFormatter.format(dateRange.start);
    endDate = dateFormatter.format(dateRange.end);
    return '$startDate / $endDate';
  }

  bool isTermAndConditionAgreed = false; // Track checkbox value

  List<XFile?> selectedImages =
      List<XFile?>.filled(10, null); // Initialize a list with 6 null values

  Future<void> pickImage(BuildContext context, int imageIndex) async {
    final ImagePickerService imagePickerService = ImagePickerService();

    XFile? pickedImage;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(IconlyBold.camera),
              title: const Text('Camera'),
              onTap: () async {
                pickedImage = await imagePickerService.pickCropImage(
                  imageSource: ImageSource.camera,
                  cropAspectRatio:
                      const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(IconlyBold.image),
              title: const Text('Gallery'),
              onTap: () async {
                pickedImage = await imagePickerService.pickCropImage(
                  imageSource: ImageSource.gallery,
                  cropAspectRatio:
                      const CropAspectRatio(ratioX: 14, ratioY: 10),
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );

    if (pickedImage != null) {
      setState(() {
        selectedImages[imageIndex - 1] =
            pickedImage; // Store picked image in the list
      });
    }
  }

  // Method to open the popup with step names
  void _showStepNames(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('All Steps'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _stepNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    index <= _currentStep ? Icons.check_circle : Icons.circle,
                    color: index <= _currentStep ? fMainColor : Colors.grey,
                  ),
                  title: Text(_stepNames[index]),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Step content for each step
  Widget _getStepContent(int step) {
    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: true);
    // Determine the current theme mode (light or dark)
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    switch (step) {
      case 0:
        return Form(
          key: vehicleLocationFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Vehicle Location',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: fMainColor),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your vehicle location is needed. Enter or pick correct city name and full address in order to list your vehicle.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                label: 'Your City Name',
                controller: _addressCityController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter a valid city name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                showIcon: true,
                iconData: Icons.location_pin,
                label: 'Enter Full Address',
                controller: _pickedVehicleLocationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please pick or enter a valid vehicle address.';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      case 1:
        return Form(
          key: vinFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'VIN',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: fMainColor),
              ),
              const SizedBox(height: 10),
              const Text(
                "We'll use your Vehicle Identification Number (VIN) to identify your specific car",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                maxLength: 17,
                label: '“1HGCM82633A123456” (17 characters)',
                controller: _vehicleVinController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vehicle identification number';
                  }
                  if (value.length != 17) {
                    return 'VIN should be 17 characters long.';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      case 2:
        return Form(
          key: carDetailsFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Manual Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: fMainColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please provide manual details of your car.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        openMakeSelectionDialog(context, _makeController);
                      },
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          label: 'Make',
                          controller: _makeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        openModelSelectionDialog(context, _modelController, _makeController.text);
                      },
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          label: 'Model',
                          controller: _modelController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        openYearSelectionDialog(context, _yearController);
                      },
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          label: 'Year',
                          controller: _yearController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required.';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a \nvalid number.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        openVehicleTypeSelectionDialog(
                            context, _selectedVehicleType);
                      },
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          label: 'Type',
                          controller: _selectedVehicleType,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      label: 'License Number',
                      controller: _vehicleLicenseNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomTextFormField(
                      label: 'Reg. Number',
                      controller: _vehicleRegistraionNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        openTransmissionTypeSelectionDialog(
                            context, _selectedTransmissionType);
                      },
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          label: 'Transmission Type',
                          controller: _selectedTransmissionType,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        openFuelTypeSelectionDialog(context, _selectedFuelType);
                      },
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          label: 'Fuel Type',
                          controller: _selectedFuelType,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      label: 'Mileage (in miles)',
                      controller: _vehicleMileageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a\nvalid number.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        openNumberOfSeatsSelectionDialog(
                            context, _vehicleSeatsCapcityController);
                      },
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          label: 'No. of Seats',
                          controller: _vehicleSeatsCapcityController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required.';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a\nvalid number.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        openEngineSizeSelectionDialog(
                            context, _vehicleEngineSizeController);
                      },
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          label: 'Engine Size',
                          controller: _vehicleEngineSizeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        openColorSelectionDialog(
                            context, _vehicleColorController);
                      },
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          label: 'Color',
                          controller: _vehicleColorController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Your Vehicle Features',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: fMainColor),
            ),
            const SizedBox(height: 10),
            const Text(
              'Let renders know which features you vehicle have.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            buildFeatureCheckbox('AC', _isAc, (bool? value) {
              setState(() {
                _isAc = value!;
                print(_isAc);
              });
            }),
            const SizedBox(height: 5),
            buildFeatureCheckbox('GPS', _isGps, (bool? value) {
              setState(() {
                _isGps = value!;
              });
            }),
            const SizedBox(height: 5),
            buildFeatureCheckbox('USB', _isUsb, (bool? value) {
              setState(() {
                _isUsb = value!;
              });
            }),
            const SizedBox(height: 5),
            buildFeatureCheckbox('Charger', _isCharger, (bool? value) {
              setState(() {
                _isCharger = value!;
              });
            }),
            const SizedBox(height: 5),
            buildFeatureCheckbox('Sunroof', _isSunroof, (bool? value) {
              setState(() {
                _isSunroof = value!;
              });
            }),
            const SizedBox(height: 5),
            buildFeatureCheckbox('Bluetooth', _isBluetooth, (bool? value) {
              setState(() {
                _isBluetooth = value!;
              });
            }),
            const SizedBox(height: 5),
            buildFeatureCheckbox('Push Button Start', _isPushButtonStart,
                (bool? value) {
              setState(() {
                _isPushButtonStart = value!;
              });
            }),
          ],
        );

      case 4:
        return Form(
          key: priceAndAvailabiltyFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set Your Car Availability',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: fMainColor),
              ),
              const SizedBox(height: 10),
              const Text(
                'Let renders know when your car will be available for rent.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomTextFormField(
                      isEditable: false,
                      label: 'Add Dates',
                      controller: _pickedDatesController,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomGradientButton(
                      onPressed: () async {
                        // Open the date range picker
                        DateTimeRange? picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          initialDateRange: _selectedDateRange,
                        );

                        // If dates were picked, update the controller
                        if (picked != null) {
                          setState(() {
                            _selectedDateRange = picked;
                            _pickedDatesController.text =
                                formatDateRangeInFile(picked);
                          });
                        }
                      },
                      text: "+",
                      height: 50,
                      width: 50,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 3,
              //       child: CustomTextFormField(
              //         isEditable: false,
              //         label: 'Add Time Range',
              //         controller: _pickedTimeController,
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     Expanded(
              //       child: CustomGradientButton(
              //         onPressed: () async {
              //           await _pickTimeRange();
              //         },
              //         text: "+",
              //         height: 50,
              //         width: 50,
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Driver Availability Section
              const Text(
                'Driver Availability',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: fMainColor),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: isDarkMode ? fdarkBlue : Colors.grey.shade200,
                ),
                hint: const Text(
                  'Select Driver Availability',
                  style: TextStyle(fontSize: 12),
                ),
                value: selectedDriverOption,
                items: driverOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.white : Colors.grey.shade500,
                          fontWeight: FontWeight.w400),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDriverOption = newValue; // Store selected option
                  });
                },
              ),

              // Conditionally show the TextFormField
              if (selectedDriverOption == "Driver available on Demand" ||
                  selectedDriverOption == "Only with driver")
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: CustomTextFormField(
                    label: '\$ Driver Charges/Day',
                    controller:
                        _driverPriceController, // Your controller for this field
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Driver fee is required.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number.';
                      }
                      return null;
                    },
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  // Checkbox with label
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        //side: const BorderSide(width: 0.5),
                        value: _deliveryCheckbox,
                        onChanged: (bool? value) {
                          setState(() {
                            _deliveryCheckbox = value!;
                            print(_deliveryCheckbox);
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Provide delivery facility to renters' addresses",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Conditional rendering of the Delivery Charges TextFormField
              if (_deliveryCheckbox)
                CustomTextFormField(
                  controller: _deliveryChargesController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  label: '\$ Delivery Charges/Km',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a\nvalid number.';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 10),

              const Text(
                'Set Daily Rental Price for Your Vehicle',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: fMainColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Specify the daily rental rate for your vehicle, so renters know how much it costs to book.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                label: '\$ Vehicle Charges/Day',
                controller: _vehiclePricePerDayController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a\nvalid number.';
                  }
                  return null;
                },
              ),
            ],
          ),
        );

      case 5:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload Your Vehicle Photo",
              style: TextStyle(fontWeight: FontWeight.w700, color: fMainColor),
            ),
            const SizedBox(height: 8), // Add spacing before the textarea
            const Text(
                'Showcase your car with clear photos from different angles!'),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImageContainer(context, selectedImages[0], 1),
                _buildImageContainer(context, selectedImages[1], 2),
                _buildImageContainer(context, selectedImages[2], 3),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImageContainer(context, selectedImages[3], 4),
                _buildImageContainer(context, selectedImages[4], 5),
                _buildImageContainer(context, selectedImages[5], 6),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImageContainer(context, selectedImages[6], 7),
                _buildImageContainer(context, selectedImages[7], 8),
                _buildImageContainer(context, selectedImages[8], 9),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImageContainer(context, selectedImages[9], 10),
              ],
            ),
          ],
        );

      case 6:
        return Form(
          key: reasonAndDescriptionFormKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the start
            children: [
              const Text(
                "Vehicle Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8), // Add spacing before the textarea
              const Text(
                  'Enter a brief description or important note related to the vehicle below!'),
              // Text area for vehicle description
              const SizedBox(height: 8), // Add spacing before the textarea
              CustomTextFormField(
                controller: _vehicleDesctiptionController,
                maxLines: 5, // Textarea-like behavior
                label: '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required.';
                  }
                  return null;
                },
              ),
              // Add the description field below the goal selection
              const SizedBox(
                  height:
                      8), // Adds spacing between the radio buttons and textarea
              const Text(
                "Reason For Hosting",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8), // Add spacing before the textarea
              const Text(
                  'Enter a brief reason why you want to host your vehicle!'),
              // Text area for vehicle description
              const SizedBox(height: 8), // Add spacing before the textarea
              CustomTextFormField(
                controller: _vehicleReasonController,
                maxLines: 5, // Textarea-like behavior
                label: '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required.';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      case 7:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Agree to Safety & Quality Standards",
              style: TextStyle(fontWeight: FontWeight.w700, color: fMainColor),
            ),
            const SizedBox(height: 8), // Add spacing before the textarea
            const Text(
                'Ensure the best experience for renters by maintaining your car’s safety and cleanliness.'),
            const SizedBox(
              height: 8,
            ),
            const BulletText(text: 'Keep the car clean and free from damage.'),
            const BulletText(
                text:
                    'Ensure regular maintenance (oil changes, tire ressure checks.'),
            const BulletText(text: 'Have valid insurance and registration.'),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isTermAndConditionAgreed,
                    onChanged: (bool? value) {
                      setState(() {
                        isTermAndConditionAgreed =
                            value ?? false; // Update the checkbox value
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Text("I agree to follow these instructions."),
              ],
            ),
          ],
        );
      case 8:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Review and Submit Your Listing",
              style: TextStyle(fontWeight: FontWeight.w700, color: fMainColor),
            ),
            const SizedBox(height: 8), // Add spacing before the textarea
            const Text(
                'Take a moment to review your car listing before submitting.'),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Vehicle Images",
              style: TextStyle(fontWeight: FontWeight.w700, color: fMainColor),
            ),
            const SizedBox(
              height: 16,
            ),
            ImageCarousel(selectedImages: selectedImages),
            const SizedBox(height: 0),
            buildDetailSection('Vehicle Details', Icons.edit, [
              buildDetailRow(
                  Icons.directions_car, 'Make: ${_makeController.text}'),
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(
                  Icons.model_training, 'Model: ${_modelController.text}'),
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(
                  Icons.calendar_today, 'Year: ${_yearController.text}'),
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(Icons.minor_crash_outlined,
                  'Vehicle Type: $_selectedVehicleType'),
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(Icons.adjust_outlined,
                  'Transmission Type: $_selectedTransmissionType'),
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(
                  Icons.numbers, 'Location: ${_vehicleVinController.text}'),
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(Icons.code,
                  'License Number: ${_vehicleLicenseNumberController.text}'),
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(Icons.insert_link_rounded,
                  'Registration Number: ${_vehicleRegistraionNumberController.text}'),
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(
                  Icons.gas_meter_outlined, 'Fuel Type: $_selectedFuelType'),
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(Icons.engineering,
                  'Engine Size: ${_vehicleEngineSizeController.text}'),
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(
                  Icons.speed, 'Mileage: ${_vehicleMileageController.text}'),
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(
                  Icons.color_lens, 'Color: ${_vehicleColorController.text}'),
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(Icons.event_seat,
                  'Seats Size: ${_vehicleSeatsCapcityController.text}'),
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(
                  Icons.location_city, 'City: ${_addressCityController.text}'),
              buildDetailRow(Icons.location_on,
                  'Full Address: ${_pickedVehicleLocationController.text}'),
            ]),
            buildDetailSection('Vehicle Availability & Pricing', Icons.edit, [
              buildDetailRow(Icons.calendar_today, _pickedDatesController.text),
              const SizedBox(
                height: 3,
              ),
              // buildDetailRow(Icons.access_time, _pickedTimeController.text),
              // const SizedBox(
              //   height: 3,
              // ),
              buildDetailRow(Icons.transfer_within_a_station,
                  'Driver Availability: $selectedDriverOption'),
              // Conditionally show Driver Cost if the selected option is not "Without Driver"
              if (selectedDriverOption != "Without Driver") ...[
                const SizedBox(
                  height: 3,
                ),
                buildDetailRow(Icons.price_change,
                    'Driver Cost/Day: ${_driverPriceController.text}\$'),
              ],
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(Icons.person,
                  'Delivery Service Availabe: ${_deliveryCheckbox ? 'Yes' : 'No'}'),
              // Conditionally show delivery service cost if deliveryCheckbox is true
              if (_deliveryCheckbox) ...[
                const SizedBox(
                  height: 3,
                ),
                buildDetailRow(Icons.price_change,
                    'Delivery Service Cost/Day: ${_deliveryChargesController.text}\$'),
              ],
              const SizedBox(
                height: 3,
              ),
              buildDetailRow(Icons.directions_car,
                  'Vehicle Cost/Day:  ${_vehiclePricePerDayController.text}\$'),
            ]),

            buildDetailSection('Vehicle Features', Icons.edit, [
              buildFeatureRow(Icons.ac_unit, 'AC', _isAc),
              buildFeatureRow(Icons.gps_fixed, 'GPS', _isGps),
              buildFeatureRow(Icons.usb, 'USB', _isUsb),
              buildFeatureRow(
                  Icons.battery_charging_full, 'Charger', _isCharger),
              buildFeatureRow(Icons.wb_sunny, 'Sunroof', _isSunroof),
              buildFeatureRow(Icons.bluetooth, 'Bluetooth', _isBluetooth),
              buildFeatureRow(
                  Icons.power, 'Push Button Start', _isPushButtonStart),
            ]),

            buildDetailSection('Vehicle Description', Icons.edit, [
              Text(_vehicleDesctiptionController.text),
            ]),

            buildDetailSection('Reason of Hosting', Icons.edit, [
              Text(_vehicleReasonController.text),
            ]),
            // buildDetailSection('Payout Method', Icons.edit, [
            //   buildDetailRow(Icons.credit_card, 'Credit or Debit'),
            //   const Text(
            //     'Prepaid cards not accepted',
            //     style: TextStyle(color: Colors.grey, fontSize: 12),
            //   ),
            // ]),
            const SizedBox(height: 8),
            CustomGradientButton(
              text: "Submit",
              isLoading: vehicleProvider.isLoading,
              onPressed: () async {
                if (_driverPriceController.text.isEmpty) {
                  _driverPriceController.text = "0";
                }
                if (_deliveryChargesController.text.isEmpty) {
                  _deliveryChargesController.text = "0";
                }
                print(_driverPriceController.text);
                print(_vehiclePricePerDayController.text);

                // Debug the checkbox value before submission
                print("Checkbox value on submit: $_deliveryCheckbox");
                // Create a dummy vehicle object
                Vehicle newVehicle = Vehicle(
                  latitude: latitude.toString(),
                  longitude: longitude.toString(),
                  fullAddress: _pickedVehicleLocationController.text.trim(),
                  vinNumber: _vehicleVinController.text.trim(),
                  make: _makeController.text.trim(),
                  model: _modelController.text.trim(),
                  year: int.parse(_yearController.text.trim()),
                  vehicleType: _selectedVehicleType.text,
                  color: _vehicleColorController.text.trim(),
                  reasonForHosting: _vehicleReasonController.text.trim(),
                  startDate: startDate,
                  endDate: endDate,
                  transmissionType: _selectedTransmissionType.text,
                  fuelType: _selectedFuelType.text,
                  mileage: int.parse(_vehicleMileageController.text.trim()),
                  seats: int.parse(_vehicleSeatsCapcityController.text.trim()),
                  engineSize: _vehicleEngineSizeController.text.trim(),
                  pictures:
                      null, // You can set this to an appropriate value if needed
                  registrationNumber:
                      _vehicleRegistraionNumberController.text.trim(),
                  licensePlate: _vehicleLicenseNumberController.text.trim(),
                  description: _vehicleDesctiptionController.text.trim(),
                  driverAvailability: selectedDriverOption!,
                  price: _vehiclePricePerDayController.text.trim(),
                  city: _addressCityController.text.trim(),
                  isAc: _isAc,
                  isBluetooth: _isBluetooth,
                  isCharger: _isCharger,
                  isGps: _isGps,
                  isPushButtonStart: _isPushButtonStart,
                  isSunroof: _isSunroof,
                  isUsb: _isUsb,
                  driverPrice: _driverPriceController.text.trim(),
                  deliveryAvailable: _deliveryCheckbox,
                  deliveryPrice: _deliveryChargesController.text.trim(),
                );

                // Call the provider method to create the vehicle
                int statusCode =
                    await vehicleProvider.createVehicle(newVehicle);

                // Optionally handle the status code returned
                if (statusCode == 200) {
                  // Vehicle created successfully
                  final currentvehicleID = vehicleProvider.vehicle!.id!;

                  // Filter out null values from selectedImages
                  List<XFile> nonNullImages =
                      selectedImages.whereType<XFile>().toList();

                  int uploadStatusCode = await vehicleProvider
                      .uploadVehiclePictures(currentvehicleID, nonNullImages);

                  // Optionally handle the upload status code
                  if (uploadStatusCode == 200) {
                    // Pictures uploaded successfully
                    showCustomSnackBar(
                        context,
                        "Vehicle details and pictures uploaded successfully!",
                        Colors.green);
                    Navigator.pop(context);
                  } else {
                    showCustomSnackBar(
                        context, 'Failed to upload pictures.', Colors.red);
                  }
                } else if (statusCode == 400) {
                  // Handle the error appropriately
                  showCustomSnackBar(context,
                      'This vehicle is already registered.', Colors.red);
                } else if (statusCode == 401) {
                  // Handle the error appropriately
                  showCustomSnackBar(
                      context,
                      'Token has expired close the app and open again.',
                      Colors.red);
                } else {
                  // Handle the error appropriately
                  showCustomSnackBar(
                      context, 'Failed to create vehicle.', Colors.red);
                }
              },
            ),
          ],
        );
      // You can add more case blocks for other steps here
      default:
        return Center(child: Text('Content for Step ${step + 1}'));
    }
  }

  void nextStep() {
    bool isValid = true;
    switch (_currentStep) {
      case 0:
        //isValid = vehicleLocationFormKey.currentState!.validate();
        break;
      case 1:
        //isValid = vinFormKey.currentState!.validate();
        break;
      case 2:
        //isValid = carDetailsFormKey.currentState!.validate();
        break;
      case 4:
        if (_pickedDatesController.text.isEmpty) {
          isValid = false;
          showCustomSnackBar(
              context, "Please select both start and end dates!", Colors.red);
        } else {
          // Only validate the form if the dates are provided
          isValid = priceAndAvailabiltyFormKey.currentState!.validate();
        }
        break;

      case 5:
        // Check if at least one image has been selected
        bool hasSelectedImage = selectedImages.any((image) => image != null);
        if (!hasSelectedImage) {
          isValid = false;
          showCustomSnackBar(
              context, "Upload at least one vehicle photo", Colors.red);
        }
        break;
      case 6:
        isValid = reasonAndDescriptionFormKey.currentState!.validate();
        break;
      case 7:
        if (isTermAndConditionAgreed == false) {
          isValid = false;
          showCustomSnackBar(context,
              "Please agree to safety and quality standards!", Colors.red);
        }
        break;
      default:
        break;
    }
    if (isValid && _currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  Widget _buildImageContainer(
      BuildContext context, XFile? imageFile, int index) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => pickImage(context, index),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDarkMode ? fdarkBlue : Colors.grey.shade200,
          border:
              Border.all(color: isDarkMode ? fdarkBlue : Colors.grey.shade200),
        ),
        child: imageFile == null
            ? Icon(Icons.add,
                color: isDarkMode ? Colors.white : Colors.grey.shade600)
            : CircleAvatar(
                backgroundImage: FileImage(File(imageFile.path)),
                radius: 50,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        title: Text(
          _stepNames[_currentStep],
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentStep -= 1; // Decrement the step
                  });
                },
              )
            : null, // If it's the first step, don't show back arrow
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stepper progress line
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(fMainColor),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_currentStep + 1} of $_totalSteps'),
                    InkWell(
                      onTap: () => _showStepNames(context),
                      child: const Text('View all steps',
                          style: TextStyle(
                              color: fMainColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Current step content
                _getStepContent(_currentStep),
            
                // const Spacer(),
                const SizedBox(
                  height: 20,
                ),
                // Navigation button (Next)
                if (_currentStep < _totalSteps - 1)
                  CustomGradientButton(
                    onPressed: () {
                      nextStep();
                    },
                    text: 'Next',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
