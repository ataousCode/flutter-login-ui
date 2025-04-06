// File: app/modules/messaging/controllers/chat_list_controller.dart
import 'package:get/get.dart';
import '../../../data/services/message_service.dart';
import '../../../data/models/message_model.dart';

class ChatListController extends GetxController {
  final _messageService = Get.find<MessageService>();
  
  // Observable chat list
  final RxList<ChatModel> chats = <ChatModel>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadChats();
  }
  
  void loadChats() {
    isLoading.value = true;
    try {
      // Get chats for the current user
      chats.value = _messageService.getUserChats();
    } catch (e) {
      print('Error loading chats: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void refreshChats() {
    loadChats();
  }
  
  // Navigate to chat screen
  void openChat(String chatId, String chatName) {
    Get.toNamed('/chat', arguments: {
      'chat_id': chatId,
      'chat_name': chatName,
    });
  }
  
  // Get total unread message count for badge
  int get totalUnreadCount {
    return chats.fold(0, (sum, chat) => sum + chat.unreadCount);
  }
}