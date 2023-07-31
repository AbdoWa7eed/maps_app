import 'package:dartz/dartz.dart';
import 'package:maps_app/data/network/failure.dart';
import 'package:maps_app/domain/models/models.dart';
import 'package:maps_app/domain/repository/places_history_repo.dart';
import 'package:maps_app/domain/usecases/base_usecase.dart';

class GetPlacesUseCase extends BaseUseCase<String, List<PlaceModel>> {
  final SavedPlacesRepository _placesRepository;
  GetPlacesUseCase(this._placesRepository);

  @override
  Future<Either<Failure, List<PlaceModel>>> execute(String input) async {
    return await _placesRepository.getSavedPlaces(input);
  }
}

class DeletePlaceUseCase extends BaseUseCase<String, void> {
  final SavedPlacesRepository _placesRepository;
  DeletePlaceUseCase(this._placesRepository);

  @override
  Future<Either<Failure, void>> execute(String input) async {
    return await _placesRepository.deletePlace(placeId: input);
  }
}

class DeleteAllPlacesUseCase extends BaseUseCase<String, void> {
  final SavedPlacesRepository _placesRepository;
  DeleteAllPlacesUseCase(this._placesRepository);

  @override
  Future<Either<Failure, void>> execute(String input) async {
    return await _placesRepository.deleteAllPlaces(phoneNumber: input);
  }
}
