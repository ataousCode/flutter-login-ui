// File: app/modules/profile/views/profile_edit_view.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_strings.dart';
import '../controllers/profile_controller.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/loading_overlay.dart';

class ProfileEditView extends GetView<ProfileController> {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), centerTitle: true),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.isLoading.value,
          message: AppStrings.savingChanges,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Profile Image
                  Stack(
                    children: [
                      Obx(() => _buildProfileImage()),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.background,
                              width: 2,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onPressed: _showImageSourceOptions,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Full Name
                  CustomTextField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    controller: controller.nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Username
                  CustomTextField(
                    label: 'Username',
                    hint: 'Choose a username',
                    controller: controller.usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      if (value.length < 4) {
                        return 'Username must be at least 4 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Bio
                  CustomTextField(
                    label: 'Bio',
                    hint: 'Tell us about yourself',
                    controller: controller.bioController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),

                  const SizedBox(height: 20),

                  // Phone
                  CustomTextField(
                    label: 'Phone',
                    hint: 'Enter your phone number',
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 20),

                  // Website
                  CustomTextField(
                    label: 'Website',
                    hint: 'Enter your website or social media',
                    controller: controller.websiteController,
                    keyboardType: TextInputType.url,
                  ),

                  const SizedBox(height: 20),

                  // Location
                  CustomTextField(
                    label: 'Location',
                    hint: 'Enter your city or country',
                    controller: controller.locationController,
                  ),

                  const SizedBox(height: 30),

                  // Save Button
                  CustomButton(
                    text: 'Save Changes',
                    onPressed: controller.saveProfileChanges,
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

  Widget _buildProfileImage() {
    if (controller.profileImagePath.value.isNotEmpty) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: AppColors.cardBackground,
        backgroundImage: FileImage(File(controller.profileImagePath.value)),
      );
    } else if (controller.user.value?.photoUrl != null &&
        controller.user.value!.photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: AppColors.cardBackground,
        backgroundImage: NetworkImage(controller.user.value!.photoUrl!),
      );
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundColor: AppColors.primary.withOpacity(0.2),
        child: const Icon(Icons.person, size: 80, color: AppColors.primary),
      );
    }
  }

  void _showImageSourceOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Change Profile Picture',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.primary,
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera, color: AppColors.primary),
              title: const Text('Take a Photo'),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            if (controller.profileImagePath.value.isNotEmpty ||
                (controller.user.value?.photoUrl != null &&
                    controller.user.value!.photoUrl!.isNotEmpty))
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Get.back();
                  controller.removeProfileImage();
                },
              ),
          ],
        ),
      ),
    );
  }
}
