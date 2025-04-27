import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kitkat_social_app/features/auth/domain/entities/appUser.dart';
import 'package:kitkat_social_app/features/auth/domain/repo/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // Attempt the sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // Fetch user's name from Firestore
      final doc =
          await firebaseFirestore
              .collection("users")
              .doc(userCredential.user!.uid)
              .get();

      String name = "";
      if (doc.exists && doc.data() != null) {
        name = doc.data()!['name'] ?? "";
      }

      // Create Our User
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      // REturn user
      return user;
    }
    //Catch any errors
    catch (e) {
      throw Exception('Login Failed : $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      // Attempt the sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create Our User
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      // save user data in fire store
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());

      // Return user
      return user;
    }
    //Catch any errors
    catch (e) {
      throw Exception('Login Failed : $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    // Get Current User from firebase
    final firebaseuser = firebaseAuth.currentUser;

    // No user login
    if (firebaseuser == null) {
      return null;
    }

    // fetch User doc
    DocumentSnapshot userDoc =
        await firebaseFirestore.collection("users").doc(firebaseuser.uid).get();

    return AppUser(
      uid: firebaseuser.uid,
      email: firebaseuser.email!,
      name: userDoc["name"],
    );
  }
}
