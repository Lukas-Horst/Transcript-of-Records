// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/authentication/auth_api.dart';
import 'package:transcript_of_records/backend/database/user_collection_functions.dart';

class UserState {
  final User? user;
  final bool firstCheck;

  UserState({required this.user, required this.firstCheck});
}

// Notifier to check if the user is logged in or not
class UserStateNotifier extends StateNotifier<UserState> {
  late final AuthApi _authApi;

  UserStateNotifier(this._authApi) :super(UserState(user: null,
      firstCheck: false)) {
    checkUserStatus();
  }

  // Method to check if the user is logged in
  Future<void> checkUserStatus({WidgetRef? ref}) async {
    final user = await _authApi.getCurrentUser();
    state = UserState(user: user, firstCheck: true);
    if (ref != null && user != null) {
      await createUser(ref);
    }
  }
}