import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isUiBusy = false;
  String _userType = "driver";
  SharedPreferences _preferences;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;
  User get user => _user;
  bool get isUiBusy => _isUiBusy;
  String get userType => _userType;

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
        documentSnapshot.reference
            .set({'name': 'Mr. Abc', 'token': '', 'type': "driver"});
        _userType = 'driver';
      } else {
        _userType = documentSnapshot.data()['type'];
      }

      _preferences.setString('userType', _userType);
      _isUiBusy = false;
      notifyListeners();
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      _isUiBusy = false;
      return false;
    }
  }

  Future<bool> signUp(String name, String mobile, String email, String password,
      String address, BuildContext context) async {
    try {
      _isUiBusy = true;
      notifyListeners();
      final QuerySnapshot documentSnapshot = await _firebaseFirestore
          .collection('users')
          .where('email', isEqualTo: "aasdfs")
          .get();
      if (documentSnapshot.docs.length == 0) {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (_auth.currentUser != null) {
          _auth.currentUser.updateProfile(
            displayName: name,
          );
          await _firebaseFirestore
              .collection('users')
              .doc(_auth.currentUser.uid)
              .set({
            'name': name,
            'email': email,
            'contact': mobile,
            'emirate': '',
            'address': '$address',
            'type': "customer"
          });
          _userType = "customer";
          _preferences.setString('userType', _userType);
          Navigator.pop(context);
        }
      } else {
        _isUiBusy = false;
        notifyListeners();
        return false;
      }
      _isUiBusy = false;
      notifyListeners();
      return true;
    } catch (e) {
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
    // await _firebaseFirestore
    //     .collection('users')
    //     .doc(_auth.currentUser.uid)
    //     .update({'token': null});
    await _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    _preferences = await SharedPreferences.getInstance();
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
      _userType = null;
    } else {
      _user = firebaseUser;
      _userType = _preferences.getString('userType');
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
