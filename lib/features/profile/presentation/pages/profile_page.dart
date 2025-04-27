import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/auth/domain/entities/appUser.dart';
import 'package:kitkat_social_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:kitkat_social_app/features/posts/presentation/components/post_tile.dart';
import 'package:kitkat_social_app/features/posts/presentation/cubits/post_cubit.dart';
import 'package:kitkat_social_app/features/posts/presentation/cubits/post_states.dart';
import 'package:kitkat_social_app/features/profile/presentation/components/bio_box.dart';
import 'package:kitkat_social_app/features/profile/presentation/components/follow_button.dart';
import 'package:kitkat_social_app/features/profile/presentation/components/profile_stats.dart';
import 'package:kitkat_social_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:kitkat_social_app/features/profile/presentation/cubits/profile_state.dart';
import 'package:kitkat_social_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:kitkat_social_app/features/profile/presentation/pages/follower_page.dart';
import 'package:kitkat_social_app/features/responsives/constrained_scaffold.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  late AppUser? currentUser = authCubit.currentUser;
  int postCount = 0;

  @override
  void initState() {
    super.initState();

    // fetch user profile
    profileCubit.fetchUserProfile(widget.uid);
  }

  /* 

  Follow Unfollow
  
  */
  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      return;
    }
    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    // smoother Ui
    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      } else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      setState(() {
        if (isFollowing) {
          profileUser.followers.add(currentUser!.uid);
        } else {
          profileUser.followers.remove(currentUser!.uid);
        }
      });
    });
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    bool isOwnPost = (widget.uid == currentUser!.uid);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        //loaded
        if (state is ProfileLoaded) {
          // get loaded user
          final user = state.profileUser;
          return ConstrainedScaffold(
            appBar: AppBar(
              title: Text(user.name),
              actions: [
                // edit button
                if (isOwnPost)
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: user),
                        ),
                      );
                    },
                    icon: Icon(Icons.edit),
                  ),
              ],
            ),
            body: Column(
              children: [
                //email
                Text(user.email),
                SizedBox(height: 25),
                //Profile
                CachedNetworkImage(
                  imageUrl: user.profileImageUrl,
                  // loading..
                  placeholder: (context, url) => CircularProgressIndicator(),

                  // error
                  errorWidget:
                      (context, url, error) => Icon(Icons.person, size: 70),
                  // loaded
                  imageBuilder:
                      (context, imageProvider) => Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),

                ProfileStats(
                  postCount: postCount,
                  followerCount: user.followers.length,
                  followingCount: user.following.length,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => FollowerPage(
                                followers: user.followers,
                                following: user.following,
                              ),
                        ),
                      ),
                ),

                if (!isOwnPost)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FollowButton(
                        onPressed: followButtonPressed,
                        isFollowing: user.followers.contains(currentUser!.uid),
                      ),
                    ],
                  ),

                SizedBox(height: 20),

                // Bio Box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(children: [Text("Bio")]),
                ),

                BioBox(text: user.bio),
                SizedBox(height: 10),
                // Posts Box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(children: [Text("Posts")]),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      // list of posts
                      BlocBuilder<PostCubit, PostStates>(
                        builder: (context, state) {
                          if (state is PostsLoaded) {
                            //filter posts
                            final userPosts =
                                state.posts
                                    .where(
                                      (post) => (post.userId == widget.uid),
                                    )
                                    .toList();
                            postCount = userPosts.length;
                            return ListView.builder(
                              itemCount: postCount,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final post = userPosts[index];
                                //return as post tile
                                return PostTile(
                                  post: post,
                                  deleteOnPressed:
                                      () => context
                                          .read<PostCubit>()
                                          .deletePost(post.id),
                                );
                              },
                            );
                          } else if (state is PostsLoading) {
                            return CircularProgressIndicator();
                          } else if (state is PostsError) {
                            return Center(child: Text("Error"));
                          } else {
                            return Center(child: Text("Error"));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        // loading
        else if (state is ProfileLoading) {
          return const ConstrainedScaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return Center(child: const Text("No Profile found"));
        }
      },
    );
  }
}
