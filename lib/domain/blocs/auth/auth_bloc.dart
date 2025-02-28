import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_parkingo/data/constants/const.dart';
import 'package:new_parkingo/data/repositories/firebase_auth_repositories.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_event.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_state.dart';
import 'package:new_parkingo/domain/entities/user_entity.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuthRepositories _firebaseAuthRepositories =
      FirebaseAuthRepositories();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthBloc() : super(AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<UploadProfilePictureEvent>(_onProfilePicUpload);
    on<RemoveUserEvent>(_onRemoveUser);
    // on<FetchAllUsersEvent>(_onFetchAllUsers);
  }
  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      var email = event.email;
      var password = event.password;
      final user = await _firebaseAuthRepositories.signIn(email, password);

      if (email == "parkingoadmin@gmail.com" && password == "parkingo123") {
        emit(AuthAuthenticatedAdmin(user));
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // print("inside Authbloc->signinwithgoogle");
      final user = await _firebaseAuthRepositories.signInwithGoogle();
      // print("booyah");
      emit(AuthAuthenticated(user!));
      // print("Fuck yeeah");
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _firebaseAuthRepositories.signUp(
          event.displayName, event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) {
    final currentUser = _firebaseAuth.currentUser;
    final email = currentUser?.email;
    if (currentUser != null && email == Constants.adminEmail) {
      emit(AuthAuthenticatedAdmin(UserEntity.fromFirebaseUser(currentUser)));
    } else if (currentUser != null) {
      emit(AuthAuthenticated(UserEntity.fromFirebaseUser(currentUser)));
    } else {
      emit(UnAuthenticated());
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.signOut();
      emit(UnAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  FutureOr<void> _onProfilePicUpload(
      UploadProfilePictureEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Step 1: Upload the image to Firebase Storage
      final ref = _firebaseStorage
          .ref()
          .child('profile_pictures/${event.userId}/profile_pic');

      final uploadTask = ref.putFile(event.imageFile);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Step 2: Update Firebase Auth profile photo
      await _firebaseAuth.currentUser?.updatePhotoURL(downloadUrl);

      // Step 3: Update Firestore user document with new profile URL
      await _firebaseFirestore
          .collection('user')
          .doc(event.userId)
          .update({'profile_pic_url': downloadUrl});

      // Step 4: Update UserEntity and emit new Authenticated state
      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser != null) {
        emit(AuthAuthenticated(UserEntity(
          uid: updatedUser.uid,
          email: updatedUser.email ?? 'No email provided',
          displayName: updatedUser.displayName ?? 'No display name',
          profilePictureUrl: downloadUrl, // Update UserEntity with new URL
        )));
      } else {
        emit(AuthError('Failed to update user profile.'));
      }
    } catch (e) {
      emit(AuthError('Failed to upload profile picture: ${e.toString()}'));
    }
  }

  FutureOr<void> _onRemoveUser(
      RemoveUserEvent event, Emitter<AuthState> emit) async {
    try {
      final ref = FirebaseFirestore.instance.collection('users');

      await ref.doc(event.uid).delete();
      emit(UserRemoved());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
