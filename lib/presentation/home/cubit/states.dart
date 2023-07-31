abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

abstract class HomeErrorStates extends HomeStates {
  String errorMessage;
  HomeErrorStates(this.errorMessage);
}

class ChangeCameraPositionState extends HomeStates {}

class CreateMarkerState extends HomeStates {}

class ChangeDistanceTimeState extends HomeStates {}

class GetCurrentLocationState extends HomeStates {}

class GetUserDataLoadingState extends HomeStates {}

class GetUserDataSuccessState extends HomeStates {}

class GetUserDataErrorState extends HomeErrorStates {
  GetUserDataErrorState(super.errorMessage);
}

class GetSuggestedPlacesSuccessState extends HomeStates {}

class GetSuggestedPlacesErrorState extends HomeErrorStates {
  GetSuggestedPlacesErrorState(super.errorMessage);
}

class GetPlaceDetailsSuccessState extends HomeStates {}

class GetPlaceDetailsErrorState extends HomeErrorStates {
  GetPlaceDetailsErrorState(super.errorMessage);
}

class GetDirectionsSuccessState extends HomeStates {}

class GetDirectionsErrorState extends HomeErrorStates {
  GetDirectionsErrorState(super.errorMessage);
}

class SavePlaceSuccessState extends HomeStates {}

class SavePlaceErrorState extends HomeErrorStates {
   SavePlaceErrorState(super.errorMessage);
}

