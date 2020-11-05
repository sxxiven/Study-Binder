// This class provides the the properties of the recipients information as well as method to create a new chat room

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_binder/Model/User.dart';

class Chat{

  static String chatID;
  static String recepientName;
  static String recipientemail;

  // creates a new chat room in the firebase database
  Future<void> setupNewChat(String recipient, String recipientuid, String email, String course, String postID) async {
    recepientName = recipient;
    recipientemail = email;
    chatID = await _get_newchatnumber();
    String text = User.displayName + ' would like to join your '+ course + ' study sessions.';
    await Firestore.instance.collection('/chat').document(chatID).collection("messages").document().setData({'senderName' : User.displayName, 'senderEmail': User.loggedInUser.email, 'text': text, 'createdAt' : DateTime.now().millisecondsSinceEpoch});
    await Firestore.instance.collection('/chat').document(chatID).setData({'author1': User.loggedInUser.uid, 'author2' : recipientuid, 'name1' : User.displayName, 'name2' : recipient, 'course' : course, 'preview': text, 'new' : true, 'lastSender' : User.loggedInUser.email, 'postID' : postID});
    return;
  }

  // creates a unique ID to create the new chat room.
  Future<String> _get_newchatnumber() async{
    String NewChatNumber = await Firestore.instance.collection('chat').document('chatrooms').get()
        .then((DocumentSnapshot ds) async {
      var rooms = ds['Rooms'];
      rooms +=1;
      await Firestore.instance.collection('/chat').document('chatrooms').setData({'Rooms' : rooms});
      return rooms.toString();
    });

    return NewChatNumber;
  }
}