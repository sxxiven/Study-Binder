// This file contains the text widgets that display the about indormation of the application

import 'package:flutter/material.dart';
import '../Model/User.dart';

class About extends StatefulWidget {

  static String id = '/about';

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //uniformed app bar across the pages displayes the circle avator of the logged in user and a button to logout
        title: Text('About',
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
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'About Study Binder',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              Spacer(flex: 1),
              Text(
                'Study Binder is an applicatoin that was first proposed as a class project. Its main goal of development is to provide '
                    'an application that can be utilized by many students accross a campus of a specified school to create or search for study groups to join.\n',
                style: TextStyle(fontSize: 15),
              ),
              Spacer(flex: 1),
              Text(
                  'Study Binder contains various of tool and features to provide the best experience for its users.'
                      'The Home Page of the app allows its users to instantly check their messages from their inbox. The Home Page '
                      'also allows the user to create a study group post and submit thier planned study group session for all to see. This option '
                      'is also available though the Posts tab in which lists all ongoing and planned study groups. The other pages '
                      'included in this application is the Chat page where users can request to join posted study groups through instant messaging and '
                      'a page dedicated to lists all TA and IA office hours from classes that have the information avialbe to the application. \n',
                  style: TextStyle(fontSize: 15)),
              Spacer(flex: 1),
              Text(
                  'The developer of this application plans to add additional features and design improvements for Study Binder in the '
                      'near future. If you have any further questions, comments, concerns, or want to suggest new edditions for the'
                      ' application, you can reach the developer at:',
                  style: TextStyle(fontSize: 15)),
              Spacer(flex: 1),
              Text('sjrobles2@miners.utep.edu',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Spacer(flex: 3),
            ],
          )),
    );
  }
}