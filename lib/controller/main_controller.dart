import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affiliatepro_mobile/controller/login_controller.dart';
import 'package:affiliatepro_mobile/utils/preference.dart';
import 'package:affiliatepro_mobile/view/screens/dashboard/dashboard.dart';
import 'package:affiliatepro_mobile/view/screens/network/network.dart';
import 'package:affiliatepro_mobile/view/screens/profile/profile.dart';
import 'package:affiliatepro_mobile/view/screens/wallet/wallet.dart';

import '../view/screens/bannerAndLinks/bannerAndLinks.dart';
import '../view/screens/login/login.dart';

class MainController extends GetxController {
  var selectedIndex = 0;
  PageController get pageController => _pageController;
  late PageController _pageController;
  var pageList = [
    const DashboardPage(),
    const BannerAndLinks(),
    const NetworkPage(),
    // const PaymentPage(),
    const WalletPage(),
    const ProfilePage()
  ];

  @override
  void onInit() {
    super.onInit();
    _pageController = PageController(initialPage: 0);
  }

  changePageIndex(int index) {
    selectedIndex = index;
    pageController.jumpToPage(index);
    update();
  }

  logOut(BuildContext context) async {
    await SharedPreference.logOut().then((value) {
      if (value) {
        Get.find<LoginController>().checkRememberData();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => LoginPage()), (route) => false);
      }
    });
  }
}
