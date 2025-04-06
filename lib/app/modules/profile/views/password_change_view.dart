// File: app/modules/profile/views/password_change_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_strings.dart';
import '../controllers/password_controller.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/loading_overlay.dart';

class PasswordChangeView extends GetView<PasswordController> {
  const PasswordChangeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.isLoading.value,
          message: AppStrings.changingPassword,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Password change icon
                  const Center(
                    child: Icon(
                      Icons.lock_reset,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Heading
                  const Center(
                    child: Text(
                      'Update Your Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Description
                  const Center(
                    child: Text(
                      'Choose a strong password that will be hard for others to guess',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Current Password
                  Obx(
                    () => CustomTextField(
                      label: 'Current Password',
                      hint: 'Enter your current password',
                      controller: controller.currentPasswordController,
                      obscureText: !controller.isCurrentPasswordVisible.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isCurrentPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: controller.toggleCurrentPasswordVisibility,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // New Password
                  Obx(
                    () => CustomTextField(
                      label: 'New Password',
                      hint: 'Enter your new password',
                      controller: controller.newPasswordController,
                      obscureText: !controller.isNewPasswordVisible.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isNewPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: controller.toggleNewPasswordVisibility,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Confirm New Password
                  Obx(
                    () => CustomTextField(
                      label: 'Confirm New Password',
                      hint: 'Confirm your new password',
                      controller: controller.confirmPasswordController,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != controller.newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                  ),
                  
                  // Password Strength Meter
                  const SizedBox(height: 20),
                  Obx(() => _buildPasswordStrengthMeter()),
                  
                  // Error message
                  Obx(
                    () => controller.errorMessage.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              controller.errorMessage.value,
                              style: const TextStyle(
                                color: AppColors.error,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : const SizedBox(height: 16),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Change Password Button
                  CustomButton(
                    text: 'Update Password',
                    onPressed: controller.changePassword,
                    isLoading: controller.isLoading.value,
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPasswordStrengthMeter() {
    final strengthText = controller.passwordStrength.value;
    Color strengthColor;
    double strengthValue;
    
    switch (strengthText) {
      case 'Weak':
        strengthColor = Colors.red;
        strengthValue = 0.25;
        break;
      case 'Medium':
        strengthColor = Colors.orange;
        strengthValue = 0.5;
        break;
      case 'Strong':
        strengthColor = Colors.lightGreen;
        strengthValue = 0.75;
        break;
      case 'Very Strong':
        strengthColor = Colors.green;
        strengthValue = 1.0;
        break;
      default:
        strengthColor = Colors.grey;
        strengthValue = 0.0;
        break;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password Strength: ${strengthText.isNotEmpty ? strengthText : "None"}',
          style: TextStyle(
            color: strengthText.isNotEmpty ? strengthColor : AppColors.grey,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: strengthValue,
          backgroundColor: AppColors.cardBackground,
          valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}