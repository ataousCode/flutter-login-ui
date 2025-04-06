// File: app/modules/profile/controllers/profile_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/user_service.dart';
import '../../../data/models/user_model.dart';

class ProfileController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _userService = Get.find<UserService>();
  
  final formKey = GlobalKey<FormState>();
  
  // Text controllers for form fields
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();
  final websiteController = TextEditingController();
  final locationController = TextEditingController();
  
  // Observable variables
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isLoading = false.obs;
  final RxString profileImagePath = ''.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }
  
  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    websiteController.dispose();
    locationController.dispose();
    super.onClose();
  }
  
  Future<void> loadUserProfile() async {
    isLoading.value = true;
    
    try {
      // Get user from auth service
      final currentUser = _authService.user;
      
      if (currentUser != null) {
        // Get detailed user profile from user service
        final userProfile = await _userService.getUserProfile(currentUser.id);
        user.value = userProfile;
        
        // Populate form fields
        nameController.text = userProfile.fullName ?? '';
        usernameController.text = userProfile.username;
        bioController.text = userProfile.bio ?? '';
        phoneController.text = userProfile.phone ?? '';
        websiteController.text = userProfile.website ?? '';
        locationController.text = userProfile.location ?? '';
      }
    } catch (e) {
      errorMessage.value = 'Error loading profile: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> saveProfileChanges() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading.value = true;
    try {
      // Create updated user object
      final updatedUser = UserModel(
        id: user.value!.id,
        username: usernameController.text.trim(),
        email: user.value!.email,
        fullName: nameController.text.trim(),
        bio: bioController.text.trim(),
        phone: phoneController.text.trim(),
        website: websiteController.text.trim(),
        location: locationController.text.trim(),
        photoUrl: user.value?.photoUrl,
      );
      
      // Update profile image if changed
      if (profileImagePath.value.isNotEmpty) {
        final photoUrl = await _userService.uploadProfileImage(
          userId: user.value!.id,
          imagePath: profileImagePath.value,
        );
        updatedUser.photoUrl = photoUrl;
      }
      
      // Save changes to server
      await _userService.updateUserProfile(updatedUser);
      
      // Update local user object
      user.value = updatedUser;
      
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Go back to profile screen
      Get.back();
    } catch (e) {
      errorMessage.value = 'Error updating profile: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        profileImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void removeProfileImage() {
    profileImagePath.value = '';
    if (user.value != null) {
      user.value!.photoUrl = null;
    }
  }
}