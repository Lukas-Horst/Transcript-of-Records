// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';

class StandardText extends StatelessWidget {

  final String text;
  final Color color;

  const StandardText({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: ScreenSize.height * 0.03,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
