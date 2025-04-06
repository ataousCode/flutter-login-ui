import 'package:get/get.dart';
import 'package:login_ui/app/data/services/message_service.dart';
import 'package:login_ui/app/data/services/user_service.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<UserService>()) {
      Get.lazyPut<UserService>(() => UserService());
    }

    if (!Get.isRegistered<MessageService>()) {
      Get.lazyPut<MessageService>(() => MessageService());
    }

    Get.lazyPut<HomeController>(() => HomeController());
  }
}
