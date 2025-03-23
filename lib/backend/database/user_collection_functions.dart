// author: Lukas Horst

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/constants/appwrite_constants.dart';
import 'package:transcript_of_records/backend/riverpod/provider.dart';

// Function to create a user in the user collection of the database
Future<bool> createUser(WidgetRef ref) async {
  print(true);
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
      'userName': userState.user!.name,
    },
  );
  return response;
}

// Future<bool> deleteUser(String userId, WidgetRef ref) async {
//
// }