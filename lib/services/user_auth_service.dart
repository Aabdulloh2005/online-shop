import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_shop_animation/views/screens/home_page.dart';

class UserAuthService {
  final _userAuthentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(BuildContext context, String email, String password,
      String username) async {
    UserCredential userCredential =
        await _userAuthentication.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'username': username,
        'email': email,
      });
      Navigator.of(context).pushReplacement(CupertinoPageRoute(
        builder: (context) => HomePage(),
      ));
    }
  }

  Future<void> logInUser(String email, String password) async {
    await _userAuthentication.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> resetPasswordUser(String email) async {
    await _userAuthentication.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<void> signOut() async {
    await _userAuthentication.signOut();
  }

  Future<void> updateUserProfile(
      String userId, String username, String? photoUrl) async {
    await _firestore.collection('users').doc(userId).update({
      'username': username,
      if (photoUrl != null) 'photoUrl': photoUrl,
    });
  }

  Future<DocumentSnapshot> getUserProfile(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }
}
