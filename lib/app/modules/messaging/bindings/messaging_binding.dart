// File: app/modules/messaging/bindings/messaging_binding.dart
import 'package:get/get.dart';
import '../controllers/chat_list_controller.dart';
import '../controllers/chat_controller.dart';
import '../../../data/services/message_service.dart';

class MessagingBinding extends Bindings {
  @override
  void dependencies() {
    // Register MessageService if not already registered
    if (!Get.isRegistered<MessageService>()) {
      Get.lazyPut<MessageService>(() => MessageService());
    }

    // Register controllers
    Get.put<ChatController>(ChatController(), permanent: true);
    Get.put<ChatListController>(ChatListController());
  }
}
