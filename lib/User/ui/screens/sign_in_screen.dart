import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'package:platzi_trips_app/platzi_trips_cupertino.dart';
import 'package:platzi_trips_app/widgets/button_green.dart';
import 'package:platzi_trips_app/widgets/gradient_back.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return _handleCurrentSession();
  }

  Widget _handleCurrentSession(){
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
        // el snapshot contiene nuestros datos, en este caso nuesttro objeto user
        if(!snapshot.hasData || snapshot.hasError){
          return signInGoogleUI();
        }
        return PlatziTripsCupertino();
      },
    );
  }

  Widget signInGoogleUI() {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GradientBack(

          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Welcome\nThis is your Travel App",
                    style: TextStyle(
                      fontSize: 37.0,
                      fontFamily: "Lato",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ButtonGreen(
                text: "Login with Gmail",
                onPressed: () {
                  userBloc.signOut();
                  userBloc.signIn().then((FirebaseUser user){
                    userBloc.updateUserData(User(
                      uid: user.uid,
                      name: user.displayName,
                      email: user.email,
                      photoUrl: user.photoUrl
                    ));
                  });
                },
                width: 300.0,
                height: 50.0,
              )
            ],
          ),
        ],
      ),
    );
  }
}
