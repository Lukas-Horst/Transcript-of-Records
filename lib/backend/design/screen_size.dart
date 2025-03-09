// author: Lukas Horst

import 'package:flutter/material.dart' show BuildContext, MediaQuery;

// Class to get the screen size globally
class ScreenSize {
  static late double width;
  static late double height;
  static late double bottomViewInsets;

  static void init(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    bottomViewInsets = MediaQuery.of(context).viewInsets.bottom;
  }
}