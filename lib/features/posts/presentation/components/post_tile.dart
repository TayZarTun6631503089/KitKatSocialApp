import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/auth/domain/entities/appUser.dart';
import 'package:kitkat_social_app/features/auth/presentation/components/my_text_field.dart';
import 'package:kitkat_social_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:kitkat_social_app/features/posts/domain/entities/comment.dart';
import 'package:kitkat_social_app/features/posts/domain/entities/post.dart';
import 'package:kitkat_social_app/features/posts/presentation/components/comment_tile.dart';
import 'package:kitkat_social_app/features/posts/presentation/cubits/post_cubit.dart';
import 'package:kitkat_social_app/features/posts/presentation/cubits/post_states.dart';
import 'package:kitkat_social_app/features/profile/domain/entities/profile_user.dart';
import 'package:kitkat_social_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:kitkat_social_app/features/profile/presentation/pages/profile_page.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? deleteOnPressed;
  const PostTile({
    super.key,
    required this.post,
    required this.deleteOnPressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  //Cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnpost = false;

  // Current User
  AppUser? currentUser;

  // post user
  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();

    // get Current User
    getCurrentUser();

    // Fetch post User
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnpost = widget.post.userId == currentUser!.uid;
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  //show Options delete or not
  void showOption() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Post?"),
            actions: [
              //Cencel button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cencel"),
              ),

              //delete button
              TextButton(
                onPressed: () {
                  widget.deleteOnPressed!();
                  Navigator.pop(context);
                },
                child: Text("Delete"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  /*
    Like
 */

  void updateToggleLikePost() {
    // current Like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // smothly flow like UI
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });

    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((
      error,
    ) {
      // back to original
      if (isLiked) {
        widget.post.likes.add(currentUser!.uid);
      } else {
        widget.post.likes.remove(currentUser!.uid);
      }
    });
  }

  // comment
  final commentTextController = TextEditingController();

  void openNewCommentBox() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Add a new comment"),
            content: MyTextField(
              controller: commentTextController,
              hintText: "Type New Comment",
              obsureText: false,
            ),
            actions: [
              //Cencel button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cencel"),
              ),

              //delete button
              TextButton(
                onPressed: () {
                  addCommentPost();
                  Navigator.pop(context);
                },
                child: Text("Save"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.greenAccent,
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void addCommentPost() {
    //create new comment
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    // add comment using cubit
    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    } else {}
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  //Build UI
  @override
  Widget build(BuildContext context) {
    final postTime = widget.post.timestamp;
    return Container(
      child: Column(
        children: [
          //top
          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(uid: widget.post.userId),
                  ),
                ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Profile picture
                  postUser?.profileImageUrl != null
                      ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget:
                            (context, url, error) =>
                                const Icon(Icons.person_2_outlined),
                        imageBuilder:
                            (context, imageProvider) => Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      )
                      : const Icon(Icons.person),
                  // Name
                  SizedBox(width: 10),
                  Text(
                    widget.post.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  if (isOwnpost)
                    GestureDetector(
                      onTap: showOption,
                      child: Icon(
                        Icons.delete,
                        size: 30,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 430),
            errorWidget:
                (context, url, error) => const Icon(Icons.error_outline),
          ),

          // buttons -> Like, comment ,timestamp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Row(
              children: [
                //like
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: updateToggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              widget.post.likes.contains(currentUser!.uid)
                                  ? Colors.red
                                  : null,
                        ),
                      ),
                      Text("${widget.post.likes.length}"),
                    ],
                  ),
                ),

                //comment
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(Icons.comment_outlined),
                ),
                Text("${widget.post.comments.length}"),

                Spacer(),
                //timestemp
                Text(
                  "${postTime.day}-${postTime.month}-${postTime.year} ${postTime.hour}:${postTime.minute}",
                ),
              ],
            ),
          ),

          //Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                // Username
                Text(
                  widget.post.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),

                // text
                Text("-   ${widget.post.text}"),
              ],
            ),
          ),

          //Comment
          BlocBuilder<PostCubit, PostStates>(
            builder: (context, state) {
              if (state is PostsLoaded) {
                //fetch
                final post = state.posts.firstWhere(
                  (post) => (post.id == widget.post.id),
                );
                if (post.comments.isNotEmpty) {
                  //how many comment
                  int showCommentCount = post.comments.length;
                  return ListView.builder(
                    itemCount: showCommentCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // get individual comment
                      final comment = post.comments[index];
                      // comment tile ui
                      return CommentTile(comment: comment);
                    },
                  );
                }
              }
              if (state is PostsLoading) {
                return const CircularProgressIndicator();
              } else if (state is PostsError) {
                return Center(child: Text(state.messages));
              } else {
                return Center(child: Text("Error"));
              }
            },
          ),
        ],
      ),
    );
  }
}
