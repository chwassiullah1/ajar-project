// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:ajar/common/snakbar/custom_snakbar.dart';
import 'package:ajar/models/vehicle/favoriteVehicle/favorite_vehicle.dart';
import 'package:ajar/models/vehicle/vehicle_model.dart';
import 'package:ajar/providers/vehicles/car_models.dart';
import 'package:ajar/services/vehicle_service/get_vehicle_models_service.dart';
import 'package:ajar/services/vehicle_service/vehicle_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class VehicleProvider with ChangeNotifier {
  final VehicleService _vehicleService =
      VehicleService(); // Instance of VehicleService

  final List<Vehicle> _allVehicles = [];

  List<Vehicle> get allVehicles => _allVehicles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingWithoutFilter = false;
  bool get isLoadingWithoutFilter => _isLoadingWithoutFilter;

  bool _isLoadingWithFilter = false;
  bool get isLoadingWithFilter => _isLoadingWithFilter;

  Vehicle? _vehicle; // Private variable to hold vehicle data
  Vehicle? get vehicle => _vehicle; // Getter for vehicle data

  bool _hasMoreDataWithoutFilter = true; // To track if more data is available
  bool get hasMoreDataWithoutFilter => _hasMoreDataWithoutFilter;

  bool _hasMoreDataWithFilter = true; // To track if more data is available
  bool get hasMoreDataWithFilter => _hasMoreDataWithFilter;

  final int _totalCount = 0;
  String? _nextPageUrl;
  int get totalCount => _totalCount;
  String? get nextPageUrl => _nextPageUrl;
  int page = 1;

  final List<Vehicle> _allSeachedVehicles = [];

  List<Vehicle> get allSeachedVehicles => _allSeachedVehicles;

  int searchedPage = 1;

  // Method to create a vehicle and handle response
  Future<int> createVehicle(Vehicle vehicleData) async {
    try {
      _isLoading = true;
      notifyListeners(); // Notify UI that loading has started
      // Call the service to create the vehicle
      http.Response response = await _vehicleService.createVehicle(vehicleData);

      if (response.statusCode == 200) {
        // On success, convert response to Vehicle model
        _vehicle = Vehicle.fromJsonNewCreateVehicle(
            jsonDecode(response.body)["data"][0]);
        // No need to reset _isLoading to false here, let it be handled in finally block
      } else {
        print(
            'Error: Failed to create vehicle. Status Code: ${response.statusCode}');
      }
      return response.statusCode;
    } catch (error) {
      print('Exception: $error');
      return 500; // Return 500 or a custom error code in case of exceptions
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI that loading has stopped
    }
  }

  // Method to upload vehicle pictures
  Future<int> uploadVehiclePictures(
      String vehicleId, List<XFile> images) async {
    try {
      _isLoading = true;
      notifyListeners(); // Notify UI that loading has started

      // Call the service to upload pictures
      http.Response response =
          await _vehicleService.uploadVehiclePictures(vehicleId, images);

      if (response.statusCode == 200) {
        // On success, convert response to Vehicle model (assuming the structure contains the data)
        _vehicle = Vehicle.fromJsonNewCreateVehicle(
            jsonDecode(response.body)['data']['data']
                [0]); // Adjust as per your response structure
      } else {
        print(
            'Error: Failed to upload vehicle pictures. Status Code: ${response.statusCode}');
      }

      return response.statusCode;
    } catch (error) {
      print('Exception: $error');
      return 500; // Return 500 or a custom error code in case of exceptions
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI that loading has stopped
    }
  }

  Future<void> getVehicleItemsWithoutFilter() async {
    if (_hasMoreDataWithoutFilter && !_isLoadingWithoutFilter) {
      // Only fetch if there's more data and not loading
      _isLoadingWithoutFilter = true;
      notifyListeners();

      try {
        // Fetching Data from Network
        final response = await _vehicleService.fetchVehicles(page: page);

        // If vehicles are returned, add them to the list
        if (response.vehicles!.isNotEmpty) {
          _allVehicles.addAll(response.vehicles!);
          page++;
        }

        // Check if there are more pages (nextPageUrl is not null)
        if (response.nextPageUrl == null) {
          _hasMoreDataWithoutFilter = false; // No more vehicles to fetch
        }
      } catch (e) {
        print('Error fetching vehicles without filters: $e');
      } finally {
        _isLoadingWithoutFilter = false;
        notifyListeners();
      }
    }
  }

  Future<void> getVehicleItemsWithFilter({
    int? limit,
    String? make,
    String? price,
    String? vehicleId,
    String? hostId,
    String? startDate,
    String? endDate,
    int? page,
    String? city,
    String? vehicleType,
    int? year,
    int? seats,
    String? fuelType,
  }) async {
    if (_hasMoreDataWithFilter && !_isLoadingWithFilter) {
      // Only fetch if there's more data and not loading
      _isLoadingWithFilter = true;
      notifyListeners();

      try {
        // Fetching Data from Network
        final response = await _vehicleService.fetchVehicles(
          limit: limit,
          make: make,
          price: price,
          vehicleId: vehicleId,
          hostId: hostId,
          startDate: startDate,
          endDate: endDate,
          page: searchedPage,
          city: city,
          vehicleType: vehicleType,
          year: year,
          seats: seats,
          fuelType: fuelType,
        );

        // If vehicles are returned, add them to the list
        if (response.vehicles!.isNotEmpty) {
          _allSeachedVehicles.addAll(response.vehicles!);
          searchedPage++;
        }

        // Check if there are more pages (nextPageUrl is not null)
        if (response.nextPageUrl == null) {
          _hasMoreDataWithFilter = false; // No more vehicles to fetch
        }
      } catch (e) {
        print('Error fetching vehicles with filters: $e');
      } finally {
        _isLoadingWithFilter = false;
        notifyListeners();
      }
    }
  }

  void clearFiltersData() {
    _allSeachedVehicles.clear();
    searchedPage = 1;
    _hasMoreDataWithFilter = true;
  }

  Future<void> addVehicleToFavorites(
      BuildContext context, String vehicleId) async {
    final response = await _vehicleService.addFavoriteVehicle(vehicleId);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _favorites!.add(FavoriteVehicle.fromJsonAddToFavorite(data['data'][0]));
      notifyListeners();
      showCustomSnackBar(context, "Vehicle added to favorites", Colors.green);
      // Optionally, show a success message
    } else if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body);

      showCustomSnackBar(context, errorData['message'].toString(), Colors.red);
    } else {
      showCustomSnackBar(context, "An unexpected error occurred", Colors.red);
    }
  }

  Future<void> removeFavoriteVehicle(
      String favoriteVehicleId, BuildContext context) async {
    final response = await _vehicleService
        .deleteFavoriteVehicle(favoriteVehicleId); // Pass the ID

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        // Remove the vehicle from the local favorites list
        _favorites!.removeWhere((fav) =>
            fav.id ==
            favoriteVehicleId); // Adjust based on your FavoriteVehicle model
        notifyListeners();
        showCustomSnackBar(
            context, "Vehicle removed from favorites", Colors.green);
      }
    } else if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body);
      showCustomSnackBar(
          context, '${errorData['message'][0]['message']}', Colors.red);
    } else if (response.statusCode == 404) {
      final errorData = jsonDecode(response.body);
      showCustomSnackBar(context, "${errorData['message']}", Colors.red);
    } else {
      showCustomSnackBar(context, "An unexpected error occurred", Colors.red);
    }
  }

  List<FavoriteVehicle>? _favorites = [];
  List<FavoriteVehicle>? get favorites => _favorites;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isFavoriteLoading = false;
  bool get isFavoriteLoading => _isFavoriteLoading;

  Future<void> fetchFavoriteVehicles() async {
    _isFavoriteLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify listeners before the fetch

    try {
      _favorites = await _vehicleService
          .fetchFavoriteVehicles(); // Call the service method
    } catch (e) {
      _errorMessage = 'Error fetching favorite vehicles: $e';
    } finally {
      _isFavoriteLoading = false;
      notifyListeners(); // Notify listeners after the fetch
    }
  }

  final List<Vehicle> _allMyHostedVehicles = [];

  List<Vehicle> get allMyHostedVehicles => _allMyHostedVehicles;
  bool _isMyHostedVehiclesLoading = false;
  bool get isMyHostedVehiclesLoading => _isMyHostedVehiclesLoading;

  bool _hasMoreDataMyHostedVehicles =
      true; // To track if more data is available for
  bool get hasMoreDataMyHostedVehicles => _hasMoreDataMyHostedVehicles;
  int myHostedVehiclesPage = 1;

  Future<void> fetchMyHostedVehicles(String hostId) async {
    if (_hasMoreDataMyHostedVehicles && !_isMyHostedVehiclesLoading) {
      _isMyHostedVehiclesLoading = true;
      _errorMessage = null;
      notifyListeners(); // Notify listeners before the fetch
      try {
        final response = await _vehicleService.fetchVehicles(
          hostId: hostId,
          page: myHostedVehiclesPage,
        ); // Call the service method
        if (response.vehicles!.isNotEmpty) {
          _allMyHostedVehicles.addAll(response.vehicles!);
          myHostedVehiclesPage++;
        }
        print(response.totalCount);
        print(myHostedVehiclesPage);
        //if there are more pages (nextPageUrl is not null)
        if (_allMyHostedVehicles.length >= response.totalCount) {
          _hasMoreDataMyHostedVehicles = false; // No more vehicles to fetch
        }
      } catch (e) {
        _errorMessage = 'Error fetching your hosted vehicles vehicles: $e';
      } finally {
        _isMyHostedVehiclesLoading = false;
        notifyListeners(); // Notify listeners after the fetch
      }
    }
  }

  void clearMyHostedData() {
    _allMyHostedVehicles.clear();
    myHostedVehiclesPage = 1;
    _hasMoreDataMyHostedVehicles = true;
  }

  bool _isDeleteVehicleLoading = false;
  bool get isDeleteVehicleLoading => _isDeleteVehicleLoading;

  Future<int> deleteVehicle(String vehicleId) async {
    try {
      _isDeleteVehicleLoading = true;
      notifyListeners();

      // Attempt to delete the vehicle via the service
      final response = await _vehicleService.deleteVehicle(vehicleId);

      if (response.statusCode == 200) {
        allVehicles.removeWhere((vehicle) => vehicle.id == vehicleId);
        allSeachedVehicles.removeWhere((vehicle) => vehicle.id == vehicleId);
        allMyHostedVehicles.removeWhere((vehicle) => vehicle.id == vehicleId);
        notifyListeners();
      }

      // Log the response status code (for debugging purposes)
      print("Response from delete vehicle: ${response.statusCode}");
      return response.statusCode;
      // Additional success handling can go here, if needed
    } catch (e) {
      print('Error deleting vehicle: $e');
      return -1; // Return 500 or a custom error code in case of exceptions
    } finally {
      _isDeleteVehicleLoading = false;
      notifyListeners();
    }
  }

  // Method to create a vehicle and handle response
  Future<int> updateVehicle(Vehicle vehicleData, String vehicleId) async {
    try {
      _isLoading = true;
      notifyListeners(); // Notify UI that loading has started
      // Call the service to create the vehicle
      http.Response response =
          await _vehicleService.updateVehicle(vehicleData, vehicleId);

      if (response.statusCode == 200) {
        // On success, convert response to Vehicle model
        _vehicle = Vehicle.fromJsonNewCreateVehicle(
            jsonDecode(response.body)["data"][0]);
        // No need to reset _isLoading to false here, let it be handled in finally block
      } else {
        print(
            'Error: Failed to update vehicle. Status Code: ${response.statusCode}');
      }
      return response.statusCode;
    } catch (error) {
      print('Exception: $error');
      return 500; // Return 500 or a custom error code in case of exceptions
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI that loading has stopped
    }
  }

  final GetVehicleModelsService _service = GetVehicleModelsService();
  List<CarModel> carModels = [];
  bool _isModelsFetching = false;
  bool get isModelsFetching => _isModelsFetching;

  Future<void> fetchCarModels(String make) async {
    _isModelsFetching = true;
    notifyListeners();

    try {
      carModels = await _service.fetchCarModels(make);
    } catch (e) {
      print('Error fetching car models: $e');
      carModels = [];
    } finally {
      _isModelsFetching = false;
      notifyListeners(); // Ensure UI updates regardless of success or failure
    }
  }
}
