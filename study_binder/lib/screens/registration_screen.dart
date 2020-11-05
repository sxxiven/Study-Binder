// This file contains the registration screen where the user is prompted for the first and last name, an email account which is
// going to be used to log in again, and their password. A new account will be created for them under the autherization within the
// firebase project

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_binder/main.dart';
import 'package:study_binder/Model/User.dart';
import 'package:study_binder/Components/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:study_binder/Components/roundedButton.dart';
import 'package:study_binder/Components/AlertDialogs.dart';


class RegistrationScreen extends StatefulWidget {

  static String id = '/registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  String email, password, firstname, lastname;
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
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Container(
            child: Column(
              children: <Widget>[
                ListTile(title: Image.asset('images/logo.jpg')),
                Form(
                  key: _formKey,
                  child: Expanded(
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          title: TextFormField(
                            textAlign: TextAlign.center,
                            validator: (String value){
                              if(value.length == 0){
                                return 'Please Enter Your First Name';
                              }
                              return null;
                            },
                            onChanged: (value)
                            {
                              firstname = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your your first name'),
                          ),
                        ),
                       // Spacer(flex: 1,),
                        ListTile(
                          title: TextFormField(
                            textAlign: TextAlign.center,
                            validator: (String value){
                              if(value.length == 0){
                                return 'Please Enter Your Last Name';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              lastname = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your last name'),
                          ),
                        ),
                       // Spacer(flex: 1,),
                        ListTile(
                          title: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                            validator: (String value){
                              if(value.length == 0){
                                return 'Please Enter Your Email';
                              }
                              return null;
                            },
                            onChanged: (value)
                            {
                              email = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
                          ),
                        ),
                      //  Spacer(flex: 1,),
                        ListTile(
                          title: TextFormField(
                            obscureText: true,
                            textAlign: TextAlign.center,
                            validator: (String value){
                              if(value.length == 0){
                                return 'Please Enter Your Password';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
                          ),
                        ),
                       // Spacer(flex: 2),
                        ListTile(
                          title: RoundedButton(title: 'Register', color: Colors.blue[900], onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                showSpinning = true;
                              });

                              try {
                                final newUser = await _auth
                                    .createUserWithEmailAndPassword(
                                    email: email, password: password);
                                if (newUser != null) {
                                  final FirebaseUser loggedInUser = await _auth
                                      .currentUser();
                                  await _firestore.collection('/users')
                                      .document(loggedInUser.uid)
                                      .setData({
                                    'firstname': firstname,
                                    'lastname': lastname,
                                    'userid': loggedInUser.uid
                                  });
                                  await userInfo.loadUserInformation(
                                      loggedInUser, _auth);
                                  Navigator.popAndPushNamed(context, Tabs.id);
                                }
                              }
                              catch (e) {
                                alertDialogs.error_message(context, e.message);
                              }
                              setState(() {
                                showSpinning = false;
                              });
                            }
                          }),
                        ),
                       // Spacer(flex: 10,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
