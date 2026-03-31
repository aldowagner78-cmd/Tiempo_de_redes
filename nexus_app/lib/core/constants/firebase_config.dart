// ============================================
// NEXUS CONTROL - Firebase Configuration
// ============================================
// These are client-side Firebase credentials.
// Security is enforced by Firestore Rules, not
// by keeping these values secret (standard Firebase practice).
//
// Source: firebase-applet-config.json del proyecto web.

class FirebaseConfig {
  FirebaseConfig._();

  static const String apiKey = 'AIzaSyAYYEt-E8GiaQGG5PAxeXbyHKpHXVrAhok';
  static const String projectId = 'protocolos-auditor-ia-app';
  static const String databaseId = 'ai-studio-9f4007c9-d261-483f-b2ff-7d00b63c65a6';

  // Endpoints de Firebase Auth REST API
  static const String authSignUpAnon =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUpNewUser';
  static const String authRefreshToken =
      'https://securetoken.googleapis.com/v1/token';

  // Base URL del Firestore REST API
  static String get firestoreBase =>
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/$databaseId/documents';
}
