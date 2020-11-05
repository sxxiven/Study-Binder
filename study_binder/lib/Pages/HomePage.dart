// This files contains the homepage tab. The homepage tab offers quick shortcuts to view all messages and to post a new study session

import 'package:flutter/material.dart';
import 'package:study_binder/Model/User.dart';
import 'package:study_binder/Components/roundedButton.dart';
import 'package:study_binder/Pages/posts/PostEntry.dart';
import 'package:study_binder/Pages/chat/ChatHome.dart';


class HomePage extends StatefulWidget {


  static String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String displayName = User.displayName, firstname = User.firstname, lastname = User.lastname;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Home',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(User.firstname[0] + User.lastname[0], style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),),
            radius: 50.00,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              User.auth.signOut();
              Navigator.pop(context);
            },
          )
        ],
      ),
      backgroundColor: Colors.blueGrey[100],
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(displayName,
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height : MediaQuery.of(context).size.height * 0.03),
              Container(
                color: Colors.blue[900],
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Current Messages', textAlign: TextAlign.center, style: TextStyle(
                  color: Colors.white, fontSize: 25.0
                ),),
              ),
              Expanded(
                child: Container(
                  color: Colors.blueGrey[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ChatStream(),
                    ],
                  ),
                ),
              ),
              SizedBox(height : MediaQuery.of(context).size.height * 0.03),
              RoundedButton(title: 'Create A New Study Group', color: Colors.orange[600], onPressed: (){Navigator.pushNamed(context, PostEntry.id);}),
              //Spacer(flex:5),
            ],
          )
      ),
    );
  }
}