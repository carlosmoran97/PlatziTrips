import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/Place/ui/widgets/card_image.dart';
import 'package:platzi_trips_app/Place/ui/widgets/title_input_location.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/widgets/button_purple.dart';
import 'package:platzi_trips_app/widgets/gradient_back.dart';
import 'package:platzi_trips_app/widgets/text_input.dart';
import 'package:platzi_trips_app/widgets/title_header.dart';

class AddPlaceScreen extends StatefulWidget {
  final File image;

  AddPlaceScreen({Key key, this.image});

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  UserBloc userBloc;
  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    final _controllerTitlePlace = TextEditingController();
    final _controllerDescriptionPlace = TextEditingController();
    final _controllerLocationPlace = TextEditingController();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GradientBack(
            height: 300.0,
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 25.0,
                  left: 5.0,
                ),
                child: SizedBox(
                  height: 45.0,
                  width: 45.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 45.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 45.0,
                    left: 20.0,
                    right: 10.0,
                  ),
                  child: TitleHeader(
                    title: "Add a new place",
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: 120.0,
              bottom: 20.0,
            ),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: CardImageWithFabIcon(
                    pathImage: widget.image.path,
                    iconData: Icons.camera_alt,
                    width: MediaQuery.of(context).size.width * 0.90,
                    //width: 350.0,
                    height: 250.0,
                    left: 0.0,
                    internet: false,
                  ),
                ), //contiene la foto
                Container( // text field del titulo
                  margin: EdgeInsets.only(
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  child: TextInput(
                    hintText: "Title",
                    inputType: null,
                    controller: _controllerTitlePlace,
                    maxLines: 1,
                  ),
                ),
                TextInput(
                  hintText: "Description",
                  inputType: TextInputType.multiline,
                  maxLines: 4,
                  controller: _controllerDescriptionPlace,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextInputLocation(
                    hintText: "Location",
                    iconData: Icons.location_on,
                    controller: _controllerLocationPlace,
                  ),
                ),
                Container(
                  width: 70.0,
                  child: ButtonPurple(
                    buttonText: "Add Place",
                    onPressed: (){

                      // ID del usuario
                      userBloc.currentUser.then((FirebaseUser user){
                        if(user != null){
                          // 1. Firebase Storage
                          // url -
                          String uid = user.uid;
                          String path = "$uid/${DateTime.now().toString()}";
                          userBloc.uploadFile(path, widget.image).then((StorageUploadTask storageUploadTask){
                            storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot){
                              snapshot.ref.getDownloadURL().then((urlImage){
                                // 2. Cloud Firestore
                                // Place - title, description, url, userOwner, likes
                                userBloc.updatePlaceData(Place(
                                    name: _controllerTitlePlace.text,
                                    description: _controllerDescriptionPlace.text,
                                    likes: 0,
                                    urlImage: urlImage
                                )).whenComplete((){
                                  print("Terminó");
                                  Navigator.pop(context);
                                });
                              });
                            });
                          });
                        }
                      });

                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
