/*

Auth repo = outlines the possible auth operations for this app.

 */

import 'package:kitkat_social_app/features/auth/domain/entities/appUser.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  );

  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}
