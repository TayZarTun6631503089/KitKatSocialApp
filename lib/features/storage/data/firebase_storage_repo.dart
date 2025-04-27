import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:kitkat_social_app/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo extends StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }

  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }

  /*

  Helper -- to upload file to storage
  
   */

  // Mobile platform (file)

  Future<String?> _uploadFile(
    String path,
    String fileName,
    String folder,
  ) async {
    try {
      // get file
      final file = File(path);

      // Find place to store
      final storageRef = storage.ref().child("$folder/$fileName");

      // upload
      final uploadTask = await storageRef.putFile(file);

      //get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Web platform (bytes)
  Future<String?> _uploadFileBytes(
    Uint8List fileBytes,
    String fileName,
    String folder,
  ) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;

      // find place to store
      final storageReg = storage.ref().child("$folder/$fileName");

      // upload
      final uploadTask = await storageReg.putData(fileBytes);

      // get image download link
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
