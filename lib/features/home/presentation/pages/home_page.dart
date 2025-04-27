import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/home/presentation/components/my_drawer.dart';
import 'package:kitkat_social_app/features/posts/presentation/components/post_tile.dart';
import 'package:kitkat_social_app/features/posts/presentation/cubits/post_cubit.dart';
import 'package:kitkat_social_app/features/posts/presentation/cubits/post_states.dart';
import 'package:kitkat_social_app/features/posts/presentation/pages/upload_post_page.dart';
import 'package:kitkat_social_app/features/responsives/constrained_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Post Cubit
  late final postCubit = context.read<PostCubit>();

  // On startup
  @override
  void initState() {
    super.initState();
    //fetch all post
    fetchAllPost();
  }

  // void fetchAllPost() async {
  //   await postCubit.fetchAllPosts();
  // }
  void fetchAllPost() {
    postCubit.fetchAllPosts();
  }

  void deletPost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPost();
  }

  //Build UI
  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      // App Bar
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          //upload new Post icons
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadPostPage()),
              );
            },
            icon: Icon(Icons.post_add),
          ),
        ],
      ),

      body: BlocBuilder<PostCubit, PostStates>(
        builder: (context, state) {
          print(state);
          //Loading
          if (state is PostsLoading && state is PostUploading) {
            return Center(child: CircularProgressIndicator());
          }
          //Loaded
          else if (state is PostsLoaded) {
            final allPosts = state.posts;
            if (allPosts.isEmpty) {
              return Center(child: Text("No Post avaiable!!"));
            } else {
              return ListView.builder(
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  final post = allPosts[index];
                  //image
                  return PostTile(
                    post: post,
                    deleteOnPressed: () => deletPost(post.id),
                  );
                },
              );
            }
          }
          //Error
          else if (state is PostsError) {
            return Center(child: Text(state.messages));
          } else {
            return const SizedBox();
          }
        },
      ),

      // Drawer
      drawer: MyDrawer(),
    );
  }
}
