import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affiliatepro_mobile/utils/colors.dart';
import 'package:affiliatepro_mobile/utils/text.dart';
import 'package:affiliatepro_mobile/view/screens/dashboard/components/menu.dart';
import '../../../controller/bannerAndLinks_controller.dart';
import '../../base/custom_app_bar.dart';
import 'components/bannerAndLinks_listView.dart';
import 'components/banner_shimmer_widget.dart';

class BannerAndLinks extends StatefulWidget {
  const BannerAndLinks({super.key});

  @override
  State<BannerAndLinks> createState() => _BannerAndLinksState();
}

class _BannerAndLinksState extends State<BannerAndLinks> {
  @override
  void initState() {
    Get.find<BannerAndLinksController>().getBannerAndLinksData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GetBuilder<BannerAndLinksController>(
        builder: (bannerAndLinksController) {
      if (bannerAndLinksController.isLoading ||
          bannerAndLinksController.isBannerAndLinksLoading) {
        return BannerShimmerWidget(
          controller: bannerAndLinksController,
        );
      } else {
        var dashModel = bannerAndLinksController.bannerAndLinksData!;
        return Scaffold(
          drawer: const Drawer(
            child: MenuPage(),
          ),
          backgroundColor: AppColor.dashboardBgColor,
          body: Column(
            children: [
              CustomAppBar(
                title: AppText.bannerAndLinks,
                isProfile: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      BannerAndLinksListView(
                        controller: bannerAndLinksController,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
