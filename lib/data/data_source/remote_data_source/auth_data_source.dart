import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maps_app/data/data_source/remote_data_source/firebase_constants.dart';
import 'package:maps_app/data/network/requests.dart';

abstract class AuthDataSource {
  Future<void> sendVerificationCode(
      {required String phoneNumber,
      required Function(String, int?) codeSent,
      required Function(String) onError});

  Future<String?> signInWithCredential(UserAuthenticationRequest user);

  Future<bool> isUserAlreadyRegisterd(String uid);
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  AuthDataSourceImpl(this._auth, this._firestore);

  @override
  Future<void> sendVerificationCode({
    required String phoneNumber,
    required Function(String, int?) codeSent,
    required Function(String) onError,
  }) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await _auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          if (error.message != null) {
            onError.call(error.message!);
          }
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (verificationId) {});
  }

  @override
  Future<String?> signInWithCredential(UserAuthenticationRequest user) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: user.verificationId, smsCode: user.smsCode);
    return (await _auth.signInWithCredential(credential)).user?.uid;
  }

  @override
  Future<bool> isUserAlreadyRegisterd(String uid) async {
    return (await _firestore.collection(usersCollectionPath).doc(uid).get())
        .exists;
  }
}
