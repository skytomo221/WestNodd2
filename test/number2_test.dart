import "dart:io";
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';

import "package:nodd/number.dart";
import "package:nodd/libIO.dart";
class NumGenFromID implements StoredDataIO{
  List<String> ids = [];
  List<String> rawDataI = [];
  NumGenFromID(){
    peint("\$ NumGenFromID()");
  }
  void loadRawData(){
    peint("\$ NumGenFromID.loadRawData()");
    String rStr = File("./../data/hanData.csv").readAsStringSync();
    this.rawDataI = rStr.split(whatCodeForNL(rStr)).map((String elm)=>elm.last).toList();
    peint("# ./../data/hanData.csv(${this.rawDataI.length}) was loaded");
    File("./../data/hanData.lst").writeAsStringSync(this.rawDataI.join(", "));
    peint("# ./../data/hanData.lst(${this.rawDataI.length}) was wretten");
  }
  void loadOverHTTP(String url,WebAPIArch kind){}
  void writeOverHTTP(String url,WebAPIArch kind){

  }
  void loadFromLocal(String path){
    peint("\$ NumGenFromID.loadFromLocal($path)");
    if(path.endsWith(".tab")||path.endsWith(".lst")){
      this.ids.addAll(File(path).readAsStringSync().split("\n"));
      peint("# $path(${this.ids.length}) was loaded");
    }
  }
  void writeToLocal(String path){
  }
  List<int> get idNr=>this.ids.map((String idS){
      late int idN;
      try{
        idN = int.parse(idS);
      }catch (e){
        idN = -999;
      }
      return idN;
  }).where((int idN)=>idN>0).toList();
  void main(){
    peint("\$ NumGenFromID.main()");
    this.loadRawData();
    List<NumOnId> idns = this.idNr.map((int id)=>NumOnId(id,this.rawDataI)).toList();
    peint("# List NumOnId Instance Created(${idns.length})");
    List<Tuple3<int,int,String>> wipes = idns.map((NumOnId idn)=>idn.both()).toList();
    //peint(wipes.toStr());
    File("./../data/ansHashes.lst").writeAsStringSync(wipes.toStr());
    peint("# ./../data/ansHashes.lst(wipes) was written");

  }
}
void log_init(){
  needPrint = false;
  DateTime now = DateTime.now();
  DateFormat outputFormat = DateFormat('yyyyMMddHmm');
  dateStr = "num2test_"+ outputFormat.format(now);
}
void main(){
  log_init();
  peint("\n[]from: test/number_test2.dart");
  peint("\$ ~global.main()");
  NumGenFromID ngfi = NumGenFromID();
  ngfi.loadFromLocal("./../data/idlist.lst");
  //peint(ngfi.idNr);
  ngfi.main();
  peint("& All program finished");
}

