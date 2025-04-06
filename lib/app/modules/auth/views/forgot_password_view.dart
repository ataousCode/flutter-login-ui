import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../controllers/forgot_password_controller.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/loading_overlay.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.forgotPassword),
        centerTitle: true,
      ),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.isLoading.value,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Icon
                      const Icon(
                        Icons.lock_reset,
                        size: 80,
                        color: AppColors.primary,
                      ),

                      const SizedBox(height: 20),

                      // Reset password heading
                      const Text(
                        AppStrings.resetPassword,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      // Instruction text
                      const Text(
                        'Enter your email address and we\'ll send you a 6-digit OTP to reset your password.',
                        style: TextStyle(color: AppColors.grey),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                      // Email field
                      CustomTextField(
                        label: AppStrings.email,
                        hint: 'Enter your email',
                        controller: controller.emailController,
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                      ),

                      // Success message
                      Obx(
                        () =>
                            controller.isSuccess.value
                                ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(
                                    'Check your email for the OTP code to reset your password.',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                                : const SizedBox(height: 16),
                      ),

                      // Error message
                      Obx(
                        () =>
                            controller.errorMessage.isNotEmpty
                                ? Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Text(
                                    controller.errorMessage.value,
                                    style: const TextStyle(
                                      color: AppColors.error,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                                : const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 20),

                      // Submit button
                      CustomButton(
                        text: AppStrings.submit,
                        onPressed: controller.resetPassword,
                        isLoading: controller.isLoading.value,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
