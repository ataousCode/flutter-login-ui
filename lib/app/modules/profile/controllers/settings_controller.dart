// File: app/modules/profile/controllers/settings_controller.dart
// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/user_service.dart';
import '../views/profile_edit_view.dart';
import '../views/password_change_view.dart';
import '../views/account_deletion_view.dart';

class SettingsController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _userService = Get.find<UserService>();
  final _storage = GetStorage();
  
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isDarkMode = true.obs;
  final RxBool isPushNotificationsEnabled = true.obs;
  final RxBool isEmailNotificationsEnabled = true.obs;
  final RxBool isBiometricEnabled = false.obs;
  final RxBool isLocationEnabled = false.obs;
  
  // App version
  String appVersion = '1.0.0';
  
  // Storage keys
  final _darkModeKey = 'dark_mode';
  final _pushNotificationsKey = 'push_notifications';
  final _emailNotificationsKey = 'email_notifications';
  final _biometricKey = 'biometric';
  final _locationKey = 'location';
  
  @override
  void onInit() async {
    super.onInit();
    
    // Load settings from storage
    isDarkMode.value = _storage.read(_darkModeKey) ?? true;
    isPushNotificationsEnabled.value = _storage.read(_pushNotificationsKey) ?? true;
    isEmailNotificationsEnabled.value = _storage.read(_emailNotificationsKey) ?? true;
    isBiometricEnabled.value = _storage.read(_biometricKey) ?? false;
    isLocationEnabled.value = _storage.read(_locationKey) ?? false;
    
    // Get app version
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
    } catch (e) {
      appVersion = '1.0.0';
    }
  }
  
  // Navigation methods
  void goToEditProfile() {
    Get.to(() => const ProfileEditView());
  }
  
  void goToChangePassword() {
    Get.to(() => const PasswordChangeView());
  }
  
  void goToDeleteAccount() {
    Get.to(() => const AccountDeletionView());
  }
  
  // Toggle settings
  void toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    await _storage.write(_darkModeKey, value);
    
    // Apply theme change
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
  
  void togglePushNotifications(bool value) async {
    isPushNotificationsEnabled.value = value;
    await _storage.write(_pushNotificationsKey, value);
    
    // In a real app, you'd update this on your backend
    _updateUserPreferences();
  }
  
  void toggleEmailNotifications(bool value) async {
    isEmailNotificationsEnabled.value = value;
    await _storage.write(_emailNotificationsKey, value);
    
    // In a real app, you'd update this on your backend
    _updateUserPreferences();
  }
  
  void toggleBiometric(bool value) async {
    isBiometricEnabled.value = value;
    await _storage.write(_biometricKey, value);
    
    // In a real app, you'd set up biometric authentication
    _updateUserPreferences();
  }
  
  void toggleLocation(bool value) async {
    isLocationEnabled.value = value;
    await _storage.write(_locationKey, value);
    
    // In a real app, you'd request location permissions
    _updateUserPreferences();
  }
  
  // Update user preferences on server
  Future<void> _updateUserPreferences() async {
    isLoading.value = true;
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // In a real app, you'd send these preferences to your backend
      // await _userService.updateUserPreferences({
      //   'push_notifications': isPushNotificationsEnabled.value,
      //   'email_notifications': isEmailNotificationsEnabled.value,
      //   'biometric': isBiometricEnabled.value,
      //   'location': isLocationEnabled.value,
      // });
      
      Get.snackbar(
        'Settings Updated',
        'Your preferences have been saved',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save preferences: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // About section methods
  void showTermsOfService() {
    Get.dialog(
      AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'This is a placeholder for the terms of service text. In a real app, you would display your actual terms and conditions here.\n\n'
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n'
            'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void showPrivacyPolicy() {
    Get.dialog(
      AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'This is a placeholder for the privacy policy text. In a real app, you would display your actual privacy policy here.\n\n'
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n'
            'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}