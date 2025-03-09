// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/riverpod/provider.dart';
import 'package:transcript_of_records/frontend/widgets/module_table/module_table.dart';
import 'package:transcript_of_records/frontend/widgets/module_table/module_table_cell.dart';

class MarksMobilPage extends ConsumerStatefulWidget {
  const MarksMobilPage({super.key});

  @override
  ConsumerState<MarksMobilPage> createState() => _MarksPageState();
}

class _MarksPageState extends ConsumerState<MarksMobilPage> {
  @override
  Widget build(BuildContext context) {

    final appTheme = ref.watch(appThemeProvider);

    return Scaffold(
      backgroundColor: appTheme.primaryColor,
      appBar: AppBar(
        title: const Text('Transcript of Records'),
        backgroundColor: appTheme.secondaryColor
      ),
      body: ModuleTable()
    );
  }
}
