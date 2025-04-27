import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/profile/domain/entities/profile_user.dart';
import 'package:kitkat_social_app/features/profile/domain/repo/profile_repo.dart';
import 'package:kitkat_social_app/features/profile/presentation/cubits/profile_state.dart';
import 'package:kitkat_social_app/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.profileRepo, required this.storageRepo})
    : super(ProfileInitial());

  // fetch user profile using repo

  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // return user profile given uid
  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }

  // update bio and profile picture
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());
    try {
      // fetch the current user
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError("Failed to update"));
        return;
      }
      // profile picture update
      String? imageDownloadedUrl;
      // ensure there is an image
      if (imageWebBytes != null || imageMobilePath != null) {
        if (imageMobilePath != null) {
          imageDownloadedUrl = await storageRepo.uploadProfileImageMobile(
            imageMobilePath,
            uid,
          );
        } else if (imageWebBytes != null) {
          imageDownloadedUrl = await storageRepo.uploadProfileImageWeb(
            imageWebBytes,
            uid,
          );
        } else {
          emit(ProfileError("Failed to upload image"));
        }
      }

      // update new profile

      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadedUrl ?? currentUser.profileImageUrl,
      );

      // update in repo
      await profileRepo.updateProfile(updatedProfile);

      // re-fetch the updated profile
      await profileRepo.fetchUserProfile(uid);

      // loaded state
      final updatedUser = await profileRepo.fetchUserProfile(uid);
      if (updatedUser != null) {
        emit(ProfileLoaded(updatedUser));
      } else {
        emit(ProfileError("User not found after update"));
      }
    } catch (e) {
      emit(ProfileError("Failed $e"));
    }
  }

  //toggle follow
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      await profileRepo.toggleFollow(currentUid, targetUid);
    } catch (e) {
      emit(ProfileError("Error toggling following $e"));
    }
  }
}
