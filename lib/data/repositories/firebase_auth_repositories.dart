import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_parkingo/domain/entities/user_entity.dart';

class FirebaseAuthRepositories {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserEntity> signIn(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    if (user == null) {
      throw Exception("User not found");
    }

    // Fetch profile_pic_url from Firestore
    String profilePictureUrl = "";
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firebaseFirestore.collection('users').doc(user.uid).get();

    if (snapshot.exists && snapshot.data() != null) {
      profilePictureUrl = snapshot.data()?['profile_pic_url'] ?? "";
      debugPrint("inside signIn profile pic url: $profilePictureUrl");
    }

    return UserEntity(
      uid: user.uid,
      email: user.email ?? 'No email provided',
      displayName: user.displayName ?? 'No display name',
      profilePictureUrl: profilePictureUrl,
    );
  }

  Future<UserEntity?> signInwithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Check if Google sign-in was successful
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create OAuthCredential with the Google access and id tokens
      final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      // Sign in to Firebase with Google credentials
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Handle potential null values safely
      if (user != null) {
        return UserEntity(
            uid: user.uid,
            email: user.email ?? 'No email provided',
            displayName: user.displayName ?? 'No display name');
      }
    }

    return null; // Return null if the sign-in failed or user is null
  }

  Future<UserEntity> signUp(
      String displayName, String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    await user?.updateDisplayName(displayName);
    user?.reload();
    user = _firebaseAuth.currentUser!;
    await _firebaseFirestore.collection("user").doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName
    });
    return UserEntity(uid: user.uid, email: email, displayName: displayName);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
