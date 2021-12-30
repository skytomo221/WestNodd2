TableStyle mdStyle = TableStyle(" | ","| "," |","---");
TableStyle csvStyle = TableStyle(",","","","");
TableStyle tsvStyle = TableStyle("\t","","","");
class TableStyle{
  String delim;
  String coverHd;
  String coverTl;
  String headDelim;
  TableStyle(this.delim,this.coverHd,this.coverTl, this.headDelim);
  String convertRow<T>(List<T> tabRow){
    List<String> tabRowStr = tabRow.map((T elm)=>elm.toString()).toList();
    if(this.coverHd != ""){
      tabRowStr.insert(0,this.coverHd);
    }
    if(this.coverTl != ""){
      tabRowStr.add(this.coverTl);
    }
    return tabRowStr.join(this.delim);
  }
  String convert(){
    return "";
  }
}