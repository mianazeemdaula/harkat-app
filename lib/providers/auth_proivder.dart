import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;
  FirebaseFirestore _fbStore = FirebaseFirestore.instance;
  bool _isUiBusy = false;
  String _userType = "driver";

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;
  User get user => _user;
  bool get isUiBusy => _isUiBusy;
  String get userType => _userType;

  Future signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      _isUiBusy = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      _status = Status.Unauthenticated;
      _isUiBusy = false;
      notifyListeners();
    }
  }

  Future signUp(String name, String mobile, String email, String password,
      String address, BuildContext context) async {
    try {
      _isUiBusy = true;
      notifyListeners();
      final QuerySnapshot snapshot = await _fbStore
          .collection('users')
          .where('email', isEqualTo: "$email")
          .get();
      if (snapshot.docs.length == 0) {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (_auth.currentUser != null) {
          await _fbStore.collection('users').doc(_auth.currentUser.uid).set({
            'name': name,
            'email': email,
            'contact': mobile,
            'emirate': '',
            'address': '$address',
            'type': "customer"
          });
          _userType = "customer";
        }
      }
      _isUiBusy = false;
      notifyListeners();
    } catch (e) {
      _isUiBusy = false;
      notifyListeners();
    }
  }

  Future updatePassword(String oldPassword, String newPassword) async {
    try {
      _isUiBusy = true;
      notifyListeners();
      await _auth.currentUser.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: _user.email, password: oldPassword),
      );
      await _auth.currentUser.updatePassword(newPassword);
      _isUiBusy = false;
      notifyListeners();
    } catch (e) {
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
    await _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
      _userType = null;
    } else {
      _user = firebaseUser;
      var doc =
          await _fbStore.collection('users').doc(_auth.currentUser.uid).get();
      if (doc.exists) {
        await _auth.currentUser.updateProfile(
          displayName: doc.data()['name'],
        );
        _userType = doc.data()['type'];
      }
      if (_userType == 'admin') {
        _status = Status.Unauthenticated;
        Get.snackbar("Error", "You are not authorized to use this app",
            snackPosition: SnackPosition.BOTTOM);
        await signOut();
      } else {
        _status = Status.Authenticated;
      }
    }
    Get.back();
    _isUiBusy = false;
    notifyListeners();
  }
}
