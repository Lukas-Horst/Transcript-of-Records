// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DragDropList extends ConsumerStatefulWidget {

  final List<Widget> moduleEntryList;
  final List<List<String>> moduleList;
  final void Function(WidgetRef ref) updateDatabaseEntries;

  const DragDropList({super.key, required this.moduleEntryList,
    required this.moduleList, required this.updateDatabaseEntries});

  @override
  ConsumerState<DragDropList> createState() => _DragDropListState();
}

class _DragDropListState extends ConsumerState<DragDropList> {

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
        children: widget.moduleEntryList,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex--;
            }
            final moduleEntryItem = widget.moduleEntryList.removeAt(oldIndex);
            widget.moduleEntryList.insert(newIndex, moduleEntryItem);
            final moduleListItem = widget.moduleList.removeAt(oldIndex);
            widget.moduleList.insert(newIndex, moduleListItem);
            widget.updateDatabaseEntries(ref);
          });
        });
  }
}
