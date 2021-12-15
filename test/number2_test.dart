import "dart:io";
import "package:http/http.dart" as http;

import "package:nodd/number.dart";
import "package:nodd/libIO.dart";

class NumGenFromID implements StoredDataIO{
  List<String> ids = [];
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
    List<NumOnId> idns = this.idNr.map((int id)=>NumOnId(id)).toList();
    List<Tuple<int,String>> wipes = idns.map((NumOnId idn)=>idn.both()).toList();
    print(wipes.toStr());
  }
}
void main(){
  NumGenFromID ngfi = NumGenFromID();
  ngfi.loadFromLocal("./idtab.tab");
  //print(ngfi.idNr);
  ngfi.main();
}

