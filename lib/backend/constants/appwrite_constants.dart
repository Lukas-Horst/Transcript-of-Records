// author: Lukas Horst

import 'package:flutter_dotenv/flutter_dotenv.dart';

final String appwriteProjectId = dotenv.env['APPWRITE_ID']!;
final String appwriteUrl = dotenv.env['APPWRITE_URL']!;

// Database constants
final String appwriteDatabaseId = dotenv.env['APPWRITE_DATABASE_ID']!;

final String userCollectionId = dotenv.env['DATABASE_USER_COLLECTION_ID']!;
