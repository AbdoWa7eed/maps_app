// ignore_for_file: void_checks

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:maps_app/app/constants.dart';
import 'package:maps_app/data/data_source/remote_data_source/register_data_source.dart';
import 'package:maps_app/data/mapper/mapper.dart';
import 'package:maps_app/data/network/error_handler.dart';
import 'package:maps_app/data/network/failure.dart';
import 'package:maps_app/data/network/network_info.dart';
import 'package:maps_app/domain/models/models.dart';
import 'package:maps_app/domain/repository/register_repo.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterDataSource _registerDataSource;
  final NetworkInfo _networkInfo;

  RegisterRepositoryImpl(this._registerDataSource, this._networkInfo);

  @override
  Future<Either<Failure, void>> addUserToFireStore(UserModel userModel) async {
    if (await _networkInfo.isConnected) {
      await _registerDataSource.addUserToFireStore(userModel.toUserRequest());
      return const Right(Constants.zero);
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(File imageFile) async {
    if (await _networkInfo.isConnected) {
      final response = await _registerDataSource.uploadImage(imageFile);
      return Right(response);
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
