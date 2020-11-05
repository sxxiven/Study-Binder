// This files constructs the home page for the chat tab. It builds all of the chat rooms that belongs to the current logged in
// user in order to view them.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_binder/Model/User.dart';
import 'chatScreen.dart';
import 'Chat.dart';

final _firestore = Firestore.instance;

class ChatHome extends StatefulWidget {

  static String id = '/chat_home';

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

//sets up the screen and calls the stream builder to construct the chat rooms
class _ChatHomeState extends State<ChatHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //uniformed app bar across the pages displayes the circle avator of the logged in user and a button to logout
        title: Text('Study Groups',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ChatStream(),
        ],
      ),
    );
  }
}

// Stateless class wich builds the chat rooms through a streambuilder which updates the list if a new chat room is created.
// The Streambuilder reads all of the chat rooms and only adds the chatCards to the listview if their fiven values corresponds
// to the information of the current logged in users information.

class ChatStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('chat').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: Text('There are currently no available study groups', style: TextStyle(
              fontSize: 25.0,
              color: Colors.black54,
            )),
          );
        }
        final chats = snapshot.data.documents.reversed;
        List<ChatCard> chatCards = [];
        for(var chat in chats){
          bool show = false; //starts with the chat room bueing red as a no show
          String recipient;
          final chatID = chat.documentID;
          final author1 = chat.data['author1'];
          final author2 = chat.data['author2'];
          final subtitle = chat.data['course'];
          final preview = chat.data['preview'];
          final notify = chat.data['new'];
          final lastSender = chat.data['lastSender'];

          //if the first author's ID of the chat room matches the logged in user, then the card would be added to the listview
          if(author1 == User.loggedInUser.uid) {
            recipient = chat.data['name2'];
            show = true; //show is true
          }

          // if the second author's ID of the chat room matches the logged in user, then the card would be added to the listview
          if(author2 == User.loggedInUser.uid){
            recipient = chat.data['name1'];
            show = true; // show is true
          }
          Chat.recepientName = recipient;
          if (show){ //only shows/adds the chat rooms that the logged in user is part of
            final chatCard = ChatCard(recipient: recipient, documentID: chatID, subtitle: subtitle, preview: preview, notify: (notify && (lastSender!= User.loggedInUser.email)),);
            chatCards.add(chatCard);
          }
        }

        return Expanded( //retuns a listview of all of the logged in user chat rooms
          child: ListView(
            padding: EdgeInsets.symmetric( vertical: 5),
            children: chatCards,
          ),
        );
      },
    );
  }
}


class ChatCard extends StatefulWidget {
  final String recipient, documentID, subtitle, preview;
  final bool notify;

  ChatCard({this.recipient,this.documentID, this.subtitle, this.preview, this.notify});

  @override
  _ChatCardState createState() => _ChatCardState(recepient: recipient, documentID: documentID, course: subtitle, preview: preview, notify: notify);
}

//stateful class of the the users chat rooms cards that displayes the reciever, study session's title, and a preview of the las message tat was sent.
class _ChatCardState extends State<ChatCard> {
  final String recepient, documentID, course, preview;
  bool notify;

  _ChatCardState({this.recepient, this.documentID, this.course, this.preview, this.notify});

  @override
  Widget build(BuildContext context) {
    var name = recepient.split(' ');
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.only(topRight: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.orange[600],
                child: Text(name[0][0] + name[1][0], style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
                radius: 30.00,
              ),
              Expanded(
                child: ListTile(
                  title: Text(recepient, overflow: TextOverflow.ellipsis, style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                    ),
                  ),
                  //the following displayes a 'new' icon if a message was sent to the current logged in user and it has not yet been opened and read
                  trailing:(notify) ? Container(child: Icon(Icons.fiber_new, color: Colors.orange[600],)) : Container(width: MediaQuery.of(context).size.width * 0.10,) ,
                  subtitle: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: Text(course, textAlign: TextAlign.start,  overflow: TextOverflow.ellipsis, style: TextStyle(
                          color: Colors.blueGrey[100]
                        ),),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.70,
                          child: Text(preview, overflow: TextOverflow.ellipsis, style: TextStyle(
                            color: Colors.blueGrey[100]
                          ),)),
                    ],
                  ),
                  onTap: () async {
                    if(notify){
                     await  _firestore.collection('chat').document(documentID).updateData({'new' : false});
                     notify = false;
                    }
                    User.chatID = documentID;
                    Chat.recepientName = recepient;
                    Navigator.pushNamed(context, ChatScreen.id);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
