import 'package:dartz/dartz.dart';
import 'package:maps_app/data/network/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> sendVerificationCode({
    required String phoneNumber,
    required Function(String, int?) codeSent,
    required Function(String) onError,
  });
  Future<Either<Failure, String>> signInWithCredential(
      {required String verificationId, required String smsCode});

  Future<Either<Failure, bool>> isUserAlreadyRegistered({required String uid});
}
