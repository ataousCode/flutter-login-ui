// File: app/modules/profile/bindings/profile_binding.dart
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../controllers/password_controller.dart';
import '../controllers/account_controller.dart';
import '../controllers/settings_controller.dart';
import '../../../data/services/user_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    if (!Get.isRegistered<UserService>()) {
      Get.lazyPut<UserService>(() => UserService());
    }
    
    // Controllers
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<PasswordController>(() => PasswordController());
    Get.lazyPut<AccountController>(() => AccountController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}