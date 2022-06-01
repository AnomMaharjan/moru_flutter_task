// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:moru/api/api.dart';
import 'package:moru/constants/constants.dart';
import 'package:moru/model/weather_response_model.dart';
import 'package:http/http.dart' as http;

class HttpApi extends Api {
  String? url;

  @override
  Future<WeatherResponse?> retrieveWeatherData(String latLong) async {
    //checks if the latitude, longitude or previously searched location is available or not.
    //if available, returns the weather data of the previously searched location else returns default latLong weather data defined on constants file

    url = "$baseURL&q=$latLong";
    log(url.toString());

    try {
      final response = await http.get(Uri.parse(url!));
      if (response.statusCode == 200) {
        return WeatherResponse.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } on HttpException catch (err) {
      log(err.message);
      return null;
    }
  }

  @override
  Future<WeatherResponse?> searchLocation(String location) async {
    String url = "$baseURL&q=$location";
    log(url.toString());

    try {
      final response = await http.get(Uri.parse(url));
      log(response.body.toString());
      if (response.statusCode == 200) {
        return WeatherResponse.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } on HttpException catch (err) {
      log(err.message.toLowerCase());
      return null;
    }
  }
}
