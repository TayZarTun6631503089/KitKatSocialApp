import 'package:kitkat_social_app/features/posts/domain/entities/post.dart';

abstract class PostStates {}

// initial
class PostsInitial extends PostStates {}

// loading
class PostsLoading extends PostStates {}

// uploading
class PostUploading extends PostStates {}

// error
class PostsError extends PostStates {
  final String messages;
  PostsError(this.messages);
}

// loaded
class PostsLoaded extends PostStates {
  final List<Post> posts;
  PostsLoaded(this.posts);
}
