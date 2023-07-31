import 'package:dartz/dartz.dart';
import 'package:maps_app/data/network/failure.dart';
import 'package:maps_app/domain/models/models.dart';

abstract class HomeRepository {
  Future<Either<Failure, UserModel>> getUserData(String uid);

  Future<Either<Failure, List<SuggestedPlaceModel>>> getSuggestedPlaces(
      String place, String sessionToken);

  Future<Either<Failure, PlaceModel>> getPlaceDetails(
      String placeId, String sessionToken);

  Future<Either<Failure, DirectionsModel>> getDirections(
      PlaceModel currentPlaceModel, PlaceModel searchedPlaceModel);

  Future<Either<Failure, void>> savePlaceToDatabase(
      {required PlaceModel placeModel, required String phoneNumber});
}
