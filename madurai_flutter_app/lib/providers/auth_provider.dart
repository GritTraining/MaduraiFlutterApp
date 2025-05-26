// providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  User? _user;
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Sign in with email and password
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _setError('');
      
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = result.user;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      switch (e.code) {
        case 'user-not-found':
          _setError('No user found for that email.');
          break;
        case 'wrong-password':
          _setError('Wrong password provided.');
          break;
        case 'invalid-email':
          _setError('Invalid email address.');
          break;
        case 'user-disabled':
          _setError('This user account has been disabled.');
          break;
        case 'too-many-requests':
          _setError('Too many requests. Try again later.');
          break;
        default:
          _setError('An error occurred: ${e.message}');
      }
      return false;
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred: $e');
      return false;
    }
  }

  // Sign up with email and password
  Future<bool> signUpWithEmail(String email, String password, {String? displayName}) async {
    try {
      _setLoading(true);
      _setError('');
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await result.user?.updateDisplayName(displayName);
      }
      
      _user = result.user;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      switch (e.code) {
        case 'weak-password':
          _setError('The password provided is too weak.');
          break;
        case 'email-already-in-use':
          _setError('The account already exists for that email.');
          break;
        case 'invalid-email':
          _setError('Invalid email address.');
          break;
        case 'operation-not-allowed':
          _setError('Email/password accounts are not enabled.');
          break;
        default:
          _setError('An error occurred: ${e.message}');
      }
      return false;
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred: $e');
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError('');
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        _setLoading(false);
        return false; // User cancelled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      _user = result.user;
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError('Google sign-in failed: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
      _errorMessage = '';
      notifyListeners();
    } catch (e) {
      _setError('Error signing out: $e');
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _setError('');
      
      await _auth.sendPasswordResetEmail(email: email);
      
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      switch (e.code) {
        case 'user-not-found':
          _setError('No user found for that email.');
          break;
        case 'invalid-email':
          _setError('Invalid email address.');
          break;
        default:
          _setError('An error occurred: ${e.message}');
      }
      return false;
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred: $e');
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile({String? displayName, String? photoURL}) async {
    try {
      _setLoading(true);
      _setError('');
      
      if (_user != null) {
        await _user!.updateDisplayName(displayName);
        await _user!.updatePhotoURL(photoURL);
        await _user!.reload();
        _user = _auth.currentUser;
        notifyListeners();
      }
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError('Error updating profile: $e');
      return false;
    }
  }

  // Delete user account
  Future<bool> deleteAccount() async {
    try {
      _setLoading(true);
      _setError('');
      
      await _user?.delete();
      _user = null;
      
      _setLoading(false);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      if (e.code == 'requires-recent-login') {
        _setError('This operation requires recent authentication. Please sign in again.');
      } else {
        _setError('Error deleting account: ${e.message}');
      }
      return false;
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred: $e');
      return false;
    }
  }
}