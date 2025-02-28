import 'package:equatable/equatable.dart';
import 'package:new_parkingo/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthAuthenticatedAdmin extends AuthState {
  final UserEntity admin;
  AuthAuthenticatedAdmin(this.admin);
  @override
  List<Object?> get props => [admin];
}

class UnAuthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class ProfilePicLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserRemoved extends AuthState {}

// class UsersFetched extends AuthState {
//   final List<Map<String, dynamic>> users; // List of user details

//   UsersFetched(this.users);

//   @override
//   List<Object?> get props => [users];
// }
