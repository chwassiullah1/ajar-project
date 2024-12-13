// ignore_for_file: use_build_context_synchronousl

import 'package:ajar/common/buttons/custom_gradient_button.dart';
import 'package:ajar/common/buttons/icon_gradient_button.dart';
import 'package:ajar/common/snakbar/custom_snakbar.dart';
import 'package:ajar/common/text_form_fields/custom_text_form_field.dart';
import 'package:ajar/models/booking/renter_address.dart';
import 'package:ajar/models/vehicle/vehicle_model.dart';
import 'package:ajar/providers/authentication/authentication_provider.dart';
import 'package:ajar/providers/booking/booking_provider.dart';
import 'package:ajar/utils/calculation.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:ajar/utils/date_and_time_formatting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingCustomStepper extends StatefulWidget {
  final Vehicle vehicle;
  const BookingCustomStepper({super.key, required this.vehicle});

  @override
  State<BookingCustomStepper> createState() => _BookingCustomStepperState();
}

class _BookingCustomStepperState extends State<BookingCustomStepper> {
  DateTimeRange? _selectedDateRange;
  final TextEditingController _pickedDatesController = TextEditingController();
  final TextEditingController _pickedDeliveryAddress = TextEditingController();
  final TextEditingController _countryAdressController =
      TextEditingController();
  final TextEditingController _cityAddressController = TextEditingController();
  final TextEditingController _stateAddressController = TextEditingController();
  final TextEditingController _postalCodeAddressController =
      TextEditingController();
  final TextEditingController _streetNoAddressController =
      TextEditingController();

  String selectedPaymentMethod = 'Cash on Delivery'; // Default value
  //bool _useDefaultAddress = true; // Default is using the default address
  int _currentStep = 0;
  final int _totalSteps = 7;

  // Progress for the Linear Progress Indicator
  double get _progress => (_currentStep + 1) / _totalSteps;

  // Step names for the popup modal
  final List<String> _stepNames = [
    'Trip Dates And Time',
    'Driver Availaibility',
    'Delivery Facility',
    'Booking Details',
    'Payout',
    'Confirmation',
    'Review'
  ];

  String? selectedDriverOption; // Default value
  String? selectedDeliveryOption; // Default value
  String? selectedAddressOption; // Default value

  bool _withDriver = false;
  bool _withDelivery = false;
  bool _useDefaultAddress = true;

  final List<String> driverOptions = [
    "With Driver",
    "Without Driver",
  ];

  final List<String> deliveryOptions = [
    "With Delivery",
    "Without Delivery",
  ];

  final List<String> addressOptions = [
    "Your Default Location Address",
    "New Address Location",
  ];

  final GlobalKey<FormState> newAddressFormKey = GlobalKey<FormState>();

  final double latitude = 31.5204;
  final double longitude = 74.3587;
  double totalDistance = 10.0;

  String startDate = "";
  String endDate = "";

  //final TextEditingController _pickedTimeController = TextEditingController();

  // TimeOfDay? _startTime;
  // TimeOfDay? _endTime;
  DateTime today = DateTime.now();

  // // Function to pick the time range (start time and end time)
  // Future<void> _pickTimeRange(
  //   Vehicle vehicle,
  // ) async {
  //   if (_selectedDateRange == null) {
  //     // Ensure dates are picked first
  //     return;
  //   }

  //   // Pick start time
  //   final TimeOfDay? pickedStartTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.fromDateTime(DateTime.parse(vehicle.startDate)),
  //   );

  //   if (pickedStartTime != null) {
  //     // Pick end time
  //     final TimeOfDay? pickedEndTime = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.fromDateTime(DateTime.parse(vehicle.startDate)),
  //     );

  //     if (pickedEndTime != null) {
  //       setState(() {
  //         _startTime = pickedStartTime;
  //         _endTime = pickedEndTime;

  //         // Combine selected start date and start time
  //         DateTime startDateTime =
  //             combineDateAndTime(_selectedDateRange!.start, _startTime!);
  //         DateTime endDateTime =
  //             combineDateAndTime(_selectedDateRange!.end, _endTime!);

  //         // Format both start and end DateTime to ISO format
  //         formattedStartDateTime = formatDateTimeToISO(startDateTime);
  //         formattedEndDateTime = formatDateTimeToISO(endDateTime);

  //         // Update the controller to show formatted time range
  //         _pickedTimeController.text =
  //             formatTimeRange(context, _startTime, _endTime);

