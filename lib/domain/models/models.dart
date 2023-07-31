import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel {
  final String uid;
  final String imageLink;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  UserModel(this.uid, this.firstName, this.lastName, this.phoneNumber,
      this.imageLink);
}

class SuggestedPlaceModel {
  final String description;
  final String placeId;
  SuggestedPlaceModel(this.description, this.placeId);
}

class PlaceModel {
  final String name;
  final String placeId;
  final double latitude;
  final double longitude;
  late String? description;

  PlaceModel(this.name, this.placeId, this.latitude, this.longitude,
      {this.description});

  void setDescription(String description) {
    this.description = description;
  }
}

class DirectionsModel {
  LatLng startLocation;
  LatLng endLocation;
  String points;
  String distance;
  String duration;
  DirectionsModel(this.startLocation, this.endLocation, this.points,
      this.distance, this.duration);
}
