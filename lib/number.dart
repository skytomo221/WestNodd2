import "dart:math";
import "dart:io";
import "package:http/http.dart" as http;
import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart';
// ignore: implementation_imports
import "package:pointycastle/src/utils.dart";
import 'package:intl/intl.dart';

import "package:nodd/libIO.dart";

String dateStr = "";
String logFileName = "";
bool noticed = false;
bool needPrint = true;
void Function(Object?) peint = (Object? obj){
  DateTime now = DateTime.now();
  DateFormat outputFormat = DateFormat('ddHmmss');
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
extension StringOpr on String{
  String get last=>this.split(",").last;
}
class Tuple3<F,M,L>{
  F first;
  M middle;
  L last;
  Tuple3(this.first,this.middle,this.last);
  @override
  String toString(){
    return [this.first.toString(),this.middle.toString(),this.last.toString()].join(" : ");
  }
}
class Tuple2<F,L>{
  F first;
  L last;
  Tuple2(this.first,this.last);
  @override
  String toString(){
    return [this.first.toString(),this.last.toString()].join(" : ");
  }
}
extension Prinyer<F,M,L> on List<Tuple3<F,M,L>>{
  @override
  String toStr(){
    return this.map((Tuple3<F,M,L> tup)=>tup.toString()).join("\n");
  }
}
String whatCodeForNL(String base){
  if(base.contains("\r\n")){
    peint("% CodeForNL is \\r\\n");
    return "\r\n";
  }else if(base.contains("\r")){
    return "\r";
    peint("% CodeForNL is \\n");
  }else{
    peint("% CodeForNL is \\n");
    return "\n";
  }
}
class NumOnId{
  int id;
  List<String> rawDataI = [];
  NumOnId(this.id,[List<String>? rawData]){
    if(rawData != null){
      //peint("\$ NumOnID()");
      this.rawDataI = rawData;
      //peint("# this.rawdata = arg(${this.rawDataI.length})");
    }else{
      //peint("\$ NumOnID.loadRawData()");
      this.loadRawData();
      //peint("# ./hanData.csv(${this.rawDataI.length}) was loaded");
    }
  }
  void loadRawData(){
    String rStr = File("./hanData.csv").readAsStringSync();
    this.rawDataI = rStr.split(whatCodeForNL(rStr)).map((String elm)=>elm.last).toList();
  }
  Tuple3<int,int,String> both(){
    //peint("id: ${this.id}");
    //peint("hash: ${this.withHash()}");
    //peint("han: ${this.withHan()}");
    return Tuple3<int,int,String>(this.id,this.withHash(),this.withHan());
  }
  String _rawHan(int raw){
    //peint("rawdata(${rawData.length}): $rawData");
    if(raw < 0 || this.rawDataI.length <= raw){
      return "??";
    }else{
      return this.rawDataI[raw];
    }
  }
  String _rawHans(List<int> raws){
    return raws.map((int el)=>this._rawHan(el)).join("");
  }
  String withHan(){
    int tmp1 = ((this.id %  pow(10,8)).floor()/pow(633,2)).floor();
    int tmp2 = ((this.id %  pow(10,8)).floor()/633).floor() - tmp1*633;
    int tmp3 = ((this.id %  pow(10,8)).floor() %  633).floor();
    //peint([tmp1,tmp2,tmp3]);
    return this._rawHans([tmp1,tmp2,tmp3]);
  }
  int withHash() {
    Digest keccak = Digest("Keccak/128");
    Uint8List chunk = Uint8List.fromList([this.id >> 24, this.id >> 16, this.id >> 8, this.id]);
    keccak.update(chunk, 0, chunk.length);
    Uint8List hash = Uint8List(keccak.digestSize);
    keccak.doFinal(hash, 0);
    return (decodeBigInt(hash) %  BigInt.from(900)).toInt() + 100;
  }
}
class NumGenRand {
  late int _radix;
  late List<String> _past;
  bool _deplet = false;
  NumGenRand(int radix) {
    this._past = [];
    this._radix = radix;
    this.isDepletSet;
  }
  NumGenRand.init(int radix, int n) {
    this._radix = radix;
    try{
      this._past = numgenRdForN(n, this._radix);
    }on StackOverflowError catch (e){
      this._past = [];
      this._past.add("@Deplet Stack Overflow");
      this.isDepletSet;
    }
    this.isDepletSet;
  }
  List<String> genForN(int n) {
    if (!isDeplet) {
      List<String> ngfn = numgenRdForN_I(n, this._radix, this._past);
      this._past.addAll(ngfn);
      this.isDepletSet;
      return ngfn;
    } else {
      return ["@Deplet ${past.length + 1}"];
    }
  }

  void get isDepletSet {
    if (this._past.last.startsWith("@")) {
      if (this._past.last == "@Deplet") {
        this._deplet = true;
      }
    }
  }

  bool get isDeplet => _deplet;
  String get next {
    if (!isDeplet) {
      Tuple2<int,String> ng = numgenRd(this._radix, this._past);
      peint("Count of Attempts(in ${past.length + 1}): ${ng.first}");
      this._past.add(ng.last);
      this.isDepletSet;
      return ng.last;
    } else {
      return "@Deplet ${past.length + 1}";
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
    Tuple2<int,String> next = numgenRd(radix, past);
    String addit = next.first > 1 ? " [! Heavy]" : "";
    peint("Count of Attempts(in ${past.length + 1}, Remaining: ${n - 1}): ${next.first}$addit");
    past.add(next.last);
    return numgenRdForN_I(n - 1, radix, past);
  }
}

Tuple2<int,String> numgenRd(int radix, List<String> past,[int cout = 0]) {
  int len = 3;
  cout++;
  String ni = Random.secure()
      .nextInt((pow(radix, len) - 1).floor())
      .toRadixString(radix)
      .toUpperCase();
  if (ni.length != len || ni.startsWith("0") || past.contains(ni)) {
    return numgenRd(radix, past, cout);
  } else {
    return Tuple2<int,String>(cout,ni);
  }
}
