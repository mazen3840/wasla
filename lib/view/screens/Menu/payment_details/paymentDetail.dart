import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affiliatepro_mobile/utils/colors.dart';
import 'package:affiliatepro_mobile/utils/text.dart';
import 'package:affiliatepro_mobile/view/screens/Menu/payment_details/paymentDetailInputs.dart';
import 'package:affiliatepro_mobile/view/screens/Menu/payment_details/shimmer_widget.dart';
import '../../../../controller/dashboard_controller.dart';
import '../../../../controller/payments_detail_controller.dart';

class PaymentDetailPage extends StatefulWidget {
  const PaymentDetailPage({super.key});

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  @override
  void initState() {
    // fetchPayment();
    super.initState();
  }
  fetchPayment() {
    Get.find<PaymentDetailController>().getPaymentsData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GetBuilder<PaymentDetailController>(
      builder: (PaymentDetailController) {
        if (PaymentDetailController.isLoading ||
            PaymentDetailController.isPaymentDetailLoading) {
          return PaymentDetailShimmerWidget(
            controller: PaymentDetailController,
          );
        } else {
          // ignore: non_constant_identifier_names
          var PaymentDetailModel = PaymentDetailController.PaymentDetailData;
          return Scaffold(
              appBar: AppBar(
                foregroundColor: AppColor.appWhite,
                backgroundColor: AppColor.appPrimary,
                toolbarHeight: height * 0.08,
                centerTitle: true,
                title: Text(
                  AppText.my_payment_detail,
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
              body: PaymentDetailInputs(
                  paymentDetailController: PaymentDetailController));
        }
      },
    );
  }
}
