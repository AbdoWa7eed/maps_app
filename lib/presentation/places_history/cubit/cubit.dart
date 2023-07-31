import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/app/app_preferences.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/domain/models/models.dart';
import 'package:maps_app/domain/usecases/places_history_usecase.dart';
import 'package:maps_app/presentation/places_history/cubit/states.dart';

class PlacesHistoryCubit extends Cubit<PlacesHistoryStates> {
  PlacesHistoryCubit() : super(PlacesHistoryInitialState());
  final GetPlacesUseCase _getPlacesUseCase = instance<GetPlacesUseCase>();
  final DeleteAllPlacesUseCase _deleteAllPlacesUseCase =
      instance<DeleteAllPlacesUseCase>();
  final DeletePlaceUseCase _deletePlaceUseCase = instance<DeletePlaceUseCase>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  List<PlaceModel> placesHistory = [];

  getSavedPlaces() async {
    (await _getPlacesUseCase.execute(_appPreferences.getUserPhoneNumber()))
        .fold((failure) {
      emit(GetPlacesErrorState(failure.message));
    }, (placesHistory) {
      this.placesHistory = placesHistory;
      emit(GetPlacesSuccessState());
    });
  }

  deletePlace(String placeId) async {
    (await _deletePlaceUseCase
            .execute(placeId + _appPreferences.getUserPhoneNumber()))
        .fold((failure) {
      emit(GetPlacesErrorState(failure.message));
    }, (success) async {
      await getSavedPlaces();
      emit(GetPlacesSuccessState());
    });
  }

  deleteAllPlace() async {
    (await _deleteAllPlacesUseCase
            .execute(_appPreferences.getUserPhoneNumber()))
        .fold((failure) {
      emit(DeletePlaceErrorState(failure.message));
    }, (success) async {
      emit(DeletePlaceSuccessState());
      await getSavedPlaces();
    });
  }
}
