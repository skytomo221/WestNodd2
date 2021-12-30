import "dart:io";

import "package:nodd/number.dart";
import "package:nodd/lib/io.dart";

enum NumStyle{
  invalid,
  oldStyle,
  newStyle
}
class NrSysComp{
  String oldS;
  String newS;
  NrSysComp(this.oldS,this.newS);
}
extension SearchNr on List<NrSysComp>{
  String getNew(String oldS){
    return this.where((NrSysComp ncp)=>ncp.oldS==oldS).first.newS;
  }
  String getOld(String newS){
    return this.where((NrSysComp ncp)=>ncp.newS==newS).first.oldS;
  }
}

class NickConverter implements StoredDataIO{
  NickCtl nx = NickCtl();
  List<NrSysComp> compTab = [];
  NickConverter();
  void loadOverHTTP(String url,WebAPIArch kind){}
  void writeOverHTTP(String url,WebAPIArch kind){}
  void loadFromLocal(String path){
    String sourceTab = File(path).readAsStringSync();
    List<String> tabList = sourceTab.split("\n");
    List<NrSysComp> compTabTp = tabList.map<List<String>>((String l)=>l.split(":")).where((List<String> l)=>l.length==2).map<NrSysComp>((List<String> l)=>NrSysComp(l[0],l[1])).toList();
    compTabTp.addAll(this.compTab);
    this.compTab = compTabTp.toSet().toList();
  }
  void writeToLocal(String path){}
  String toNew(String nickOld){
    if(nx.isOldStyleNick(nickOld)){
      return compTab.getNew(nickOld);
    }else{
      return nickOld;
    }
  }
  String toOld(String nickNew){
    if(nx.isNewStyleNick(nickNew)){
      return compTab.getOld(nickNew);
    }else{
      return nickNew;
    }
  }
}
class NickCtl{
  String oldSuffix = r"（Ｎｏ．[０-９]+）$";
  String newSuffix = r"#[0-9]{3}$";
  String new2Suffix = r"#.{3}[0-9]{3}$";
  bool isValidNick(String nick)=>isOldStyleNick(nick)||isNewStyleNick(nick);
  bool isOldStyleNick(String nick)=>RegExp(this.oldSuffix).hasMatch(nick);
  bool isNewStyleNick(String nick)=>RegExp(this.newSuffix).hasMatch(nick);
  NumStyle numStyleOfNick(String nick,[NumStyle mode = NumStyle.oldStyle]){
    if(this.isValidNick(nick)){
      if(mode == NumStyle.oldStyle){
        if(this.isOldStyleNick(nick)){
          return NumStyle.oldStyle;
        }else{
          return NumStyle.newStyle;
        }
      }else if(mode == NumStyle.newStyle){
        if(this.isNewStyleNick(nick)){
          return NumStyle.newStyle;
        }else{
          return NumStyle.oldStyle;
        }
      }else{
        return NumStyle.invalid;
      }
    }else{
      return NumStyle.invalid;
    }
    if(this.isNewStyleNick(nick)){
      return NumStyle.newStyle;
    }else if(this.isOldStyleNick(nick)){
      return NumStyle.oldStyle;
    }else{
    }
  }
}
