abstract class RegisterStates {}

abstract class RegisterErrorState extends RegisterStates {
  final String errorMessage;
  RegisterErrorState(this.errorMessage);
}

class RegisterInitialState extends RegisterStates {}

class UploadLoadingState extends RegisterStates {}

class UploadImageSuccessState extends RegisterStates {}

class UploadImageErrorState extends RegisterErrorState {
  UploadImageErrorState(super.errorMessage);
}

class UploadUserDataErrorState extends RegisterErrorState {
  UploadUserDataErrorState(super.errorMessage);
}

class UploadUserDataSuccessState extends RegisterStates {}

class PickedImageState extends RegisterStates {}
