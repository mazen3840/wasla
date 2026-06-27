import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/notification_controller.dart';



class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final NotificationsController controller;

  @override
  void initState() {
    super.initState();
    controller =
        Get.put<NotificationsController>(NotificationsController(), permanent: true);
    controller.getNotificationsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.getNotificationsData(),
          ),
        ],
      ),
      body: GetBuilder<NotificationsController>(
        builder: (c) {
          if (c.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (c.notificationsData == null ||
              c.notificationsData!.data.isEmpty) {
            return const Center(child: Text('No notifications found'));
          }
          return RefreshIndicator(
            onRefresh: () async => controller.getNotificationsData(),
            child: ListView.builder(
              itemCount: c.notificationsData!.data.length,
              itemBuilder: (_, i) {
                final n = c.notificationsData!.data[i];
                return Card(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(n.title),
                    subtitle: Text(n.description),
                    trailing: const Icon(Icons.notifications),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}