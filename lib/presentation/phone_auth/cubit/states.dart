abstract class PhoneAuthStates {}

class PhoneAuthInitialState extends PhoneAuthStates {}

class SendCodeLoadingState extends PhoneAuthStates {}

class SendCodeSuccessState extends PhoneAuthStates {}

class SendCodeErrorState extends PhoneAuthStates {
  final String error;
  SendCodeErrorState(this.error);
}

class VerifiactionCodeLoadingState extends PhoneAuthStates {}

class VerifiactionCodeSuccessState extends PhoneAuthStates {}

class VerifiactionCodeErrorState extends PhoneAuthStates {
  final String error;
  VerifiactionCodeErrorState(this.error);
}
