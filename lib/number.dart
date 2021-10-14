import "dart:math";
class NumGen{
  late int _radix;
  late List<String> _past;
  bool _deplet = false;
  NumGen(int radix){
    this._past = [];
    this._radix = radix;
    this.isDepletSet;
  }
  NumGen.init(int radix,int n){
    this._radix = radix;
    this._past = numgenForN(n, this._radix);
    this.isDepletSet;
  }
  List<String> genForN(int n){
    if(!this.isDeplet){
      List<String> ngfn = numgenForN_I(n, this._radix,this._past);
      this._past.addAll(ngfn);
      this.isDepletSet;
      return ngfn;
    }else{
      return ["@Deplet ${this.past.length-1}"];
    }
  }
  void get isDepletSet{
    if(this._past.last.startsWith("@")){
      if(this._past.last=="@Deplet"){
        this._deplet = true;
      }
    }
  }
  bool get isDeplet => this._deplet; 
  String get next{
    if(!this.isDeplet){
      String ng = numgen(this._radix, this._past);
      this._past.add(ng);
      this.isDepletSet;
      return ng;
    }else{
      return "@Deplet ${this.past.length-1}";
    }
  }
  List<String> get past => this._past;
  
}
List<String> numgenForN(int n, int radix){
  return numgenForN_I(n, radix, []);
}
List<String> numgenForN_I(int n, int radix, List<String> past){
  if(n <= 0){
    return past.reversed.toList();
  }else if((n+past.length) > (pow(radix,2).floor()*(radix+1))){
    //[1-radix][1-radix][0-radix]
    return past.reversed.toList()..add("@Deplet");
  }else{
    String next = numgen(radix, past);
    past.add(next);
    return numgenForN_I(n - 1, radix, past);
  }
}
String numgen(int radix, List<String> past){
  int len = 3;
  String ni = Random.secure().nextInt((pow(radix,len)-1).floor()).toRadixString(radix).toUpperCase();
  if(ni.length != len ||ni.startsWith("0") || past.contains(ni)){
    return numgen(radix, past);
  }else{
    return ni;
  }
}