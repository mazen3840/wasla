import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affiliatepro_mobile/controller/main_controller.dart';
import 'package:affiliatepro_mobile/view/screens/notifications/notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../Menu/log_list/loglist.dart';
import '../../Menu/orders/orders.dart';
import '../../Menu/payment_details/paymentDetail.dart';
import '../../Menu/payments/payments.dart';
import '../../Menu/reports/reports.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 50),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReportsPage()),
                      );
                    },
                    leading: const Icon(FontAwesomeIcons.chartPie),
                    title: const Text("My Reports", style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoglistPage()),
                      );
                    },
                    leading: const Icon(FontAwesomeIcons.list),
                    title: const Text("My Logs list", style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrdersPage()),
                      );
                    },
                    leading: const Icon(FontAwesomeIcons.solidRectangleList),
                    title: const Text("My Order", style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentDetailPage()),
                      );
                    },
                    leading: const Icon(FontAwesomeIcons.solidMoneyBill1),
                    title: const Text("Payment Details", style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentsPage()),
                      );
                    },
                    leading: const Icon(FontAwesomeIcons.solidCreditCard),
                    title: const Text("Payments", style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications'),
                    onTap: () {
                      Navigator.pop(context);                        // close the drawer
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NotificationsPage()),
                      );
                    },
                  ),
                  // ✅ Reset AI Suggestions Option
                  ListTile(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('hide_ai_box_forever');
                      Navigator.pop(context); // ✅ Safer than Get.back()
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("AI suggestions have been reset.")),
                      );
                    },
                    leading: const Icon(Icons.refresh),
                    title: const Text("Reset AI Suggestions", style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ),

          // Logout
          ListTile(
            onTap: () {
              Get.find<MainController>().logOut(context);
            },
            leading: const Icon(Icons.logout),
            title: const Text("Log Out", style: TextStyle(fontWeight: FontWeight.w500)),
          ),

          // ✅ App Version Display
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              final version = snapshot.data!.version;
              final build = snapshot.data!.buildNumber;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 4),
                child: Text(
                  'Version $version+$build',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}