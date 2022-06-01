import 'package:moru/model/weather_response_model.dart';

abstract class Api {
  Future<WeatherResponse?> retrieveWeatherData(String latLong);
  Future<WeatherResponse?> searchLocation(String location);
}
