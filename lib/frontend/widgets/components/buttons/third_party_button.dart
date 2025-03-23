// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';
import 'package:transcript_of_records/backend/riverpod/provider.dart';
import 'package:transcript_of_records/frontend/widgets/components/text/standard_text.dart';

// The button to log in with a third party provider
class ThirdPartyButton extends ConsumerWidget {

  final String imageName;
  final Function onPressed;

  const ThirdPartyButton({super.key, required this.imageName,
    required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appTheme = ref.watch(appThemeProvider);

    return TextButton.icon(
      onPressed: () {onPressed();},
      icon: Image.asset(
        'assets/images/$imageName.png',
      ),
      label: StandardText(text: 'Anmelden mit Google', color: Colors.white),
      style: IconButton.styleFrom(
          backgroundColor: appTheme.tertiaryColor,
          foregroundColor: Colors.black,
          fixedSize: Size(
            ScreenSize.width * 0.85,
            ScreenSize.height * 0.065,
          ),
          side: const BorderSide(
            color: Colors.black,
            width: 3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          )
      ),
    );
  }
}