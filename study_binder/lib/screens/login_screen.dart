//this files contains the log in screen of the application. Here the credentials are checked before proceeding into the applicaiton

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_binder/main.dart';
import 'package:study_binder/Model/User.dart';
import 'package:study_binder/Components/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:study_binder/Components/roundedButton.dart';
import 'package:study_binder/Components/AlertDialogs.dart';

class LoginScreen extends StatefulWidget {
  static String id = '/login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email, password;
  bool showSpinning = false;
  User userInfo = new User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.blueGrey[100],
      body: ModalProgressHUD(
        inAsyncCall: showSpinning,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Spacer(
                  flex: 3,
                ),
                Image.asset('images/logo.jpg'),
                Spacer(
                  flex: 2,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  validator: (String value){
                    if(value.length == 0){
                      return 'Please Enter Your Email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your username'),
                ),
                Spacer(
                  flex: 1,
                ),
                TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  validator: (String value){
                    if(value.length == 0){
                      return 'Please Enter Your First Name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                Spacer(
                  flex: 2,
                ),
                RoundedButton(
                    title: 'Log In',
                    color: Colors.orange[600],
                    onPressed: () async {
                     if (_formKey.currentState.validate()) {
                       setState(() {
                         showSpinning = true;
                       });

                       try {
                         final user = await _auth.signInWithEmailAndPassword(
                             email: email, password: password);
                         if (user != null) {
                           final FirebaseUser loggedInUser =
                           await _auth.currentUser();
                           await userInfo.loadUserInformation(loggedInUser,
                               _auth);
                           Navigator.popAndPushNamed(context, Tabs.id);
                         }
                       } catch (e) {
                         alertDialogs.error_message(context, e.message);
                       }
                       setState(() {
                         showSpinning = false;
                       });
                     }
                    }),
                Spacer(
                  flex: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
