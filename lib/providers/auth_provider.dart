import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../screens/job_seeker/job_seeker_home_screen.dart';
import '../screens/recruiter/recruiter_home_screen.dart';
import '../screens/admin/admin_home_screen.dart';
import '../screens/auth/login_screen.dart';

class AuthProvider with ChangeNotifier {
  AppUser? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoggedIn => _token != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final _firebaseAuth = auth.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Firebase authentication
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Registration successful
        _isLoading = false;
        _error = null;
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

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Firebase authentication
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final idToken = await userCredential.user!.getIdToken();

        // Fetch user data from your backend or set default values
        _user = AppUser(
          id: 1, // This would typically come from your backend
          name: userCredential.user!.displayName ?? 'User',
          email: userCredential.user!.email!,
          phone: userCredential.user!.phoneNumber ?? '',
          roleId: 1, // Default role - would typically come from your backend
          roleName: 'Job Seeker',
          profileStatus: 'Active',
          photoUrl: userCredential.user!.photoURL,
        );
        _token = idToken;

        // Save token to SharedPreferences
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
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        _error = 'Google sign-in was canceled';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final idToken = await userCredential.user!.getIdToken();

        _user = AppUser(
          id: 1,
          name: userCredential.user!.displayName ?? 'User',
          email: userCredential.user!.email!,
          phone: userCredential.user!.phoneNumber ?? '',
          roleId: 1,
          roleName: 'Job Seeker',
          profileStatus: 'Active',
          photoUrl: userCredential.user!.photoURL,
        );
        _token = idToken;

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', _token!);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Google sign-in failed';
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

  Future<bool> autoLogin(String savedToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Verify the token with Firebase
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        // Token is valid, fetch user info
        // This would typically involve a backend call to get user details
        _user = AppUser(
          id: 1,
          name: currentUser.displayName ?? 'User',
          email: currentUser.email!,
          phone: currentUser.phoneNumber ?? '',
          roleId: 1,
          roleName: 'Job Seeker',
          profileStatus: 'Active',
          photoUrl: currentUser.photoURL,
        );
        _token = savedToken;

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // Token is invalid or expired
        _token = null;
        _user = null;

        final prefs = await SharedPreferences.getInstance();
        prefs.remove('auth_token');

        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _token = null;
      _user = null;

      final prefs = await SharedPreferences.getInstance();
      prefs.remove('auth_token');

      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firebaseAuth.signOut();
      await googleSignIn.signOut();

      _user = null;
      _token = null;

      final prefs = await SharedPreferences.getInstance();
      prefs.remove('auth_token');

      _isLoading = false;
      notifyListeners();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void navigateToRoleBasedHome(BuildContext context) {
    if (_user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
      return;
    }

    Widget homeScreen;
    switch (_user!.roleId) {
      case 1:
        homeScreen = JobSeekerHomeScreen();
        break;
      case 2:
        homeScreen = RecruiterHomeScreen();
        break;
      case 3:
        homeScreen = AdminHomeScreen();
        break;
      default:
        homeScreen = LoginScreen();
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => homeScreen),
          (route) => false,
    );
  }

  updateUserProfile(AppUser updatedUser) {}
}