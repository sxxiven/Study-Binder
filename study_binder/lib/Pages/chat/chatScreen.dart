//this file builds the chat screen that allows the users to message each other instantly

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_binder/Model/User.dart';
import 'Chat.dart';

final _firestore = Firestore.instance;


class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}


//this class builds the chat screen as well as writes to the database when the save button is sent
class _ChatScreenState extends State<ChatScreen> {

  final messageTextController = TextEditingController();
  String messageText;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Chat.recepientName),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.blueGrey[100],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        hintText: 'Type your message here...',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      messageTextController.clear();
                      //Implement send functionality.
                      //messageTExt + loggedInUser.email
                      if(messageText != null) { //checks that the message beings send it not null. If not, then it proceeds.
                        await _firestore.collection('chat')
                            .document(User.chatID)
                            .collection('messages')
                            .add({
                          'text': messageText,
                          'senderName': User.displayName,
                          'senderEmail': User.loggedInUser.email,
                          'createdAt': DateTime
                              .now()
                              .millisecondsSinceEpoch
                        });
                        await  _firestore.collection('chat').document(User.chatID).updateData({'new' : true, 'lastSender' : User.loggedInUser.email, 'preview' : messageText});
                        await Future.delayed(Duration(milliseconds: 100));
                      }
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//this class implements the StreamBuilder which listens to any changes from the database of its specified location in order to
// update and show real time messages.

class MessagesStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('chat').document(User.chatID).collection('messages').orderBy("createdAt").snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for(var message in messages){
          final messageText = message.data['text'];
          final messageSender = message.data['senderName'];
          final senderEmail = message.data['senderEmail'];

          final messageBubble = MessageBubble(sender: messageSender, text: messageText, isMe: senderEmail == User.loggedInUser.email);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          ),
        );
      } ,
    );
  }
}

//this class constructs the message bubble which displayes all send messages contents. If it is from the logged in user, the
// message bubble constructs a blue bubble on the right side of the screen. If it was sent from the other party, then an
// orange bubble is constructedon the left side.
class MessageBubble extends StatelessWidget {

  MessageBubble({this.sender, this.text, this.isMe});

  final String text, sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender, style: TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),),
          Material(
            borderRadius: isMe? BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0))
                : BorderRadius.only(bottomLeft: Radius.circular(30.0), topRight: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.blue[900] : Colors.orange[600],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text('$text', style: TextStyle(fontSize: 15.0,
                color:  isMe ? Colors.white: Colors.black,
              ),),
            ),
          ),
        ],
      ),
    );
  }
}
