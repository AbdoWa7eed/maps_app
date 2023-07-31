import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maps_app/data/data_source/remote_data_source/firebase_constants.dart';
import 'package:maps_app/data/network/app_api.dart';
import 'package:maps_app/data/network/requests.dart';
import 'package:maps_app/data/responses/responses.dart';

abstract class HomeDataSource {
  Future<UserRespone?> getUserData(String uid);

  Future<SuggestionsResponse> getSuggestedPlaces(
      String place, String sessionToken);

  Future<PlaceDetailsResponse> getPlaceDetails(
      String placeId, String sessionToken);

  Future<DirectionsResponse> getDirections(
      LocationRequest currentLocation, LocationRequest searchedPlaceLocation);
}

class HomeDataSourceImpl implements HomeDataSource {
  final FirebaseFirestore _firestore;
  final AppServiceClient _appServiceClient;
  HomeDataSourceImpl(this._firestore, this._appServiceClient);
  @override
  Future<UserRespone?> getUserData(String uid) async {
    final userData =
        (await _firestore.collection(usersCollectionPath).doc(uid).get())
            .data();

    return UserRespone.fromJson(userData!);
  }

  @override
  Future<SuggestionsResponse> getSuggestedPlaces(
      String place, String sessionToken) async {
    return await _appServiceClient.getSuggestedPlaces(place, sessionToken);
  }

  @override
  Future<PlaceDetailsResponse> getPlaceDetails(
      String placeId, String sessionToken) async {
    return await _appServiceClient.getPlaceDetails(placeId, sessionToken);
  }

  @override
  Future<DirectionsResponse> getDirections(LocationRequest currentLocation,
      LocationRequest searchedPlaceLocation) async {
    return await _appServiceClient.getDirections(
        currentLocation, searchedPlaceLocation);
  }
}
