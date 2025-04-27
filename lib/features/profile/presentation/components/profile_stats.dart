import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postCount, followerCount, followingCount;
  final void Function()? onTap;
  const ProfileStats({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              children: [Text(postCount.toString()), Text("Posts")],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              children: [Text(followerCount.toString()), Text("Follower")],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              children: [Text(followingCount.toString()), Text("Following")],
            ),
          ),
        ],
      ),
    );
  }
}
