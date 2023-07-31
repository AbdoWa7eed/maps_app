import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/app/app_preferences.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/app/location_helper.dart';
import 'package:maps_app/domain/models/models.dart';
import 'package:maps_app/domain/usecases/home_usecase.dart';
import 'package:maps_app/presentation/home/cubit/states.dart';
import 'package:maps_app/presentation/resourses/language_manager.dart';
import 'package:maps_app/presentation/resourses/strings_manager.dart';
import 'package:maps_app/presentation/resourses/values_manager.dart';
import 'package:uuid/uuid.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());
  Position? myPosistion;
  late UserModel? userModel;
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final GetUserDataUseCase _userDataUseCase = instance<GetUserDataUseCase>();
  final GetSuggestedPlacesUseCase _placesUseCase =
      instance<GetSuggestedPlacesUseCase>();
  final GetPlaceDetailsUseCase _placeDetailsUseCase =
      instance<GetPlaceDetailsUseCase>();
  final GetDirectionsUseCase _directionsUseCase =
      instance<GetDirectionsUseCase>();
  final SavePlaceUseCase _savePlaceUseCase = instance<SavePlaceUseCase>();

  getCurrentLocation() async {
    myPosistion = await LocationHelper.getCurrentLocation().whenComplete(() {
      directionsModel = null;
      markers.clear();
      emit(GetCurrentLocationState());
    });
  }

  getUserData() async {
    String uid = _appPreferences.getUserUid();
    (await _userDataUseCase.execute(uid)).fold((failure) {
      emit(GetUserDataErrorState(failure.message));
    }, (userModel) {
      this.userModel = userModel;
      emit(GetUserDataSuccessState());
    });
  }

  Map<String, SuggestedPlaceModel> placesMap = {};
  getSuggestedPlaces(String place) async {
    String sessionToken = _generateSessionToken();
    (await _placesUseCase.execute(SuggestedPlacesInput(place, sessionToken)))
        .fold((failure) {
      emit(GetSuggestedPlacesErrorState(failure.message));
    }, (placesList) {
      placesMap.clear();
      for (var element in placesList) {
        placesMap[element.placeId] = element;
      }
      emit(GetSuggestedPlacesSuccessState());
    });
  }

  PlaceModel? placeModel;
  getPlaceDetails(String placeId) async {
    String sessionToken = _generateSessionToken();
    (await _placeDetailsUseCase
            .execute(PlaceDetailsInput(placeId, sessionToken)))
        .fold((failure) {
      emit(GetPlaceDetailsErrorState(failure.message));
    }, (placeModel) async {
      this.placeModel = placeModel;
      this
          .placeModel
          ?.setDescription(placesMap[placeModel.placeId]!.description);
      emit(GetPlaceDetailsSuccessState());
      goToLocation(newPosition: getSearchedPlacePlaceCamera());
      await savePlaceToSql();
    });
  }

  String _generateSessionToken() {
    return const Uuid().v4();
  }

  DirectionsModel? directionsModel;
  bool isVisible = false;
  getDirections() async {
    (await _directionsUseCase.execute(DirectionsUseCaseInput(
            PlaceModel(AppStrings.yourPosistion, AppStrings.yourPosistion,
                myPosistion!.latitude, myPosistion!.longitude),
            placeModel!)))
        .fold((failure) {
      emit(GetDirectionsErrorState(failure.message));
    }, (directionsModel) {
      isVisible = true;
      this.directionsModel = directionsModel;
      emit(GetDirectionsSuccessState());
    });
  }

  savePlaceToSql() async {
    String phoneNumber = _appPreferences.getUserPhoneNumber();
    (await _savePlaceUseCase.execute(SavedPlacesInput(
            placeModel: placeModel!, phoneNumber: phoneNumber)))
        .fold((failure) {}, (success) {
      emit(SavePlaceSuccessState());
    });
  }

  reInitialzePlaceModel(PlaceModel placeModel) {
    this.placeModel = placeModel;
    directionsModel = null;
    hideDistanceAndTime();
    goToLocation(newPosition: getSearchedPlacePlaceCamera());
    emit(GetPlaceDetailsSuccessState());
  }

  changeAppLanguage() async {
    await _appPreferences.changeAppLanguage();
  }

  late bool isEnglishLanguage;
  getAppLanguage() async {
    String lang = await _appPreferences.getAppLanguage();
    if (lang == LanguageType.english.getValue()) {
      isEnglishLanguage = true;
    } else {
      isEnglishLanguage = false;
    }
  }

  Future<bool> logout() async {
    return await _appPreferences.logout();
  }

  // UI Functions
  late Completer<GoogleMapController>? controller;
  Set<Marker> markers = {};
  late Marker? _searchedPlaceMarker;

  goToLocation({CameraPosition? newPosition}) async {
    GoogleMapController mapController = await controller!.future;
    await mapController.animateCamera(CameraUpdate.newCameraPosition(
        newPosition ?? getCurrentCameraPosistion()));
    if (newPosition != null) {
      _createMarker();
    } else {
      markers.clear();
      placeModel = null;
      directionsModel = null;
    }
    emit(ChangeCameraPositionState());
  }

  CameraPosition getCurrentCameraPosistion() {
    return CameraPosition(
        bearing: AppSize.s0,
        target: LatLng(myPosistion!.latitude, myPosistion!.longitude),
        zoom: AppSize.s10,
        tilt: AppSize.s0);
  }

  CameraPosition getSearchedPlacePlaceCamera() {
    return CameraPosition(
        bearing: AppSize.s0,
        target: LatLng(placeModel!.latitude, placeModel!.longitude),
        zoom: AppSize.s10,
        tilt: AppSize.s0);
  }

  _createMarker({Position? position}) {
    _searchedPlaceMarker = Marker(
      markerId: MarkerId(position?.toString() ??
          LatLng(placeModel!.latitude, placeModel!.longitude).toString()),
      infoWindow: InfoWindow(
        title: position != null
            ? AppStrings.yourPosistion.tr()
            : placeModel?.description,
      ),
      onTap: () async {
        if (!isVisible) {
          await getDirections();
        } else {
          isVisible = false;
        }
        _createMarker(position: myPosistion);
      },
      position: LatLng(position?.latitude ?? placeModel!.latitude,
          position?.longitude ?? placeModel!.longitude),
    );
    if (position == null) {
      markers.clear();
    }
    markers.add(_searchedPlaceMarker!);
    emit(CreateMarkerState());
  }

  hideDistanceAndTime() {
    isVisible = false;
    emit(ChangeDistanceTimeState());
  }
}
