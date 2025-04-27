import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;
  const FollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color:
              !isFollowing
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
        ),

        child: Center(
          child: Text(
            isFollowing ? "Unfollow" : "Follow",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
