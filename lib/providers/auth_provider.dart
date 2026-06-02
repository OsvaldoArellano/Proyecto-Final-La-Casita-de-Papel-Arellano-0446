import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AppAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  AppAuthProvider() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await fetchUserData(user.uid);
    }
  }

  Future<void> fetchUserData(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      _currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await fetchUserData(res.user!.uid);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      UserModel newUser = UserModel(
        id: res.user!.uid,
        name: name,
        email: email,
        isAdmin: false,
        profileImageUrl: 'https://raw.githubusercontent.com/Arat-Sosa/AppPapeleria/main/assets/images/user_avatar.png',
      );
      await _db.collection('users').doc(res.user!.uid).set(newUser.toMap());
      _currentUser = newUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateUserProfile(String name, String? imageUrl) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(name: name, profileImageUrl: imageUrl);
    await _db.collection('users').doc(_currentUser!.id).update(_currentUser!.toMap());
    notifyListeners();
  }
}