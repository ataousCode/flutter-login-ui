// File: app/modules/profile/controllers/password_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class PasswordController extends GetxController {
  final _authService = Get.find<AuthService>();
  
  final formKey = GlobalKey<FormState>();
  
  // Text controllers
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isCurrentPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString passwordStrength = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Listen to password changes to calculate strength
    newPasswordController.addListener(_updatePasswordStrength);
  }
  
  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }
  
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  
  void _updatePasswordStrength() {
    final password = newPasswordController.text;
    
    if (password.isEmpty) {
      passwordStrength.value = '';
      return;
    }
    
    // Calculate password strength
    int score = 0;
    
    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    
    // Complexity checks
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    
    // Set strength based on score
    switch (score) {
      case 0:
      case 1:
      case 2:
        passwordStrength.value = 'Weak';
        break;
      case 3:
      case 4:
        passwordStrength.value = 'Medium';
        break;
      case 5:
        passwordStrength.value = 'Strong';
        break;
      case 6:
        passwordStrength.value = 'Very Strong';
        break;
      default:
        passwordStrength.value = '';
    }
  }
  
  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) return;
    
    // Check password strength
    if (passwordStrength.value == 'Weak') {
      Get.snackbar(
        'Weak Password',
        'Please choose a stronger password for better security',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    
    isLoading.value = true;
    try {
      // Verify current password and update to new password
      final success = await _authService.changePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      );
      
      if (success) {
        // Clear controllers
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        
        Get.snackbar(
          'Success',
          'Password changed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Go back to settings
        Get.back();
      } else {
        errorMessage.value = 'Current password is incorrect';
      }
    } catch (e) {
      errorMessage.value = 'Error changing password: ${e.toString()}';
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
}