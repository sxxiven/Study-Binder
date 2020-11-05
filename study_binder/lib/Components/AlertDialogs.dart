// this files contains the alert dialogs that are called from the other files to represent their messages

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_binder/Pages/chat/Chat.dart';

class alertDialogs{
  //alert diolog that confirm with the user to delete a note
  static Future<void> error_message(BuildContext context, var message) {
    return showDialog(
        context : context,
        barrierDismissible : false,
        builder : (BuildContext alertContext) {
          return AlertDialog(
              title : Text('Could note commplete request.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              content : Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue[900],
              actions : [
                FlatButton(child : Text('Ok'),
                    color: Colors.white,
                    onPressed : () async {
                      Navigator.of(alertContext).pop();
                    }
                ) ] );

        } ); }

  //this function is called to confirm that the user wants to delete a post. If they do not own the post, then their only option is to go back
  static Future<void> deleteConfirmation(BuildContext context, var postID, bool participating) {
    return showDialog(
        context : context,
        barrierDismissible : false,
        builder : (BuildContext alertContext) {
          return (participating) ? AlertDialog(
              title : Text("Delete Post", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              content : Text("Are you sure you want to delete this study group post?", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue[900],
              actions : [
                FlatButton(child : Text("Cancel", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.orange[600])),
                    onPressed: () {Navigator.of(alertContext).pop();}
                ),
                FlatButton(child : Text("Delete"),
                    color: Colors.red,
                    onPressed : () async {
                      await Firestore.instance.collection('posts').document(postID).delete();
                      Navigator.of(alertContext).pop();
                      Scaffold.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor : Colors.red,
                              duration : Duration(seconds : 1),
                              content : Text("Post Deleted", textAlign: TextAlign.center,)
                          )
                      );
                    }
                ) ] ): AlertDialog(
              title : Text('Cannot Complete Request', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              content : Text('Could not complete requests since you do not own this post.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue[900],
              actions : [
                FlatButton(child : Text('Okay', style: TextStyle( fontWeight: FontWeight.bold, color: Colors.orange[600])),
                    onPressed: () {Navigator.of(alertContext).pop();
                    }
                ),
              ] );

        } ); }

  //alert diolog that confirms if the logged in user want to request to join a study sessions if they are not already partiicipating in it
  static Future<void> requestConfirmation(BuildContext context, var postID, var authorName, var authoruid, var authorEmail, var course, bool author) {
    return showDialog(
        context : context,
        barrierDismissible : false,
        builder : (BuildContext alertContext) {
          return (author) ? AlertDialog(
              title : Text('Cannot Complete Request', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              content : Text('You already are participating/requested to join in this session.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue[900],
              actions : [
                FlatButton(child : Text('Okay', style: TextStyle( fontWeight: FontWeight.bold, color: Colors.orange[600])),
                    onPressed: () {Navigator.of(alertContext).pop();
                    }
                ),
              ] ) :
          AlertDialog(
              title : Text("Request To Join", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              content : Text("Are you sure you want to request to join $course study session?", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue[900],
              actions : [
                FlatButton(child : Text("Cancel", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white)),
                    onPressed: () {Navigator.of(alertContext).pop();}
                ),
                FlatButton(child : Text("Yes"),
                    color: Colors.orange[600],
                    onPressed : () async {
                      Chat chat = new Chat();
                      await chat.setupNewChat(authorName, authoruid, authorEmail, course, postID);
                      Navigator.of(alertContext).pop();
                      Scaffold.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor : Colors.green,
                              duration : Duration(seconds : 1),
                              content : Text('Message sent to author in chat.', textAlign: TextAlign.center,)
                          )
                      );
                    }
                ) ] ) ;
        } ); }
}