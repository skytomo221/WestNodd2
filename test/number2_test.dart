import "dart:io";
import "package:http/http.dart" as http;

import "package:nodd/number.dart";
import "package:nodd/libIO.dart";

class NumGenFromID implements StoredDataIO{
  List<String> ids = [];
  void loadOverHTTP(String url,WebAPIArch kind){}
  void writeOverHTTP(String url,WebAPIArch kind){}
  void loadFromLocal(String path){}
  void writeToLocal(String path){
    if(path.endsWith(".tab")){
      this.ids.addAll(File(path).readAsStringSync().split("\n"));
    }
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
}
