// File: app/modules/messaging/widgets/message_bubble.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isFromCurrentUser;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isFromCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isFromCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Read status indicator (for sent messages)
          if (isFromCurrentUser)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                message.isRead ? Icons.done_all : Icons.done,
                size: 16,
                color: message.isRead
                    ? AppColors.primary
                    : AppColors.grey,
              ),
            ),

          // Message content
          Container(
            constraints: BoxConstraints(
              maxWidth: Get.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isFromCurrentUser
                  ? AppColors.primary
                  : Get.theme.cardColor,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: isFromCurrentUser
                    ? const Radius.circular(16)
                    : const Radius.circular(0),
                bottomRight: isFromCurrentUser
                    ? const Radius.circular(0)
                    : const Radius.circular(16),
              ),
            ),
            padding: _getPadding(),
            child: _buildMessageContent(),
          ),
        ],
      ),
    );
  }

  // Get appropriate padding based on message type
  EdgeInsets _getPadding() {
    switch (message.type) {
      case MessageType.image:
      case MessageType.video:
        return const EdgeInsets.all(4);
      default:
        return const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        );
    }
  }

  // Build message content based on type
  Widget _buildMessageContent() {
    switch (message.type) {
      case MessageType.text:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.content ?? '',
              style: TextStyle(
                color: isFromCurrentUser
                    ? Colors.white
                    : Get.theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              message.formattedTime,
              style: TextStyle(
                fontSize: 10,
                color: isFromCurrentUser
                    ? Colors.white.withOpacity(0.7)
                    : AppColors.grey,
              ),
            ),
          ],
        );

      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: message.mediaUrl != null
                  ? Image.network(
                      message.mediaUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 8,
                top: 4,
                bottom: 4,
              ),
              child: Text(
                message.formattedTime,
                style: TextStyle(
                  fontSize: 10,
                  color: isFromCurrentUser
                      ? Colors.white.withOpacity(0.7)
                      : AppColors.grey,
                ),
              ),
            ),
          ],
        );

      case MessageType.sticker:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isFromCurrentUser
                    ? AppColors.primary
                    : Get.theme.cardColor,
              ),
              child: Center(
                child: Image.asset(
                  'assets/stickers/${message.content}.png',
                  width: 100,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.emoji_emotions,
                      size: 60,
                      color: Colors.amber,
                    );
                  },
                ),
              ),
            ),
            Text(
              message.formattedTime,
              style: TextStyle(
                fontSize: 10,
                color: isFromCurrentUser
                    ? Colors.white.withOpacity(0.7)
                    : AppColors.grey,
              ),
            ),
          ],
        );

      case MessageType.file:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.metadata?['filename'] ?? 'Document',
                        style: TextStyle(
                          color: isFromCurrentUser
                              ? Colors.white
                              : Get.theme.textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        message.metadata?['size'] ?? 'Unknown size',
                        style: TextStyle(
                          fontSize: 12,
                          color: isFromCurrentUser
                              ? Colors.white.withOpacity(0.7)
                              : AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                message.formattedTime,
                style: TextStyle(
                  fontSize: 10,
                  color: isFromCurrentUser
                      ? Colors.white.withOpacity(0.7)
                      : AppColors.grey,
                ),
              ),
            ),
          ],
        );
        
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Unsupported message type',
              style: TextStyle(
                color: isFromCurrentUser
                    ? Colors.white
                    : Get.theme.textTheme.bodyLarge?.color,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              message.formattedTime,
              style: TextStyle(
                fontSize: 10,
                color: isFromCurrentUser
                    ? Colors.white.withOpacity(0.7)
                    : AppColors.grey,
              ),
            ),
          ],
        );
    }
  }
}

