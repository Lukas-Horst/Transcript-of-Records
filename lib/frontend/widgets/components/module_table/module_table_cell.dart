// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';
import 'package:transcript_of_records/backend/riverpod/provider.dart';
import 'package:transcript_of_records/frontend/widgets/components/buttons/custom_icon_button.dart';

// Widget to display one module entry
class ModuleTableCell extends ConsumerWidget {

  final String moduleName;
  final String credits;
  final String grade;
  final Function() onTap;

  const ModuleTableCell({super.key, required this.moduleName,
    required this.credits, required this.grade, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appTheme = ref.watch(appThemeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: ScreenSize.height * 0.07,
          width: ScreenSize.width * 0.85,
          margin: EdgeInsets.symmetric(vertical: ScreenSize.height * 0.0075),
          decoration: BoxDecoration(
            color: appTheme.tertiaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            border: Border.all(
              color: Colors.black,
              width: 3,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: ScreenSize.width * 0.45,
                height: ScreenSize.height * 0.07,
                decoration: const BoxDecoration(
                  border: Border(
                      right: BorderSide(
                        color: Colors.black,
                        width: 3,
                      )
                  ),
                ),
                child: Center(
                    child: Text(
                      moduleName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenSize.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
              ),
              Container(
                width: ScreenSize.width * 0.19,
                height: ScreenSize.height * 0.07,
                decoration: const BoxDecoration(
                  border: Border(
                      right: BorderSide(
                        color: Colors.black,
                        width: 3,
                      )
                  ),
                ),
                child: Center(
                  child: Text(
                    credits,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenSize.height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: ScreenSize.width * 0.19,
                child: Center(
                  child: Text(
                    grade,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenSize.height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        CustomIconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
            size: ScreenSize.height * 0.04,
          ),
          onTap: onTap),
      ],
    );
  }
}
