// File: app/modules/messaging/views/chat_list_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_list_controller.dart';
import '../../../core/values/app_colors.dart';
import '../../../data/models/message_model.dart';
import '../../../../widgets/loading_overlay.dart';

class ChatListView extends GetView<ChatListController> {
  const ChatListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshChats,
          ),
        ],
      ),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.isLoading.value,
          child: controller.chats.isEmpty
              ? _buildEmptyState()
              : _buildChatList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar(
            'New Chat',
            'This feature will be available soon',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildEmptyState() {
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
            'No conversations yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start a new chat by tapping the button below',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: controller.chats.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final chat = controller.chats[index];
        return _buildChatItem(chat);
      },
    );
  }

  Widget _buildChatItem(ChatModel chat) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            backgroundImage: chat.avatarUrl != null
                ? NetworkImage(chat.avatarUrl!)
                : null,
            child: chat.avatarUrl == null
                ? Text(
                    chat.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          if (chat.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(
                    color: Get.theme.scaffoldBackgroundColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (chat.lastMessage != null)
            Text(
              chat.lastMessage!.formattedTime,
              style: TextStyle(
                fontSize: 12,
                color: chat.unreadCount > 0
                    ? AppColors.primary
                    : AppColors.grey,
              ),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          if (chat.lastMessage != null)
            Expanded(
              child: _buildLastMessagePreview(chat.lastMessage!),
            ),
          if (chat.unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${chat.unreadCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: () => controller.openChat(chat.id, chat.name),
    );
  }

  Widget _buildLastMessagePreview(MessageModel message) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: message.isRead ? AppColors.grey : Colors.white,
          ),
        );
      case MessageType.image:
        return Row(
          children: [
            const Icon(
              Icons.photo,
              size: 16,
              color: AppColors.grey,
            ),
            const SizedBox(width: 4),
            const Text(
              'Photo',
              style: TextStyle(
                color: AppColors.grey,
              ),
            ),
          ],
        );
      case MessageType.sticker:
        return const Row(
          children: [
            Icon(
              Icons.emoji_emotions,
              size: 16,
              color: AppColors.grey,
            ),
            SizedBox(width: 4),
            Text(
              'Sticker',
              style: TextStyle(
                color: AppColors.grey,
              ),
            ),
          ],
        );
      case MessageType.file:
        return Row(
          children: [
            const Icon(
              Icons.attach_file,
              size: 16,
              color: AppColors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              message.metadata?['filename'] ?? 'File',
              style: const TextStyle(
                color: AppColors.grey,
              ),
            ),
          ],
        );
      case MessageType.audio:
        return const Row(
          children: [
            Icon(
              Icons.mic,
              size: 16,
              color: AppColors.grey,
            ),
            SizedBox(width: 4),
            Text(
              'Audio message',
              style: TextStyle(
                color: AppColors.grey,
              ),
            ),
          ],
        );
      case MessageType.video:
        return const Row(
          children: [
            Icon(
              Icons.videocam,
              size: 16,
              color: AppColors.grey,
            ),
            SizedBox(width: 4),
            Text(
              'Video',
              style: TextStyle(
                color: AppColors.grey,
              ),
            ),
          ],
        );
      case MessageType.location:
        return const Row(
          children: [
            Icon(
              Icons.location_on,
              size: 16,
              color: AppColors.grey,
            ),
            SizedBox(width: 4),
            Text(
              'Location',
              style: TextStyle(
                color: AppColors.grey,
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
