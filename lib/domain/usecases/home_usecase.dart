import 'package:dartz/dartz.dart';
import 'package:maps_app/data/network/failure.dart';
import 'package:maps_app/domain/models/models.dart';
import 'package:maps_app/domain/repository/home_repo.dart';
import 'package:maps_app/domain/usecases/base_usecase.dart';

class GetUserDataUseCase implements BaseUseCase<String, UserModel> {
  final HomeRepository _homeRepository;

  GetUserDataUseCase(this._homeRepository);
  @override
  Future<Either<Failure, UserModel>> execute(String input) async {
    return await _homeRepository.getUserData(input);
  }
}

class GetSuggestedPlacesUseCase
    implements BaseUseCase<SuggestedPlacesInput, List<SuggestedPlaceModel>> {
  final HomeRepository _homeRepository;
  GetSuggestedPlacesUseCase(this._homeRepository);

  @override
  Future<Either<Failure, List<SuggestedPlaceModel>>> execute(
      SuggestedPlacesInput input) async {
    return await _homeRepository.getSuggestedPlaces(
        input.place, input.sessionToken);
  }
}

class GetPlaceDetailsUseCase
    implements BaseUseCase<PlaceDetailsInput, PlaceModel> {
  final HomeRepository _homeRepository;
  GetPlaceDetailsUseCase(this._homeRepository);

  @override
  Future<Either<Failure, PlaceModel>> execute(PlaceDetailsInput input) async {
    return await _homeRepository.getPlaceDetails(
        input.place, input.sessionToken);
  }
}

class GetDirectionsUseCase
    implements BaseUseCase<DirectionsUseCaseInput, DirectionsModel> {
  final HomeRepository _homeRepository;
  GetDirectionsUseCase(this._homeRepository);

  @override
  Future<Either<Failure, DirectionsModel>> execute(
      DirectionsUseCaseInput input) async {
    return await _homeRepository.getDirections(
        input.currentPlace, input.searchedPlace);
  }
}

class SavedPlacesInput {
  PlaceModel placeModel;
  String phoneNumber;
  SavedPlacesInput({required this.placeModel, required this.phoneNumber});
}

class SavePlaceUseCase extends BaseUseCase<SavedPlacesInput, void> {
  final HomeRepository _placesRepository;
  SavePlaceUseCase(this._placesRepository);

  @override
  Future<Either<Failure, void>> execute(SavedPlacesInput input) async {
    return await _placesRepository.savePlaceToDatabase(
        placeModel: input.placeModel, phoneNumber: input.phoneNumber);
  }
}

abstract class BaseInput {
  String sessionToken;
  BaseInput(this.sessionToken);
}

class SuggestedPlacesInput extends BaseInput {
  String place;
  SuggestedPlacesInput(this.place, super.sessionToken);
}

class PlaceDetailsInput extends BaseInput {
  String place;
  PlaceDetailsInput(this.place, super.sessionToken);
}

class DirectionsUseCaseInput {
  PlaceModel currentPlace;
  PlaceModel searchedPlace;
  DirectionsUseCaseInput(this.currentPlace, this.searchedPlace);
}
