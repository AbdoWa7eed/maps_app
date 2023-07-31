import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/app/app_preferences.dart';
import 'package:maps_app/app/di.dart';
import 'package:maps_app/domain/repository/auth_repo.dart';
import 'package:maps_app/presentation/phone_auth/cubit/states.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthStates> {
  PhoneAuthCubit() : super(PhoneAuthInitialState());
  String? phoneNumber;
  late String _verificationId;
  final AuthRepository _authRepository = instance<AuthRepository>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  void sendVerificationCode({required Function codeSent}) async {
    emit(SendCodeLoadingState());
    (await _authRepository.sendVerificationCode(
            phoneNumber: phoneNumber!,
            onError: (error) {
              emit(SendCodeErrorState(error));
            },
            codeSent: (verificationId, p1) {
              codeSent.call();
              _verificationId = verificationId;
            }))
        .fold((faiure) {
      emit(SendCodeErrorState(faiure.message));
    }, (success) {
      emit(SendCodeSuccessState());
    });
  }

  bool? isRegisterd;

  void signIn(
      {required String smsCode, required Function whenCompleted}) async {
    emit(VerifiactionCodeLoadingState());
    (await _authRepository.signInWithCredential(
            verificationId: _verificationId, smsCode: smsCode))
        .fold((failure) {
      emit(VerifiactionCodeErrorState(failure.message));
    }, (uid) async {
      await isUserRegisterd(uid);
      await _saveDataToSharedPreferences(uid);
      emit(VerifiactionCodeSuccessState());
      whenCompleted.call();
    });
  }

  Future<void> isUserRegisterd(String uid) async {
    (await _authRepository.isUserAlreadyRegistered(uid: uid)).fold((failure) {
      emit(VerifiactionCodeErrorState(failure.message));
    }, (response) {
      isRegisterd = response;
    });
  }

  Future<void> _saveDataToSharedPreferences(String uid) async {
    await _appPreferences.setUserPhoneNumber(phoneNumber!);
    await _appPreferences.setUserUid(uid);
    if (isRegisterd != null) {
      if (isRegisterd!) {
        await _appPreferences.setUserRegistered();
      }
    }
  }
}
