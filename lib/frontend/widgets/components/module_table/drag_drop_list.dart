// author: Lukas Horst

import 'package:flutter/material.dart';

class DragDropList extends StatefulWidget {

  final List<Widget> moduleEntryList;

  const DragDropList({super.key, required this.moduleEntryList});

  @override
  State<DragDropList> createState() => _DragDropListState();
}

class _DragDropListState extends State<DragDropList> {

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
        children: widget.moduleEntryList,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex--;
            }
            final item = widget.moduleEntryList.removeAt(oldIndex);
            widget.moduleEntryList.insert(newIndex, item);
          });
        });
  }
}
