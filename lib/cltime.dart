import "dart:math";

//todo: channelid etc.が準備できたらon intのものはそれらのラップとする
extension ServerTime on int{
  DateTime get serverCreatedTime{
    int epoch = (this / 4194304).floor() + 1420070400000;
    return DateTime.fromMillisecondsSinceEpoch(epoch);
  }
  /*
  DateTime get channelCreatedTime{}
  DateTime get massageSendTime{}
  */
}
extension ToIntParse on String{
  int get toInt => int.parse(this);
}