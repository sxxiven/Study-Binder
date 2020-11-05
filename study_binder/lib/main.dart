// Steven Robles
// Study Binder
// This application is inteded to be the final projcet for cross-platfrom mobile apps development. It creates an app to be used
// as a tool for students to create and search for study groups in their campus was well as look up faculty office hours that are
// seperated by course.


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_binder/screens/welcome_screen.dart';
import 'package:study_binder/screens/login_screen.dart';
import 'package:study_binder/screens/registration_screen.dart';
import 'package:study_binder/Pages/HomePage.dart';
import 'package:study_binder/Pages/posts/Posts.dart';
import 'package:study_binder/Pages/Classes.dart';
import 'package:study_binder/Pages/posts/PostEntry.dart';
import 'package:study_binder/Pages/chat/ChatHome.dart';
import 'package:study_binder/Pages/chat/chatScreen.dart';
import 'Pages/About.dart';

void main() async {
  runApp(StudyBinder());
}


//main file which crates the routes and pushed the welcome screen first
class StudyBinder extends StatefulWidget {

  @override
  _StudyBinderState createState() => _StudyBinderState();
}

class _StudyBinderState extends State<StudyBinder> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        accentColor: Colors.orange[600],
        hintColor: Colors.white,
      ),

        routes: {
          '/': (context) => WelcomeScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          HomePage.id: (context) => HomePage(),
          Posts.id : (context) => Posts(),
          Classes.id: (context) => Classes(),
          OfficeHours.id : (context) => OfficeHours(),
          About.id: (context) => About(),
          Tabs.id: (context) => Tabs(),
          PostEntry.id: (context) => PostEntry(),
          ChatHome.id : (context) => ChatHome(),
          ChatScreen.id: (context) => ChatScreen(),

        },
    );
  }
}

//Tab class which crates the application's tabs and controller for navigation between each page.
 class Tabs extends StatefulWidget {

  static String id = '/pages';


   @override
   _TabsState createState() => _TabsState();
 }

 class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {


   TabController controller;

   @override
   void initState() {
     super.initState();
     controller = TabController(length: 5, vsync: this);
   }

   @override
   void dispose() {
     super.dispose();
     controller.dispose();
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
         body: TabBarView(
           children: <Widget>[
             HomePage(),
             Posts(),
             ChatHome(),
             Classes(),
             About(),
           ],
           controller: controller,
         ),
         bottomNavigationBar: Material(
           color: Colors.blue[900],
           child: TabBar(
             tabs: <Widget>[
               Tab(
                 icon: Icon(Icons.home),
                 text: 'Home',
               ),
               Tab(
                 icon: Icon(Icons.reorder),
                 text: 'Posts',
               ),
               Tab(
                 icon: Icon(Icons.message),
                 text: 'Chat',
               ),
               Tab(
                 icon: Icon(Icons.supervised_user_circle),
                 text: 'TA/IA',
               ),
               Tab(
                 icon: Icon(Icons.error_outline),
                 text: 'About',
               ),
             ],
             controller: controller,
           ),
         ),
     );
   }
 }

