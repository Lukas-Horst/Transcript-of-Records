// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';

// Class to activate or deactivate the loading spin
class LoadingSpin {

  static bool _activated = false;

  static void openLoadingSpin(BuildContext context) {
    if (!_activated) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: SpinKitPulse(
              color: Colors.black,
              size: ScreenSize.height * 0.1,
            ),
          );
        },
      );
    }
    _activated = true;
  }

  // Method to close the loading spin
  static void closeLoadingSpin(BuildContext context) {
    if (_activated) {
      Navigator.of(context).pop();
    }
    _activated = false;
  }

}