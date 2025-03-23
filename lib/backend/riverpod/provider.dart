// author: Lukas Horst

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/authentication/auth_api.dart';
import 'package:transcript_of_records/backend/authentication/user_state_notifier.dart';
import 'package:transcript_of_records/backend/database/database_api.dart';
import 'package:transcript_of_records/backend/design/app_theme_notifier.dart';

// The provider for the app theme
final appThemeProvider = Provider<AppTheme>((ref) {
  return AppTheme();
});

// The provider for the auth api
final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi();
});

// The provider for the database api
final databaseApiProvider = Provider<DatabaseApi>((ref) {
  final authApi = ref.watch(authApiProvider);
  return DatabaseApi(authApi);
});

// The provider for the user state notifier
final userStateProvider = StateNotifierProvider<UserStateNotifier, UserState>((ref) {
  final authApi = ref.watch(authApiProvider);
  return UserStateNotifier(authApi);
});