import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_ui/app/modules/messaging/bindings/messaging_binding.dart';
import 'package:login_ui/app/modules/messaging/views/chat_screen.dart';
import 'package:login_ui/app/routes/app_pages.dart';
import '../../../core/values/app_colors.dart';
import '../../../data/services/message_service.dart';
import '../../../modules/messaging/controllers/chat_controller.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the message service
    final messageService = Get.find<MessageService>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Messages',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Sample chats display
          Expanded(
            child: ListView.builder(
              itemCount: messageService.chats.length,
              itemBuilder: (context, index) {
                final chat = messageService.chats[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      backgroundImage:
                          chat.avatarUrl != null
                              ? NetworkImage(chat.avatarUrl!)
                              : null,
                      child: chat.avatarUrl == null ? Text(chat.name[0]) : null,
                    ),
                    title: Text(chat.name),
                    subtitle: Text(
                      chat.lastMessage?.content ?? 'No messages yet',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing:
                        chat.unreadCount > 0
                            ? Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${chat.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                            : const Text(''),
                    // onTap: () {
                    //   // Directly register a new instance of ChatController
                    //   Get.put(ChatController());

                    //   // Then navigate to a custom ChatScreen that doesn't use GetView
                    //   Get.to(
                    //     () => ChatScreen(
                    //       chatId: chat.id,
                    //       chatName: chat.name,
                    //     ),
                    //   );
                    // },
                    onTap: () {
                      // First register the binding
                      MessagingBinding().dependencies();

                      // Then navigate to the chat
                      Get.toNamed(
                        Routes.CHAT,
                        arguments: {'chat_id': chat.id, 'chat_name': chat.name},
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
