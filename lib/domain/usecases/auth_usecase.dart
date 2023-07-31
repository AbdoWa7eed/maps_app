import 'package:dartz/dartz.dart';
import 'package:maps_app/data/network/failure.dart';
import 'package:maps_app/domain/repository/auth_repo.dart';
import 'package:maps_app/domain/usecases/base_usecase.dart';

class SendCodeUseCase implements BaseUseCase<SendCodeInput, void> {
  final AuthRepository _authRepository;
  SendCodeUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> execute(SendCodeInput input) async {
    return await _authRepository.sendVerificationCode(
        phoneNumber: input.phoneNumber,
        codeSent: input.codeSent,
        onError: input.onError);
  }
}

class VerificationUseCase implements BaseUseCase<VerificationInput, String> {
  final AuthRepository _authRepository;
  VerificationUseCase(this._authRepository);
  @override
  Future<Either<Failure, String>> execute(VerificationInput input) async {
    return await _authRepository.signInWithCredential(
        verificationId: input.verificationId, smsCode: input.smsCode);
  }
}

class SendCodeInput {
  final String phoneNumber;
  final Function(String, int?) codeSent;
  final Function(String) onError;
  SendCodeInput(this.phoneNumber, this.codeSent, this.onError);
}

class VerificationInput {
  final String verificationId;
  final String smsCode;
  VerificationInput(this.verificationId, this.smsCode);
}
