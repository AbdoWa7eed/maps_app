import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:maps_app/data/data_source/remote_data_source/firebase_constants.dart';
import 'package:maps_app/data/responses/responses.dart';

abstract class RegisterDataSource {
  Future<String> uploadImage(File image);

  Future<void> addUserToFireStore(UserRespone userRequest);
}

class RegisterDataSourceImpl implements RegisterDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _fireStorage;

  RegisterDataSourceImpl(this._firestore, this._fireStorage);

  @override
  Future<String> uploadImage(File image) async {
    final store = _fireStorage
        .ref()
        .child("$imagesFolderPath${image.path.split('/').last}");
    final snapshot = await store.putFile(image);
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Future<void> addUserToFireStore(UserRespone userRequest) async {
    await _firestore
        .collection(usersCollectionPath)
        .doc(userRequest.uid)
        .set(userRequest.toMap());
  }
}
