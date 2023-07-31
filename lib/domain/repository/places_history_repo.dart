import 'package:dartz/dartz.dart';
import 'package:maps_app/data/network/failure.dart';
import 'package:maps_app/domain/models/models.dart';

abstract class SavedPlacesRepository {
  Future<Either<Failure, List<PlaceModel>>> getSavedPlaces(String phoneNumber);
  Future<Either<Failure, void>> deletePlace({required String placeId});
  Future<Either<Failure, void>> deleteAllPlaces({required String phoneNumber});
}
