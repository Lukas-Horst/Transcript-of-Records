// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';
import 'package:transcript_of_records/backend/helper/string_functions.dart';
import 'package:transcript_of_records/frontend/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:transcript_of_records/frontend/widgets/text/changeable_text.dart';
import 'package:transcript_of_records/frontend/widgets/text/standard_text.dart';
import 'package:transcript_of_records/frontend/widgets/useful_widgets/text_form_field.dart';

CustomBottomSheet addModuleBottomSheet(BuildContext context, double totalCP,
    double totalGrade, void Function(List<String>, bool) addTableCell,
    double Function({List<double>? additionalGrade}) countGrade) {

  // Module text field
  final moduleTextController = TextEditingController();
  final moduleFocusNode = FocusNode();
  final GlobalKey<CustomTextFormFieldState> moduleTextFieldKey = GlobalKey<CustomTextFormFieldState>();

  // CP text field
  final cpTextController = TextEditingController();
  final cpFocusNode = FocusNode();
  final GlobalKey<CustomTextFormFieldState> cpTextFieldKey = GlobalKey<CustomTextFormFieldState>();

  // Grade text field
  final gradeTextController = TextEditingController();
  final gradeFocusNode = FocusNode();
  final GlobalKey<CustomTextFormFieldState> gradeTextFieldKey = GlobalKey<CustomTextFormFieldState>();

  // Text keys
  final GlobalKey<ChangeableTextState> totalCPTextKey = GlobalKey<ChangeableTextState>();
  final GlobalKey<ChangeableTextState> totalGradeTextKey = GlobalKey<ChangeableTextState>();

  double localTotalCP = totalCP;
  double localTotalGrade = totalGrade;

  void updateTotalNumbers(String gradeText, String cpText, bool cpChange) {
    double grade = stringToDouble(gradeText) ?? 0;
    double cp = stringToDouble(cpText) ?? 0;
    // The cp and grade can not be negative
    grade = grade > 0 ? grade : 0;
    grade = grade < 4.0 ? grade : 4.0;
    if (cpChange) {
      cpTextFieldKey.currentState?.changeText('$cp'.replaceAll('.', ',').replaceAll(',0', ''));
    } else {
      gradeTextFieldKey.currentState?.changeText('$grade'.replaceAll('.', ',').replaceAll(',0', ''));
    }
    cp = cp > 0 ? cp : 0;
    // Calculating the new value for the total grade and the total cp if possible
    if (cp > 0) {
      localTotalGrade = countGrade(additionalGrade: [cp, grade]);
    }
    localTotalCP = totalCP + cp;
    // Reset for the grade
    if (grade == 0.0 || cp == 0.0) {
      localTotalGrade = totalGrade;
      totalGradeTextKey.currentState?.updateText('Gesamtnote: ${localTotalGrade.toString().replaceAll('.', ',')}');
    }
    // Checking for changes
    if (localTotalGrade != totalGrade) {
      totalGradeTextKey.currentState?.updateText('Gesamtnote: ${localTotalGrade.toString().replaceAll('.', ',')}');
    }
    totalCPTextKey.currentState?.updateText('Gesamt-CP: ${localTotalCP.toString().replaceAll('.', ',')}');
  }

  // Listener for the cp text field
  cpFocusNode.addListener(() {
    if (!cpFocusNode.hasFocus) {
      print('Listener Aufruf');
      updateTotalNumbers(gradeTextController.text.trim(),
          cpTextController.text.trim(), true);
    }
  });

  // Listener for the grade text field
  gradeFocusNode.addListener(() {
    if (!gradeFocusNode.hasFocus) {
      updateTotalNumbers(gradeTextController.text.trim().replaceAll('.', ','),
          cpTextController.text.trim().replaceAll('.', ','), false);
    }
  });

  List<Widget> children = [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: ScreenSize.width * 0.3,
          child: StandardText(text: 'Modul:', color: Colors.black),
        ),
        CustomTextFormField(
          key: moduleTextFieldKey,
          hintText: '',
          obscureText: false,
          textController: moduleTextController,
          readOnly: false,
          autoFocus: false,
          width: ScreenSize.width * 0.55,
          height: ScreenSize.height * 0.07,
          currentFocusNode: moduleFocusNode,
          nextFocusNode: cpFocusNode,
        ),
      ],
    ),
    SizedBox(height: ScreenSize.height * 0.03,),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: ScreenSize.width * 0.3,
          child: StandardText(text: 'CP:', color: Colors.black),
        ),
        SizedBox(
          width: ScreenSize.width * 0.55,
          child: Center(
            child: CustomTextFormField(
              key: cpTextFieldKey,
              hintText: '',
              obscureText: false,
              textController: cpTextController,
              readOnly: false,
              autoFocus: false,
              width: ScreenSize.width * 0.35,
              height: ScreenSize.height * 0.07,
              currentFocusNode: cpFocusNode,
              nextFocusNode: gradeFocusNode,
            ),
          ),
        ),
      ],
    ),
    SizedBox(height: ScreenSize.height * 0.03,),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: ScreenSize.width * 0.3,
          child: StandardText(text: 'Note:', color: Colors.black),
        ),
        SizedBox(
          width: ScreenSize.width * 0.55,
          child: Center(
            child: CustomTextFormField(
              key: gradeTextFieldKey,
              hintText: '',
              obscureText: false,
              textController: gradeTextController,
              readOnly: false,
              autoFocus: false,
              width: ScreenSize.width * 0.35,
              height: ScreenSize.height * 0.07,
              currentFocusNode: gradeFocusNode,
            ),
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(
            Icons.check,
            size: ScreenSize.height * 0.05,
            color: Colors.green,
          ),
          onPressed: () {
            String moduleText = moduleTextController.text.trim();
            String gradeText = gradeTextController.text.trim();
            String cpText = cpTextController.text.trim();
            double grade = stringToDouble(gradeText) ?? 0;
            double cp = stringToDouble(cpText) ?? 0;
            // The grade can not be negative
            grade = grade > 0 ? grade : 0;
            // If the values are allowed, a module entry list will be created
            if (moduleText.isNotEmpty && cp > 0) {
              if (grade > 0) {
                // The grade can not be higher than 4.0
                grade = grade < 4.0 ? grade : 4.0;
                gradeText = '$grade'.replaceAll('.', ',').replaceAll(',0', '');
              } else {
                gradeText = '-';
              }
              List<String> moduleEntry = [moduleText, '$cp'.replaceAll('.', ',').replaceAll(',0', ''), gradeText];
              addTableCell(moduleEntry, true);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
    SizedBox(
      height: ScreenSize.height * 0.02,
      child: Divider(
        thickness: 3,
        color: Colors.black,
      ),
    ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ChangeableText(
            key: totalCPTextKey,
            text: 'Gesamt-CP: ${localTotalCP.toString().replaceAll('.', ',')}',
            color: Colors.black,
          ),
          ChangeableText(
            key: totalGradeTextKey,
            text: 'Gesamtnote: ${localTotalGrade.toString().replaceAll('.', ',')}',
            color: Colors.black,
          ),
        ],
      ),
    )
  ];
  return CustomBottomSheet(children, false, ScreenSize.height * 0.53);
}