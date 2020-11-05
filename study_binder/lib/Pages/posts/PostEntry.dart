//this file contains the entry screen where the user is prompt to provide all of the information reguarding a new study session

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:study_binder/Model/User.dart';


final _firestore = Firestore.instance;

class PostEntry extends StatefulWidget {

  static String id = '/post_entry';

  @override
  _PostEntryState createState() => _PostEntryState();
}

//staful calls that promts for the study session information
class _PostEntryState extends State<PostEntry> {

  final TextEditingController _courseTitleCountroller = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startTimeCountroller = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String course_name, location_name, start_time, end_time;
  DateTime startStamp, endStamp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Create A Study Group',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        leading: new Container(),
      ),
      backgroundColor: Colors.blueGrey[100],
      bottomNavigationBar: Container(
        color: Colors.blue[900],
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Material(
                elevation: 8.0,
                color: Colors.orange[600],
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  minWidth: 150.0,
                  onPressed: () async{
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Material(
                elevation: 8.0,
                color: Colors.orange[600],
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  minWidth: 150.0,
                  onPressed: (){
                    if(start_time == null || end_time == null) {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2), content: Text(
                              'Please Select The Start and End Times'),
                          )
                      );
                    }
                    _save(context);
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height : MediaQuery.of(context).size.width * 0.33),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.title),
                      title: TextFormField(
                        controller: _courseTitleCountroller,
                        decoration: InputDecoration(hintText: 'Cousre Number and Name', hintStyle: TextStyle(color: Colors.black)),
                        validator: (String value){
                          if(value.length == 0){
                            return 'Please Enter A Course Name And Title';
                          }
                          return null;
                        },
                        onChanged: (value){
                          course_name = value;
                        },
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(hintText: 'Location', hintStyle: TextStyle(color: Colors.black)),
                        validator: (String value){
                          if(value.length == 0){
                            return 'Please Enter A Location';
                          }
                          return null;
                        },
                        onChanged: (value){
                          location_name = value;
                        },
                      ),
                    ),
                      ListTile(
                      leading: Icon(Icons.timer),
                      title: Text(start_time ?? 'Select The Start Time Below', textAlign: TextAlign.center,)
                    ),
                    ListTile(
                      leading: Icon(Icons.timer_off),
                      title: Text(end_time ?? 'Select The End Time Below', textAlign: TextAlign.center,)
        ,
                    ),
                    Material(
                      elevation: 5.0,
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(30.0),
                      child: MaterialButton(
                        onPressed: () {

                          //below brings up the input date and time picker of the application which was imported from an external Dart package.
                          DateTimeRangePicker(
                              startText: 'Starting Time',
                              endText: 'Ending Time',
                              doneText: 'Confirm',
                              cancelText: 'Cancel',
                              interval: 5,
                              initialStartTime: DateTime.now(),
                              initialEndTime: DateTime.now().add(Duration(hours: 1)),
                              mode: DateTimeRangePickerMode.dateAndTime,
                              minimumTime: DateTime.now().subtract(Duration(days: 1)),
                              onConfirm: (start, end) {
                                var diff = end.difference(start);
                                if(start.isBefore(end) && (diff.inDays <= 7)) {
                                  setState(() {
                                    startStamp = start;
                                    endStamp = end;
                                    start_time =
                                        DateFormat.EEEE().add_jms().format(
                                            start);
                                    end_time =
                                        DateFormat.EEEE().add_jms().format(end);
                                  });
                                }

                                else{
                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                          backgroundColor : Colors.red,
                                          duration : Duration(seconds : 4),
                                          content: Text("Plese Select An End Time After The Start Time To Within 7 Days", textAlign: TextAlign.center,)
                                      )
                                  );
                                }
                              }).showPicker(context);
                        },
                        minWidth: 200.0,
                        height: 42.0,
                        child: Text(
                          'Enter Start And End Times',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //writes all the inputed data into the post section of the firebase if it is validated
  void _save(BuildContext context) async {
    if (!_formKey.currentState.validate() || start_time == null || end_time == null) {
      return;
    }

    await _firestore.collection('posts').add({'author' : User.displayName, 'authoruid' : User.loggedInUser.uid ,'email' : User.loggedInUser.email, 'course' : course_name ,
      'location' : location_name, 'startTime' : start_time, 'endTime': end_time, 'endingAt' : endStamp});
    await Future.delayed(Duration(milliseconds: 100));
    _courseTitleCountroller.clear();
    _courseTitleCountroller.clear();
    _startTimeCountroller.clear();
    _endTimeController.clear();

    Navigator.pop(context);
  }
}