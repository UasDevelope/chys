class CommonService {
  static String kgToLbs(num kg) {
    double lbs = kg * 2.20462;
    return lbs.toStringAsFixed(0); // or use toStringAsFixed(1) for one decimal
  }
}
