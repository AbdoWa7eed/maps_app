import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_app/app/app_preferences.dart';
import 'package:maps_app/app/constants.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/domain/models/models.dart';
import 'package:maps_app/domain/usecases/register_use_case.dart';
import 'package:maps_app/presentation/register/cubit/states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  final UploadImageUseCase _imageUseCase = instance<UploadImageUseCase>();
  final AddUserDataUseCase _addUserDataUseCase = instance<AddUserDataUseCase>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  late ImagePicker _imagePicker;
  File? image;
  String? _imageUrl;

  void uploadImage({required Function whenCompleted}) async {
    emit(UploadLoadingState());
    (await _imageUseCase.execute(image!)).fold((failure) {
      emit(UploadImageErrorState(failure.message));
    }, (url) {
      _imageUrl = url;
      whenCompleted.call();
      emit(UploadImageSuccessState());
    });
  }

  void uploadUserData({
    required String firstName,
    required String lastName,
    required Function whenCompleted,
  }) async {
    emit(UploadLoadingState());
    UserModel user = UserModel(
        _appPreferences.getUserUid(),
        firstName,
        lastName,
        _appPreferences.getUserPhoneNumber(),
        _imageUrl ?? Constants.defaultUserImage);
    (await _addUserDataUseCase.execute(user)).fold((failure) {
      emit(UploadUserDataErrorState(failure.message));
    }, (success) {
      whenCompleted.call();
      _appPreferences.setUserRegistered();
      emit(UploadUserDataSuccessState());
    });
  }

  imageFromGallery() async {
    _imagePicker = instance<ImagePicker>();
    String? path =
        (await _imagePicker.pickImage(source: ImageSource.gallery))?.path;
    if (path != null) {
      image = File(path);
    }
    emit(PickedImageState());
  }

  imageFromCamera() async {
    _imagePicker = instance<ImagePicker>();
    String? path =
        (await _imagePicker.pickImage(source: ImageSource.camera))?.path;
    if (path != null) {
      image = File(path);
    }
    emit(PickedImageState());
  }
}
