// File: app/modules/auth/controllers/mobile_signin_controller.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class MobileSignInController extends GetxController {
  final _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  
  // Country code selection
  final RxString selectedCountryCode = '+1'.obs;
  final List<String> countryCodes = ['+1', '+44', '+91', '+61', '+86'];
  
  // OTP fields
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  
  final List<FocusNode> otpFocusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );
  
  // State management
  final RxBool isLoading = false.obs;
  final RxBool isOtpSent = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt resendCounter = 60.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Add listeners to OTP fields to auto-advance focus
    for (int i = 0; i < 5; i++) {
      otpControllers[i].addListener(() {
        if (otpControllers[i].text.length == 1) {
          otpFocusNodes[i + 1].requestFocus();
        }
      });
    }
  }
  
  @override
  void onClose() {
    phoneController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }
  
  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) return;
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, we'll just switch to OTP entry mode
      isOtpSent.value = true;
      
      // Start countdown for resend OTP
      startResendCounter();
      
      // Show success message
      Get.snackbar(
        'OTP Sent',
        'A verification code has been sent to your mobile number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
      );
      
    } catch (e) {
      errorMessage.value = 'An error occurred: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> verifyOtp() async {
    // Combine OTP digits
    final otp = otpControllers.map((c) => c.text).join();
    
    if (otp.length != 6) {
      errorMessage.value = 'Please enter all 6 digits';
      return;
    }
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, any 6-digit code is considered valid
      // In a real app, this would verify with your backend
      
      // Create a demo user or get existing user
      await _authService.register(
        'mobile_user', 
        'mobile_user@example.com', 
        'password123'
      );
      
      // Navigate to home screen
      Get.offAllNamed(Routes.HOME);
      
    } catch (e) {
      errorMessage.value = 'An error occurred: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
  
  void changePhoneNumber() {
    // Reset OTP fields
    for (var controller in otpControllers) {
      controller.clear();
    }
    
    // Go back to phone number entry
    isOtpSent.value = false;
    errorMessage.value = '';
  }
  
  void resendOtp() {
    if (resendCounter.value > 0) return;
    
    // Simulate resending OTP
    isLoading.value = true;
    
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      
      // Reset countdown
      startResendCounter();
      
      Get.snackbar(
        'OTP Resent',
        'A new verification code has been sent to your mobile number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
      );
    });
  }
  
  void startResendCounter() {
    resendCounter.value = 60;
    
    // Count down from 60 seconds
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (resendCounter.value > 0) {
        resendCounter.value -= 1;
        return true;
      }
      return false;
    });
  }
}