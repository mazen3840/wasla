import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../controller/main_controller.dart';
import '../../../utils/colors.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Get.find<MainController>();
    return GetBuilder<MainController>(builder: (mainController) {
      return Scaffold(
          body: PageView.builder(
            controller: mainController.pageController,
            itemCount: mainController.pageList.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return mainController.pageList[mainController.selectedIndex];
            },
          ),
          bottomNavigationBar: SalomonBottomBar(
            selectedItemColor: AppColor.appWhite,
            unselectedItemColor: AppColor.appGrey,
            backgroundColor: AppColor.dashboardBgColor,
            currentIndex: mainController.selectedIndex,
            onTap: (i) {
              pageIndex = i;
              mainController.selectedIndex = i;
              mainController.changePageIndex(mainController.selectedIndex);
            },
            items: [
              /// Dashboard
              SalomonBottomBarItem(
                icon: const Icon(Icons.dashboard),
                title: const Text("Dashboard"),
                selectedColor: AppColor.appPrimary,
              ),
              // Banner
              SalomonBottomBarItem(
                icon: const Icon(Icons.link),
                title: const Text("B&L"),
                selectedColor: AppColor.appPrimary,
              ),

              /// Network
              SalomonBottomBarItem(
                icon: const Icon(
                  FontAwesomeIcons.networkWired,
                  size: 17,
                ),
                title: const Text("Network"),
                selectedColor: AppColor.appPrimary,
              ),

              /// Wallet
              SalomonBottomBarItem(
                icon: const Icon(Icons.wallet),
                title: const Text("Wallet"),
                selectedColor: AppColor.appPrimary,
              ),
              

              /// Profile
              SalomonBottomBarItem(
                icon: const Icon(Icons.person),
                title: const Text("Profile"),
                selectedColor: AppColor.appPrimary,
              ),
            ],
          ));
    });
  }
}
