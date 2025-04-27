/* 
    Auth States
*/

import 'package:kitkat_social_app/features/auth/domain/entities/appUser.dart';

abstract class AuthState {}

// initial

class AuthInitial extends AuthState {}

// loading
class AuthLoading extends AuthState {}

// authenticated
class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);
}

// unauthenticated
class Unauthenticated extends AuthState {}

// errors
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
