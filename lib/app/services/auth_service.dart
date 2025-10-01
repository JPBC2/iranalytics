import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Google Sign-In instance (now singleton in v7.0+)
  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  bool _isInitialized = false;

  // Initialize Google Sign-In (required in v7.0+)
  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isInitialized) {
      try {
        // For web, initialize without clientId (it's configured in HTML)
        // For other platforms, you can add clientId if needed
        if (kIsWeb) {
          await _googleSignIn.initialize();
        } else {
          await _googleSignIn.initialize(
            // For mobile platforms, you can specify clientId if needed
            // clientId: 'your-client-id',
            // serverClientId: 'your-server-client-id',
          );
        }
        _isInitialized = true;
      } catch (e) {
        print('Failed to initialize Google Sign-In: $e');
        throw AuthException('initialization_failed', 'Failed to initialize Google Sign-In: $e');
      }
    }
  }

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Get current app user
  Future<AppUser?> getCurrentAppUser() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data()!);
      } else {
        // Create user document if it doesn't exist
        final appUser = AppUser.fromFirebaseUser(user);
        await _createUserDocument(appUser);
        return appUser;
      }
    } catch (e) {
      print('Error getting current app user: $e');
      return null;
    }
  }

  // Sign in with Google - Updated for v7.0+ API with web support
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Ensure Google Sign-In is initialized
      await _ensureGoogleSignInInitialized();

      GoogleSignInAccount? googleUser;

      // Handle web platform differently (Google Sign-In 7.0+ requirement)
      if (kIsWeb) {
        // On web, we might need to use a different approach
        // Web platform requires special handling in Google Sign-In 7.0+
        try {
          if (_googleSignIn.supportsAuthenticate()) {
            googleUser = await _googleSignIn.authenticate(
              scopeHint: [
                'email',
                'profile',
              ],
            );
          } else {
            throw AuthException('web_not_supported', 'Authentication not supported on web platform');
          }
        } catch (e) {
          print('Web authentication error: $e');
          // Fallback: try different approach for web
          throw AuthException('web_auth_failed', 'Web authentication failed: $e');
        }
      } else {
        // Mobile platforms
        if (_googleSignIn.supportsAuthenticate()) {
          googleUser = await _googleSignIn.authenticate(
            scopeHint: [
              'email',
              'profile',
              'https://www.googleapis.com/auth/spreadsheets',
              'https://www.googleapis.com/auth/drive.file',
            ],
          );
        } else {
          throw AuthException('unsupported_platform', 'Google Sign-In not supported on this platform');
        }
      }

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Get authentication details from the GoogleSignInAccount
      // In v7.0+, GoogleSignInAuthentication only contains idToken
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Firebase Auth only needs idToken for Google Sign-In authentication
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        // Note: accessToken is not available in google_sign_in 7.0+
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Create or update user document in Firestore
      if (userCredential.user != null) {
        await _createOrUpdateUserDocument(userCredential.user!);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      throw AuthException(e.code, e.message ?? 'Authentication failed');
    } catch (e) {
      print('Google Sign In Error: $e');
      throw AuthException('google_signin_error', 'Failed to sign in with Google: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _ensureGoogleSignInInitialized();
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('Error signing out: $e');
      throw AuthException('signout_error', 'Failed to sign out');
    }
  }

  // Create or update user document
  Future<void> _createOrUpdateUserDocument(User user) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      final now = DateTime.now();

      if (docSnapshot.exists) {
        // Update existing user
        await userDoc.update({
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'lastLoginAt': now.toIso8601String(),
        });
      } else {
        // Create new user
        final appUser = AppUser.fromFirebaseUser(
          user,
          createdAt: now,
          lastLoginAt: now,
        );
        await userDoc.set(appUser.toMap());

        // Initialize user progress document
        await _initializeUserProgress(user.uid);
      }
    } catch (e) {
      print('Error creating/updating user document: $e');
    }
  }

  // Create user document (for new users)
  Future<void> _createUserDocument(AppUser appUser) async {
    try {
      await _firestore.collection('users').doc(appUser.uid).set(appUser.toMap());
      await _initializeUserProgress(appUser.uid);
    } catch (e) {
      print('Error creating user document: $e');
    }
  }

  // Initialize user progress document
  Future<void> _initializeUserProgress(String userId) async {
    try {
      await _firestore.collection('user_progress').doc(userId).set({
        'userId': userId,
        'exercises': {},
        'totalCompleted': 0,
        'totalTime': 0,
        'lastActivity': DateTime.now().toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error initializing user progress: $e');
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await _deleteUserData(user.uid);

        // Delete Firebase Auth account
        await user.delete();
      }
    } catch (e) {
      print('Error deleting account: $e');
      throw AuthException('delete_account_error', 'Failed to delete account');
    }
  }

  // Delete user data from Firestore
  Future<void> _deleteUserData(String userId) async {
    try {
      final batch = _firestore.batch();

      // Delete user document
      batch.delete(_firestore.collection('users').doc(userId));

      // Delete user progress
      batch.delete(_firestore.collection('user_progress').doc(userId));

      await batch.commit();
    } catch (e) {
      print('Error deleting user data: $e');
    }
  }
}

// Custom exception class
class AuthException implements Exception {
  final String code;
  final String message;

  AuthException(this.code, this.message);

  @override
  String toString() => 'AuthException: $code - $message';
}
