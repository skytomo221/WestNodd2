import "dart:math";

class NumGen {
  late int _radix;
  late List<String> _past;
  bool _deplet = false;
  NumGen(int radix) {
    _past = [];
    _radix = radix;
    isDepletSet;
  }
  NumGen.init(int radix, int n) {
    _radix = radix;
    _past = numgenForN(n, _radix);
    isDepletSet;
  }
  List<String> genForN(int n) {
    if (!isDeplet) {
      List<String> ngfn = numgenForN_I(n, _radix, _past);
      _past.addAll(ngfn);
      isDepletSet;
      return ngfn;
    } else {
      return ["@Deplet ${past.length - 1}"];
    }
  }

  void get isDepletSet {
    if (_past.last.startsWith("@")) {
      if (_past.last == "@Deplet") {
        _deplet = true;
      }
    }
  }

  bool get isDeplet => _deplet;
  String get next {
    if (!isDeplet) {
      String ng = numgen(_radix, _past);
      _past.add(ng);
      isDepletSet;
      return ng;
    } else {
      return "@Deplet ${past.length - 1}";
    }
  }

  List<String> get past => _past;
}

List<String> numgenForN(int n, int radix) {
  return numgenForN_I(n, radix, []);
}

// ignore: non_constant_identifier_names
List<String> numgenForN_I(int n, int radix, List<String> past) {
  if (n <= 0) {
    return past.reversed.toList();
  } else if ((n + past.length) > (pow(radix, 2).floor() * (radix + 1))) {
    //[1-radix][1-radix][0-radix]
    return past.reversed.toList()..add("@Deplet");
  } else {
    String next = numgen(radix, past);
    past.add(next);
    return numgenForN_I(n - 1, radix, past);
  }
}

String numgen(int radix, List<String> past) {
  int len = 3;
  String ni = Random.secure()
      .nextInt((pow(radix, len) - 1).floor())
      .toRadixString(radix)
      .toUpperCase();
  if (ni.length != len || ni.startsWith("0") || past.contains(ni)) {
    return numgen(radix, past);
  } else {
    return ni;
  }
}
