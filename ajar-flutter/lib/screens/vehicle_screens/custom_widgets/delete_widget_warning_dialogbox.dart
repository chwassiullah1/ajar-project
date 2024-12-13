// ignore_for_file: use_build_context_synchronously

import 'package:ajar/common/snakbar/custom_snakbar.dart';
import 'package:ajar/providers/vehicles/vehicle_provider.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showDeleteConfirmationDialog(BuildContext context, String vehicleId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final vehicleProvider = Provider.of<VehicleProvider>(context);
      return AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
            'Are you sure you want to delete this vehicle? This action cannot be undone.'),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: fMainColor),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.red),
            onPressed: () async {
              if (!vehicleProvider.isDeleteVehicleLoading) {
                final statusCode =
                    await vehicleProvider.deleteVehicle(vehicleId);

                Navigator.of(context).pop(); // Close the dialog

                if (statusCode == 200) {
                  showCustomSnackBar(
                      context, "Vehicle deleted successfully!", Colors.green);
                  Navigator.pop(context);
                } else {
                  showCustomSnackBar(
                    context,
                    "Failed to delete vehicle. Please try again.",
                    Colors.red,
                  );
                }
              }
            },
            child: vehicleProvider.isDeleteVehicleLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.red,
                      strokeWidth: 2.0,
                    ),
                  )
                : const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
