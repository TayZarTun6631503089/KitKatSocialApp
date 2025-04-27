import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/auth/domain/entities/appUser.dart';
import 'package:kitkat_social_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:kitkat_social_app/features/posts/domain/entities/comment.dart';
import 'package:kitkat_social_app/features/posts/presentation/cubits/post_cubit.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  //current user
  AppUser? currentUser;
  bool isOwnPost = false;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

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
                  context.read<PostCubit>().deleteComment(
                    widget.comment.postId,
                    widget.comment.id,
                  );
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

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          //Name
          Text(
            widget.comment.userName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(" - "),
          Text(widget.comment.text),

          Spacer(),
          // delete post
          if (isOwnPost)
            GestureDetector(
              onTap: showOption,
              child: Icon(Icons.more_horiz_outlined),
            ),
        ],
      ),
    );
  }
}
