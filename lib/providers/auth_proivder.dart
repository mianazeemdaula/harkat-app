import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isUiBusy = false;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;
  User get user => _user;
  bool get isUiBusy => _isUiBusy;

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      _isUiBusy = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final DocumentSnapshot documentSnapshot = await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser.uid)
          .get();
      if (!documentSnapshot.exists) {
        documentSnapshot.reference.set({'name': 'Mr. Abc', 'token': ''});
      }
      _isUiBusy = false;
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      _isUiBusy = false;
      return false;
    }
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    try {
      _isUiBusy = true;
      notifyListeners();
      await _auth.currentUser.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: _user.email, password: oldPassword),
      );
      await _auth.currentUser.updatePassword(newPassword);
      _isUiBusy = false;
      print("Password changed");
      notifyListeners();
      return true;
    } catch (e) {
      print("Password Not changed $e");
      _isUiBusy = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendResetPassword(String email) async {
    try {
      _isUiBusy = true;
      notifyListeners();
      await _auth.sendPasswordResetEmail(email: email);
      _isUiBusy = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isUiBusy = false;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser.uid)
        .update({'token': null});
    await _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
