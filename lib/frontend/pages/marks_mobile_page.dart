// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/database/user_collection_functions.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';
import 'package:transcript_of_records/backend/riverpod/provider.dart';
import 'package:transcript_of_records/frontend/widgets/components/module_table/module_table.dart';
import 'package:transcript_of_records/frontend/widgets/components/text/standard_text.dart';
import 'package:transcript_of_records/frontend/widgets/components/useful_widgets/loading_spin.dart';

class MarksMobile extends ConsumerWidget {
  const MarksMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    LoadingSpin.closeLoadingSpin(context);
    final appTheme = ref.watch(appThemeProvider);
    final authApi = ref.read(authApiProvider);
    final userStateNotifier = ref.read(userStateProvider.notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didpop, _) async {
        if (!didpop) {}
      },
      child: Scaffold(
        backgroundColor: appTheme.primaryColor,
        appBar: AppBar(
          title: const StandardText(text: 'Notenspiegel', color: Colors.black),
          backgroundColor: appTheme.secondaryColor,
          actions: [
            IconButton(
              icon: Icon(
                Icons.person,
                size: ScreenSize.height * 0.04,
              ),
              onPressed: () async {
                await deleteUser(ref, context);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.logout,
                size: ScreenSize.height * 0.04,
              ),
              onPressed: () async {
                await authApi.logout(context);
                await userStateNotifier.checkUserStatus(ref: ref);
              },
            )
          ],
        ),
        body: ModuleTable()
      ),
    );
  }
}
