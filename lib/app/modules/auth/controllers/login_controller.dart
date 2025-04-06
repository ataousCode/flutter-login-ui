import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await _authService.login(
        emailController.text.trim(),
        passwordController.text,
      );
      
      if (result) {
        Get.offAllNamed(Routes.HOME);
      } else {
        errorMessage.value = 'Invalid email or password';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
  
  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }
  
  void goToForgotPassword() {
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }

  void goToMobileSignIn() {
  Get.toNamed(Routes.MOBILE_SIGNIN);
}
}