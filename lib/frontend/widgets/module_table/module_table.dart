// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';
import 'package:transcript_of_records/frontend/widgets/drag_drop_list.dart';

import 'module_table_cell.dart';

class ModuleTable extends ConsumerStatefulWidget {
  const ModuleTable({super.key});

  @override
  ConsumerState<ModuleTable> createState() => _ModuleTableState();
}

class _ModuleTableState extends ConsumerState<ModuleTable> {

  final List<Widget> moduleEntryList = [];
  final List<List<String>> moduleList = [['EPR', '6', '2,3'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7'], ['Dismod', '8', '1,7']];

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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: ScreenSize.width * 0.45,
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
              width: ScreenSize.width * 0.19,
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
            SizedBox(width: ScreenSize.height * 0.04,),
          ],
        ),
        SizedBox(
          height: ScreenSize.height * 0.75,
          child: DragDropList(moduleEntryList: moduleEntryList),
        ),
      ],
    );
  }
}
