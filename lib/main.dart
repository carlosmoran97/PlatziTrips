import 'dart:async';

import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'User/ui/screens/sign_in_screen.dart';
import 'platzi_trips.dart';
import 'platzi_trips_cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: UserBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        home: SignInScreen(),
      ),
    );
  }
}
