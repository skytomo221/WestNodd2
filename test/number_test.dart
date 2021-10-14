import "package:nodd/number.dart";
void main(){
  
  int n = 86;
  int rad = 10;

  print("SCJ-Number\n\n");
  NumGen numgen = NumGen.init(rad,n);
  print("now?: $n");
  List<String> now = numgen.past;
  print(now.last.startsWith("@Deplet") ? "@Deplet" : now.join("\n"));
  print("next: ${++n}");
  print("\t" + numgen.next);
  print("next: ${++n}");
  print("\t" + numgen.next);
  print("next: ${++n}");
  print("\t" + numgen.next);
  print("next: ${++n}");
  print("\t" + numgen.next);
  print("next: ${++n}");
  print("\t" + numgen.next);
  print("next: ${++n}");
  print("\t" + numgen.next);
  print("next: ${++n}");
  print("\t" + numgen.next);
  print("next: ${++n}");
  print("\t" + numgen.next);
  print("next: ${++n}");
  print("\t" + numgen.next);
  print("next: ${++n}");
  print("\t" + numgen.next);
  print("next: ${++n}");
  print("\t" + numgen.next);
  print("next: ${++n}");
  print("\t" + numgen.next);
}
