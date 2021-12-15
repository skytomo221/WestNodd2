import "package:nodd/number.dart";
import "dart:math";
import "dart:io";

void main(){
  int getForN = 10;
  Logger4L<LogList<String>> logger =Logger4L<LogList<String>>();
  List<String> nickSampleOld = ["あづまにゃん（Ｎｏ．１）","りめすとり（Ｎｏ．２）","多々井ゆかり（Ｎｏ．３）","skytomo（Ｎｏ．４）","Ziphineko（Ｎｏ．３０）","佐藤陽花 Haruka Sato（Ｎｏ．６５）",
  "にふ（Ｎｏ．２７）","Xirdim（Ｎｏ．６８）","るる（Ｎｏ．１８）","Acsitol（Ｎｏ．８１）","yuhr（Ｎｏ．３４）"];
  logger.put("nickSampleOld",LogList<String>(nickSampleOld));
  List<String> nickSampleNew = ["","","","","","","","","","",""];
  logger.put("nickSampleNew",LogList<String>(nickSampleNew));
  List<String> nickSampleInvalid = ["がーねっと @自作言語","がーねっと#9502","thd：佐藤陽花#7369","Rhemestry#0111","Xirdim#9996","かつ２１/暁語たん"];
  logger.put("nickSampleInvalid",LogList<String>(nickSampleInvalid));
  List<String> flashedWithOutInvalid = [nickSampleNew,nickSampleOld,nickSampleInvalid].flash(getForN);
  logger.put("flashedWithOutInvalid",LogList<String>(flashedWithOutInvalid));
  List<String> flashedWithInvalid = [nickSampleNew,nickSampleOld].flash(getForN);
  logger.put("flashedWithInvalid",LogList<String>(flashedWithInvalid));
  NickCtl nctl = NickCtl();
  List<NumStyle> modeForOldWithOutInvalid = flashedWithOutInvalid.map((String nick)=>nctl.numStyleOfNick(nick)).toList();
  logger.put("modeForOldWithOutInvalid",LogList<String>(modeForOldWithOutInvalid.toIString()));
  List<NumStyle> modeForNewWithOutInvalid = flashedWithOutInvalid.map((String nick)=>nctl.numStyleOfNick(nick, NumStyle.newStyle)).toList();
  logger.put("modeForNewWithOutInvalid",LogList<String>(modeForNewWithOutInvalid.toIString()));
  List<NumStyle> modeForOldWithInvalid = flashedWithInvalid.map((String nick)=>nctl.numStyleOfNick(nick)).toList();
  logger.put("modeForOldWithInvalid",LogList<String>(modeForOldWithInvalid.toIString()));
  List<NumStyle> modeForNewWithInvalid = flashedWithInvalid.map((String nick)=>nctl.numStyleOfNick(nick, NumStyle.newStyle)).toList();
  logger.put("modeForNewWithInvalid",LogList<String>(modeForNewWithInvalid.toIString()));
  logger.fprint("./log/nicsty.131221.tz");
}
class LogList<T>{
  List<T> ls;
  bool Function(int) isNL = (int ind)=>ind % 5 == 4;
  LogList(this.ls);
  @override
  String toString()=>this.ls.indexedMap((int ind, T val)=>this.isNL(ind) ? val.toString() + "\n" : val.toString()).join(", ");
}
class Logger4L<T>{
  String Function(String, String) captPlace = (String capt, String body)=>"【$capt】\n$body";

  Map<String,T> log = {};
  void put(String ind, T val)=>this.log.putIfAbsent(ind,()=>val);
  @override
  String toString()=>this.log.map((String ind, T val)=>MapEntry(ind,this.captPlace(ind,val.toString()))).values.join("\n\n");
  void sprint(){
    print(this.toString());
  }
  void fprint(String path){
    File(path).writeAsStringSync(this.toString());
  }
}
extension Flassher<T> on List<List<T>>{
  List<T> flash(int getNr){
    Random rds = Random.secure();
    List<T> mearged = this.expand((List<T> i) => i).toList();
    mearged.shuffle(rds);
    return mearged.take(getNr).toList();
  }
}
extension ListInToString<T> on List<T>{
  List<String> toIString()=>this.map((T val)=>val.toString()).toList();
}
extension IndexedMap<T, E> on List<T> {
  List<E> indexedMap<E>(E Function(int index, T item) function) {
    final list = <E>[];
    asMap().forEach((index, element) {
      list.add(function(index, element));
    });
    return list;
  }
}