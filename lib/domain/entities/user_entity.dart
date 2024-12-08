import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  final String uid;
  final String email;
  final String displayName;
  final String? profilePictureUrl;

  UserEntity(
      {required this.uid,
      required this.email,
      required this.displayName,
      this.profilePictureUrl});

  factory UserEntity.fromFirebaseUser(User user) {
    return UserEntity(
        uid: user.uid,
        email: user.email ?? "Error",
        displayName: user.displayName ?? "Error",
        profilePictureUrl: user.photoURL);
  }
}
