import 'package:ajar/common/text_form_fields/custom_text_form_field.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildDetailSection(String title, IconData icon, List<Widget> children) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, color: fMainColor),
      ),
      const SizedBox(height: 8),
      const Divider(
        height: 2,
      ),
      const SizedBox(height: 8),
      ...children,
      const SizedBox(height: 8),
      const Divider(
        height: 2,
      ),
      const SizedBox(height: 8),
    ],
  );
}

Widget buildDetailRow(IconData icon, String detail) {
  return Row(
    children: [
      Icon(icon, size: 18, color: fMainColor),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          detail,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    ],
  );
}

// Helper method to build each feature row
Widget buildFeatureRow(IconData icon, String title, bool isAvailable) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3.0),
    child: Row(
      children: [
        Icon(icon, size: 16, color: fMainColor), // Feature icon
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Text(
          isAvailable ? 'Yes' : 'No', // Availability status
          style: TextStyle(
            fontSize: 12,
            color: isAvailable ? Colors.green : Colors.red,
          ),
        ),
      ],
    ),
  );
}

void openYearSelectionDialog(
    BuildContext context, TextEditingController yearController) {
  List<String> years =
      List.generate(2030 - 1970 + 1, (index) => (1970 + index).toString());
  List<String> filteredYears = List.from(years); // Initialize with all years
  String? selectedYear;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      const Text(
                        "Year",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Placeholder for symmetry
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: yearController,
                        label: 'Search years',
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
                        onChanged: (text) {
                          setState(() {
                            selectedYear = text;
                            filteredYears = years
                                .where((year) => year.contains(text))
                                .toList();
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300,
                        child: RawScrollbar(
                          thumbColor: fMainColor,
                          thickness: 2.0,
                          thumbVisibility: true,
                          child: ListView.builder(
                            itemCount: filteredYears.isNotEmpty
                                ? filteredYears.length
                                : 1,
                            itemBuilder: (context, index) {
                              if (filteredYears.isEmpty) {
                                return ListTile(
                                  title: Text(
                                    'Not available "$selectedYear"',
                                    style: const TextStyle(color: fMainColor),
                                  ),
                                );
                              }
                              return RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                value: filteredYears[index],
                                groupValue: selectedYear,
                                onChanged: (value) {
                                  setState(() {
                                    selectedYear = value;
                                  });
                                  yearController.text = value!;
                                  Navigator.pop(context); // Close dialog
                                },
                                title: Text(filteredYears[index]),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

String? selectedMake;

List<String> brands = [
  'Abarth',
  'Acura',
  'Alfa Romeo',
  'Alpina',
  'Aston Martin',
  'Audi',
  'Austin',
  'Bentley',
  'BMW',
  'Bugatti',
  'Buick',
  'Byd',
  'Cadillac',
  'Changan',
  'Chery',
  'Chevrolet',
  'Chrysler',
  'Citroen',
  'Cupra',
  'Dacia',
  'Daewoo',
  'Dodge',
  'Ferrari',
  'Fiat',
  'Ford',
  'Geely',
  'Genesis',
  'GMC',
  'Great Wall',
  'Haval',
  'Honda',
  'Hyundai',
  'Infiniti',
  'Isuzu',
  'Jaguar',
  'Jeep',
  'Kia',
  'Lada',
  'Lamborghini',
  'Land Rover',
  'Lexus',
  'Lincoln',
  'Lotus',
  'Mahindra',
  'Maserati',
  'Maybach',
  'Mazda',
  'Mercedes',
  'MG',
  'Mini',
  'Mitsubishi',
  'Nissan',
  'Opel',
  'Peugeot',
  'Porsche',
  'Proton',
  'Ram',
  'Renault',
  'Rolls-Royce',
  'Rover',
  'Saab',
  'Skoda',
  'Smart',
  'Ssangyong',
  'Subaru',
  'Suzuki',
  'Tata',
  'Tesla',
  'Toyota',
  'Volkswagen',
  'Volvo',
  'Wey'
];

void openMakeSelectionDialog(
    BuildContext context, TextEditingController makeController) {
  List<String> filteredBrands =
      List.from(brands); // Initialize with all brands

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      const Text(
                        "Make",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Placeholder for symmetry
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: makeController,
                        label: 'Search brands or create new here..',
                        onChanged: (text) {
                          setState(() {
                            selectedMake = text;
                            filteredBrands = brands
                                .where((brand) => brand
                                    .toLowerCase()
                                    .contains(text.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300,
                        child: RawScrollbar(
                          thumbColor: fMainColor,
                          thickness: 2.0,
                          thumbVisibility: true,
                          child: ListView.builder(
                            itemCount: filteredBrands.isNotEmpty
                                ? filteredBrands.length
                                : 1,
                            itemBuilder: (context, index) {
                              if (filteredBrands.isEmpty) {
                                return ListTile(
                                  title: Text(
                                    'Create "$selectedMake"',
                                    style: const TextStyle(color: fMainColor),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedMake = selectedMake;
                                      makeController.text = selectedMake!;
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              }
                              return RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                value: filteredBrands[index],
                                groupValue: selectedMake,
                                // Inside your onChanged callback
                                onChanged: (value) async {
                                  setState(() {
                                    selectedMake = value;
                                  });
                                  // Update the text field immediately
                                  makeController.text = value!;
                                  Navigator.pop(context);
                                },
                                title: Text(filteredBrands[index]),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void openVehicleTypeSelectionDialog(
    BuildContext context, TextEditingController selectedVehicleType) {
  List<String> vehicleTypes = [
    'Cars',
    'SUVs',
    'Minivans',
    'Box Trucks',
    'Trucks',
    'Vans',
    'Cargo Vans'
  ];

  // Map your vehicle type names to their corresponding image paths
  Map<String, String> vehicleTypeImages = {
    'Cars': 'assets/vehicles/types/cars.png',
    'SUVs': 'assets/vehicles/types/suvs.png',
    'Minivans': 'assets/vehicles/types/minivans.png',
    'Box Trucks': 'assets/vehicles/types/box_trucks.png',
    'Trucks': 'assets/vehicles/types/trucks.png',
    'Vans': 'assets/vehicles/types/vans.png',
    'Cargo Vans': 'assets/vehicles/types/cargo_vans.png',
  };

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with back button and title
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      const Text(
                        "Type",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Placeholder for symmetry
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: vehicleTypes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      String vehicleType = vehicleTypes[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedVehicleType.text = vehicleType;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedVehicleType.text == vehicleType
                                  ? fMainColor
                                  : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                vehicleTypeImages[vehicleType]!,
                                height: 40,
                                width: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                vehicleType,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      selectedVehicleType.text == vehicleType
                                          ? fMainColor
                                          : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    },
  );
}

// void openMakeSelectionDialog(BuildContext context) {
//   List<String> _filteredBrands =
//       List.from(brands); // Initialize with all brands

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Consumer<VehicleProvider>(
//         builder: (context, vehicleProvider, child) {
//           return StatefulBuilder(
//             builder: (context, setState) {
//               return Dialog(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(5),
//                       decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(20),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.arrow_back),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                           const Spacer(),
//                           const Text(
//                             "Make",
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           const Spacer(),
//                           const SizedBox(
//                               width: 48), // Placeholder for symmetry
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 5.0),
//                       child: Column(
//                         children: [
//                           CustomTextFormField(
//                             controller: _makeController,
//                             label: 'Search brands or create new here..',
//                             onChanged: (text) {
//                               setState(() {
//                                 selectedMake = text;
//                                 _filteredBrands = brands
//                                     .where((brand) => brand
//                                         .toLowerCase()
//                                         .contains(text.toLowerCase()))
//                                     .toList();
//                               });
//                             },
//                           ),
//                           const SizedBox(height: 10),
//                           vehicleProvider.isModelsFetching
//                               ? const Center(
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                           "Retrieving models, please wait..."),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       CircularProgressIndicator(
//                                         color: fMainColor,
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               : SizedBox(
//                                   height: 300,
//                                   child: RawScrollbar(
//                                     thumbColor: fMainColor,
//                                     thickness: 2.0,
//                                     thumbVisibility: true,
//                                     child: ListView.builder(
//                                       itemCount: _filteredBrands.isNotEmpty
//                                           ? _filteredBrands.length
//                                           : 1,
//                                       itemBuilder: (context, index) {
//                                         if (_filteredBrands.isEmpty) {
//                                           return ListTile(
//                                             title: Text(
//                                               'Create "$selectedMake"',
//                                               style: const TextStyle(
//                                                   color: fMainColor),
//                                             ),
//                                             onTap: () {
//                                               setState(() {
//                                                 selectedMake = selectedMake;
//                                                 _makeController.text =
//                                                     selectedMake!;
//                                               });
//                                               Navigator.pop(context);
//                                             },
//                                           );
//                                         }
//                                         return RadioListTile<String>(
//                                           contentPadding: EdgeInsets.zero,
//                                           value: _filteredBrands[index],
//                                           groupValue: selectedMake,
//                                           // Inside your onChanged callback
//                                           onChanged: (value) async {
//                                             setState(() {
//                                               selectedMake = value;
//                                             });
//                                             // Update the text field immediately
//                                             _makeController.text = value!;
//                                             try {
//                                               await vehicleProvider
//                                                   .fetchCarModels(
//                                                       value); // Fetch models
//                                             } catch (error) {
//                                               print(
//                                                   "Error fetching car models: $error");
//                                               // Optionally, display an error message or dialog here
//                                             }
//                                             Navigator.pop(context);
//                                           },
//                                           title: Text(_filteredBrands[index]),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       );
//     },
//   );
// }

void openTransmissionTypeSelectionDialog(
    BuildContext context, TextEditingController selectedTransmissionType) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with back button and title
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      const Text(
                        "Transmission Type",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Placeholder for symmetry
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Manual'),
                        value: 'Manual',
                        groupValue: selectedTransmissionType.text,
                        onChanged: (value) {
                          setState(() {
                            selectedTransmissionType.text = value!;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Auto'),
                        value: 'Auto',
                        groupValue: selectedTransmissionType.text,
                        onChanged: (value) {
                          setState(() {
                            selectedTransmissionType.text = value!;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    },
  );
}

void openFuelTypeSelectionDialog(
    BuildContext context, TextEditingController selectedFuelType) {
  List<String> fuelTypes = [
    'Gasoline',
    'Diesel',
    'Electric',
    'Hybrid'
  ]; // Fuel types list

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with back button and title
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      const Text(
                        "Fuel Type",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Placeholder for symmetry
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20.0),
                  child: SizedBox(
                    height: 200, // Set a height limit for scrolling
                    child: RawScrollbar(
                      thumbColor: fMainColor,
                      thickness: 2.0,
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: fuelTypes.length,
                        itemBuilder: (context, index) {
                          return RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            title: Text(fuelTypes[index]),
                            value: fuelTypes[index],
                            groupValue: selectedFuelType.text,
                            onChanged: (value) {
                              setState(() {
                                selectedFuelType.text = value!;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    },
  );
}

void openEngineSizeSelectionDialog(
    BuildContext context, TextEditingController engineSizeController) {
  List<String> engineSizes = [
    '1.0L',
    '1.2L',
    '1.5L',
    '1.8L',
    '2.0L',
    '2.5L',
    '3.0L'
  ]; // Hardcoded engine sizes

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      const Text(
                        "Engine Size",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Placeholder for symmetry
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: RawScrollbar(
                          thumbColor: fMainColor,
                          thickness: 2.0,
                          thumbVisibility: true,
                          child: ListView.builder(
                            itemCount: engineSizes.length,
                            itemBuilder: (context, index) {
                              return RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                value: engineSizes[index],
                                groupValue: engineSizeController.text,
                                onChanged: (value) {
                                  // Update the text field immediately
                                  engineSizeController.text = value!;
                                  Navigator.pop(context);
                                },
                                title: Text(engineSizes[index]),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void openNumberOfSeatsSelectionDialog(
    BuildContext context, TextEditingController seatsController) {
  // Available seat numbers for vehicles
  List<int> seatOptions =
      List.generate(50, (index) => (index + 1) * 2); // [2, 4, 6, 8, ..., 20]

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      const Text(
                        "Number of Seats",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Placeholder for symmetry
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: RawScrollbar(
                          thumbColor: fMainColor,
                          thickness: 2.0,
                          thumbVisibility: true,
                          child: ListView.builder(
                            itemCount: seatOptions.length,
                            itemBuilder: (context, index) {
                              return RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                value: seatOptions[index].toString(),
                                groupValue: seatsController.text,
                                onChanged: (value) {
                                  // Update the text field immediately
                                  seatsController.text = value!;
                                  Navigator.pop(context);
                                },
                                title: Text('${seatOptions[index]}'),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void openColorSelectionDialog(
    BuildContext context, TextEditingController colorController) {
  // List of popular vehicle color names
  List<String> colorOptions = [
    'Black',
    'White',
    'Silver',
    'Gray',
    'Blue',
    'Red',
    'Green',
    'Yellow',
    'Orange',
    'Purple',
    'Brown',
    'Pink',
    'Beige',
    'Gold',
    'Turquoise',
    'Teal',
    'Maroon',
    'Cream',
    'Copper',
    'Charcoal'
  ];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      const Text(
                        "Select Color",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Placeholder for symmetry
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: RawScrollbar(
                          thumbColor: fMainColor,
                          thickness: 2.0,
                          thumbVisibility: true,
                          child: ListView.builder(
                            itemCount: colorOptions.length,
                            itemBuilder: (context, index) {
                              return RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                value: colorOptions[index],
                                groupValue: colorController.text,
                                onChanged: (value) {
                                  // Update the text field immediately
                                  colorController.text = value!;
                                  Navigator.pop(context);
                                },
                                title: Text(colorOptions[index]),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Map<String, List<String>> vehicleBrandsWithModels = {
  'Abarth': ['500', '595', '124 Spider'],
  'Acura': ['ILX', 'MDX', 'RDX', 'TLX', 'NSX'],
  'Alfa Romeo': ['Giulia', 'Stelvio', '4C', 'Spider'],
  'Aston Martin': ['DB11', 'Vantage', 'DBX', 'Rapide'],
  'Audi': ['A3', 'A4', 'A5', 'Q5', 'Q7', 'Q8', 'R8', 'TT'],
  'Austin': ['Mini', 'Montego', 'Metro'],
  'Bentley': ['Continental GT', 'Bentayga', 'Flying Spur', 'Mulsanne'],
  'BMW': ['3 Series', '5 Series', '7 Series', 'X5', 'X3', 'Z4', 'i8', 'i3'],
  'Bugatti': ['Chiron', 'Veyron', 'Divo'],
  'Buick': ['Enclave', 'Encore', 'LaCrosse', 'Regal'],
  'Byd': ['Tang', 'Song', 'Qin', 'Han'],
  'Cadillac': ['Escalade', 'ATS', 'CT6', 'XT5', 'XT4'],
  'Changan': ['Alsvin', 'Eado', 'CS75', 'CS55'],
  'Chery': ['Tiggo 8', 'Arrizo 5', 'QQ'],
  'Chevrolet': [
    'Camaro',
    'Silverado',
    'Tahoe',
    'Corvette',
    'Malibu',
    'Traverse'
  ],
  'Chrysler': ['300', 'Pacifica', 'Voyager', 'Aspen'],
  'Citroen': ['C3', 'C4', 'C5 Aircross', 'Berlingo'],
  'Cupra': ['Ateca', 'Formentor', 'Leon'],
  'Dacia': ['Duster', 'Logan', 'Sandero'],
  'Daewoo': ['Matiz', 'Nubira', 'Lanos', 'Leganza'],
  'Dodge': ['Challenger', 'Charger', 'Durango', 'Journey', 'Viper'],
  'Ferrari': ['488', 'Portofino', 'Roma', 'F8 Tributo', 'SF90'],
  'Fiat': ['500', 'Punto', 'Tipo', 'Panda'],
  'Ford': ['F-150', 'Mustang', 'Explorer', 'Escape', 'Edge', 'Fusion'],
  'Geely': ['Coolray', 'Azkarra', 'Tugella', 'Emgrand'],
  'Genesis': ['G70', 'G80', 'G90', 'GV80'],
  'GMC': ['Sierra', 'Yukon', 'Acadia', 'Terrain'],
  'Great Wall': ['Poer', 'Haval H6', 'Haval F7', 'Wingle'],
  'Haval': ['H2', 'H6', 'H9', 'F5', 'F7'],
  'Honda': ['Civic', 'Accord', 'CR-V', 'Pilot', 'Fit', 'Odyssey'],
  'Hyundai': ['Elantra', 'Santa Fe', 'Tucson', 'Sonata', 'Kona', 'Palisade'],
  'Infiniti': ['Q50', 'Q60', 'QX50', 'QX80'],
  'Isuzu': ['D-Max', 'MU-X', 'Trooper', 'Rodeo'],
  'Jaguar': ['F-Pace', 'XE', 'XF', 'XJ', 'E-Pace', 'F-Type'],
  'Jeep': ['Wrangler', 'Grand Cherokee', 'Compass', 'Cherokee', 'Renegade'],
  'Kia': ['Sorento', 'Sportage', 'Telluride', 'Seltos', 'Optima', 'Carnival'],
  'Lada': ['Niva', 'Vesta', 'Granta', 'XRAY'],
  'Lamborghini': ['Huracan', 'Aventador', 'Urus', 'Gallardo'],
  'Land Rover': ['Range Rover', 'Defender', 'Discovery', 'Evoque'],
  'Lexus': ['RX', 'ES', 'GX', 'LX', 'NX', 'IS'],
  'Lincoln': ['Navigator', 'Aviator', 'Corsair', 'Continental'],
  'Lotus': ['Evora', 'Exige', 'Elise', 'Emira'],
  'Mahindra': ['Scorpio', 'XUV500', 'Bolero', 'Thar'],
  'Maserati': ['Ghibli', 'Levante', 'Quattroporte', 'GranTurismo'],
  'Maybach': ['S560', 'S650', 'GLS600'],
  'Mazda': ['Mazda3', 'CX-5', 'MX-5 Miata', 'Mazda6', 'CX-9'],
  'Mercedes': ['C-Class', 'E-Class', 'S-Class', 'GLE', 'GLS', 'A-Class'],
  'MG': ['ZS', 'HS', 'MG5', 'MG6', 'Gloster'],
  'Mini': ['Cooper', 'Countryman', 'Clubman', 'Paceman'],
  'Mitsubishi': ['Lancer', 'Outlander', 'Pajero', 'Eclipse Cross'],
  'Nissan': ['Altima', 'Rogue', 'GT-R', '370Z', 'Maxima', 'Pathfinder'],
  'Opel': ['Astra', 'Corsa', 'Insignia', 'Mokka'],
  'Peugeot': ['208', '3008', '5008', '508'],
  'Porsche': ['911', 'Cayenne', 'Macan', 'Taycan', 'Panamera'],
  'Proton': ['Saga', 'Persona', 'X70', 'X50'],
  'Ram': ['1500', '2500', '3500'],
  'Renault': ['Clio', 'Megane', 'Captur', 'Koleos', 'Duster'],
  'Rolls-Royce': ['Phantom', 'Ghost', 'Cullinan', 'Wraith'],
  'Rover': ['75', '45', 'Streetwise'],
  'Saab': ['9-3', '9-5', '900'],
  'Skoda': ['Octavia', 'Superb', 'Kodiaq', 'Kamiq', 'Karoq'],
  'Smart': ['Fortwo', 'Forfour'],
  'Ssangyong': ['Rexton', 'Tivoli', 'Korando', 'Musso'],
  'Subaru': ['Impreza', 'Outback', 'Forester', 'Legacy', 'Crosstrek'],
  'Suzuki': ['Swift', 'Vitara', 'Jimny', 'Alto', 'Celerio'],
  'Tata': ['Nexon', 'Harrier', 'Safari', 'Tiago'],
  'Tesla': ['Model S', 'Model 3', 'Model X', 'Model Y'],
  'Toyota': ['Corolla', 'Camry', 'RAV4', 'Highlander', '4Runner', 'Prius'],
  'Volkswagen': ['Golf', 'Passat', 'Tiguan', 'Polo', 'Jetta'],
  'Volvo': ['XC40', 'XC60', 'XC90', 'S60', 'S90', 'V60'],
  'Wey': ['VV7', 'VV6', 'VV5'],
};

String? selectedModel;

void openModelSelectionDialog(BuildContext context,
    TextEditingController modelController, String selectedMake) {
  List<String> filteredModels = vehicleBrandsWithModels[selectedMake] ??
      []; // Get models based on the selected make

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      const Text(
                        "Model",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Placeholder for symmetry
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: modelController,
                        label: 'Search models or create new here..',
                        onChanged: (text) {
                          setState(() {
                            selectedModel = text;
                            filteredModels =
                                (vehicleBrandsWithModels[selectedMake] ?? [])
                                    .where((model) => model
                                        .toLowerCase()
                                        .contains(text.toLowerCase()))
                                    .toList();
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300,
                        child: RawScrollbar(
                          thumbColor: fMainColor,
                          thickness: 2.0,
                          thumbVisibility: true,
                          child: ListView.builder(
                            itemCount: filteredModels.isNotEmpty
                                ? filteredModels.length
                                : 1,
                            itemBuilder: (context, index) {
                              if (filteredModels.isEmpty) {
                                return ListTile(
                                  title: Text(
                                    'Create "$selectedModel"',
                                    style: const TextStyle(color: fMainColor),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedModel = selectedModel;
                                      modelController.text = selectedModel!;
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              }
                              return RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                value: filteredModels[index],
                                groupValue: selectedModel,
                                onChanged: (value) async {
                                  setState(() {
                                    selectedModel = value;
                                  });
                                  modelController.text = value!;
                                  Navigator.pop(context);
                                },
                                title: Text(filteredModels[index]),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
