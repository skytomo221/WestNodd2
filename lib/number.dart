import "dart:math";
import "dart:io";
import "package:http/http.dart" as http;
import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart';
// ignore: implementation_imports
import "package:pointycastle/src/utils.dart";
import 'package:intl/intl.dart';

import "package:nodd/lib/io.dart";
import "package:nodd/lib/tuple.dart";
import "package:nodd/lib/textformat.dart";
import "package:nodd/lib/logger.dart";


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
