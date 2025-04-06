// File: app/modules/messaging/controllers/chat_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/message_service.dart';
import '../../../data/models/message_model.dart';
import '../../../data/services/auth_service.dart';

class ChatController extends GetxController {
  final _messageService = Get.find<MessageService>();
  final _authService = Get.find<AuthService>();

  // Form controller
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Observable messages
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxBool showEmojiPicker = false.obs;
  final RxBool isRecording = false.obs;

  // Chat info
  late String chatId = '';
  late String chatName = '';
  final RxString chatStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Get chat ID and name from arguments if available
    if (Get.arguments != null) {
      chatId = Get.arguments['chat_id'] ?? '';
      chatName = Get.arguments['chat_name'] ?? '';

      if (chatId.isNotEmpty) {
        loadMessages();
        markAsRead();
      }
    }

    // Add this listener for UI updates
    messageController.addListener(() {
      update(); // This will update GetBuilder widgets
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // Load messages for this chat
  void loadMessages() {
    isLoading.value = true;
    try {
      // Get messages for this chat
      messages.value = _messageService.getChatMessages(chatId);

      // Update online status (for demo)
      final chat = _messageService.chats.firstWhere((c) => c.id == chatId);
      chatStatus.value =
          chat.isOnline ? 'Online' : 'Last seen ${chat.lastSeenStatus}';

      // Scroll to bottom after messages load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });
    } catch (e) {
      print('Error loading messages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Mark messages as read
  void markAsRead() {
    _messageService.markMessagesAsRead(chatId);
  }

  // Send a text message
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    isSending.value = true;
    try {
      final message = await _messageService.sendTextMessage(chatId, text);
      if (message != null) {
        messageController.clear();
        loadMessages();
        scrollToBottom();
      }
    } catch (e) {
      print('Error sending message: $e');
    } finally {
      isSending.value = false;
    }
  }

  // Send an image
  Future<void> sendImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (image != null) {
        isSending.value = true;

        final message = await _messageService.sendImageMessage(
          chatId,
          File(image.path),
        );

        if (message != null) {
          loadMessages();
          scrollToBottom();
        }
      }
    } catch (e) {
      print('Error sending image: $e');
    } finally {
      isSending.value = false;
    }
  }

  // Send a sticker
  Future<void> sendSticker(String stickerId) async {
    isSending.value = true;
    try {
      final message = await _messageService.sendStickerMessage(
        chatId,
        stickerId,
      );
      if (message != null) {
        loadMessages();
        scrollToBottom();
        showEmojiPicker.value = false;
      }
    } catch (e) {
      print('Error sending sticker: $e');
    } finally {
      isSending.value = false;
    }
  }

  // Toggle emoji picker
  void toggleEmojiPicker() {
    showEmojiPicker.value = !showEmojiPicker.value;
  }

  // Scroll to bottom of chat
  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Check if message is from current user
  bool isFromCurrentUser(MessageModel message) {
    return message.senderId == _authService.user?.id;
  }

  // Show attachment options
  void showAttachmentOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share Content',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.photo,
                  color: Colors.purple,
                  label: 'Gallery',
                  onTap: () {
                    Get.back();
                    sendImage(ImageSource.gallery);
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.camera_alt,
                  color: Colors.red,
                  label: 'Camera',
                  onTap: () {
                    Get.back();
                    sendImage(ImageSource.camera);
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.insert_emoticon,
                  color: Colors.amber,
                  label: 'Stickers',
                  onTap: () {
                    Get.back();
                    showEmojiPicker.value = true;
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.location_on,
                  color: Colors.green,
                  label: 'Location',
                  onTap: () {
                    Get.back();
                    Get.snackbar(
                      'Coming Soon',
                      'Location sharing will be available soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.attach_file,
                  color: Colors.blue,
                  label: 'Document',
                  onTap: () {
                    Get.back();
                    Get.snackbar(
                      'Coming Soon',
                      'Document sharing will be available soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.music_note,
                  color: Colors.orange,
                  label: 'Audio',
                  onTap: () {
                    Get.back();
                    Get.snackbar(
                      'Coming Soon',
                      'Audio sharing will be available soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.videocam,
                  color: Colors.pink,
                  label: 'Video',
                  onTap: () {
                    Get.back();
                    Get.snackbar(
                      'Coming Soon',
                      'Video sharing will be available soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.person,
                  color: Colors.teal,
                  label: 'Contact',
                  onTap: () {
                    Get.back();
                    Get.snackbar(
                      'Coming Soon',
                      'Contact sharing will be available soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build attachment option button
  Widget _buildAttachmentOption({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
