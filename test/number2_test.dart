import "dart:io";
import "package:http/http.dart" as http;

import "package:nodd/number.dart";
import "package:nodd/libIO.dart";

class NumGenFromID implements StoredDataIO{
  List<String> ids = [];
  List<String> rawDataI = [];
  void loadRawData(){
    print("\$\$NumGenFromID.loadRawData()");
    String rStr = File("./hanData.csv").readAsStringSync();
    this.rawDataI = rStr.split(whatCodeForNL(rStr)).map((String elm)=>elm.last).toList();
    File("rawDataI.tab").writeAsStringSync(this.rawDataI.join(", "));
    print("#./hanData.csv(${this.rawDataI.length}) was loaded");
  }
  void loadOverHTTP(String url,WebAPIArch kind){}
  void writeOverHTTP(String url,WebAPIArch kind){

  }
  void loadFromLocal(String path){
    if(path.endsWith(".tab")){
      this.ids.addAll(File(path).readAsStringSync().split("\n"));
      print("#$path(${this.ids.length}) was loaded");
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
    this.loadRawData();
    List<NumOnId> idns = this.idNr.map((int id)=>NumOnId(id,this.rawDataI)).toList();
    List<Tuple<int,int,String>> wipes = idns.map((NumOnId idn)=>idn.both()).toList();
    //print(wipes.toStr());
    File("ansHashes.lst").writeAsStringSync(wipes.toStr());
  }
}
void main(){
  NumGenFromID ngfi = NumGenFromID();
  ngfi.loadFromLocal("./idtab.tab");
  //print(ngfi.idNr);
  ngfi.main();
}

