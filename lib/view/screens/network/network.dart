import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/dashboard_controller.dart';
import '../../../controller/network_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/text.dart';
import '../../base/custom_app_bar.dart';
import '../dashboard/components/menu.dart';
import 'network_listView.dart';
import 'network_shimmer_widget.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  @override
  void initState() {
    Get.find<NetworkController>().getNetworkData();
    Get.find<DashboardController>().getDashboardData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GetBuilder<NetworkController>(builder: (bannerAndLinksController) {
      if (bannerAndLinksController.isLoading ||
          bannerAndLinksController.isNetworkLoading ||
          bannerAndLinksController.networkData == null) {  // Add null check
        return NetworkShimmerWidget(
          controller: bannerAndLinksController,
        );
      } else {
        var dashModel = bannerAndLinksController.networkData!;
        return Scaffold(
          drawer: const Drawer(
            child: MenuPage(),
          ),
          backgroundColor: AppColor.dashboardBgColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomAppBar(
                title: AppText.network,
                isProfile: true,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 110,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          containerWidget(
                            width,
                            'Referrals product Click Commissions',
                            dashModel.data.referTotal.totalAction.clickCount ?? '0',
                          ),
                          containerWidget(
                            width,
                            'Sale / Sale Commission',
                            dashModel.data.referTotal.totalProductSale.amounts ?? '0/\$0',
                          ),
                          containerWidget(
                            width,
                            'Refer General Click Commission',
                            dashModel.data.referTotal.totalGaneralClick.totalClicks ?? '0',
                          ),
                          containerWidget(
                            width,
                            'Refer Action Commission',
                            dashModel.data.referTotal.totalAction.clickCount ?? '0',
                          ),
                        ],
                      ),
                    ),
                    NetworkListView(
                      controller: bannerAndLinksController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  containerWidget(double width, String title, var content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 30,
        width: width / 1.6,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: AppColor.appWhite,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(-3, -3),
            ),
            BoxShadow(
              color: AppColor.appShadow,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(3, 4),
            ),
          ],
          color: AppColor.appPrimaryLight,
          borderRadius: BorderRadius.circular(width * 0.06),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: width * 0.05,
                      color: AppColor.appPrimary,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: width * 0.04,
                      color: AppColor.appPrimary,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
