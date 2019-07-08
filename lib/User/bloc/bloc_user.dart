import 'package:firebase_auth/firebase_auth.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'package:platzi_trips_app/User/repository/auth_repository.dart';
import 'package:platzi_trips_app/User/repository/cloud_firestore_repository.dart';

class UserBloc implements Bloc {

  final _authRepository = AuthRepository();

  // Flujo de datos - Streams
  // Stream de Firebase, ya maneja una clase con Streams
  // Stream Controller
  Stream<FirebaseUser> _streamFirebase = FirebaseAuth.instance.onAuthStateChanged;
  Stream<FirebaseUser> get authStatus => _streamFirebase;


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

  @override
  void dispose() {

  }
}
