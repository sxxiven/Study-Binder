// This file loads all o fthe user data by retreiving it from the firebase using firestore before it pushes the navigator to the
// homescreen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User{

  // logged in user information poperties
  static String firstname;
  static String lastname;
  static String displayName;
  static String chatID; //used to pull up chat room according to their ID's
  static FirebaseUser loggedInUser;
  static var auth;


  //loads the current user's display name
  Future<void> loadUserInformation (FirebaseUser currentUser, var _auth) async {

    loggedInUser = currentUser;
    auth = _auth;
    displayName = await _get_displayname(loggedInUser);

  }

  //retreives the current user displayname from the database
  Future<String> _get_displayname(FirebaseUser loggedInUser) async{
    firstname = await Firestore.instance.collection('users').document(loggedInUser.uid).get()
        .then((DocumentSnapshot ds) {
      var first = ds['firstname'];
      assert(first is String);
      return first;
    });

    lastname = await Firestore.instance.collection('users').document(loggedInUser.uid).get()
        .then((DocumentSnapshot ds) {
      var last = ds['lastname'];
      assert(last is String);
      return last;
    });
    return '$firstname $lastname';
  }
}

//            _firestore.collection('/chat').document("roomA").collection("messages").document("message1").setData({'title': 'hello'});