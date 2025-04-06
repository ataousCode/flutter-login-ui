// File: app/modules/home/views/home_view.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_ui/app/modules/messaging/views/chat_view.dart';
import 'package:login_ui/app/modules/messaging/views/messages_view.dart';
import 'package:login_ui/app/routes/app_pages.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_strings.dart';
import '../controllers/home_controller.dart';
import '../../../../widgets/loading_overlay.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isLoading.value,
        message: 'Logging out...',
        child: Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.home),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: controller.logout,
                tooltip: AppStrings.logout,
              ),
            ],
          ),
          body: SafeArea(child: _buildBody()),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedTabIndex.value,
            onTap: controller.changeTab,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.grey,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.cardBackground,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Activity',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    // Show different content based on selected tab
    switch (controller.selectedTabIndex.value) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildActivityFeed();
      case 2:
        return const MessagesView();
      case 3:
        return _buildProfile();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: 30,
                    child: Icon(Icons.person, size: 32, color: AppColors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${controller.username}!',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          controller.email,
                          style: const TextStyle(color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Your Dashboard',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Dashboard grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1,
              ),
              itemCount: controller.dashboardItems.length,
              itemBuilder: (context, index) {
                final item = controller.dashboardItems[index];
                return _buildDashboardCard(
                  icon: item['icon'],
                  title: item['title'],
                  count: item['count'],
                  color: item['color'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityFeed() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: controller.activityFeed.length,
              itemBuilder: (context, index) {
                final activity = controller.activityFeed[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: activity['color'].withOpacity(0.2),
                      child: Icon(activity['icon'], color: activity['color']),
                    ),
                    title: Text(activity['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(activity['description']),
                        const SizedBox(height: 4),
                        Text(
                          activity['time'],
                          style: TextStyle(
                            color: AppColors.grey.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 80,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Messages Feature',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'This feature will be implemented in the future',
            style: TextStyle(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile header
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              controller.username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              controller.email,
              style: const TextStyle(fontSize: 16, color: AppColors.grey),
            ),
            const SizedBox(height: 32),

            // Profile options
            _buildProfileOption(
              icon: Icons.settings,
              title: 'Settings & Privacy',
              onTap: () => Get.toNamed(Routes.SETTINGS),
            ),
            _buildProfileOption(
              icon: Icons.favorite,
              title: 'Saved Items',
              onTap:
                  () => Get.snackbar(
                    'Coming Soon',
                    'Saved Items feature will be available in the next update',
                    snackPosition: SnackPosition.BOTTOM,
                  ),
            ),
            _buildProfileOption(
              icon: Icons.history,
              title: 'Activity History',
              onTap:
                  () => Get.snackbar(
                    'Coming Soon',
                    'Activity History feature will be available in the next update',
                    snackPosition: SnackPosition.BOTTOM,
                  ),
            ),
            _buildProfileOption(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap:
                  () => Get.snackbar(
                    'Coming Soon',
                    'Help & Support feature will be available in the next update',
                    snackPosition: SnackPosition.BOTTOM,
                  ),
            ),
            _buildProfileOption(
              icon: Icons.dark_mode,
              title: 'Appearance',
              onTap:
                  () => Get.snackbar(
                    'Coming Soon',
                    'Theme customization will be available in the next update',
                    snackPosition: SnackPosition.BOTTOM,
                  ),
            ),

            const SizedBox(height: 5),

            // Logout button
            ElevatedButton.icon(
              onPressed: controller.logout,
              icon: const Icon(Icons.logout),
              label: const Text(AppStrings.logout),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
    VoidCallback? onTap, // Add this parameter
  }) {
    return InkWell(
      // Wrap with InkWell
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (count.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    count,
                    style: TextStyle(
                      fontSize: 20,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  //   Widget _buildDashboardCard({
  //     required IconData icon,
  //     required String title,
  //     required String count,
  //     required Color color,
  //   }) {
  //     return Card(
  //       elevation: 5,
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(icon, size: 40, color: color),
  //             const SizedBox(height: 12),
  //             Text(
  //               title,
  //               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //             ),
  //             if (count.isNotEmpty)
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 8.0),
  //                 child: Text(
  //                   count,
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     color: color,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
}
