// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_strings.dart';
import '../../../routes/app_pages.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/loading_overlay.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final _formKey = GlobalKey<FormState>();
  
  // 6 controllers for the 6 OTP digits
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );
  
  bool _isLoading = false;
  String _errorMessage = '';
  String? _email;
  
  @override
  void initState() {
    super.initState();
    
    // Get email from arguments
    if (Get.arguments != null && Get.arguments is Map) {
      _email = Get.arguments['email'];
    }
    
    // Add listeners to move focus to next field
    for (int i = 0; i < 5; i++) {
      _otpControllers[i].addListener(() {
        if (_otpControllers[i].text.length == 1) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }
  
  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
  
  Future<void> verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Combine all digits
    final otp = _otpControllers.map((c) => c.text).join();
    
    // Validate OTP
    if (otp.length != 6) {
      setState(() {
        _errorMessage = 'Please enter all 6 digits';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo, accept any 6-digit OTP
      // In a real app, you'd verify with your backend
      
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to home on success
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: ${e.toString()}';
      });
    }
  }
  
  void resendOtp() {
    // Simulate resending OTP
    Get.snackbar(
      'OTP Sent',
      'A new OTP has been sent to your email',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.secondary.withOpacity(0.8),
      colorText: AppColors.white,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.otpVerification),
        centerTitle: true,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon
                    const Icon(
                      Icons.message,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Heading
                    const Text(
                      'Verification Code',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Email display
                    if (_email != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: '${AppStrings.otpSentTo} ',
                            style: const TextStyle(
                              color: AppColors.grey,
                            ),
                            children: [
                              TextSpan(
                                text: _email,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // OTP fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                        (index) => SizedBox(
                          width: 40,
                          child: TextFormField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
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
                                borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isEmpty && index > 0) {
                                // Move focus back when deleting
                                _focusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    
                    // Error message
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    
                    const SizedBox(height: 30),
                    
                    // Verify button
                    CustomButton(
                      text: AppStrings.verifyOtp,
                      onPressed: verifyOtp,
                      isLoading: _isLoading,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Resend OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Didn\'t receive the code? ',
                          style: TextStyle(color: AppColors.grey),
                        ),
                        TextButton(
                          onPressed: resendOtp,
                          child: const Text(AppStrings.resendOtp),
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
    );
  }
}