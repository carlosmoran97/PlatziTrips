import 'package:flutter/material.dart';
import 'package:platzi_trips_app/Place/model/place.dart';

class User {
  String uid;
  String photoUrl;
  String name;
  String email;
  final List<Place> myPlaces;
  final List<Place> myFavoritePlaces;

  // myFavoritePlaces;
  // myPlaces;

  User({
    Key key,
    @required this.uid,
    @required this.name,
    @required this.email,
    @required this.photoUrl,
    this.myPlaces,
    this.myFavoritePlaces,
  });
}
