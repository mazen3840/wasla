import 'package:flutter/material.dart';
import 'package:affiliatepro_mobile/utils/colors.dart';
import 'package:affiliatepro_mobile/service/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:affiliatepro_mobile/view/screens/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReniewPage extends StatelessWidget {
  const ReniewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the base URL from ApiService and create login URL
    String baseUrl = ApiService.instance.baseUrl;
    Uri uri = Uri.parse(baseUrl);
    String loginUrl = "${uri.scheme}://${uri.host}/login";

    return Scaffold(
      backgroundColor: AppColor.dashboardBgColor,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppColor.dashboardBgColor,
        title: const Text("Expired"),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Your account is expired!",
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "Please renew your membership by logging in to the web version:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    final url = Uri.parse(loginUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not open the link')),
                      );
                    }
                  },
                  child: Text(
                    loginUrl,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                    );
                  },
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}