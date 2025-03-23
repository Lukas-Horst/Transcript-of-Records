// author: Lukas Horst

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:transcript_of_records/backend/constants/appwrite_constants.dart';
import 'package:transcript_of_records/frontend/widgets/components/useful_widgets/loading_spin.dart';


// Class for all authentication method to AppWrite
class AuthApi {

  final Client _client = Client()
      .setEndpoint(appwriteUrl)
      .setProject(appwriteProjectId)
      .setSelfSigned(status: true);
  late final Account _account;

  // Constructor
  AuthApi() {
    _account = Account(_client);
  }

  Client getClient() {
    return _client;
  }

  // Method to login with google
  Future<bool> googleLogin(BuildContext context) async {
    LoadingSpin.openLoadingSpin(context);
    try {
      await _account.createOAuth2Session(
        provider: OAuthProvider.google,
        scopes: ['profile', 'email'],
      );

      return true;
    } catch (e) {
      LoadingSpin.closeLoadingSpin(context);
      print(e);
      return false;
    }
  }

  // Method to logout from AppWrite
  Future<bool> logout(BuildContext? context) async {
    if (context != null) {
      LoadingSpin.openLoadingSpin(context);
    }
    try {
      await _account.deleteSession(sessionId: 'current');
      return true;
    } catch(e) {
      if (context != null) {
        LoadingSpin.closeLoadingSpin(context);
      }
      print(e);
      return false;
    }
  }

  // Method to get the current user, if he is logged in
  Future<User?> getCurrentUser() async {
    try {
      // User is logged in
      return await _account.get();
    } catch(e) {
      // User isn't logged in
      return null;
    }
  }

}