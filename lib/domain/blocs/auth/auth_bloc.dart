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
      // Step 1: Upload the selected image to Firebase Storage
      final ref = _firebaseStorage
          .ref()
          .child('profile_pictures/${event.userId}/profile_pic');

      // Upload the image file and get the download URL
      final uploadTask = ref.putFile(event.imageFile);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      // Step 2: Update the user's profile photo in Firebase Auth
      await _firebaseAuth.currentUser?.updatePhotoURL(downloadUrl);

      // Step 3: Emit the updated AuthAuthenticated state with the new UserEntity
      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser != null) {
        emit(AuthAuthenticated(UserEntity.fromFirebaseUser(updatedUser)));
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

// Future<void> _onFetchAllUsers(
//     FetchAllUsersEvent event, Emitter<AuthState> emit) async {
//   try {
//     emit(AuthLoading());

//     // Reference the Firestore collection
//     final ref = FirebaseFirestore.instance.collection('users');

//     // Fetch all documents from the collection
//     final querySnapshot = await ref.get();

//     // Convert the documents to a list of maps
//     final users = querySnapshot.docs
//         .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
//         .toList();

//     emit(UsersFetched(users));
    
//   } catch (e) {
//     emit(AuthError(e.toString()));
//   }
// }
