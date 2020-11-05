// this files construst the courses home page as well os the office hours of the TA's and IA's

import 'package:flutter/material.dart';
import 'package:study_binder/Model/Model.dart' as model;
import 'package:study_binder/Model/User.dart';

model.Class classes = new model.Class();
int _class;

class Classes extends StatefulWidget {

  static String id = '/classes';

  @override
  _ClassesState createState() => _ClassesState();
}


//this class constructs the home page which builds a gridbview of the current available courses for viewing.
class _ClassesState extends State<Classes> {
  List classes_details = classes.class_names;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TA/IA Office Hours',
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
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        padding: EdgeInsets.all(10),
        //color: Theme.of(context).primaryColor,
        child: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(classes_details.length, (index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              color: Theme.of(context).accentColor,
              elevation: 20,
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(padding:EdgeInsets.all(10) ,child: Text(classes_details[index][0], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                    Expanded(child: Container(padding:EdgeInsets.all(10), color: Colors.white, child: Text(classes_details[index][1], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
                  ],
                ),
                onTap: () {
                  set_class_office_hours(index);
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  void set_class_office_hours(int class_num) {
    _class = class_num;
    Navigator.pushNamed(context, '/office_hours');
  }
}

//this class builds the information of the TA's and IA's to be shown from readint the textfile that is attached.
class OfficeHours extends StatelessWidget {
  String classname = classes.class_names[_class][0];
  static String id = '/office_hours';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(classname,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: new ListView.separated(
            separatorBuilder: (context, index) =>
                Padding(padding: EdgeInsets.all(10.0)),
            itemCount: classes.class_info[classname].length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  color: Theme.of(context).hintColor,
                  shape: ContinuousRectangleBorder(
                    side: BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        color: Theme.of(context).accentColor,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                classes
                                    .class_info[classname][index].studentName,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Text(classes.class_info[classname][index].type,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: new ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: classes
                                .class_info[classname][index].days.length,
                            itemBuilder: (BuildContext context, int Index) {
                              return Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Location',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            classes.class_info[classname][index]
                                                .location,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontStyle: FontStyle.italic)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Days',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            classes.class_info[classname][index]
                                                .days[Index],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontStyle: FontStyle.italic)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Times',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            classes.class_info[classname][index]
                                                .startTime[Index] +
                                                ' - ' +
                                                classes
                                                    .class_info[classname]
                                                [index]
                                                    .endTime[Index],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontStyle: FontStyle.italic)),
                                      ],
                                    ),
                                    Container(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ));
            }),
      ),
    );
  }
}