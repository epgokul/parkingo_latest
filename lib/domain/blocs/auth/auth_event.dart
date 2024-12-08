import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Sign In Event
class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  SignInEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

// Sign In with Google Event
class SignInWithGoogleEvent extends AuthEvent {}

// Sign Up Event
class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String displayName;

  SignUpEvent(this.email, this.password, this.displayName);

  @override
  List<Object?> get props => [email, password, displayName];
}

class RemoveUserEvent extends AuthEvent {
  final String uid;
  RemoveUserEvent(this.uid);

  @override
  List<Object?> get props => [uid];
}

// Sign Out Event
class SignOutEvent extends AuthEvent {}

// Check Auth Status Event
class CheckAuthStatusEvent extends AuthEvent {}

// Authenticated Event (When the user is authenticated)
class AuthenticatedEvent extends AuthEvent {
  final User user; // Firebase user object

  AuthenticatedEvent(this.user);

  @override
  List<Object?> get props => [user];
}

// UnAuthenticated Event (When the user is unauthenticated)
class UnAuthenticatedEvent extends AuthEvent {}

// Event for updating the profile picture

class UploadProfilePictureEvent extends AuthEvent {
  final String userId;
  final File imageFile; // New field for the selected image file

  UploadProfilePictureEvent({required this.userId, required this.imageFile});

  @override
  List<Object?> get props => [userId, imageFile];
}

// class FetchAllUsersEvent extends AuthEvent {}
