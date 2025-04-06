import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class ForgotPasswordController extends GetxController {
  final _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSuccess = false.obs;
  
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
  
  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      isSuccess.value = false;
      
      final result = await _authService.resetPassword(
        emailController.text.trim(),
      );
      
      if (result) {
        isSuccess.value = true;
        // For demo, we'll just show a success message
        // In a real app, you'd navigate to an OTP verification screen
      } else {
        errorMessage.value = 'Reset password failed';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
  
  void goBack() {
    Get.back();
  }
}