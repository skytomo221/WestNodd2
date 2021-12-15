// ignore_for_file: avoid_print

import "package:nodd/number.dart";

void main() {
  int n = 86;
  int rad = 10;

  print("SCJ-Number\n\n");
  NumGenRand numgenRd = NumGenRand.init(rad, n);
  print("now?: $n");
  List<String> now = numgenRd.past;
  print(now.last.startsWith("@Deplet") ? "@Deplet" : now.join("\n"));
  print("next: ${++n}");
  print("\t" + numgenRd.next);
  print("next: ${++n}");
  print("\t" + numgenRd.next);
  print("next: ${++n}");
  print("\t" + numgenRd.next);
  print("next: ${++n}");
  print("\t" + numgenRd.next);
  print("next: ${++n}");
  print("\t" + numgenRd.next);
  print("next: ${++n}");
  print("\t" + numgenRd.next);
  print("next: ${++n}");
  print("\t" + numgenRd.next);
  print("next: ${++n}");
  print("\t" + numgenRd.next);
  print("next: ${++n}");
  print("\t" + numgenRd.next);
  print("next: ${++n}");
  print("\t" + numgenRd.next);
  print("next: ${++n}");
  print("\t" + numgenRd.next);
  print("next: ${++n}");
  print("\t" + numgenRd.next);
}
