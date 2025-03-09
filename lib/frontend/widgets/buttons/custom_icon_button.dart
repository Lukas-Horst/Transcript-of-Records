// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';

class CustomIconButton extends StatelessWidget {

  final Icon icon;
  final Function() onTap;

  const CustomIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ScreenSize.height),
      child: icon,
    );
  }
}
