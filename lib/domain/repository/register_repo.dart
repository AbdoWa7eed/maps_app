import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:maps_app/data/network/failure.dart';
import 'package:maps_app/domain/models/models.dart';

abstract class RegisterRepository {
  Future<Either<Failure, String>> uploadImage(File imageFile);

  Future<Either<Failure, void>> addUserToFireStore(UserModel userModel);
}
