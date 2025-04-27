import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/posts/domain/entities/comment.dart';
import 'package:kitkat_social_app/features/posts/domain/entities/post.dart';
import 'package:kitkat_social_app/features/posts/domain/repos/post_repo.dart';
import 'package:kitkat_social_app/features/posts/presentation/cubits/post_states.dart';
import 'package:kitkat_social_app/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostStates> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;
  PostCubit({
    required this.postRepo,
    //
    required this.storageRepo,
  }) : super(PostsInitial());

  // create a new post
  Future<void> createPost(
    Post post, {
    String? imagePath,
    Uint8List? imageBytes,
  }) async {
    String? imageUrl;
    try {
      // print(imagePath);
      // print(post.id);
      // handle image upload for mobile platforms file path
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }
      // handle image upload for web file bytes
      else if (imageBytes != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }
      // print(imageUrl);

      // Only save post if imageUrl is present
      // if ((imagePath != null || imageBytes != null) &&
      //     (imageUrl == null || imageUrl.isEmpty)) {
      //   emit(PostsError("Failed to upload image. Post not saved."));
      //   return;
      // }

      // give image url to post
      final newPost = post.copyWith(imageUrl: imageUrl ?? '');

      // create post in the backend
      await postRepo.creatPost(newPost);

      // re-fetch post
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError(("Failed to create post : $e")));
    }
  }

  // fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to fetch posts : $e"));
    }
  }

  // delete post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {}
  }

  // fetch user posts
  Future<void> fetchUserPosts(String userId) async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchPostsByUserId(userId);
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to fetch posts : $e"));
    }
  }

  // toggle like
  Future<void> toggleLikePost(String postId, String uid) async {
    try {
      await postRepo.toggleLikePost(postId, uid);
    } catch (e) {
      emit(PostsError("Like Error : $e"));
    }
  }

  // Add Comment
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed comment : $e"));
    }
  }

  // Delete Comment
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed Delete Comment : $e"));
    }
  }
}
