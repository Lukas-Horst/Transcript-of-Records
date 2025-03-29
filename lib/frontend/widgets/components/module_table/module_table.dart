// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/constants/appwrite_constants.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';
import 'package:transcript_of_records/backend/helper/convert_appwrite_data.dart';
import 'package:transcript_of_records/backend/helper/math_functions.dart';
import 'package:transcript_of_records/backend/helper/string_functions.dart';
import 'package:transcript_of_records/backend/riverpod/provider.dart';
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
  final List<List<String>> moduleList = [];
  double _totalCP = 0;
  double _totalGrade = 0;
  bool initialization = false;

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
        if (grade != 0) {
          totalCP += cp;
        }
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

  void addTableCell(List<String> moduleEntry, bool updateState, WidgetRef ref) {
    final key = UniqueKey();
    moduleEntryList.add(ModuleTableCell(
      key: key,
      moduleName: moduleEntry[0],
      credits: moduleEntry[1].replaceAll('.', ',').replaceAll(RegExp(r',0$'), ''),
      grade: moduleEntry[2].replaceAll('.', ',').replaceAll(RegExp(r',0$'), '').replaceAll('0', '-'),
      onTap: () {
        setState(() {
          moduleList.remove(moduleEntry);
          updateDatabaseEntries(ref);
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
        updateDatabaseEntries(ref);
        _totalCP = countCP();
        _totalGrade = countGrade();
      });
    }
  }

  // Updates the database entries of the user
  Future<void> updateDatabaseEntries(WidgetRef ref) async {
    List<String> modules = [];
    List<double> cps = [];
    List<double> grades = [];
    for (List<String> moduleEntry in moduleList) {
      modules.add(moduleEntry[0]);
      cps.add(stringToDouble(moduleEntry[1])!);
      if (moduleEntry[2] == '-') {
        grades.add(0.0);
      } else {
        grades.add(stringToDouble(moduleEntry[2])!);
      }
    }
    final databaseApi = ref.read(databaseApiProvider);
    final userState = ref.read(userStateProvider);
    Map<String, dynamic> data = {
      'module': modules,
      'cp': cps,
      'grade': grades,
    };
    await databaseApi.updateDocument(userCollectionId, userState.user!.$id, data);
  }

  @override
  void initState() {
    super.initState();
  }

  // Method to get the data from the appwrite database
  void init(WidgetRef ref) async {
    if (!initialization) {
      final databaseApi = ref.read(databaseApiProvider);
      final userState = ref.read(userStateProvider);
      initialization = true;
      Document? userDocument = await databaseApi.getDocumentById(userCollectionId, userState.user!.$id);
      if (userDocument != null) {
        List<String> modules = convertDynamicToStringList(userDocument.data['module']);
        List<double> cps = convertDynamicToDoubleList(userDocument.data['cp']);
        List<double> grades = convertDynamicToDoubleList(userDocument.data['grade']);
        for (int i=0; i < modules.length; i++) {
          List<String> moduleListElement = [modules[i], '${cps[i]}', '${grades[i]}'];
          moduleList.add(moduleListElement);
        }
        for (List<String> moduleEntry in moduleList) {
          addTableCell(moduleEntry, false, ref);
          setState(() {
            _totalCP = countCP();
            _totalGrade = countGrade();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    init(ref);
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
          child: DragDropList(moduleEntryList: moduleEntryList, moduleList: moduleList,
            updateDatabaseEntries: updateDatabaseEntries,),
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
                      addTableCell, countGrade, ref).openBottomSheet(context);
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
                'Gesamt-CP: ${_totalCP.toString().replaceAll('.', ',').replaceAll(RegExp(r',0$'), '')}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenSize.height * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Gesamtnote: ${_totalGrade.toString().replaceAll('.', ',').replaceAll(RegExp(r',0$'), '')}',
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
