import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'package:platzi_trips_app/User/ui/widgets/button_bar.dart';
import 'package:platzi_trips_app/User/ui/widgets/user_info.dart';

class ProfileHeader extends StatelessWidget {

  User user;
  ProfileHeader();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext, AsyncSnapshot<FirebaseUser> snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.none:
            return CircularProgressIndicator();
          case ConnectionState.active:
            return _showProfileData(snapshot);
          case ConnectionState.done:
            return _showProfileData(snapshot);
        }
      }
    );
  }

  Widget _showProfileData(AsyncSnapshot snapshot){
    final title = Text(
      'Profile',
      style: TextStyle(
          fontFamily: 'Lato',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30.0),
    );
    if(!snapshot.hasData || snapshot.hasError){
      print("No logeado");
      return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
        child: Column(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("No se pudo cargar la información. Haz login")
          ],
        ),
      );
    }

    print("Logeado");
    user = User(
        name: snapshot.data.displayName,
        email: snapshot.data.email,
        photoUrl: snapshot.data.photoUrl
    );
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[title],
          ),
          UserProfileInfo(user),
          ButtonsBar()
        ],
      ),
    );
  }
}
