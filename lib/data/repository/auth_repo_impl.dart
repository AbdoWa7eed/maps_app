// ignore_for_file: void_checks

import 'package:dartz/dartz.dart';
import 'package:maps_app/app/constants.dart';
import 'package:maps_app/data/network/error_handler.dart';
import 'package:maps_app/data/network/failure.dart';
import 'package:maps_app/data/network/network_info.dart';
import 'package:maps_app/data/network/requests.dart';
import 'package:maps_app/domain/repository/auth_repo.dart';
import '../data_source/remote_data_source/auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  final NetworkInfo _networkInfo;
  AuthRepositoryImpl(this._authDataSource, this._networkInfo);
  @override
  Future<Either<Failure, void>> sendVerificationCode(
      {required String phoneNumber,
      required Function(String p1, int? p2) codeSent,
      required Function(String p1) onError}) async {
    if (await _networkInfo.isConnected) {
      await _authDataSource.sendVerificationCode(
          phoneNumber: phoneNumber, codeSent: codeSent, onError: onError);
      return const Right(Constants.zero);
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> signInWithCredential(
      {required String verificationId, required String smsCode}) async {
    if (await _networkInfo.isConnected) {
      try {
        UserAuthenticationRequest user =
            UserAuthenticationRequest(verificationId, smsCode);
        var uid = await _authDataSource.signInWithCredential(user);
        return Right(uid ?? Constants.empty);
      } catch (error) {
        return Left(DataSource.WRONG_OTP_CODE.getFailure());
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isUserAlreadyRegistered(
      {required String uid}) async {
    if (await _networkInfo.isConnected) {
      var isUserExists = await _authDataSource.isUserAlreadyRegisterd(uid);
      return Right(isUserExists);
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
