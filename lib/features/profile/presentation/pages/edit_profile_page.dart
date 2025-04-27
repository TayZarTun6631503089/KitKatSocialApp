import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/auth/presentation/components/my_text_field.dart';
import 'package:kitkat_social_app/features/profile/domain/entities/profile_user.dart';
import 'package:kitkat_social_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:kitkat_social_app/features/profile/presentation/cubits/profile_state.dart';
import 'package:kitkat_social_app/features/responsives/constrained_scaffold.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Mobile image pick
  PlatformFile? imagePickedFile;

  // Web image pick
  Uint8List? webImage;

  //bio Text controller
  final bioTextController = TextEditingController();

  // pick Images
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

  void updateProfile() async {
    // profile cubit
    final profileCubit = context.read<ProfileCubit>();

    // Prepare image & data
    final String uid = widget.user.uid;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    // Only update if needed
    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
        uid: uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    }
    //Nothing to update
    else {
      Navigator.pop(context);
    }
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // profile loading..
        if (state is ProfileLoading) {
          return ConstrainedScaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(), Text("Uploading...")],
              ),
            ),
          );
        } else {
          // edit form
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage() {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [IconButton(onPressed: updateProfile, icon: Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            // profile picture
            Center(
              child: Container(
                height: 200,
                width: 200,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
                child:
                    // Display for mobile
                    (!kIsWeb && imagePickedFile != null)
                        ? Image.file(
                          File(imagePickedFile!.path!),
                          fit: BoxFit.cover,
                        )
                        // Display for web
                        : (kIsWeb && webImage != null)
                        ? Image.memory(webImage!, fit: BoxFit.cover)
                        :
                        // No image selected existing show
                        CachedNetworkImage(
                          imageUrl: widget.user.profileImageUrl,
                          // loading..
                          placeholder:
                              (context, url) => CircularProgressIndicator(),

                          // error
                          errorWidget:
                              (context, url, error) =>
                                  Icon(Icons.person, size: 70),
                          // loaded
                          imageBuilder:
                              (context, imageProvider) =>
                                  Image(image: imageProvider),
                          fit: BoxFit.cover,
                        ),
              ),
            ),

            const SizedBox(height: 10),

            // pick image button
            Center(
              child: MaterialButton(
                onPressed: pickImage,
                color: Colors.blue,
                child: Text("Pick Image"),
              ),
            ),

            // bio
            Text("Bio"),
            const SizedBox(height: 10),
            MyTextField(
              controller: bioTextController,
              hintText: widget.user.bio,
              obsureText: false,
            ),
          ],
        ),
      ),
    );
  }
}
