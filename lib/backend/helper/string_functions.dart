// author: Lukas Horst

double? stringToDouble(String str) {
  try {
    return double.parse(str.replaceAll(',', '.'));
  } catch(e) {
    return null;
  }
}