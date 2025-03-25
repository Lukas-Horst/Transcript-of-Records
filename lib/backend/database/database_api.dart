// author: Lukas Horst

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:transcript_of_records/backend/authentication/auth_api.dart';
import 'package:transcript_of_records/backend/constants/appwrite_constants.dart';

class DatabaseApi {

  late final Databases _database;
  final String databaseId = appwriteDatabaseId;

  // Constructor
  DatabaseApi(AuthApi authApi) {
    _database = Databases(authApi.getClient());
  }

  // Method to create a document in a collection
  Future<bool> createDocument(String collectionId, String? documentId,
      Map<String, dynamic> data) async {
    try {
      await _database.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId ?? 'unique()',
        data: data,
      );
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  // Method to get a document by the id from a specific collection
  Future<Document?> getDocumentById(String collectionId, String documentId) async {
    try {
      Document? document = await _database.getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
      if (document.data['\$id'] == null) {
        return null;
      }
      return document;
    } catch(e) {
      print(e);
      return null;
    }
  }

  // Method to update a document with the given data
  Future<bool> updateDocument(String collectionId, String documentId,
      Map<String, dynamic> data) async {
    try {
      await _database.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: data,
      );
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  // Method to delete a document
  Future<bool> deleteDocument(String collectionId, String documentId) async {
    try {
      await _database.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
      return true;
    } catch(e) {
      if (e.toString().contains('AppwriteException: document_not_found')) {
        return true;
      }
      print(e);
      return false;
    }
  }
}