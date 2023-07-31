import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:maps_app/data/network/failure.dart';
import 'package:maps_app/domain/models/models.dart';
import 'package:maps_app/domain/repository/register_repo.dart';
import 'package:maps_app/domain/usecases/base_usecase.dart';

class UploadImageUseCase implements BaseUseCase<File, String> {
  final RegisterRepository _registerRepository;

  UploadImageUseCase(this._registerRepository);
  @override
  Future<Either<Failure, String>> execute(File image) {
    return _registerRepository.uploadImage(image);
  }
}

class AddUserDataUseCase implements BaseUseCase<UserModel, void> {
  final RegisterRepository _registerRepository;

  AddUserDataUseCase(this._registerRepository);
  @override
  Future<Either<Failure, void>> execute(UserModel user) {
    return _registerRepository.addUserToFireStore(user);
  }
}
