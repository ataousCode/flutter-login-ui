// File: app/data/models/message_model.dart
import 'package:intl/intl.dart';

enum MessageType {
  text,
  image,
  sticker,
  file,
  audio,
  video,
  location
}

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String? content;
  final String? mediaUrl;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? metadata;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.content,
    this.mediaUrl,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.metadata,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
      mediaUrl: json['media_url'],
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['is_read'] ?? false,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'media_url': mediaUrl,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
      'metadata': metadata,
    };
  }

  // Helper method to format time for display
  String get formattedTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (messageDate == today) {
      // Today, just show time
      return DateFormat('h:mm a').format(timestamp);
    } else if (messageDate == yesterday) {
      // Yesterday
      return 'Yesterday ${DateFormat('h:mm a').format(timestamp)}';
    } else if (now.difference(timestamp).inDays < 7) {
      // Within a week, show day of week
      return '${DateFormat('EEEE').format(timestamp)} ${DateFormat('h:mm a').format(timestamp)}';
    } else {
      // Older than a week, show full date
      return DateFormat('MMM d, y • h:mm a').format(timestamp);
    }
  }
}

// A model for contacts/chat list
class ChatModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final MessageModel? lastMessage;
  final int unreadCount;
  final bool isOnline;
  final DateTime? lastSeen;

  ChatModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.lastMessage,
    this.unreadCount = 0,
    this.isOnline = false,
    this.lastSeen,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatar_url'],
      lastMessage: json['last_message'] != null
          ? MessageModel.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
      isOnline: json['is_online'] ?? false,
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
      'is_online': isOnline,
      'last_seen': lastSeen?.toIso8601String(),
    };
  }

  // Helper method to show last seen status
  String get lastSeenStatus {
    if (isOnline) return 'Online';
    if (lastSeen == null) return 'Offline';

    final now = DateTime.now();
    final difference = now.difference(lastSeen!);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d, y').format(lastSeen!);
    }
  }
}