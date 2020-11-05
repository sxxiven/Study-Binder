// This file contains the hopme page of the Post tab which builds the lists of the current and planned study groups

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PostEntry.dart';
import 'package:study_binder/Model/User.dart';
import 'package:study_binder/Components/AlertDialogs.dart';

final _firestore = Firestore.instance;
enum choices{Request, Delete}

class Posts extends StatefulWidget {

  static String id = '/post';

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {

  PostStream stream = PostStream();

  Future<void> refreshPost()  async {
    await Future.delayed(Duration(seconds: 2));

    setState((){
      stream = new PostStream();
      });
    //return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, PostEntry.id);
          }
      ),
      body: RefreshIndicator(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            stream,
          ],
        ),
        onRefresh: refreshPost,
      )
    );
  }
}

class PostStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('bulding stream');
    return StreamBuilder<QuerySnapshot> (
      stream: _firestore.collection('posts').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: Text('There are currently no available study groups', style: TextStyle(
              fontSize: 25.0,
              color: Colors.black54,
            )),
          );
        }
        final posts = snapshot.data.documents.reversed;
        List<PostCard> postsCards = [];
        for(var post in posts){
          bool show = true;
          String postID = post.documentID;
          String authorEmail = post.data['email'];
          String author = post.data['author'];
          String authoruid = post.data['authoruid'];
          String course = post.data['course'];
          String location = post.data['location'];
          String startTime = post.data['startTime'];
          String endTime = post.data['endTime'];
          var endStamp = post.data['endingAt'].toDate();

          if(endStamp.isBefore(DateTime.now())){
            show = false;
            _firestore.collection('posts').document(postID).delete();
          }

          if (show) {
            final postCard = PostCard(author: author,
              course: course,
              location: location,
              startTime: startTime,
              endTime: endTime,
              postID: postID,
              email: authorEmail,
              authoruid: authoruid,);
            postsCards.add(postCard);
          }

        }

        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: postsCards,
          ),
        );
      },
    );
  }
}

class PostCard extends StatefulWidget {
  final String author, course, location, startTime, endTime, postID, email, authoruid;
  PostCard({this.author, this.course, this.location, this.startTime, this.endTime, this.postID, this.email, this.authoruid});

  @override
  _PostCardState createState() => _PostCardState(author: author, course: course, location: location, startTime: startTime, endTime: endTime, postID: postID, authorEmail: email, authoruid: authoruid);
}

class _PostCardState extends State<PostCard> {
  final String author, course, location, startTime, endTime, postID, authorEmail, authoruid;

  _PostCardState({this.author, this.course, this.location, this.startTime, this.endTime, this.postID, this.authorEmail, this.authoruid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Container(
        color: Colors.white,
        child: ListTile(
          trailing: PopupMenuButton <choices>(
            icon: Icon(Icons.arrow_drop_down, color: Colors.orange[600],),
            elevation: 30.0,
            color: Colors.blue[900],
            onSelected: (choices result)async{
                setState(() {
                });
              if(result == choices.Delete){
                alertDialogs.deleteConfirmation(context, postID, authorEmail == User.loggedInUser.email);
              }
              if(result == choices.Request){
                bool participating = await checkAlreadyParicipating(postID, authorEmail);
                alertDialogs.requestConfirmation(context, postID, author, authoruid, authorEmail, course, participating);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<choices>> [
              const PopupMenuItem<choices>(
                value: choices.Request,
                child: Text('Request to join', style: TextStyle(color: Colors.white),),
              ),
              const PopupMenuItem<choices>(
                value: choices.Delete,
                child: Text('Delete post', style: TextStyle(color: Colors.white),),
              )
            ]
          ),
          title: Text(course, style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 6.0,),
              Text('Poseted by:', style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold
              ),),
              Text(author, style: TextStyle(
                fontSize: 16.0,
              ),),
              SizedBox(height: 2.0,),
              Text('Where:', style: TextStyle(
                fontSize: 16.0,
                  fontWeight: FontWeight.bold
              ),),
              Text(location, style: TextStyle(
                fontSize: 16.0,
              ),),
              SizedBox(height: 2.0,),
              Text('Starting At:', style: TextStyle(
                fontSize: 16.0, fontWeight: FontWeight.bold
              ),),
              Text(startTime, style: TextStyle(
                fontSize: 16.0,
              ),),
              SizedBox(height: 2.0,),
              Text('Ending At:', style: TextStyle(
                fontSize: 16.0, fontWeight: FontWeight.bold
              ),),
              Text(endTime, style: TextStyle(
                fontSize: 16.0,
              ),),
              SizedBox(height: 6.0,),
            ],
          ),
        ),
      ),
    );
  }

  //this function checks if the logged in user is requesting to join a studdy session that they are already part of (they are the
  // origional author or they alreadt rquestested it) by checking the post's author and unique ID. If they are not already participating it,
  // then a function is called to create a new chat room and an automated message is sent to the author to request to join.
  Future<bool> checkAlreadyParicipating(String PostID, String authorEmail) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('chat')
        .where('postID', isEqualTo: PostID)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    bool checkResult = (documents.length == 1) || (authorEmail == User.loggedInUser.email);
    return checkResult;
  }

}

