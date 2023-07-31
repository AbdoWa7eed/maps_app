import 'package:dio/dio.dart';
import 'package:maps_app/app/app_preferences.dart';
import 'package:maps_app/app/constants.dart';
import 'package:maps_app/data/network/requests.dart';
import 'package:maps_app/data/responses/responses.dart';

const suggestionsEndPoint = 'place/autocomplete/json';
const placeDetailsEndPoint = 'place/details/json';
const directionsEndPoint = 'directions/json';

abstract class AppServiceClient {
  Future<SuggestionsResponse> getSuggestedPlaces(
      String place, String sessionToken);
  Future<PlaceDetailsResponse> getPlaceDetails(
      String placeId, String sessionToken);
  Future<DirectionsResponse> getDirections(
      LocationRequest currentLocation, LocationRequest searchedPlaceLocation);
}

class AppServiceClientImpl implements AppServiceClient {
  final Dio _dio;
  final AppPreferences _appPreferences;

  AppServiceClientImpl(this._dio, this._appPreferences);

  @override
  Future<SuggestionsResponse> getSuggestedPlaces(
      String place, String sessionToken) async {
    Map<String, dynamic> queryParameters = {
      'input': place,
      'key': Constants.googleMapsAPIKey,
      'sessiontoken': sessionToken,
    };
    var response =
        await _dio.get(suggestionsEndPoint, queryParameters: queryParameters);
    var data = SuggestionsResponse.fromJson(response.data);
    return data;
  }

  @override
  Future<PlaceDetailsResponse> getPlaceDetails(
      String placeId, String sessionToken) async {
    Map<String, dynamic> queryParameters = {
      'place_id': placeId,
      'key': Constants.googleMapsAPIKey,
      'fields': 'name,geometry,place_id',
      'sessiontoken': sessionToken,
    };
    var response =
        await _dio.get(placeDetailsEndPoint, queryParameters: queryParameters);
    var data = PlaceDetailsResponse.fromJson(response.data);

    return data;
  }

  @override
  Future<DirectionsResponse> getDirections(LocationRequest currentLocation,
      LocationRequest searchedPlaceLocation) async {
    String lang = await _appPreferences.getAppLanguage();
    Map<String, dynamic> queryParameters = {
      'origin': '${currentLocation.latitude} , ${currentLocation.longitude}',
      'key': Constants.googleMapsAPIKey,
      'language': lang,
      'destination':
          '${searchedPlaceLocation.latitude} , ${searchedPlaceLocation.longitude}'
    };

    var response =
        await _dio.get(directionsEndPoint, queryParameters: queryParameters);
    var data = DirectionsResponse.fromJson(response.data);

    return data;
  }
}
