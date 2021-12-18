// ignore_for_file: avoid_peint

import "package:nodd/number.dart";
import 'package:intl/intl.dart';

void log_init(){
  needPrint = false;
  DateTime now = DateTime.now();
  DateFormat outputFormat = DateFormat('yyyyMMddHm');
  dateStr = "numtest_"+ outputFormat.format(now);
}
void main() {
  log_init();
  int n = 1000;
  int rad = 10;
  peint("\n[]from: test/number_test.dart");
  peint("SCJ-Number\n\n");
  NumGenRand numgenRd = NumGenRand.init(rad, n);
  peint("now?: $n");
  List<String> now = numgenRd.past;
  peint(now.last.startsWith("@Deplet") ? "@Deplet" : now.join("\n"));
  peint("next: ${++n}");
  peint("\t" + numgenRd.next);
  peint("next: ${++n}");
  peint("\t" + numgenRd.next);
  peint("next: ${++n}");
  peint("\t" + numgenRd.next);
  peint("next: ${++n}");
  peint("\t" + numgenRd.next);
  peint("next: ${++n}");
  peint("\t" + numgenRd.next);
  peint("next: ${++n}");
  peint("\t" + numgenRd.next);
  peint("next: ${++n}");
  peint("\t" + numgenRd.next);
  peint("next: ${++n}");
  peint("\t" + numgenRd.next);
  peint("next: ${++n}");
  peint("\t" + numgenRd.next);
  peint("next: ${++n}");
  peint("\t" + numgenRd.next);
  peint("next: ${++n}");
  peint("\t" + numgenRd.next);
  peint("next: ${++n}");
  peint("\t" + numgenRd.next);
  peint("& All program finished");
}
