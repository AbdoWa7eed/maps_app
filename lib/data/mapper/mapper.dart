import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/app/constants.dart';
import 'package:maps_app/data/network/requests.dart';
import 'package:maps_app/data/responses/responses.dart';
import 'package:maps_app/domain/models/models.dart';

extension UserResponetMapper on UserRespone? {
  UserModel toUserModel() {
    return UserModel(
        this?.uid ?? Constants.empty,
        this?.firstName ?? Constants.empty,
        this?.lastName ?? Constants.empty,
        this?.phoneNumber ?? Constants.empty,
        this?.imageLink ?? Constants.defaultUserImage);
  }
}

extension UserModelMapper on UserModel {
  UserRespone toUserRequest() {
    return UserRespone(
      uid,
      firstName,
      lastName,
      phoneNumber,
      imageLink,
    );
  }
}

extension SuggestedPlaceResponseMapper on SuggestedPlaceResponse? {
  SuggestedPlaceModel toPlaceModel() {
    return SuggestedPlaceModel(
      this?.description ?? Constants.empty,
      this?.placeId ?? Constants.empty,
    );
  }
}

extension PlaceResponseMapper on PlaceDetailsResponse? {
  PlaceModel toPlaceModel() {
    return PlaceModel(
        this?.name ?? Constants.empty,
        this?.placeId ?? Constants.empty,
        this?.placeLocation?.latitude ?? Constants.zero,
        this?.placeLocation?.longtude ?? Constants.zero);
  }
}

extension PlaceModelMapper on PlaceModel {
  LocationRequest toLocationRequest() {
    return LocationRequest(latitude, longitude);
  }
}

extension DirectionResponseMapper on DirectionsResponse? {
  DirectionsModel toDirectionsModel() {
    return DirectionsModel(
        LatLng(this?.startLocation?.latitude ?? Constants.zero,
            this?.startLocation?.longtude ?? Constants.zero),
        LatLng(this?.endLocation?.latitude ?? Constants.zero,
            this?.endLocation?.longtude ?? Constants.zero),
        this?.points ?? Constants.empty,
        this?.distance ?? Constants.empty,
        this?.duration ?? Constants.empty);
  }
}
