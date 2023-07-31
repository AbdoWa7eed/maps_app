abstract class PlacesHistoryStates {}

class PlacesHistoryInitialState extends PlacesHistoryStates {}

class GetPlacesSuccessState extends PlacesHistoryStates {}

class GetPlacesErrorState extends PlacesHistoryStates {
  String errorMessage;
  GetPlacesErrorState(this.errorMessage);
}

class DeletePlaceSuccessState extends PlacesHistoryStates {}

class DeletePlaceErrorState extends PlacesHistoryStates {
  String errorMessage;
  DeletePlaceErrorState(this.errorMessage);
}