  //         print(formattedStartDateTime);
  //         print(formattedEndDateTime);
  //       });
  //     }
  //   }
  // }

  String formatDateRangeInFile(DateTimeRange dateRange) {
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    startDate = dateFormatter.format(dateRange.start);
    endDate = dateFormatter.format(dateRange.end);
    print("$startDate $endDate");
    return '$startDate / $endDate';
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
  Widget _getStepContent(int step, Vehicle vehicle,
      AuthenticationProvider authProvider, BookingProvider bookingProvider) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    switch (step) {
      case 0:
        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Trip Dates And Time',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: fMainColor),
              ),
              const SizedBox(height: 10),
              const Text(
                'You have to select the trip dates and time in which you need this vehicle.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () async {
                        // Determine the first date to use in the date range picker
                        DateTime firstDate =
                            DateTime.parse(vehicle.startDate).isBefore(today)
                                ? today
                                : DateTime.parse(vehicle.startDate);
                        // Open the date range picker
                        DateTimeRange? picked = await showDateRangePicker(
                          context: context,
                          firstDate: firstDate,
                          lastDate: DateTime.parse(vehicle.endDate),
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
                      child: CustomTextFormField(
                        isEditable: false,
                        label: 'Add Dates',
                        controller: _pickedDatesController,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomGradientButton(
                      onPressed: () async {
                        // Determine the first date to use in the date range picker
                        DateTime firstDate =
                            DateTime.parse(vehicle.startDate).isBefore(today)
                                ? today
                                : DateTime.parse(vehicle.startDate);
                        // Open the date range picker
                        DateTimeRange? picked = await showDateRangePicker(
                          context: context,
                          firstDate: firstDate,
                          lastDate: DateTime.parse(vehicle.endDate),
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
            ],
          ),
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Driver Availability',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: fMainColor),
            ),
            if (vehicle.driverAvailability == "Without Driver") ...[
              const SizedBox(height: 10),
              const Text(
                  "This vehicle does not come with the driver pickup facility. You can get the vehicle without the driver."),
            ] else if (vehicle.driverAvailability == "Only with driver") ...[
              const SizedBox(height: 10),
              const Text(
                  "This vehicle only comes with driver. You can get the vehicle with the driver only."),
              const SizedBox(height: 10),
              Text(
                "Driver cost is \$${vehicle.driverPrice}/per day.",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: fMainColor),
              ),
            ] else ...[
              const SizedBox(
                height: 10,
              ),
              const Text(
                  "This vehicle comes with 2 options. You can get the vehicle with driver or without driver."),
              const SizedBox(height: 10),
              Text(
                "Driver cost is \$${vehicle.driverPrice}/per day.",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: fMainColor),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: isDarkMode ? fdarkBlue : Colors.grey.shade200,
                ),
                hint: Text(
                  'Select Driver Availability',
                  style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white : Colors.grey.shade500),
                ),
                value: selectedDriverOption,
                items: driverOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDriverOption = newValue; // Update selected option

                    // Set _withDriver based on the selected option
                    if (newValue == "With Driver") {
                      _withDriver = true;
                    } else if (newValue == "Without Driver") {
                      _withDriver = false;
                    }
                  });
                },
              ),
            ],
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Delivery Facility",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: fMainColor),
            ),
            if (vehicle.deliveryAvailable == false) ...[
              const SizedBox(height: 10),
              const Text(
                  "This vehicle does not come with delivery facility. You can get the vehicle without delivery."),
            ] else ...[
              const SizedBox(height: 10),
              const Text(
                  "This vehicle comes with delivery facility. You can get the vehicle with delivery or with out delivery at your particular address."),
              const SizedBox(height: 10),
              Text(
                "Delivery cost is \$${vehicle.deliveryPrice}/per km",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: fMainColor),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: isDarkMode ? fdarkBlue : Colors.grey.shade200,
                ),
                hint: Text(
                  'Select Delivery Options',
                  style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.grey.shade500),
                ),
                value: selectedDeliveryOption,
                items: deliveryOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDeliveryOption = newValue; // Update selected option
                    // Update _withDelivery based on the selected option
                    _withDelivery = newValue == "With Delivery";
                  });
                },
              ),

              // Show TextFormField if _withDelivery is true
              if (_withDelivery) ...[
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDarkMode ? fdarkBlue : Colors.grey.shade200,
                  ),
                  hint: Text(
                    'Select Address Options',
                    style: TextStyle(
                        fontSize: 14,
                        color:
                            isDarkMode ? Colors.white : Colors.grey.shade500),
                  ),
                  value: selectedAddressOption,
                  items: addressOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.white : Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAddressOption =
                          newValue; // Update selected option
                      // Update _withDelivery based on the selected option
                      _useDefaultAddress =
                          newValue == "Your Default Location Address";
                    });
                  },
                ),

                if (_useDefaultAddress == true) ...[
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Your Default Address",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: fMainColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(IconlyLight.location),
                    title: Text(
                      "Your Current Location",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Fill Your Delivery Address Details",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: fMainColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                      key: newAddressFormKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Search bar container
                              Expanded(
                                child: CustomTextFormField(
                                  label: 'Your Full Address',
                                  controller: _pickedDeliveryAddress,
                                  isEditable: false,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ), // Add spacing between search bar and filter icon
                              IconGradientButton(
                                height: 50,
                                width: 50,
                                icon: IconlyLight.location,
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextFormField(
                            controller: _countryAdressController,
                            label: "Country",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter\nyour country';
                              } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                  .hasMatch(value)) {
                                return 'Country must be a\nstring of characters';
                              }
                              return null;
                            },
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _stateAddressController,
                                  label: "State",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter\nyour state';
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
                                  controller: _cityAddressController,
                                  label: "City",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter\nyour country';
                                    } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                        .hasMatch(value)) {
                                      return 'City must be a\nstring of characters';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  label: 'Street No',
                                  controller: _streetNoAddressController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your\nstreet no';
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
                                label: 'Postal Code',
                                controller: _postalCodeAddressController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your\n postal code';
                                  } else if (!RegExp(r'^\d+$')
                                      .hasMatch(value)) {
                                    return 'Postal Code must\nbe numbers only';
                                  }
                                  return null;
                                },
                              )),
                            ],
                          ),
                        ],
                      )),
                ],

                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Vehicle Address and Cost",
                  style: TextStyle(
                    color: fMainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(IconlyLight.location),
                  title: Text(
                    vehicle.fullAddress,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),

                const Text(
                  "Distance and Delivery Pricing",
                  style: TextStyle(
                    color: fMainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.timeline_sharp),
                  title: Text(
                    "${totalDistance.toInt().toString()} Km",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  subtitle: const Text(
                    "Total Distance Between Your Address and Vehicle",
                    style: TextStyle(fontSize: 12),
                  ),
                ),

                // if (_totalDistance != null && _deliveryCost != null) ...[
                //   const SizedBox(height: 10),
                //   Text("Total Distance: $_totalDistance km"),
                //   Text("Total Delivery Price: \$_deliveryCost"),
                // ],

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.money),
                  title: Text(
                    "${calculateTotalDeliveryCost(
                      double.parse(
                        vehicle.deliveryPrice.toString(),
                      ),
                      totalDistance,
                    ).toInt().toString()}\$",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  subtitle: Text(
                    "Total Chargers For Delivery (${totalDistance.toInt().toString()}Km X ${vehicle.deliveryPrice}\$ Per/Km)",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ],
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Please review your order details before submitting.",
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Total Number of Days And Time",
              style: TextStyle(
                fontSize: 14,
                color: fMainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(IconlyLight.calendar),
              title: Text("${calculateTotalDays(startDate, endDate)} Days"),
            ),
            const Text(
              "Vehicle and Price",
              style: TextStyle(
                fontSize: 14,
                color: fMainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(IconlyLight.bookmark),
              title: Text("${vehicle.make} ${vehicle.model} ${vehicle.year}"),
              subtitle: Text("${vehicle.price}\$ Per/day"),
            ),
            const Text(
              "Driver Availibility and Charges",
              style: TextStyle(
                fontSize: 14,
                color: fMainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(IconlyLight.profile),
              title: Text(_withDriver == true ? "Yes" : "Not Available"),
              subtitle: _withDriver
                  ? Text(_withDriver == true
                      ? "Driver Cost ${vehicle.driverPrice}\$"
                      : "")
                  : null,
            ),
            const Text(
              "Delivery Availability and Charges",
              style: TextStyle(
                fontSize: 14,
                color: fMainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(IconlyLight.activity),
              title: Text(_withDelivery == true ? "Yes" : "Not Available"),
              subtitle: _withDelivery == true
                  ? Text(
                      _withDelivery == true
                          ? "${totalDistance.toInt().toString()}Km X ${vehicle.deliveryPrice}\$ Per/Km"
                          : "",
                      style: const TextStyle(fontSize: 12),
                    )
                  : null,
              trailing: _withDelivery == true
                  ? Text(
                      "${calculateTotalDeliveryCost(
                        double.parse(
                          vehicle.deliveryPrice.toString(),
                        ),
                        totalDistance,
                      ).toInt().toString()}\$",
                      style: const TextStyle(fontSize: 18),
                    )
                  : null,
            ),
            const Text(
              "Total Bill",
              style: TextStyle(
                fontSize: 14,
                color: fMainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(IconlyLight.chart),
              title: const Text("Calculations"),
              subtitle: Text(
                "${vehicle.price}\$ x ${calculateTotalDays(startDate, endDate)} Days "
                "${_withDriver ? "+ ${vehicle.driverPrice}\$ X ${calculateTotalDays(startDate, endDate)} Days" : ""}"
                "${_withDelivery ? "+ ${calculateTotalDeliveryCost(double.parse(vehicle.deliveryPrice.toString()), totalDistance).toInt()}\$" : ""}",
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Text(
                "${calculateTotalPrice(double.parse(vehicle.price), calculateTotalDays(startDate, endDate), driverCostPerDay: _withDriver ? (double.parse(vehicle.driverPrice)) : 0.0, deliveryCost: _withDelivery ? calculateTotalDeliveryCost(double.parse(vehicle.deliveryPrice.toString()), totalDistance) : 0.0)}\$",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Check out",
              style: TextStyle(
                fontSize: 14,
                color: fMainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Select your preferred payment method for renting a vehicle.",
            ),
            const SizedBox(
              height: 10,
            ),

            // Cash on Delivery option
            RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.trailing,
              value: 'Cash on Delivery',
              groupValue: selectedPaymentMethod,
              title: const Text('Cash on Delivery'),
              secondary: const Icon(Icons.attach_money_outlined),
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
            // Credit or Debit card option
            RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.trailing,
              value: 'Credit Card',
              groupValue: selectedPaymentMethod,
              title: const Text('Credit or Debit'),
              subtitle: const Text('Prepaid cards not accepted'),
              secondary: const Icon(Icons.credit_card_sharp),
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
          ],
        );

      case 5:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Booking Confirmation",
            style: TextStyle(
              fontSize: 14,
              color: fMainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Please review your forms details correctly before before submitting.",
          ),
          const SizedBox(
            height: 20,
          ),
          CustomGradientButton(
            text: "Submit",
            isLoading: bookingProvider.isLoading,
            onPressed: () async {
              int statusCode = await bookingProvider.createBooking(
                vehicleId: vehicle.id!,
                startDate: startDate,
                endDate: endDate,
                withDriver: _withDriver,
                withDelivery: _withDelivery,
                distanceForDelivery: _withDelivery == true ? 10 : 1,
                renterAddress: _useDefaultAddress == true
                    ? RenterAddress(
                        streetNo: authProvider.user!.address!.streetNo,
                        city: authProvider.user!.address!.city,
                        state: authProvider.user!.address!.state,
                        postalCode: authProvider.user!.address!.postalCode,
                        country: authProvider.user!.address!.country,
                      )
                    : RenterAddress(
                        streetNo: int.parse(_streetNoAddressController.text),
                        city: _cityAddressController.text,
                        state: _stateAddressController.text,
                        country: _countryAdressController.text,
                        postalCode: _postalCodeAddressController.text,
                      ),
              );

              if (statusCode == 200) {
                // Navigate to the next screen if booking is successful
                showCustomSnackBar(
                    context, "Data sent to backend!", Colors.green);
                setState(() {
                  _currentStep += 1;
                });
              } else {
                // Show error message
                showCustomSnackBar(
                    context, bookingProvider.errorMessage, Colors.red);
              }
            },
          ),
        ]);

      case 6:
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Your Booking Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (bookingProvider.booking == null) ...[
                const SizedBox(height: 10),
                const Text(
                  "No booking found!",
                  style: TextStyle(color: Colors.red),
                ),
              ] else ...[
                // Text('Booking ID: ${bookingProvider.booking!.id}',
                //     style: const TextStyle(
                //         fontSize: 16, fontWeight: FontWeight.bold)),
                // const SizedBox(height: 10),
                // Text('Vehicle ID: ${bookingProvider.booking!.vehicleId}'),
                // Text('Renter ID: ${bookingProvider.booking!.renterId}'),
                // Text('Host ID: ${bookingProvider.booking!.hostId}'),
                Text(
                    'Start Date: ${formatDate(bookingProvider.booking!.startDate.toString())}'),
                Text(
                    'End Date: ${formatDate(bookingProvider.booking!.endDate.toString())}'),
                const SizedBox(height: 20),
                const Text('Invoice Details',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                    'Vehicle Cost: \$${bookingProvider.booking!.invoice.invoice.vehicle.total} - (${bookingProvider.booking!.invoice.invoice.vehicle.calculation})'),
                Text(
                    'Driver Cost: \$${bookingProvider.booking!.invoice.invoice.driver.total} - (${bookingProvider.booking!.invoice.invoice.driver.calculation})'),
                Text(
                    'Delivery Cost: \$${bookingProvider.booking!.invoice.invoice.delivery.total} (${bookingProvider.booking!.invoice.invoice.delivery.calculation})'),
                Text(
                    'Total Cost: \$${bookingProvider.booking!.invoice.invoice.totalCost}'),
                const SizedBox(height: 20),
                const Text('Renter Address',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                    'Street No: ${bookingProvider.booking!.renterAddress.streetNo}'),
                Text('City: ${bookingProvider.booking!.renterAddress.city}'),
                Text('State: ${bookingProvider.booking!.renterAddress.state}'),
                Text(
                    'Postal Code: ${bookingProvider.booking!.renterAddress.postalCode}'),
                Text(
                    'Country: ${bookingProvider.booking!.renterAddress.country}'),
                const SizedBox(height: 20),
                Text(
                    'With Driver: ${bookingProvider.booking!.withDriver ? 'Yes' : 'No'}'),
                Text(
                    'With Delivery: ${bookingProvider.booking!.withDelivery ? 'Yes' : 'No'}'),
                const SizedBox(
                  height: 20,
                ),
                CustomGradientButton(
                    text: "Done",
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]
            ],
          ),
        );
      // You can add more case blocks for other steps here
      default:
        return Center(child: Text('Content for Step ${step + 1}'));
    }
  }

  void nextStep(Vehicle vehicle) {
    bool isValid = true;
    switch (_currentStep) {
      case 0:
        if (_pickedDatesController.text.isEmpty) {
          isValid = false;
          showCustomSnackBar(
              context, "Please select both start and end dates!", Colors.red);
        }
        break;
      case 1:
        if (vehicle.driverAvailability != "Without Driver" &&
            vehicle.driverAvailability != "Only with driver" &&
            selectedDriverOption == null) {
          isValid = false;
          showCustomSnackBar(
            context,
            "Please choose an option from the Driver Availability!",
            Colors.red,
          );
        }
        break;
      case 2:
        // Step 1: Check if delivery is available
        if (vehicle.deliveryAvailable == true) {
          // Step 2: Validate delivery option selection
          if (selectedDeliveryOption == null) {
            isValid = false;
            showCustomSnackBar(
              context,
              "Please choose an option from the Delivery Availability!",
              Colors.red,
            );
          } else if (selectedDeliveryOption == "With Delivery") {
            // Step 3: Validate address option if 'With Delivery' is selected
            if (selectedAddressOption == null) {
              isValid = false;
              showCustomSnackBar(
                context,
                "Please choose an address option for delivery!",
                Colors.red,
              );
            } else if (selectedAddressOption == "New Address Location") {
              // Step 4: Validate the new address form if 'New Address' is selected
              isValid = newAddressFormKey.currentState!.validate();
              if (!isValid) {
                showCustomSnackBar(
                  context,
                  "Please fill in all the required address fields correctly!",
                  Colors.red,
                );
              }
            }
          }
        }
        break;
      case 3:
        isValid = true;
        break;
      case 4:
        isValid = true;
      case 5:
        isValid = true;
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

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: true);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
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
                _getStepContent(_currentStep, widget.vehicle, authProvider,
                    bookingProvider),
            
                // const Spacer(),
                const SizedBox(
                  height: 20,
                ),
                // Navigation button (Next)
                if (_currentStep < _totalSteps - 1 && _currentStep != 5)
                  CustomGradientButton(
                    onPressed: () {
                      nextStep(widget.vehicle);
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
