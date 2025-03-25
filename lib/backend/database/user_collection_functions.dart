// author: Lukas Horst

import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/constants/appwrite_constants.dart';
import 'package:transcript_of_records/backend/riverpod/provider.dart';
import 'package:transcript_of_records/frontend/widgets/components/useful_widgets/loading_spin.dart';

// Function to create a user in the user collection of the database
Future<bool> createUser(WidgetRef ref) async {
  final databaseApi = ref.read(databaseApiProvider);
  final userState = ref.read(userStateProvider);
  // Checking if the user already exists in the database
  if (await databaseApi.getDocumentById(userCollectionId, userState.user!.$id) != null) {
    return false;
  }
  bool response = await databaseApi.createDocument(
    userCollectionId,
    userState.user!.$id,
    {
      'module': [],
      'cp': [],
      'grade': [],
    },
  );
  return response;
}

// Function to delete a user
Future<bool> deleteUser(WidgetRef ref, BuildContext context) async {
  LoadingSpin.openLoadingSpin(context);
  final authApi = ref.read(authApiProvider);
  final userStateNotifier = ref.read(userStateProvider.notifier);
  final userState = ref.read(userStateProvider);
  final databaseApi = ref.read(databaseApiProvider);
  final String userId = userState.user!.$id;
  try {
    // Deleting the user document in the database
    bool response = await databaseApi.deleteDocument(userCollectionId, userId);
    if (!response) {
      LoadingSpin.closeLoadingSpin(context);
      return false;
    }
    // Deleting the user from the authentication
    Functions functions = Functions(authApi.getClient());
    Execution result = await functions.createExecution(
      functionId: deleteUserFunctionId,
      body: jsonEncode({'userId': userId, 'projectId': appwriteProjectId}),
      xasync: false,
    );
    // If function call was successful
    if (result.responseStatusCode == 200) {
      // The user will be logged out
      await authApi.logout(null);
      userStateNotifier.checkUserStatus();
      final responseBody = jsonDecode(result.responseBody);
      if (responseBody['message'] == 'Benutzer erfolgreich gelöscht.') {
        return true;
      }
    }
    // If the function call was not successful, then recreate the database entry
    createUser(ref);
    return false;
  } catch(e) {
    print(e);
    return false;
  }
}