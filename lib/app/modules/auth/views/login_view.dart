// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../controllers/login_controller.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/loading_overlay.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      // Top tabs
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.cardBackground,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(AppStrings.signIn),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: controller.goToRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.cardBackground,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(AppStrings.signUp),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Sign in heading
                      const Text(
                        AppStrings.signIn,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),

                      const SizedBox(height: 30),

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
                          textInputAction: TextInputAction.done,
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

                      // Forgot password and mobile sign in
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: controller.goToForgotPassword,
                              child: const Text(
                                AppStrings.forgotPassword,
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ),
                            TextButton(
                              onPressed: controller.goToMobileSignIn,
                              child: const Text(
                                'Sign in with mobile',
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Error message
                      Obx(
                        () =>
                            controller.errorMessage.isNotEmpty
                                ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
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
                                : const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 10),

                      // Sign in button
                      CustomButton(
                        text: AppStrings.signIn,
                        onPressed: controller.login,
                        isLoading: controller.isLoading.value,
                      ),

                      const SizedBox(height: 20),

                      // Or login with
                      const Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.grey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Or login with',
                              style: TextStyle(color: AppColors.grey),
                            ),
                          ),
                          Expanded(child: Divider(color: AppColors.grey)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Social login buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(
                                Icons.facebook,
                                color: Colors.blue,
                              ),
                              label: const Text('Facebook'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(
                                FontAwesomeIcons.google,
                                color: Colors.red,
                                size: 18,
                              ),
                              label: const Text('Google'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Fingerprint button
                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              const Icon(
                                Icons.fingerprint,
                                size: 48,
                                color: AppColors.primary,
                              ),
                              Container(
                                width: 80,
                                height: 2,
                                color: AppColors.primary.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
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
