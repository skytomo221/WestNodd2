import "dart:math";
import "dart:io";
import "package:http/http.dart" as http;
import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart';
// ignore: implementation_imports
import "package:pointycastle/src/utils.dart";

import "package:nodd/libIO.dart";

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
extension StringOpr on String{
  String get last=>this.split("").last;
}
class NumOnId{
  int id;
  NumOnId(this.id);
  String _rawHan(int raw){
    List<String> rawData = File("./hanData.csv").readAsStringSync().split("\n").map((String elm)=>elm.last).toList();
    if(raw < 0 || rawData.length <= raw){
      return "";
    }else{
      return rawData[raw];
    }
  }
  String _rawHans(List<int> raws){
    return raws.map((int el)=>this._rawHan(el)).join("");
  }
  String withHan(){
    int tmp1 = ((this.id % pow(10,8)).floor()/pow(633,2)).floor();
    int tmp2 = ((this.id % pow(10,8)).floor()/633).floor() - tmp1*633;
    int tmp3 = ((this.id % pow(10,8)).floor() % 633).floor();
    return this._rawHans([tmp1,tmp2,tmp3]);
  }
  int withHash() {
    Digest keccak = Digest("Keccak/128");
    Uint8List chunk = Uint8List.fromList([this.id >> 24, this.id >> 16, this.id >> 8, this.id]);
    keccak.update(chunk, 0, chunk.length);
    Uint8List hash = Uint8List(keccak.digestSize);
    keccak.doFinal(hash, 0);
    return (decodeBigInt(hash) % BigInt.from(900)).toInt() + 100;
  }
}
class NumGenRand {
  late int _radix;
  late List<String> _past;
  bool _deplet = false;
  NumGenRand(int radix) {
    _past = [];
    _radix = radix;
    isDepletSet;
  }
  NumGenRand.init(int radix, int n) {
    _radix = radix;
    _past = numgenRdForN(n, _radix);
    isDepletSet;
  }
  List<String> genForN(int n) {
    if (!isDeplet) {
      List<String> ngfn = numgenRdForN_I(n, _radix, _past);
      _past.addAll(ngfn);
      isDepletSet;
      return ngfn;
    } else {
      return ["@Deplet ${past.length - 1}"];
    }
  }

  void get isDepletSet {
    if (_past.last.startsWith("@")) {
      if (_past.last == "@Deplet") {
        _deplet = true;
      }
    }
  }

  bool get isDeplet => _deplet;
  String get next {
    if (!isDeplet) {
      String ng = numgenRd(_radix, _past);
      _past.add(ng);
      isDepletSet;
      return ng;
    } else {
      return "@Deplet ${past.length - 1}";
    }
  }

  List<String> get past => _past;
}

List<String> numgenRdForN(int n, int radix) {
  return numgenRdForN_I(n, radix, []);
}

// ignore: non_constant_identifier_names
List<String> numgenRdForN_I(int n, int radix, List<String> past) {
  if (n <= 0) {
    return past.reversed.toList();
  } else if ((n + past.length) > (pow(radix, 2).floor() * (radix + 1))) {
    //[1-radix][1-radix][0-radix]
    return past.reversed.toList()..add("@Deplet");
  } else {
    String next = numgenRd(radix, past);
    past.add(next);
    return numgenRdForN_I(n - 1, radix, past);
  }
}

String numgenRd(int radix, List<String> past) {
  int len = 3;
  String ni = Random.secure()
      .nextInt((pow(radix, len) - 1).floor())
      .toRadixString(radix)
      .toUpperCase();
  if (ni.length != len || ni.startsWith("0") || past.contains(ni)) {
    return numgenRd(radix, past);
  } else {
    return ni;
  }
}
