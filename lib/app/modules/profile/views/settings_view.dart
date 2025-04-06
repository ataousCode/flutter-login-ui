// File: app/modules/profile/views/settings_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_strings.dart';
import '../controllers/settings_controller.dart';
import '../../../../widgets/loading_overlay.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.isLoading.value,
          message: AppStrings.savingChanges,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Account Section
              _buildSectionHeader('Account'),
              _buildSettingItem(
                title: 'Edit Profile',
                subtitle: 'Change your personal information',
                icon: Icons.person,
                onTap: controller.goToEditProfile,
              ),
              _buildSettingItem(
                title: 'Change Password',
                subtitle: 'Update your password',
                icon: Icons.lock,
                onTap: controller.goToChangePassword,
              ),
              _buildSettingItem(
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                icon: Icons.delete_forever,
                iconColor: Colors.red,
                onTap: controller.goToDeleteAccount,
              ),
              const Divider(),
              
              // Appearance Section
              _buildSectionHeader('Appearance'),
              _buildSwitchItem(
                title: 'Dark Mode',
                subtitle: 'Toggle dark/light theme',
                icon: Icons.dark_mode,
                value: controller.isDarkMode.value,
                onChanged: controller.toggleDarkMode,
              ),
              const Divider(),
              
              // Notification Section
              _buildSectionHeader('Notifications'),
              _buildSwitchItem(
                title: 'Push Notifications',
                subtitle: 'Receive push notifications',
                icon: Icons.notifications,
                value: controller.isPushNotificationsEnabled.value,
                onChanged: controller.togglePushNotifications,
              ),
              _buildSwitchItem(
                title: 'Email Notifications',
                subtitle: 'Receive email notifications',
                icon: Icons.email,
                value: controller.isEmailNotificationsEnabled.value,
                onChanged: controller.toggleEmailNotifications,
              ),
              const Divider(),
              
              // Privacy Section
              _buildSectionHeader('Privacy'),
              _buildSwitchItem(
                title: 'Biometric Authentication',
                subtitle: 'Use fingerprint or face ID to login',
                icon: Icons.fingerprint,
                value: controller.isBiometricEnabled.value,
                onChanged: controller.toggleBiometric,
              ),
              _buildSwitchItem(
                title: 'Location Services',
                subtitle: 'Allow app to access your location',
                icon: Icons.location_on,
                value: controller.isLocationEnabled.value,
                onChanged: controller.toggleLocation,
              ),
              const Divider(),
              
              // About Section
              _buildSectionHeader('About'),
              _buildSettingItem(
                title: 'Terms of Service',
                subtitle: 'Read our terms and conditions',
                icon: Icons.article,
                onTap: controller.showTermsOfService,
              ),
              _buildSettingItem(
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                icon: Icons.privacy_tip,
                onTap: controller.showPrivacyPolicy,
              ),
              _buildSettingItem(
                title: 'App Version',
                subtitle: controller.appVersion,
                icon: Icons.info,
                onTap: null,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
  
  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback? onTap,
    Color? iconColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? AppColors.primary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: onTap != null
            ? const Icon(Icons.chevron_right)
            : null,
        onTap: onTap,
      ),
    );
  }
  
  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: SwitchListTile(
        secondary: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }
}