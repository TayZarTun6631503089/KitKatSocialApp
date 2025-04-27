import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitkat_social_app/features/profile/domain/entities/profile_user.dart';
import 'package:kitkat_social_app/features/search/domain/repos/search_repo.dart';

class FirebaseSearchRepo implements SearchRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<List<ProfileUser?>> searchUsers(String query) async {
    try {
      final result =
          await firestore
              .collection("users")
              .where("name", isGreaterThanOrEqualTo: query)
              .where("name", isLessThanOrEqualTo: "$query\uf8ff")
              .get();

      return result.docs
          .map((doc) => ProfileUser.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error Searching : $e");
    }
  }
}
