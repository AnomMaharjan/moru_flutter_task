import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:moru/api/http_api.dart';
import 'package:moru/constants/constants.dart';
import 'package:moru/injector/injector.dart';
import 'package:moru/model/weather_response_model.dart';
import 'package:moru/storage/shared_preferences_manager.dart';

class HomeController extends GetxController {
  final TextEditingController searchFieldController = TextEditingController();
  final HttpApi httpApi = HttpApi();

  final SharedPreferencesManager sharedPreferencesManager =
      locator<SharedPreferencesManager>();
  double? degreesInF;
  double? degreesInC;
  double? latitude;
  double? longitude;
  String? location;
  Position? position;
  // bool? serviceEnabled = false;
  WeatherResponse? weatherResponse;

  RxBool isLoading = false.obs;
  RxBool searching = false.obs;
  RxBool inputEmpty = false.obs;

  String errorText = "";
  bool? locationEnabled;

  _determinePosition() async {
    isLoading.value = true;
    LocationPermission permission;

    locationEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        retrieveWeatherData();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      retrieveWeatherData();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } else {
      if (locationEnabled!) {
        position = await Geolocator.getCurrentPosition();
        print(position);
        latitude = position!.latitude;
        longitude = position!.longitude;
        //checks if any location is searched or not, and stores the location in sharedpreferences if searched previously
        if (!sharedPreferencesManager.isKeyExists("locationSearched")!) {
          sharedPreferencesManager.putString("latLong", "$latitude,$longitude");
        }
      }
      retrieveWeatherData();
    }
  }

  Future<void> retrieveWeatherData() async {
    //if the location service is disabled, returns the weather data of default latitude and longitude defined in constants file
    if (!locationEnabled! &&
        !sharedPreferencesManager.isKeyExists("latLong")!) {
      weatherResponse = await httpApi.retrieveWeatherData(defaultLatLong);
      if (weatherResponse != null) {
        degreesInC = weatherResponse!.current!.feelslikeC!;
        degreesInF = weatherResponse!.current!.feelslikeF!;
        isLoading.value = false;
      } else {
        errorText = "Could not find location or something went wrong.";
        isLoading.value = false;
      }
    } else {
      //if the location service is enabled, returns the weather data of the current location
      weatherResponse = await httpApi.retrieveWeatherData(
          "${sharedPreferencesManager.getString('latLong')}");

      if (weatherResponse != null) {
        degreesInC = weatherResponse!.current!.feelslikeC!;
        degreesInF = weatherResponse!.current!.feelslikeF!;
        isLoading.value = false;
      } else {
        errorText = "Could not find location or something went wrong.";
        isLoading.value = false;
      }
    }
  }

  Future<void> searchLocation(String? location) async {
    searching.value = true;
    isLoading.value = true;
    weatherResponse = await httpApi.searchLocation(location!);
    if (weatherResponse != null) {
      degreesInC = weatherResponse!.current!.feelslikeC!;
      degreesInF = weatherResponse!.current!.feelslikeF!;
      isLoading.value = false;
      isLoading.value = false;
    } else {
      errorText = "Could not find location\nor\nsomething went wrong.";
      isLoading.value = false;
      isLoading.value = false;
    }
    sharedPreferencesManager.putString(
        "latLong", searchFieldController.text.trim());
    sharedPreferencesManager.putBool("locationSearched", true);
    searching.value = false;
  }

  @override
  void onInit() {
    _determinePosition();
    super.onInit();
  }

  @override
  void onClose() {}
}
