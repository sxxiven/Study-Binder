//this file contains the welcome screen in which the user can navigate either to log in or register.

import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:study_binder/Components/roundedButton.dart';


class WelcomeScreen extends StatefulWidget {

  static String id = '/welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
            Text('Study Binder', textAlign: TextAlign.center, style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
              fontFamily: 'Yellowtial'
            ),),
              SizedBox( height: 20.0,),
              Image.asset('images/logo.jpg'),
              SizedBox( height: 48.0,),
              RoundedButton(title: 'Log in', color: Colors.orange[600], onPressed: (){Navigator.pushNamed(context, LoginScreen.id);}),
              SizedBox( height: 24.0,),
              RoundedButton(title: 'Register', color: Colors.blue[900], onPressed: (){Navigator.pushNamed(context, RegistrationScreen.id);}),
            ],
          ),
        ),
    );
  }
}
