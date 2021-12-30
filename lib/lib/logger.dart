import "dart:io";
import 'package:intl/intl.dart';

String dateStr = "";
String logFileName = "";
bool noticed = false;
bool needPrint = true;
void Function(Object?) peint = (Object? obj){
  DateTime now = DateTime.now();
  DateFormat outputFormat = DateFormat('HHmmss');
  String dateW = outputFormat.format(now);
  String logFileNameThis = "./../log/$dateStr.log";
  if(logFileName != logFileNameThis){
    noticed = false;
  }
  logFileName = logFileNameThis;
  File(logFileName).writeAsStringSync("$dateW:\t${obj.toString()}\n", mode: FileMode.append);
  if(needPrint){
    print(obj);
  }
  if(!noticed){
    print(logFileName);
    noticed = true;
  }
};

class Logger4L<T>{
  String Function(String, String) captPlace = (String capt, String body)=>"【$capt】\n$body";

  Map<String,T> log = {};
  void put(String ind, T val)=>this.log.putIfAbsent(ind,()=>val);
  @override
  String toString()=>this.log.map((String ind, T val)=>MapEntry(ind,this.captPlace(ind,val.toString()))).values.join("\n\n");
  void sprint(){
    print(this.toString());
  }
  void fprint(String path){
    File(path).writeAsStringSync(this.toString());
  }
}
