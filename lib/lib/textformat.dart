import "package:nodd/lib/logger.dart";

extension StringOpr on String{
  String get last=>this.split(",").last;
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
