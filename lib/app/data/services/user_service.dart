// File: app/data/services/user_service.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';

class UserService extends GetxService {
  final _storage = GetStorage();
  final _userProfileKey = 'user_profile';
  
  // Get user profile
  Future<UserModel> getUserProfile(String userId) async {
    try {
      // In a real app, you'd fetch this from your backend API
      // For now, we'll use local storage
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      final storedProfile = _storage.read(_userProfileKey);
      
      if (storedProfile != null) {
        return UserModel.fromJson(storedProfile);
      }
      
      // Create a default profile if none exists
      final defaultProfile = UserModel(
        id: userId,
        username: 'user_$userId',
        email: 'user$userId@example.com',
        fullName: 'Default User',
        bio: 'This is a default bio. Edit your profile to change it.',
        phone: '',
        website: '',
        location: '',
        photoUrl: '',
        preferences: {
          'push_notifications': true,
          'email_notifications': true,
          'biometric': false,
          'location': false,
        },
      );
      
      // Save default profile to storage
      await _storage.write(_userProfileKey, defaultProfile.toJson());
      
      return defaultProfile;
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }
  
  // Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      // In a real app, you'd send this to your backend API
      // For now, we'll use local storage
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Save updated profile to storage
      await _storage.write(_userProfileKey, user.toJson());
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }
  
  // Upload profile image
  Future<String> uploadProfileImage({
    required String userId,
    required String imagePath,
  }) async {
    try {
      // In a real app, you'd upload the image to your server or cloud storage
      // For now, we'll simulate the upload
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Return a fake URL (in a real app, this would be the URL of the uploaded image)
      return 'https://example.com/profile_images/$userId.jpg';
    } catch (e) {
      throw Exception('Failed to upload profile image: ${e.toString()}');
    }
  }
  
  // Update user preferences
  Future<void> updateUserPreferences(String userId, Map<String, dynamic> preferences) async {
    try {
      // Get current user profile
      final userProfile = await getUserProfile(userId);
      
      // Update preferences
      userProfile.preferences = preferences;
      
      // Save updated profile
      await updateUserProfile(userProfile);
    } catch (e) {
      throw Exception('Failed to update user preferences: ${e.toString()}');
    }
  }
  
  // Delete user profile data (for account deletion)
  Future<void> deleteUserProfileData(String userId) async {
    try {
      // In a real app, you'd delete user data from your backend
      // For now, we'll just remove it from local storage
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Remove profile data from storage
      await _storage.remove(_userProfileKey);
    } catch (e) {
      throw Exception('Failed to delete user profile data: ${e.toString()}');
    }
  }
}