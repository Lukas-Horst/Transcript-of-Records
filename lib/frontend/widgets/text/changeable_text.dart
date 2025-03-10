// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:transcript_of_records/frontend/widgets/text/standard_text.dart';

// Text which can be changed via a key
class ChangeableText extends StatefulWidget {

  final String text;
  final Color color;

  const ChangeableText({super.key, required this.text, required this.color});

  @override
  State<ChangeableText> createState() => ChangeableTextState();
}

class ChangeableTextState extends State<ChangeableText> {

  late String _text;

  void updateText(String newText) {
    setState(() {
      _text = newText;
    });
  }

  @override
  void initState() {
    _text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StandardText(text: _text, color: widget.color);
  }
}
