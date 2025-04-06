import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../controllers/register_controller.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/loading_overlay.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.register), centerTitle: true),
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
                      // Register heading
                      const Text(
                        AppStrings.signUp,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Username field
                      CustomTextField(
                        label: AppStrings.username,
                        hint: 'Enter your username',
                        controller: controller.usernameController,
                        validator: Validators.validateUsername,
                      ),

                      const SizedBox(height: 20),

                      // Email field
                      CustomTextField(
                        label: AppStrings.email,
                        hint: 'Enter your email',
                        controller: controller.emailController,
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      // Password field
                      Obx(
                        () => CustomTextField(
                          label: AppStrings.password,
                          hint: 'Enter your password',
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          validator: Validators.validatePassword,
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

                      // Confirm Password field
                      Obx(
                        () => CustomTextField(
                          label: AppStrings.confirmPassword,
                          hint: 'Confirm your password',
                          controller: controller.confirmPasswordController,
                          obscureText:
                              !controller.isConfirmPasswordVisible.value,
                          validator: controller.validateConfirmPassword,
                          textInputAction: TextInputAction.done,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isConfirmPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.primary,
                            ),
                            onPressed:
                                controller.toggleConfirmPasswordVisibility,
                          ),
                        ),
                      ),

                      // Error message
                      Obx(
                        () =>
                            controller.errorMessage.isNotEmpty
                                ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
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

                      // Register button
                      CustomButton(
                        text: AppStrings.signUp,
                        onPressed: controller.register,
                        isLoading: controller.isLoading.value,
                      ),

                      const SizedBox(height: 20),

                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(color: AppColors.grey),
                          ),
                          TextButton(
                            onPressed: controller.goToLogin,
                            child: const Text(AppStrings.signIn),
                          ),
                        ],
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
