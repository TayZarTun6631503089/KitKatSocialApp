import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/auth/domain/entities/appUser.dart';
import 'package:kitkat_social_app/features/auth/presentation/components/my_text_field.dart';
import 'package:kitkat_social_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:kitkat_social_app/features/posts/domain/entities/post.dart';
import 'package:kitkat_social_app/features/posts/presentation/cubits/post_cubit.dart';
import 'package:kitkat_social_app/features/posts/presentation/cubits/post_states.dart';
import 'package:kitkat_social_app/features/responsives/constrained_scaffold.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // mobile image pick
  PlatformFile? imagePickedFile;

  // Web Image pick
  Uint8List? webImage;

  // text controller -> caption
  final textController = TextEditingController();

  // current user
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  //  select image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  // create & upload post
  void uploadPost() {
    // check both image and caption are provided
    if (textController.text.isEmpty || imagePickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Both image and caption are required")),
      );
      return;
    }
    // create a new post obj
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      name: currentUser!.name,
      imageUrl: "",
      text: textController.text,
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    // post cubit
    final postCubit = context.read<PostCubit>();
    // web upload
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    }
    // mobile upload
    else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      builder: (context, state) {
        // loading or uploading
        if (state is PostsLoading || state is PostUploading) {
          return ConstrainedScaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // build upload Page
        return buildUploadPage();
      },
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        actions: [IconButton(onPressed: uploadPost, icon: Icon(Icons.upload))],
      ),
      //body
      body: Center(
        child: Column(
          children: [
            // image preview for web
            if (kIsWeb && webImage != null) Image.memory(webImage!),

            // image preview for mobile
            if (!kIsWeb && imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!)),

            // pick image button
            MaterialButton(
              onPressed: pickImage,
              child: Text("Pick Image", style: TextStyle(color: Colors.blue)),
            ),

            // caption text box
            MyTextField(
              controller: textController,
              hintText: "Caption",
              obsureText: false,
            ),
          ],
        ),
      ),
    );
  }
}
