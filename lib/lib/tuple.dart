import "package:nodd/lib/collect.dart";
import "package:nodd/lib/table.dart";
enum AddKind{
  head,
  tail,
}
abstract class Tuple{
}
class Tuple4<F,S,M,L> extends Tuple{
  F first;
  S second;
  M middle;
  L last;
  TableStyle tabSty = TableStyle(" ： ","","","");
  String delim = " : ";
  Tuple4(this.first,this.second,this.middle,this.last,{TableStyle? style}){
    style != null ? this.tabSty = style : (){}();
  }
  @override
  String toString(){
    return this.tabSty.convertRow([this.first.toString(),this.second.toString(),this.middle.toString(),this.last.toString()]);
  }
}
class Tuple3<F,M,L> extends Tuple{
  F first;
  M middle;
  L last;
  TableStyle tabSty = TableStyle(" ： ","","","");
  Tuple3(this.first,this.middle,this.last,{TableStyle? style}){
    style != null ? this.tabSty = style : (){}();
  }
  Tuple4<N,F,M,L> addHd<N>(N data)=>Tuple4<N,F,M,L>(data,this.first,this.middle,this.last);
  Tuple4<F,M,L,N> addTl<N>(N data)=>Tuple4<F,M,L,N>(this.first,this.middle,this.last,data);
  @override
  String toString(){
    return this.tabSty.convertRow([this.first.toString(),this.middle.toString(),this.last.toString()]);
  }
}
class Tuple2<F,L> extends Tuple{
  F first;
  L last;
  TableStyle tabSty = TableStyle(" ： ","","","");
  Tuple2(this.first,this.last,{TableStyle? style}){
    style != null ? this.tabSty = style : (){}();
  }
  Tuple3<N,F,L> addHd<N>(N data)=>Tuple3<N,F,L>(data,this.first,this.last);
  Tuple3<F,L,N> addTl<N>(N data)=>Tuple3<F,L,N>(this.first,this.last,data);
  @override
  String toString(){
    return this.tabSty.convertRow([this.first.toString(),this.last.toString()]);
  }
}
extension Prinyer2<F,L> on List<Tuple2<F,L>>{
  @override
  String toStr({Tuple2<String,String>? header}){
    List<String> data = this.map((Tuple2<F,L> tup)=>tup.toString()).toList();
    data.insert(0,header.toString());
    return data.join("\n");
  }
}
extension Prinyer3<F,M,L> on List<Tuple3<F,M,L>>{
  @override
  String toStr({Tuple3<String,String,String>? header}){
    List<String> data = this.map((Tuple3<F,M,L> tup)=>tup.toString()).toList();
    data.insert(0,header.toString());
    return data.join("\n");
  }
}
extension Prinyer4<F,S,M,L> on List<Tuple4<F,S,M,L>>{
  @override
  String toStr({Tuple4<String,String,String,String>? header}){
    List<String> data = this.map((Tuple4<F,S,M,L> tup)=>tup.toString()).toList();
    data.insert(0,header.toString());
    return data.join("\n");
  }
}
extension With3<F,M,L> on List<Tuple3<F,M,L>>{
  List<Tuple4<N,F,M,L>> withInHd<N>(List<N> data)=>this.indexedMap((int ind, Tuple3<F,M,L> t3)=>t3.addHd<N>(data[ind])).toList();
  List<Tuple4<F,M,L,N>> withInTl<N>(List<N> data)=>this.indexedMap((int ind, Tuple3<F,M,L> t3)=>t3.addTl<N>(data[ind])).toList();
}
