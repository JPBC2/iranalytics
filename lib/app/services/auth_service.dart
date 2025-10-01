import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'https://www.googleapis.com/auth/spreadsheets',
      'https://www.googleapis.com/auth/drive.file',
    ],
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // Sign in with Google - Updated for new API
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow - Updated method call
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential - Updated property name
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
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
      throw AuthException('google_signin_error', 'Failed to sign in with Google');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
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
