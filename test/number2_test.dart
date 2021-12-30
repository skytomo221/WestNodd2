import "dart:io";
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';

import "package:nodd/number.dart";
import "package:nodd/lib/io.dart";
import "package:nodd/lib/logger.dart";
import "package:nodd/lib/textformat.dart";
import "package:nodd/lib/tuple.dart";
class NumGenFromID implements StoredDataIO{
  List<String> ids = [];
  List<String> names = [];
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
      List<String> lines = File(path).readAsStringSync().split("\n");
      lines.forEach((String line){
        List<String> data = line.split(",");
        this.ids.add(data.last);
        this.names.add(data.first);
      });
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
    List<Tuple4<String,int,int,String>> wipes2 = wipes.withInHd<String>(this.names);
    //peint(wipes.toStr());
    File("./../data/ansHashes.tab").writeAsStringSync(wipes2.toStr(header: Tuple4<String,String,String,String>("Nick","ID","Hash3","Han3")));
    peint("# ./../data/ansHashes.tab(wipes) was written");

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
  ngfi.loadFromLocal("./../data/iduntable.tab");
  //peint(ngfi.idNr);
  ngfi.main();
  peint("& All program finished");
}

