// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';
import 'package:transcript_of_records/frontend/widgets/components/text/standard_text.dart';

class CustomSnackbar {

  static bool _activated = false;

  // Function to open a snackbar with a text
  static Future<void> showSnackbar(String text, Color color,
      Duration duration) async {
    if (!_activated) {
      _activated = true;
      Get.snackbar(
        '',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color,
        duration: duration,
        titleText: const SizedBox(),
        messageText: StandardText(text: text, color: Colors.white),
        borderRadius: 0,
        maxWidth: ScreenSize.width,
        margin: EdgeInsets.zero,
      );
      await Future.delayed(duration);
      _activated = false;
    }
  }

  // Function to close a snackbar if any is currently open
  static void closeSnackbar() {
    _activated = false;
    Get.closeCurrentSnackbar();
  }
}