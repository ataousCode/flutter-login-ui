// File: app/modules/auth/views/mobile_signin_view.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/mobile_signin_controller.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/loading_overlay.dart';

class MobileSignInView extends GetView<MobileSignInController> {
  const MobileSignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In with Mobile"),
        centerTitle: true,
      ),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.isLoading.value,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mobile phone icon
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.smartphone,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Heading
                    const Center(
                      child: Text(
                        "Sign In with Mobile Number",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Description
                    const Center(
                      child: Text(
                        "We will send you a verification code to your mobile number",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.grey),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Phone number field with country code
                    Obx(
                      () =>
                          controller.isOtpSent.value
                              ? _buildOtpSection()
                              : _buildPhoneSection(),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phone number label
        const Text(
          "Phone Number",
          style: TextStyle(fontSize: 16, color: AppColors.grey),
        ),
        const SizedBox(height: 8),

        // Phone number input with country code
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country code dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedCountryCode.value,
                  dropdownColor: AppColors.cardBackground,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.grey,
                  ),
                  items:
                      controller.countryCodes.map((String code) {
                        return DropdownMenuItem<String>(
                          value: code,
                          child: Text(
                            code,
                            style: const TextStyle(color: AppColors.white),
                          ),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.selectedCountryCode.value = newValue;
                    }
                  },
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Phone number input field
            Expanded(
              child: TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "Enter your phone number",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone number";
                  }
                  if (value.length < 10) {
                    return "Please enter a valid phone number";
                  }
                  return null;
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        // Send OTP button
        CustomButton(
          text: "Send OTP",
          onPressed: controller.sendOtp,
          isLoading: controller.isLoading.value,
        ),
      ],
    );
  }

  Widget _buildOtpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // OTP entry instruction
        Center(
          child: Text(
            "Enter the 6-digit code sent to ${controller.selectedCountryCode.value} ${controller.phoneController.text}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.grey),
          ),
        ),

        const SizedBox(height: 24),

        // OTP input fields
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            6,
            (index) => SizedBox(
              width: 40,
              child: TextFormField(
                controller: controller.otpControllers[index],
                focusNode: controller.otpFocusNodes[index],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  counter: const Offstage(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.grey.withOpacity(0.3),
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isEmpty && index > 0) {
                    // Move focus back when deleting
                    controller.otpFocusNodes[index - 1].requestFocus();
                  } else if (value.isNotEmpty && index < 5) {
                    // Move focus forward when entering a digit
                    controller.otpFocusNodes[index + 1].requestFocus();
                  }
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Verify OTP button
        CustomButton(
          text: "Verify & Sign In",
          onPressed: controller.verifyOtp,
          isLoading: controller.isLoading.value,
        ),

        const SizedBox(height: 16),

        // Resend OTP
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Didn't receive the code? ",
                style: TextStyle(color: AppColors.grey),
              ),
              TextButton(
                onPressed: controller.resendOtp,
                child: const Text("Resend OTP"),
              ),
            ],
          ),
        ),

        // Change number option
        Center(
          child: TextButton(
            onPressed: controller.changePhoneNumber,
            child: const Text("Change Phone Number"),
          ),
        ),
      ],
    );
  }
}
