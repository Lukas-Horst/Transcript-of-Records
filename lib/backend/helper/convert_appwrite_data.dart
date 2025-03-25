// author: Lukas Horst

// Function to convert a dynamic list from appwrite into a string list if possible
List<String> convertDynamicToStringList(List<dynamic> dynamicList) {
  List<String> stringList = [];
  for (dynamic dynamicValue in dynamicList) {
    try {
      String stringValue = dynamicValue.toString();
      stringList.add(stringValue);
    } catch(e) {}
  }
  return stringList;
}

// Function to convert a dynamic list from appwrite into a int list if possible
List<int> convertDynamicToIntList(List<dynamic> dynamicList) {
  List<int> intList = [];
  for (dynamic dynamicValue in dynamicList) {
    try {
      int intValue = dynamicValue as int;
      intList.add(intValue);
    } catch(e) {}
  }
  return intList;
}

// Function to convert a dynamic list from appwrite into a double list if possible
List<double> convertDynamicToDoubleList(List<dynamic> dynamicList) {
  List<double> doubleList = [];
  for (dynamic dynamicValue in dynamicList) {
    try {
      double doubleValue = _convertDynamicToDouble(dynamicValue)!;
      doubleList.add(doubleValue);
    } catch(e) {}
  }
  return doubleList;
}

// Converts a dynamic value (if double or int) to a double
double? _convertDynamicToDouble(dynamic dynamicValue) {
  double? doubleValue;
  try {
    doubleValue = dynamicValue as double;
  } catch(e) {
    if (e.toString().contains('type \'int\'')) {
      int intValue = dynamicValue as int;
      doubleValue = intValue + 0;
    }
  }
  return doubleValue;
}