import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/User/ui/widgets/profile_place.dart';

class ProfilePlacesList extends StatelessWidget {

  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {

    userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
      child: StreamBuilder(
        stream: userBloc.placesListStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return CircularProgressIndicator();
              break;
            case ConnectionState.done:
              return Column(
                children: userBloc.buildPlaces(snapshot.data.documents),
              );
              break;
            case ConnectionState.active:
              return Column(
                children: userBloc.buildPlaces(snapshot.data.documents),
              );
              break;
            case ConnectionState.none:
              return CircularProgressIndicator();
            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
