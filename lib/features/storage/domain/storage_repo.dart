import 'dart:typed_data';

abstract class StorageRepo {
  // Upload profile images on mobile platforms
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  // upload profile images on web platforms
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName);

  // Upload profile images on mobile platforms
  Future<String?> uploadPostImageMobile(String path, String fileName);

  // upload profile images on web platforms
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName);
}
