import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/Place/repository/firebase_storage_repository.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'package:platzi_trips_app/User/repository/auth_repository.dart';
import 'package:platzi_trips_app/User/repository/cloud_firestore_api.dart';
import 'package:platzi_trips_app/User/repository/cloud_firestore_repository.dart';
import 'package:platzi_trips_app/User/ui/widgets/profile_place.dart';

class UserBloc implements Bloc {

  final _authRepository = AuthRepository();

  // Flujo de datos - Streams
  // Stream de Firebase, ya maneja una clase con Streams
  // Stream Controller
  Stream<FirebaseUser> _streamFirebase = FirebaseAuth.instance.onAuthStateChanged;
  Stream<FirebaseUser> get authStatus => _streamFirebase;
  Future<FirebaseUser> get currentUser => FirebaseAuth.instance.currentUser();
  Stream<QuerySnapshot> get placesListStream => Firestore.instance.collection(CloudFirestoreApi().PLACES).snapshots();
  List<ProfilePlace> buildPlaces(List<DocumentSnapshot> placesListSnapshot) => _cloudFirestoreRepository.buildPlaces(placesListSnapshot);

  //Casos de uso
  //1. signIn a la aplicación de Google
  // El nombre debe de ser genérico
  Future<FirebaseUser> signIn(){
    return _authRepository.signInFirebase();
  }

  //2. Cerrar sesión
  signOut(){
    _authRepository.signOut();
  }

  //3. Registrar usuario en base de datos
  final CloudFirestoreRepository _cloudFirestoreRepository = CloudFirestoreRepository();
  void updateUserData(User user) => _cloudFirestoreRepository.updateUserDataFirestore(user);

  final _firebaseStorageRepository = FirebaseStorageRepository();
  Future<StorageUploadTask> uploadFile(String path, File image) => _firebaseStorageRepository.uploadFile(path, image);

  Future<void> updatePlaceData(Place place) => _cloudFirestoreRepository.updatePlaceData(place);

  @override
  void dispose() {

  }
}
