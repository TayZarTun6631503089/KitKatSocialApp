import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitkat_social_app/features/profile/domain/entities/profile_user.dart';
import 'package:kitkat_social_app/features/profile/domain/repo/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc =
          await firebaseFirestore.collection("users").doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          //fetch followers and following
          final followers = List<String>.from(userData["followers"] ?? []);
          final following = List<String>.from(userData["following"] ?? []);
          return ProfileUser(
            uid: uid,
            email: userData["email"],
            name: userData["name"],
            bio: userData["bio"] ?? "",
            profileImageUrl: userData["profileImageUrl"].toString(),
            followers: followers,
            following: following,
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    try {
      // convert updated profile to json to store in firestore
      await firebaseFirestore
          .collection("users")
          .doc(updatedProfile.uid)
          .update({
            "bio": updatedProfile.bio,
            "profileImageUrl": updatedProfile.profileImageUrl,
          });
    } catch (e) {}
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      final currentUserDoc =
          await firebaseFirestore.collection("users").doc(currentUid).get();
      final targetUserDoc =
          await firebaseFirestore.collection("users").doc(targetUid).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();
        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing = List<String>.from(
            currentUserData["following"] ?? [],
          );
          // check already follow

          if (currentFollowing.contains(targetUid)) {
            //unfollow
            await firebaseFirestore.collection("users").doc(currentUid).update({
              "following": FieldValue.arrayRemove([targetUid]),
            });
            await firebaseFirestore.collection("users").doc(targetUid).update({
              "followers": FieldValue.arrayRemove([currentUid]),
            });
          } else {
            //follow
            await firebaseFirestore.collection("users").doc(currentUid).update({
              "following": FieldValue.arrayUnion([targetUid]),
            });
            await firebaseFirestore.collection("users").doc(targetUid).update({
              "followers": FieldValue.arrayUnion([currentUid]),
            });
          }
        }
      }
    } catch (e) {}
  }
}
