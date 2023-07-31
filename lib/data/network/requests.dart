class UserAuthenticationRequest {
  String verificationId;
  String smsCode;

  UserAuthenticationRequest(this.verificationId, this.smsCode);
}

class LocationRequest {
  double? latitude;
  double? longitude;
  LocationRequest(this.latitude, this.longitude);
}
