// File: app/modules/profile/views/account_deletion_view.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_strings.dart';
import '../controllers/account_controller.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/loading_overlay.dart';

class AccountDeletionView extends GetView<AccountController> {
  const AccountDeletionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
        centerTitle: true,
      ),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.isLoading.value,
          message: AppStrings.deletingAccount,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  
                  // Warning icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 70,
                      color: Colors.red,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Warning title
                  const Text(
                    'Delete Your Account?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Warning message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                      ),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'This action cannot be undone. This will permanently delete:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        _WarningItem(
                          icon: Icons.person,
                          text: 'Your profile information',
                        ),
                        _WarningItem(
                          icon: Icons.image,
                          text: 'Your profile picture',
                        ),
                        _WarningItem(
                          icon: Icons.settings,
                          text: 'All your preferences and settings',
                        ),
                        _WarningItem(
                          icon: Icons.history,
                          text: 'Your activity history',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Email confirmation
                  CustomTextField(
                    label: 'Confirm your email',
                    hint: 'Enter your email address',
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      if (value != controller.userEmail) {
                        return 'Email does not match your account';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Password confirmation
                  Obx(
                    () => CustomTextField(
                      label: 'Confirm your password',
                      hint: 'Enter your password',
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Confirmation checkbox
                  Row(
                    children: [
                      Obx(
                        () => Checkbox(
                          value: controller.isConfirmationChecked.value,
                          onChanged: (value) {
                            controller.isConfirmationChecked.value = value ?? false;
                          },
                          activeColor: Colors.red,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'I understand that this action is permanent and cannot be undone',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
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
                  
                  // Delete Account Button
                  Obx(
                    () => CustomButton(
                      text: 'Delete My Account',
                      onPressed: controller.isConfirmationChecked.value
                          ? controller.deleteAccount
                          : null,
                      isLoading: controller.isLoading.value,
                      color: Colors.red,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Cancel Button
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
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
}

class _WarningItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _WarningItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}