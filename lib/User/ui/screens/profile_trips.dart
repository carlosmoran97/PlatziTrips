import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'package:platzi_trips_app/User/ui/screens/profile_header.dart';
import 'package:platzi_trips_app/User/ui/widgets/profile_background.dart';
import 'package:platzi_trips_app/User/ui/widgets/profile_places_list.dart';

class ProfileTrips extends StatelessWidget {

  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);

    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            break;
          case ConnectionState.done:
            break;
          case ConnectionState.active:
            break;
          default:

        }
      },
    );

    /*return Container(
      color: Colors.indigo,
    );*/
//    return Stack(
//      children: <Widget>[
//        ProfileBackground(),
//        ListView(
//          children: <Widget>[
//            ProfileHeader(),
//            ProfilePlacesList(),
//          ],
//        ),
//      ],
//    );
  }

  Widget showProfileData(AsyncSnapshot snapshot){
    if(!snapshot.hasData || snapshot.hasError){
      print('No logeado');
      return Stack(
        children: <Widget>[
          ProfileBackground(),
          Text('Usuario no logeado. Haz login!'),
        ],
      );
    }else{
      print("Usuario logeado");
      var user = User(
        uid: snapshot.data['uid'],
        name: snapshot.data['displayName'],
        email: snapshot.data['email'],
        photoUrl: snapshot.data['photoUrl']
      );

      return Stack(
        children: <Widget>[
          ProfileBackground(),
          ListView(
            children: <Widget>[
              ProfileHeader(),
              ProfilePlacesList()
            ],
          ),
        ],
      );

    }
  }

}
