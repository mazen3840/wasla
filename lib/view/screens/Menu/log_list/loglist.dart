import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affiliatepro_mobile/utils/colors.dart';
import 'package:affiliatepro_mobile/utils/text.dart';
import 'package:affiliatepro_mobile/view/screens/Menu/log_list/reportListView.dart';
import 'package:affiliatepro_mobile/view/screens/Menu/log_list/shimmer_widget.dart';
import '../../../../controller/dashboard_controller.dart';
import '../../../../controller/loglist_controller.dart';

class LoglistPage extends StatefulWidget {
  const LoglistPage({super.key});

  @override
  State<LoglistPage> createState() => _LoglistPageState();
}

class _LoglistPageState extends State<LoglistPage> {
  @override
  void initState() {
    Get.find<LoglistController>().getLoglistData(1, 100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GetBuilder<LoglistController>(
      builder: (LoglistController) {
        if (LoglistController.isLoading || LoglistController.isLoglistLoading) {
          return LoglistShimmerWidget(
            controller: LoglistController,
          );
        } else {
          var LoglistModel = LoglistController.LoglistData;
          return Scaffold(
            appBar: AppBar(
              foregroundColor: AppColor.appWhite,
              backgroundColor: AppColor.appPrimary,
              toolbarHeight: height * 0.08,
              centerTitle: true,
              title: Text(
                AppText.my_log_list,
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                Container(
                  height: width * 0.13,
                  width: width * 0.13,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(Get.find<DashboardController>()
                              .loginModel!
                              .data!
                              .profileAvatar!)),
                      color: AppColor.dashboardCardColor),
                ),
                SizedBox(
                  width: width * 0.03,
                )
              ],
            ),
            backgroundColor: AppColor.dashboardBgColor,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.03),
                      child: Column(
                        children: <Widget>[
                          // SizedBox(
                          //   height: height * 0.03,
                          // ),
                          LoglistListView(
                            controller: LoglistController,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
