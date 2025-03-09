// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';
import 'package:transcript_of_records/backend/helper/math_functions.dart';
import 'package:transcript_of_records/backend/helper/string_functions.dart';
import 'package:transcript_of_records/frontend/widgets/buttons/custom_icon_button.dart';
import 'package:transcript_of_records/frontend/widgets/drag_drop_list.dart';

import 'module_table_cell.dart';

class ModuleTable extends ConsumerStatefulWidget {
  const ModuleTable({super.key});

  @override
  ConsumerState<ModuleTable> createState() => _ModuleTableState();
}

class _ModuleTableState extends ConsumerState<ModuleTable> {

  final List<Widget> moduleEntryList = [];
  final List<List<String>> moduleList = [['EPR', '6', '2,3'], ['Dismod', '8', '-'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7']];

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
  double countGrade() {
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
    totalGrade /= totalCP;
    return round(totalGrade, digits: 2);
  }

  @override
  void initState() {
    for (List<String> moduleEntry in moduleList) {
      final key = UniqueKey();
      moduleEntryList.add(ModuleTableCell(
        key: key,
        moduleName: moduleEntry[0],
        credits: moduleEntry[1],
        grade: moduleEntry[2],
        onTap: () {
          setState(() {
            moduleEntryList.removeWhere((widget) => widget.key == key);
          });
        },
      ));
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
                onTap: () {},
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
                'CP: ${countCP().toString().replaceAll('.', ',')}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenSize.height * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Gesamtnote: ${countGrade().toString().replaceAll('.', ',')}',
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
