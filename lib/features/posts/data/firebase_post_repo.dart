import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitkat_social_app/features/posts/domain/entities/comment.dart';
import 'package:kitkat_social_app/features/posts/domain/entities/post.dart';
import 'package:kitkat_social_app/features/posts/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // store the posts in a collection called "posts"
  final CollectionReference postsCollection = FirebaseFirestore.instance
      .collection("posts");

  @override
  Future<void> creatPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating posts : $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await postsCollection.doc(postId).delete();
    } catch (e) {
      throw Exception("Error deleting : $e");
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      // get all posts with the most recent
      final postsSnapshot =
          await postsCollection.orderBy("timestamp", descending: true).get();

      // convert each firestore doc from json -> list of post
      final List<Post> allPosts =
          postsSnapshot.docs
              .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
              .toList();
      return allPosts;
    } catch (e) {
      throw Exception("Error fetching posts : $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      // Fetch post with uid
      final postsSnapshot =
          await postsCollection.where("userId", isEqualTo: userId).get();

      // map doc json -> list of posts

      final List<Post> userPosts =
          postsSnapshot.docs
              .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
              .toList();
      return userPosts;
    } catch (e) {
      throw Exception("Failed to fetch user posts : $e");
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String uid) async {
    try {
      // get post doc from firestore
      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // check already like
        final hasLiked = post.likes.contains(uid);
        if (hasLiked) {
          post.likes.remove(uid);
        } else {
          post.likes.add(uid);
        }
        // update doc
        await postsCollection.doc(postId).update({"likes": post.likes});
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error toggling : $e");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      //get post doc
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // add new comment
        post.comments.add(comment);

        //update doc
        await postsCollection.doc(postId).update({
          "comments": post.comments.map((comment) => comment.toJson()).toList(),
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Comment error: $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      //get post doc
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // add new comment
        post.comments.removeWhere((comment) => comment.id == commentId);

        //update doc
        await postsCollection.doc(postId).update({
          "comments": post.comments.map((comment) => comment.toJson()).toList(),
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Comment error: $e");
    }
  }
}
