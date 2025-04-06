// File: app/modules/profile/controllers/account_controller.dart
// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/user_service.dart';
import '../../../routes/app_pages.dart';

class AccountController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _userService = Get.find<UserService>();
  
  final formKey = GlobalKey<FormState>();
  
  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmationChecked = false.obs;
  final RxString errorMessage = ''.obs;
  
  late String userEmail;
  
  @override
  void onInit() {
    super.onInit();
    // Get current user email
    userEmail = _authService.user?.email ?? '';
  }
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  Future<void> deleteAccount() async {
    if (!formKey.currentState!.validate()) return;
    
    if (!isConfirmationChecked.value) {
      Get.snackbar(
        'Confirmation Required',
        'Please confirm that you understand this action is permanent',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    
    // Add an extra confirmation dialog for safety
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Final Confirmation'),
        content: const Text(
          'Are you absolutely sure you want to delete your account? This action cannot be undone.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Yes, Delete My Account'),
          ),
        ],
      ),
    );
    
    if (confirm != true) return;
    
    isLoading.value = true;
    try {
      // Verify credentials and delete account
      final success = await _authService.deleteAccount(
        email: emailController.text,
        password: passwordController.text,
      );
      
      if (success) {
        // Show success message
        Get.snackbar(
          'Account Deleted',
          'Your account has been successfully deleted',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to login screen
        Get.offAllNamed(Routes.LOGIN);
      } else {
        errorMessage.value = 'Failed to delete account. Please check your credentials.';
      }
    } catch (e) {
      errorMessage.value = 'Error deleting account: ${e.toString()}';
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