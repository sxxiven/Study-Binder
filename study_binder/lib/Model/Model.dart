//this files contains the model for reading the office hours from the text file.
import 'package:flutter/services.dart' show rootBundle;

//contains the office hourse for all available classes
class Class {
  var class_info = {'CS 1301': [], 'CS 2401': [],'CS 2302': [],'CS 3331': [],'CS 3350': [],'CS 3360': [],'CS 3432': [],'CS 4310': [],'CS 4311': [],'CS 4375': []};
  List class_names = [['CS 1301','Introduction to CS'], ['CS 2401','Elementry Data Strucures'], ['CS 2302','Data Strucutres'], ['CS 3331','Adv. Objected-Oriented Programming'], ['CS 3350','Automata'], ['CS 3360','Programming Languages'],['CS 3432','Computer Architecture 1'],['CS 4310','Software Engineering 1'],['CS 4311','Software Engineering 2'],['CS 4375','Operating Systems']];

  String filename = 'assets/res/OHlist.txt';

  Class(){
    read_text_file();
  }

  void read_text_file() async{
    String data = await getFileData(filename);
    List info = data.split('#');
    for(int i = 0; i < 30; i++){
      List tempList = info[i].split(';');
      class_info[tempList[0].replaceAll('\n', '')].add(OfficeHour(tempList[1], tempList[2], tempList[3], tempList[4].split('-'), tempList[5].split('-'), tempList[6].split('-')));
    }
   }

  /// Assumes the given path is a text-file-asset.
  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  List get_class_names(){
    return class_names;
  }
}

//contains the indevidual properties of a faculty
class OfficeHour{
  String studentName, location, type;
  List <String> days, startTime, endTime;

  OfficeHour(String this.type, String this.studentName, String this.location, List<String> this.days, List<String>  this.startTime, List<String>  this.endTime);

}