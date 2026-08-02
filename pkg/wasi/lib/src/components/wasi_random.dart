// ignore_for_file: type=warning

abstract interface class Random {
  List<int> getRandomBytes({required int maxLen});
  int getRandomU64();
}

abstract interface class Insecure {
  List<int> getInsecureRandomBytes({required int maxLen});
  int getInsecureRandomU64();
}

abstract interface class InsecureSeed {
  (int, int) getInsecureSeed();
}
