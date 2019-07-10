import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'package:platzi_trips_app/User/ui/widgets/profile_place.dart';

class CloudFirestoreApi{
  final String USERS = "users";
  final String PLACES = "places";

  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateUserData(User user) async{
    DocumentReference ref = _db.collection(USERS).document(user.uid);
    return await ref.setData({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'photoUrl': user.photoUrl,
      'myPlaces': user.myPlaces,
      'myFavoritePlaces': user.myFavoritePlaces,
      'lastSignIn': DateTime.now()
    }, merge: true);

  }
  Future<void> updatePlaceData(Place place)async{
    CollectionReference refPlaces = _db.collection(PLACES);
    String uid = (await _auth.currentUser()).uid;



    await refPlaces.add({
      'name': place.name,
      'description': place.description,
      'likes': place.likes,
      'userOwner': _db.document("$USERS/$uid"),
      'urlImage': place.urlImage,
    }).then((DocumentReference dr){
      dr.get().then((DocumentSnapshot snapshot){
        DocumentReference placeRef = snapshot.reference; // REFERENCIA ARRAY
        DocumentReference refUsers = _db.collection(USERS).document(uid);
        refUsers.updateData({
          'myPlaces': FieldValue.arrayUnion([placeRef])
        });
      });
    });
  }

  List<ProfilePlace> buildPlaces(List<DocumentSnapshot> placesListSnapshot){

    List<ProfilePlace> profilePlaces = List<ProfilePlace>();

    placesListSnapshot.forEach((DocumentSnapshot placeSnapshot){
      profilePlaces.add(ProfilePlace(Place(
        name: placeSnapshot.data['name'],
        description: placeSnapshot.data['description'],
        urlImage: placeSnapshot.data['urlImage'],
        likes: placeSnapshot.data['likes']
      )));
    });

    return profilePlaces;

  }

}