// File: app/modules/messaging/views/chat_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../../../core/values/app_colors.dart';
import '../../../data/models/message_model.dart';
import '../widgets/message_bubble.dart';
import '../widgets/sticker_picker.dart';
import 'package:image_picker/image_picker.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(controller.chatName, style: const TextStyle(fontSize: 18)),
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
      body: SafeArea(
        child: Column(
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
                      ? StickerPicker(
                        onStickerSelected: (stickerId) {
                          controller.sendSticker(stickerId);
                        },
                      )
                      : const SizedBox.shrink(),
            ),

            // Message input
            _buildMessageInput(),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2429),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5.0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Add attachment button with better styling
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.add),
              iconSize: 24,
              color: AppColors.primary,
              padding: EdgeInsets.zero,
              onPressed: controller.showAttachmentOptions,
            ),
          ),

          // Emoji button
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.emoji_emotions),
              iconSize: 22,
              color: Colors.grey[400],
              padding: EdgeInsets.zero,
              onPressed: controller.toggleEmojiPicker,
            ),
          ),

          // Message text field with better styling
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF2A303A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller.messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: Color(0xFF8D9199)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                style: const TextStyle(color: Colors.white),
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
          ),

          // Camera button
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.camera_alt),
              iconSize: 22,
              color: Colors.grey[400],
              padding: EdgeInsets.zero,
              onPressed: () => controller.sendImage(ImageSource.camera),
            ),
          ),

          // Send/Voice button with better styling
          Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(left: 4.0),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: GetBuilder<ChatController>(
              builder: (ctrl) {
                final isEmpty = ctrl.messageController.text.trim().isEmpty;
                return IconButton(
                  icon: Icon(
                    isEmpty ? Icons.mic : Icons.send,
                    color: Colors.white,
                  ),
                  iconSize: 22,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (isEmpty) {
                      Get.snackbar(
                        'Coming Soon',
                        'Voice messages will be available soon',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      ctrl.sendMessage();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
