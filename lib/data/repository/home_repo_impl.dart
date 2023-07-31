// ignore_for_file: void_checks

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maps_app/app/constants.dart';
import 'package:maps_app/data/data_source/local_data_source/local_data_source.dart';
import 'package:maps_app/data/data_source/remote_data_source/home_data_source.dart';
import 'package:maps_app/data/mapper/mapper.dart';
import 'package:maps_app/data/network/error_handler.dart';
import 'package:maps_app/data/network/failure.dart';
import 'package:maps_app/data/network/network_info.dart';
import 'package:maps_app/domain/models/models.dart';
import 'package:maps_app/domain/repository/home_repo.dart';
import 'package:maps_app/presentation/resourses/strings_manager.dart';

class HomeRepositortImpl implements HomeRepository {
  final HomeDataSource _dataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  HomeRepositortImpl(
      this._dataSource, this._networkInfo, this._localDataSource);
  @override
  Future<Either<Failure, UserModel>> getUserData(String uid) async {
    if (await _networkInfo.isConnected) {
      final userData = await _dataSource.getUserData(uid);
      return Right(userData.toUserModel());
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<SuggestedPlaceModel>>> getSuggestedPlaces(
      String place, String sessionToken) async {
    if (await _networkInfo.isConnected) {
      try {
        var response =
            await _dataSource.getSuggestedPlaces(place, sessionToken);
        var data = response.placesResponse
            ?.map((place) => place.toPlaceModel())
            .toList();
        return Right(data ?? []);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, PlaceModel>> getPlaceDetails(
      String placeId, String sessionToken) async {
    if (await _networkInfo.isConnected) {
      try {
        var response = await _dataSource.getPlaceDetails(placeId, sessionToken);
        return Right(response.toPlaceModel());
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, DirectionsModel>> getDirections(
      PlaceModel currentPlaceModel, PlaceModel searchedPlaceModel) async {
    if (await _networkInfo.isConnected) {
      try {
        var response = await _dataSource.getDirections(
            currentPlaceModel.toLocationRequest(),
            searchedPlaceModel.toLocationRequest());
        if (response.status != 'OK') {
          return Left(Failure(
              ResponseCode.BAD_REQUEST, AppStrings.cantCreateDirections.tr()));
        }
        return Right(response.toDirectionsModel());
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> savePlaceToDatabase(
      {required PlaceModel placeModel, required String phoneNumber}) async {
    try {
      await _localDataSource.addPlaceToDatabase(placeModel, phoneNumber);
      return const Right(Constants.zero);
    } catch (error) {
      return Left(Failure(ResponseCode.CACHE_ERROR, error.toString()));
    }
  }
}
