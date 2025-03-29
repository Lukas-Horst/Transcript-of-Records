// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/database/user_collection_functions.dart';
import 'package:transcript_of_records/backend/riverpod/provider.dart';

// Function for the functionality of the dropdown buttons on the appbar on the marks mobile page
void onSelected(BuildContext context, int item, WidgetRef ref) async {
  switch (item) {
    case 0:
      await deleteUser(ref, context);
      break;
    case 1:
      final authApi = ref.read(authApiProvider);
      final userStateNotifier = ref.read(userStateProvider.notifier);
      await authApi.logout(context);
      await userStateNotifier.checkUserStatus(ref: ref);
      break;
  }
}