// File: app/data/services/message_service.dart
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/message_model.dart';
import 'auth_service.dart';

class MessageService extends GetxService {
  final _storage = GetStorage();
  final _messagesKey = 'messages';
  final _chatsKey = 'chats';
  final _authService = Get.find<AuthService>();

  // Observable lists
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxList<ChatModel> chats = <ChatModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadChats();
    loadMessages();
  }

  // Load saved chats
  void loadChats() {
    try {
      final storedChats = _storage.read(_chatsKey);
      if (storedChats != null) {
        final chatsList = List<Map<String, dynamic>>.from(storedChats);
        chats.value =
            chatsList.map((chat) => ChatModel.fromJson(chat)).toList();
      } else {
        // Create dummy chats for demonstration
        chats.value = _createDummyChats();
        _saveChats();
      }
    } catch (e) {
      print('Error loading chats: $e');
    }
  }

  // Load saved messages
  void loadMessages() {
    try {
      final storedMessages = _storage.read(_messagesKey);
      if (storedMessages != null) {
        final messagesList = List<Map<String, dynamic>>.from(storedMessages);
        messages.value =
            messagesList.map((msg) => MessageModel.fromJson(msg)).toList();
      } else {
        // Create dummy messages for demonstration
        messages.value = _createDummyMessages();
        _saveMessages();
      }
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  // Get chats for the current user
  List<ChatModel> getUserChats() {
    final currentUser = _authService.user;
    if (currentUser == null) return [];

    return chats;
  }

  // Get messages for a specific chat
  List<MessageModel> getChatMessages(String chatId) {
    return messages
        .where(
          (msg) =>
              (msg.senderId == chatId || msg.receiverId == chatId) &&
              (msg.senderId == _getCurrentUserId() ||
                  msg.receiverId == _getCurrentUserId()),
        )
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  // Send a text message
  Future<MessageModel?> sendTextMessage(
    String receiverId,
    String content,
  ) async {
    try {
      final newMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _getCurrentUserId(),
        receiverId: receiverId,
        content: content,
        type: MessageType.text,
        timestamp: DateTime.now(),
      );

      messages.add(newMessage);
      _updateLastMessage(receiverId, newMessage);
      await _saveMessages();
      return newMessage;
    } catch (e) {
      print('Error sending text message: $e');
      return null;
    }
  }

  // Send an image message
  Future<MessageModel?> sendImageMessage(
    String receiverId,
    File imageFile,
  ) async {
    try {
      // In a real app, you would upload the file to a server
      // and get back a URL. Here we'll simulate that.
      final fakeUrl =
          'https://example.com/images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final newMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _getCurrentUserId(),
        receiverId: receiverId,
        mediaUrl: fakeUrl,
        type: MessageType.image,
        timestamp: DateTime.now(),
      );

      messages.add(newMessage);
      _updateLastMessage(receiverId, newMessage);
      await _saveMessages();
      return newMessage;
    } catch (e) {
      print('Error sending image message: $e');
      return null;
    }
  }

  // Send a sticker message
  Future<MessageModel?> sendStickerMessage(
    String receiverId,
    String stickerId,
  ) async {
    try {
      final newMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _getCurrentUserId(),
        receiverId: receiverId,
        content: stickerId,
        type: MessageType.sticker,
        timestamp: DateTime.now(),
      );

      messages.add(newMessage);
      _updateLastMessage(receiverId, newMessage);
      await _saveMessages();
      return newMessage;
    } catch (e) {
      print('Error sending sticker message: $e');
      return null;
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatId) async {
    try {
      final chatMessages = getChatMessages(chatId);

      for (var i = 0; i < messages.length; i++) {
        if (messages[i].receiverId == _getCurrentUserId() &&
            messages[i].senderId == chatId &&
            !messages[i].isRead) {
          final updatedMessage = MessageModel(
            id: messages[i].id,
            senderId: messages[i].senderId,
            receiverId: messages[i].receiverId,
            content: messages[i].content,
            mediaUrl: messages[i].mediaUrl,
            type: messages[i].type,
            timestamp: messages[i].timestamp,
            isRead: true,
            metadata: messages[i].metadata,
          );

          messages[i] = updatedMessage;
        }
      }

      // Update unread count in chat list
      _updateUnreadCount(chatId);

      await _saveMessages();
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  // Helper method to update the last message in a chat
  void _updateLastMessage(String chatId, MessageModel message) {
    final index = chats.indexWhere((chat) => chat.id == chatId);

    if (index != -1) {
      // Update existing chat
      final chat = chats[index];
      final updatedChat = ChatModel(
        id: chat.id,
        name: chat.name,
        avatarUrl: chat.avatarUrl,
        lastMessage: message,
        unreadCount:
            message.senderId == _getCurrentUserId()
                ? chat.unreadCount
                : chat.unreadCount + 1,
        isOnline: chat.isOnline,
        lastSeen: chat.lastSeen,
      );

      chats[index] = updatedChat;
    } else {
      // Create new chat if it doesn't exist
      final newChat = ChatModel(
        id: chatId,
        name: 'User $chatId', // In a real app, get the actual name
        lastMessage: message,
        unreadCount: message.senderId == _getCurrentUserId() ? 0 : 1,
      );

      chats.add(newChat);
    }

    // Sort chats by last message time
    chats.sort((a, b) {
      final aTime = a.lastMessage?.timestamp ?? DateTime(1970);
      final bTime = b.lastMessage?.timestamp ?? DateTime(1970);
      return bTime.compareTo(aTime); // Most recent first
    });

    _saveChats();
  }

  // Helper method to update unread count
  void _updateUnreadCount(String chatId) {
    final index = chats.indexWhere((chat) => chat.id == chatId);

    if (index != -1) {
      final chat = chats[index];
      final updatedChat = ChatModel(
        id: chat.id,
        name: chat.name,
        avatarUrl: chat.avatarUrl,
        lastMessage: chat.lastMessage,
        unreadCount: 0, // Reset unread count
        isOnline: chat.isOnline,
        lastSeen: chat.lastSeen,
      );

      chats[index] = updatedChat;
      _saveChats();
    }
  }

  // Save messages to storage
  Future<void> _saveMessages() async {
    await _storage.write(
      _messagesKey,
      messages.map((msg) => msg.toJson()).toList(),
    );
  }

  // Save chats to storage
  Future<void> _saveChats() async {
    await _storage.write(
      _chatsKey,
      chats.map((chat) => chat.toJson()).toList(),
    );
  }

  // Helper method to get current user ID
  String _getCurrentUserId() {
    return _authService.user?.id ?? '1'; // Default to '1' if not logged in
  }

  // Create dummy chats for demonstration
  List<ChatModel> _createDummyChats() {
    return [
      ChatModel(
        id: '2',
        name: 'Jane Smith',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        isOnline: true,
        unreadCount: 3,
      ),
      ChatModel(
        id: '3',
        name: 'John Doe',
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ChatModel(
        id: '4',
        name: 'Alice Johnson',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        isOnline: true,
      ),
      ChatModel(
        id: '5',
        name: 'Bob Williams',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  // Create dummy messages for demonstration
  List<MessageModel> _createDummyMessages() {
    final currentUserId = _getCurrentUserId();
    return [
      // Conversation with Jane
      MessageModel(
        id: '1',
        senderId: '2',
        receiverId: currentUserId,
        content: 'Hey there! How are you doing?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        isRead: true,
      ),
      MessageModel(
        id: '2',
        senderId: currentUserId,
        receiverId: '2',
        content: 'I\'m good, thanks! How about you?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(
          const Duration(days: 1, hours: 1, minutes: 50),
        ),
        isRead: true,
      ),
      MessageModel(
        id: '3',
        senderId: '2',
        receiverId: currentUserId,
        content: 'Doing well. Have you checked out the new update?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(
          const Duration(days: 1, hours: 1, minutes: 30),
        ),
        isRead: true,
      ),
      MessageModel(
        id: '4',
        senderId: '2',
        receiverId: currentUserId,
        mediaUrl: 'https://picsum.photos/500/300?random=1',
        type: MessageType.image,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
        isRead: true,
      ),
      MessageModel(
        id: '5',
        senderId: currentUserId,
        receiverId: '2',
        content: 'Wow, that looks great!',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(
          const Duration(days: 1, minutes: 45),
        ),
        isRead: true,
      ),
      MessageModel(
        id: '6',
        senderId: '2',
        receiverId: currentUserId,
        content: 'Thanks! Let\'s catch up later.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(
          const Duration(days: 1, minutes: 30),
        ),
        isRead: false,
      ),
      MessageModel(
        id: '7',
        senderId: '2',
        receiverId: currentUserId,
        content: 'I have something exciting to share!',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      MessageModel(
        id: '8',
        senderId: '2',
        receiverId: currentUserId,
        content: 'Are you available tomorrow?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
      ),

      // Conversation with John
      MessageModel(
        id: '9',
        senderId: currentUserId,
        receiverId: '3',
        content: 'Hi John, do you have the project files?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
        isRead: true,
      ),
      MessageModel(
        id: '10',
        senderId: '3',
        receiverId: currentUserId,
        content: 'Yes, I\'ll send them right away.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(
          const Duration(days: 2, hours: 4, minutes: 50),
        ),
        isRead: true,
      ),
      MessageModel(
        id: '11',
        senderId: '3',
        receiverId: currentUserId,
        content: 'file_document_123',
        mediaUrl: 'https://example.com/files/project_docs.pdf',
        type: MessageType.file,
        timestamp: DateTime.now().subtract(
          const Duration(days: 2, hours: 4, minutes: 45),
        ),
        isRead: true,
        metadata: {'filename': 'Project Documentation.pdf', 'size': '2.4 MB'},
      ),
      MessageModel(
        id: '12',
        senderId: currentUserId,
        receiverId: '3',
        content: 'Got it, thanks!',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(
          const Duration(days: 2, hours: 4, minutes: 30),
        ),
        isRead: true,
      ),
    ];
  }
}
