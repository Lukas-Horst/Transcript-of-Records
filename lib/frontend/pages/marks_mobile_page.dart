// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/database/user_collection_functions.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';
import 'package:transcript_of_records/backend/riverpod/provider.dart';
import 'package:transcript_of_records/frontend/pages/appbar_dropdown_buttons.dart';
import 'package:transcript_of_records/frontend/widgets/components/module_table/module_table.dart';
import 'package:transcript_of_records/frontend/widgets/components/text/standard_text.dart';
import 'package:transcript_of_records/frontend/widgets/components/useful_widgets/loading_spin.dart';

class MarksMobile extends ConsumerWidget {
  const MarksMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    LoadingSpin.closeLoadingSpin(context);
    final appTheme = ref.watch(appThemeProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didpop, _) async {
        if (!didpop) {}
      },
      child: Scaffold(
        backgroundColor: appTheme.primaryColor,
        appBar: AppBar(
          centerTitle: true,
          title: const StandardText(text: 'Notenspiegel', color: Colors.black),
          backgroundColor: appTheme.secondaryColor,
          actions: [
            PopupMenuButton<int>(
              color: appTheme.secondaryColor,
              onSelected: (item) => onSelected(context, item, ref),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: [
                          Icon(Icons.delete_forever, color: Colors.black,),
                          SizedBox(width: ScreenSize.width * 0.01),
                          Text('Account löschen'),
                        ],
                      ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.black,),
                          SizedBox(width: ScreenSize.width * 0.01),
                          Text('Abmelden'),
                        ],
                      ),
                  ),
                ];},
            ),
          ],
        ),
        body: ModuleTable()
      ),
    );
  }
}
