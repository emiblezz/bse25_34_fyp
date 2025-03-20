import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import "package:google_sign_in/google_sign_in.dart";
import '../models/user_model.dart';
import 'package:bse25_34_fyp/screens/job_seeker/job_seeker_home_screen.dart';
import '../screens/recruiter/recruiter_home_screen.dart';
import '../screens/admin/admin_home_screen.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoggedIn => _token != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final FirebaseAuth = firebase.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Firebase authentication
      final userCredential = await FirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Get user token
        final idToken = await userCredential.user!.getIdToken();

        // In a real app, you would fetch user data from your backend using this token
        // Here we'll create dummy data for demonstration
        _user = User(
          id: 1,
          name: userCredential.user!.displayName ?? 'User',
          email: userCredential.user!.email!,
          phone: userCredential.user!.phoneNumber ?? '',
          roleId: 1,  // Default to job seeker
          roleName: 'Job Seeker',
          profileStatus: 'Active',
          photoUrl: userCredential.user!.photoURL,
        );
        _token = idToken;

        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', _token!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        _error = 'Google sign in was canceled';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Obtain the auth details from the Google sign in
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential for Firebase
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await FirebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Get user token
        final idToken = await userCredential.user!.getIdToken();

        // In a real app, you would fetch user data from your backend using this token
        // Here we'll create dummy data for demonstration
        _user = User(
          id: 1,
          name: userCredential.user!.displayName ?? 'User',
          email: userCredential.user!.email!,
          phone: userCredential.user!.phoneNumber ?? '',
          roleId: 1,  // Default to job seeker
          roleName: 'Job Seeker',
          profileStatus: 'Active',
          photoUrl: userCredential.user!.photoURL,
        );
        _token = idToken;

        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', _token!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Google sign in failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String phone, String password, int roleId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Create user with Firebase
      final userCredential = await FirebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Update user profile
        await userCredential.user!.updateDisplayName(name);

        // Get user token
        final idToken = await userCredential.user!.getIdToken();

        // In a real app, you would send this additional user data to your backend
        _user = User(
          id: 1,
          name: name,
          email: email,
          phone: phone,
          roleId: roleId,
          roleName: roleId == 1 ? 'Job Seeker' : (roleId == 2 ? 'Recruiter' : 'Admin'),
          profileStatus: 'Active',
          photoUrl: null,
        );
        _token = idToken;

        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', _token!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await FirebaseAuth.sendPasswordResetEmail(email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> autoLogin(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      // In a real app, you would validate the token with your backend
      // and fetch the user data

      // For demonstration purposes, we'll just set dummy data
      _token = token;
      _user = User(
        id: 1,
        name: 'John Doe',
        email: 'user@example.com',
        phone: '1234567890',
        roleId: 1,
        roleName: 'Job Seeker',
        profileStatus: 'Active',
        photoUrl: null,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      await logout();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Sign out from Firebase
      await FirebaseAuth.signOut();
      // Sign out from Google
      await googleSignIn.signOut();

      _user = null;
      _token = null;

      // Clear token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('auth_token');
    } catch (e) {
      print(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  void navigateToRoleBasedHome(BuildContext context) {
    if (_user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
      return;
    }

    switch (_user!.roleId) {
      case 1: // Job Seeker
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => JobSeekerHomeScreen()),
        );
        break;
      case 2: // Recruiter
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => RecruiterHomeScreen()),
        );
        break;
      case 3: // Admin
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminHomeScreen()),
        );
        break;
      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
    }
  }
}
