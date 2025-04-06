// File: app/modules/messaging/widgets/sticker_picker.dart
import 'package:flutter/material.dart';
import '../../../core/values/app_colors.dart';

class StickerPicker extends StatelessWidget {
  final Function(String) onStickerSelected;

   StickerPicker({
    super.key,
    required this.onStickerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Stickers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // In a real app, this would navigate to a sticker store
                    // or allow users to add custom stickers
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sticker store coming soon!'),
                      ),
                    );
                  },
                  child: Text(
                    'Get More',
                    style: TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _stickerIds.length,
              itemBuilder: (context, index) {
                final stickerId = _stickerIds[index];
                return _buildStickerItem(stickerId);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickerItem(String stickerId) {
    return InkWell(
      onTap: () => onStickerSelected(stickerId),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _getStickerWidget(stickerId),
      ),
    );
  }

  Widget _getStickerWidget(String stickerId) {
    // In a real app, you would load actual sticker images
    // For this demo, we'll use emoji icons
    IconData iconData;
    Color color;

    switch (stickerId) {
      case 'happy':
        iconData = Icons.sentiment_very_satisfied;
        color = Colors.amber;
        break;
      case 'sad':
        iconData = Icons.sentiment_very_dissatisfied;
        color = Colors.blue;
        break;
      case 'love':
        iconData = Icons.favorite;
        color = Colors.red;
        break;
      case 'laugh':
        iconData = Icons.emoji_emotions;
        color = Colors.amber;
        break;
      case 'cool':
        iconData = Icons.emoji_emotions;
        color = Colors.purple;
        break;
      case 'angry':
        iconData = Icons.mood_bad;
        color = Colors.red;
        break;
      case 'surprise':
        iconData = Icons.sentiment_satisfied_alt;
        color = Colors.orange;
        break;
      case 'confused':
        iconData = Icons.mood_bad;
        color = Colors.teal;
        break;
      case 'thumbs_up':
        iconData = Icons.thumb_up;
        color = Colors.blue;
        break;
      case 'thumbs_down':
        iconData = Icons.thumb_down;
        color = Colors.orange;
        break;
      case 'clap':
        iconData = Icons.back_hand;
        color = Colors.amber;
        break;
      case 'heart':
        iconData = Icons.favorite;
        color = Colors.pink;
        break;
      case 'fire':
        iconData = Icons.local_fire_department;
        color = Colors.deepOrange;
        break;
      case 'celebration':
        iconData = Icons.celebration;
        color = Colors.purple;
        break;
      case 'star':
        iconData = Icons.star;
        color = Colors.amber;
        break;
      case 'trophy':
        iconData = Icons.emoji_events;
        color = Colors.amber;
        break;
      default:
        iconData = Icons.emoji_emotions;
        color = Colors.grey;
    }

    return Icon(
      iconData,
      size: 40,
      color: color,
    );
  }

  // List of sticker IDs
  final List<String> _stickerIds = [
    'happy',
    'sad',
    'love',
    'laugh',
    'cool',
    'angry',
    'surprise',
    'confused',
    'thumbs_up',
    'thumbs_down',
    'clap',
    'heart',
    'fire',
    'celebration',
    'star',
    'trophy',
  ];
}