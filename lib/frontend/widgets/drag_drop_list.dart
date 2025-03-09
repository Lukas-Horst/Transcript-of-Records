// author: Lukas Horst

import 'package:flutter/material.dart';

class DragDropList extends StatefulWidget {

  final List<Widget> moduleEntryList;

  const DragDropList({super.key, required this.moduleEntryList});

  @override
  State<DragDropList> createState() => _DragDropListState();
}

class _DragDropListState extends State<DragDropList> {

  late List<Widget> moduleEntryList;

  @override
  void initState() {
    moduleEntryList = List.from(widget.moduleEntryList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
        children: moduleEntryList,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex--;
            }
            final item = moduleEntryList.removeAt(oldIndex);
            moduleEntryList.insert(newIndex, item);
          });
        });
  }
}
