// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';
import 'package:transcript_of_records/backend/helper/math_functions.dart';
import 'package:transcript_of_records/backend/helper/string_functions.dart';
import 'package:transcript_of_records/frontend/widgets/bottom_sheets/add_module_bottom_sheet.dart';
import 'package:transcript_of_records/frontend/widgets/components/buttons/custom_icon_button.dart';
import 'package:transcript_of_records/frontend/widgets/components/module_table/drag_drop_list.dart';

import 'module_table_cell.dart';

class ModuleTable extends ConsumerStatefulWidget {
  const ModuleTable({super.key});

  @override
  ConsumerState<ModuleTable> createState() => _ModuleTableState();
}

class _ModuleTableState extends ConsumerState<ModuleTable> {

  final List<Widget> moduleEntryList = [];
  final List<List<String>> moduleList = [['EPR', '6', '2,3']];
  late double _totalCP;
  late double _totalGrade;

  // Counting all credit points
  double countCP() {
    double totalCP = 0.0;
    for (List<String> moduleEntry in moduleList) {
      double? cp = stringToDouble(moduleEntry[1]);
      if (cp != null) {
        totalCP += cp;
      }
    }
    return totalCP;
  }

  // Counting the grade with the weight of the credit points
  double countGrade({List<double>? additionalGrade}) {
    double totalGrade = 0.0;
    double totalCP = 0.0;
    for (List<String> moduleEntry in moduleList) {
      double? grade = stringToDouble(moduleEntry[2]);
      double? cp = stringToDouble(moduleEntry[1]);
      if (grade != null && cp != null) {
        totalCP += cp;
        totalGrade += grade * cp;
      }
    }
    if (additionalGrade != null) {
      double cp = additionalGrade[0];
      double grade = additionalGrade[1];
      totalCP += cp;
      totalGrade += grade * cp;
    }
    if (totalCP > 0) {
      totalGrade /= totalCP;
    }
    return round(totalGrade, digits: 2);
  }

  void addTableCell(List<String> moduleEntry, bool updateState) {
    final key = UniqueKey();
    moduleEntryList.add(ModuleTableCell(
      key: key,
      moduleName: moduleEntry[0],
      credits: moduleEntry[1],
      grade: moduleEntry[2],
      onTap: () {
        setState(() {
          moduleList.remove(moduleEntry);
          moduleEntryList.removeWhere((widget) => widget.key == key);
          _totalCP = countCP();
          _totalGrade = countGrade();
        });
      },
    ));
    // If a cell is added after the initialization
    if (updateState) {
      setState(() {
        moduleList.add(moduleEntry);
        _totalCP = countCP();
        _totalGrade = countGrade();
      });
    }
  }

  @override
  void initState() {
    _totalCP = countCP();
    _totalGrade = countGrade();
    for (List<String> moduleEntry in moduleList) {
      addTableCell(moduleEntry, false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: ScreenSize.width * 0.85,
          child: Row(
            children: [
              SizedBox(
                width: ScreenSize.width * 0.39,
                child: Center(
                  child: Text(
                    'Modul:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenSize.height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: ScreenSize.width * 0.20,
                child: Center(
                  child: Text(
                    'CP:',
                    style: TextStyle(
                      color: Colors.black,
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
                    'Note:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenSize.height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: ScreenSize.height * 0.65,
          child: DragDropList(moduleEntryList: moduleEntryList),
        ),
        SizedBox(height: ScreenSize.height * 0.02,),
        SizedBox(
          width: ScreenSize.width * 0.88,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomIconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.green,
                  size: ScreenSize.height * 0.04,
                ),
                onTap: () {
                  addModuleBottomSheet(context, _totalCP, _totalGrade,
                      addTableCell, countGrade).openBottomSheet(context);
                },
              )
            ],
          ),
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
              Text(
                'Gesamt-CP: ${_totalCP.toString().replaceAll('.', ',').replaceAll(',0', '')}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenSize.height * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Gesamtnote: ${_totalGrade.toString().replaceAll('.', ',').replaceAll(',0', '')}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenSize.height * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
