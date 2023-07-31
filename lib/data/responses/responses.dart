class UserRespone {
  String? uid;
  String? firstName;
  String? lastName;
  String? imageLink;
  String? phoneNumber;

  UserRespone(this.uid, this.firstName, this.lastName, this.phoneNumber,
      this.imageLink);

  factory UserRespone.fromJson(Map<String, dynamic> json) => UserRespone(
      json['uid'],
      json['firstName'],
      json['lastName'],
      json['phoneNumber'],
      json['imageLink']);

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'imageLink': imageLink
    };
  }
}

class SuggestionsResponse {
  String? status;
  List<SuggestedPlaceResponse>? placesResponse;

  SuggestionsResponse(this.status, this.placesResponse);

  factory SuggestionsResponse.fromJson(Map<String, dynamic> json) =>
      SuggestionsResponse(
        json['status'],
        List.from(json['predictions'])
            .map((place) => SuggestedPlaceResponse.fromJson(place))
            .toList(),
      );
}

class SuggestedPlaceResponse {
  String? description;
  String? placeId;
  SuggestedPlaceResponse(this.description, this.placeId);

  factory SuggestedPlaceResponse.fromJson(Map<String, dynamic> json) =>
      SuggestedPlaceResponse(
        json['description'],
        json['place_id'],
      );
}

class PlaceDetailsResponse {
  String? name;
  String? placeId;
  PlaceLocationResponse? placeLocation;

  PlaceDetailsResponse(this.name, this.placeId, this.placeLocation);
  factory PlaceDetailsResponse.fromJson(Map<String, dynamic> json) =>
      PlaceDetailsResponse(
          json['result']['name'],
          json['result']['place_id'],
          PlaceLocationResponse.fromJson(
              json['result']['geometry']['location']));
}

class PlaceLocationResponse {
  double? latitude;
  double? longtude;
  PlaceLocationResponse(this.latitude, this.longtude);
  factory PlaceLocationResponse.fromJson(Map<String, dynamic> json) =>
      PlaceLocationResponse(json['lat'], json['lng']);
}

class DirectionsResponse {
  PlaceLocationResponse? startLocation;
  PlaceLocationResponse? endLocation;
  String? points;
  String? distance;
  String? duration;
  String? status;
  DirectionsResponse(this.startLocation, this.endLocation, this.points, this.distance,
      this.duration, this.status);
  factory DirectionsResponse.fromJson(Map<String, dynamic> json) {
    var status = json['status'];
    if (status == 'ZERO_RESULTS') {
      return DirectionsResponse(null, null, null, null, null, status);
    } else {
      var routs = json['routes'][0];
      return DirectionsResponse(
          PlaceLocationResponse.fromJson(routs['legs'][0]['start_location']),
          PlaceLocationResponse.fromJson(routs['legs'][0]['end_location']),
          routs['overview_polyline']['points'],
          routs['legs'][0]['distance']['text'],
          routs['legs'][0]['duration']['text'],
          status);
    }
  }
}
