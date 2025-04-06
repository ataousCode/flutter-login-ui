import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final _authService = Get.find<AuthService>();
  
  bool get isLoggedIn => _authService.isLoggedIn;
  
  @override
  void onInit() {
    super.onInit();
    // Check auth status
    if (isLoggedIn) {
      Get.offAllNamed(Routes.HOME);
    }
  }
  
  void logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}
