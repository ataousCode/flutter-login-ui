import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_ui/app/data/services/message_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../core/values/app_strings.dart';

class HomeController extends GetxController {
  final _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  final RxInt selectedTabIndex = 0.obs;

  String get username => _authService.user?.username ?? 'User';
  String get email => _authService.user?.email ?? 'No email';

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();

    // Make sure MessageService is available
    if (!Get.isRegistered<MessageService>()) {
      Get.put(MessageService());
    }
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text(AppStrings.logout),
        content: const Text(AppStrings.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              Get.back();

              // Set custom loading message for logout
              isLoading.value = true;
              await Future.delayed(
                const Duration(milliseconds: 800),
              ); // Simulate logout delay
              await _authService.logout();
              isLoading.value = false;

              Get.offAllNamed(Routes.LOGIN);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppStrings.logout),
          ),
        ],
      ),
    );
  }

  void profileSettings() {
    Get.snackbar(
      'Profile Settings',
      'This feature will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Dummy data for dashboard items
  final List<Map<String, dynamic>> dashboardItems = [
    {
      'icon': Icons.list_alt,
      'title': 'Tasks',
      'count': '12',
      'color': Colors.blue,
    },
    {
      'icon': Icons.calendar_today,
      'title': 'Events',
      'count': '3',
      'color': Colors.orange,
    },
    {
      'icon': Icons.message,
      'title': 'Messages',
      'count': '8',
      'color': Colors.purple,
    },
    {
      'icon': Icons.settings,
      'title': 'Settings',
      'count': '',
      'color': Colors.teal,
    },
    {
      'icon': Icons.person,
      'title': 'Users',
      'count': '18',
      'color': Colors.purple,
    },
    {'icon': Icons.money, 'title': 'Money', 'count': '', 'color': Colors.teal},
  ];

  // Dummy data for activity feed
  final List<Map<String, dynamic>> activityFeed = [
    {
      'title': 'New Task Assigned',
      'description': 'You have been assigned a new task: "Update user profile"',
      'time': '10 min ago',
      'icon': Icons.assignment,
      'color': Colors.blue,
    },
    {
      'title': 'Meeting Reminder',
      'description': 'Team meeting starts in 30 minutes',
      'time': '25 min ago',
      'icon': Icons.event,
      'color': Colors.orange,
    },
    {
      'title': 'System Update',
      'description': 'The system has been updated to version 2.0',
      'time': '1 hour ago',
      'icon': Icons.system_update,
      'color': Colors.green,
    },
  ];
}
