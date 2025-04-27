import 'package:kitkat_social_app/features/posts/domain/entities/comment.dart';
import 'package:kitkat_social_app/features/posts/domain/entities/post.dart';

abstract class PostRepo {
  // fecth all post
  Future<List<Post>> fetchAllPosts();

  // create post
  Future<void> creatPost(Post post);

  // delete post
  Future<void> deletePost(String postId);

  // fetch post from specific user
  Future<List<Post>> fetchPostsByUserId(String userId);

  // like posts
  Future<void> toggleLikePost(String postId, String uid);

  // comment
  Future<void> addComment(String postId, Comment comment);
  Future<void> deleteComment(String postId, String commentId);
}
