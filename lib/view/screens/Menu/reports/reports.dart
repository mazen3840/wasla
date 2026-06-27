import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affiliatepro_mobile/controller/report_controller.dart';
import 'package:affiliatepro_mobile/utils/colors.dart';
import 'package:affiliatepro_mobile/utils/text.dart';
import 'package:affiliatepro_mobile/view/screens/Menu/reports/shimmer_widget.dart';
import 'package:affiliatepro_mobile/view/screens/Menu/reports/widgets/click_by_country.dart';
import 'package:affiliatepro_mobile/view/screens/Menu/reports/widgets/sale_by_country.dart';
import '../../../../controller/dashboard_controller.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    Get.find<ReportController>().getReportData(1, 100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GetBuilder<ReportController>(
      builder: (ReportController) {
        if (ReportController.isLoading || ReportController.isReportLoading) {
          return ReportsShimmerWidget(
            controller: ReportController,
          );
        } else {
          var ReportModel = ReportController.ReportData;
          print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
          print(ReportController.ReportData?.data.statistics.affiliateUser);
          return Scaffold(
            appBar: AppBar(
              foregroundColor: AppColor.appWhite,
              backgroundColor: AppColor.appPrimary,
              toolbarHeight: height * 0.08,
              centerTitle: true,
              title: Text(
                AppText.reports,
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
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Click(ReportController),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Sale(ReportController),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          User(ReportController),
                          Empty(ReportController),
                          // ReportController.ReportData?.data.statistics
                          //             .affiliateUser ==
                          //         {}
                          //     ? Container()
                          //     : AffiliateUser(
                          //         controller: ReportController,
                          //       ),
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

  Widget Empty(ReportController ReportController) {
    if ((ReportController.ReportData?.data.statistics.clicks is List &&
            ReportController.ReportData?.data.statistics.clicks.isEmpty) &&
        (ReportController.ReportData?.data.statistics.affiliateUser == null ||
            ReportController
                .ReportData!.data.statistics.affiliateUser!.isEmpty) &&
        (ReportController.ReportData?.data.statistics.sale is List &&
            ReportController.ReportData?.data.statistics.sale.isEmpty)) {
      return Center(
          child: Image.asset('assets/images/empty-inbox-outline.png'));
    } else {
      return Container();
    }
  }

  Widget Click(ReportController ReportController) {
    if (ReportController.ReportData?.data.statistics.clicks is List &&
        ReportController.ReportData?.data.statistics.clicks.isEmpty) {
      return Container();
    } else {
      return ClickByCountry(
        controller: ReportController,
      );
    }
  }

  Widget User(ReportController ReportController) {
    if (ReportController.ReportData?.data.statistics.affiliateUser == null ||
        ReportController.ReportData!.data.statistics.affiliateUser!.isEmpty) {
      return Container();
    } else {
      return ClickByCountry(
        controller: ReportController,
      );
    }
  }

  Widget Sale(ReportController ReportController) {
    if (ReportController.ReportData?.data.statistics.sale is List &&
        ReportController.ReportData?.data.statistics.sale.isEmpty) {
      return Container();
    } else {
      return SaleByCountry(
        controller: ReportController,
      );
    }
  }
}
