import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affiliatepro_mobile/controller/dashboard_controller.dart';
import 'package:affiliatepro_mobile/utils/colors.dart';
import 'package:affiliatepro_mobile/view/screens/profile/profile_card.dart';
import 'package:affiliatepro_mobile/view/screens/profile/shimmer_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    Get.find<DashboardController>().getUser();
    Get.find<DashboardController>().getDashboardData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      if (dashboardController.isLoading ||
          dashboardController.isDashboardDataLoading) {
        return ProfielShimmerWidget(
          controller: dashboardController,
        );
      } else {
        var dashModel = dashboardController.dashboardData!;
        return Scaffold(
          backgroundColor: AppColor.dashboardBgColor,
          body: ProfilePageProfile(
            controller: dashboardController,
          ),
        );
      }
    });
  }
}
