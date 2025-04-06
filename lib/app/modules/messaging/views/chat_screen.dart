import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/values/app_colors.dart';
import '../../../modules/messaging/controllers/chat_controller.dart';
import '../../../modules/messaging/widgets/message_bubble.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String chatName;

  ChatScreen({Key? key, required this.chatId, required this.chatName})
    : super(key: key);

  // Get the controller directly
  final ChatController controller = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    // Initialize chat data
    controller.chatId = chatId;
    controller.chatName = chatName;
    controller.loadMessages();
    controller.markAsRead();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chatName, style: const TextStyle(fontSize: 18)),
            Obx(
              () => Text(
                controller.chatStatus.value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {
              Get.snackbar(
                'Coming Soon',
                'Video calling will be available soon',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              Get.snackbar(
                'Coming Soon',
                'Voice calling will be available soon',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              Get.snackbar(
                'Coming Soon',
                'More options will be available soon',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: Obx(
              () =>
                  controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : _buildMessagesList(),
            ),
          ),

          // Sticker picker
          Obx(
            () =>
                controller.showEmojiPicker.value
                    ? Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Center(child: Text('Sticker picker placeholder')),
                    )
                    : const SizedBox.shrink(),
          ),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    if (controller.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: AppColors.grey.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            const Text(
              'No messages yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start the conversation by sending a message',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: controller.messages.length,
      itemBuilder: (context, index) {
        final message = controller.messages[index];
        final isFromCurrentUser = controller.isFromCurrentUser(message);

        return MessageBubble(
          message: message,
          isFromCurrentUser: isFromCurrentUser,
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: controller.showAttachmentOptions,
              color: AppColors.primary,
            ),

            // Message text field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    // Emoji button
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions),
                      onPressed: controller.toggleEmojiPicker,
                      color: AppColors.grey,
                    ),

                    // Text input
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 5,
                        onTap: () {
                          if (controller.showEmojiPicker.value) {
                            controller.showEmojiPicker.value = false;
                          }
                        },
                      ),
                    ),

                    // Camera button
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () => controller.sendImage(ImageSource.camera),
                      color: AppColors.grey,
                    ),
                  ],
                ),
              ),
            ),

            // Send button
            Obx(
              () => IconButton(
                icon:
                    controller.messageController.text.trim().isEmpty
                        ? const Icon(Icons.mic)
                        : const Icon(Icons.send),
                onPressed:
                    controller.messageController.text.trim().isEmpty
                        ? () {
                          Get.snackbar(
                            'Coming Soon',
                            'Voice messages will be available soon',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                        : controller.sendMessage,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
