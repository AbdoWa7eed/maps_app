// ignore_for_file: void_checks

import 'package:dartz/dartz.dart';
import 'package:maps_app/app/constants.dart';
import 'package:maps_app/data/data_source/local_data_source/local_data_source.dart';
import 'package:maps_app/data/network/error_handler.dart';
import 'package:maps_app/data/network/failure.dart';
import 'package:maps_app/domain/models/models.dart';
import 'package:maps_app/domain/repository/places_history_repo.dart';

class SavedPlacesReposImpl implements SavedPlacesRepository {
  final LocalDataSource _localDataSource;
  SavedPlacesReposImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<PlaceModel>>> getSavedPlaces(
      String phoneNumber) async {
    try {
      var data = await _localDataSource.getSavedPlaces(phoneNumber);
      return Right(data);
    } catch (error) {
      return Left(Failure(ResponseCode.CACHE_ERROR, error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllPlaces(
      {required String phoneNumber}) async {
    try {
      await _localDataSource.deleteAllPlace(phoneNumber);
      return const Right(Constants.zero);
    } catch (error) {
      return Left(Failure(ResponseCode.CACHE_ERROR, error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlace({required String placeId}) async {
    try {
      await _localDataSource.deletePlaceFromDatabase(placeId);
      return const Right(Constants.zero);
    } catch (error) {
      return Left(Failure(ResponseCode.CACHE_ERROR, error.toString()));
    }
  }
}
