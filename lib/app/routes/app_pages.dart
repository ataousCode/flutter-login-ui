// Update in app/routes/app_pages.dart
import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/otp_verification_view.dart';
import '../modules/auth/views/mobile_signin_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_edit_view.dart';
import '../modules/profile/views/password_change_view.dart';
import '../modules/profile/views/account_deletion_view.dart';
import '../modules/profile/views/settings_view.dart';
import '../modules/messaging/bindings/messaging_binding.dart';
import '../modules/messaging/views/chat_list_view.dart';
import '../modules/messaging/views/chat_view.dart';

// part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    // Auth Routes
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.MOBILE_SIGNIN,
      page: () => const MobileSignInView(),
      binding: AuthBinding(),
    ),
    
    // Home Route
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    
    // Profile Management Routes
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.PROFILE_EDIT,
      page: () => const ProfileEditView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.PASSWORD_CHANGE,
      page: () => const PasswordChangeView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.ACCOUNT_DELETION,
      page: () => const AccountDeletionView(),
      binding: ProfileBinding(),
    ),
    
    // Messaging Routes
    GetPage(
      name: Routes.CHAT_LIST,
      page: () => const ChatListView(),
      binding: MessagingBinding(),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => const ChatView(),
      binding: MessagingBinding(),
    ),
  ];
}

// Update in app/routes/app_routes.dart part file
// part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  
  // Auth Routes
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const OTP_VERIFICATION = '/otp-verification';
  static const MOBILE_SIGNIN = '/mobile-signin';
  
  // Home Route
  static const HOME = '/home';
  
  // Profile Management Routes
  static const SETTINGS = '/settings';
  static const PROFILE_EDIT = '/profile-edit';
  static const PASSWORD_CHANGE = '/password-change';
  static const ACCOUNT_DELETION = '/account-deletion';
  
  // Messaging Routes
  static const CHAT_LIST = '/chat-list';
  static const CHAT = '/chat';
}