import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affiliatepro_mobile/controller/Payments_controller.dart';
import 'package:affiliatepro_mobile/utils/colors.dart';
import 'package:affiliatepro_mobile/utils/text.dart';
import 'package:affiliatepro_mobile/view/screens/Menu/payments/paymentsListView.dart';
import 'package:affiliatepro_mobile/view/screens/Menu/payments/shimmer_widget.dart';
import 'package:affiliatepro_mobile/view/screens/Menu/payments/widgets/numberAdjuster.dart';
import '../../../../controller/dashboard_controller.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  void initState() {
    Get.find<PaymentsController>().getPaymentsData();
    super.initState();
  }

  refresh(int pageId, int perPage) {
    Get.find<PaymentsController>().getPaymentsData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GetBuilder<PaymentsController>(
      builder: (PaymentsController) {
        if (PaymentsController.isLoading ||
            PaymentsController.isPaymentsLoading) {
          return PaymentsShimmerWidget(
            controller: PaymentsController,
          );
        } else {
          // ignore: non_constant_identifier_names
          var PaymentsModel = PaymentsController.PaymentsData;
          return Scaffold(
            appBar: AppBar(
              foregroundColor: AppColor.appWhite,
              backgroundColor: AppColor.appPrimary,
              toolbarHeight: height * 0.08,
              centerTitle: true,
              title: Text(
                AppText.my_payments,
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
                NumberAdjuster(
                  paymentsController: PaymentsController,
                  
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.03),
                      child: Column(
                        children: <Widget>[
                          PaymentsListView(
                            controller: PaymentsController,
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
