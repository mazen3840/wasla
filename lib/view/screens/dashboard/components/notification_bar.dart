import 'package:flutter/material.dart';

import '../../../../controller/payments_detail_controller.dart';
import '../../../../utils/colors.dart';
import '../../Menu/payment_details/paymentDetail.dart';

class NotificationBar extends StatelessWidget {
  const NotificationBar({super.key, required this.controller});

  final PaymentDetailController controller;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var model = controller.PaymentDetailData;
    return model == null
        ? const SizedBox()
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentDetailPage(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(width * 0.04),
              width: double.infinity,
              decoration: BoxDecoration(
                  // boxShadow: const [
                  //   BoxShadow(
                  //     color: AppColor.appWhite,
                  //     spreadRadius: 2,
                  //     blurRadius: 5,
                  //     offset: Offset(-3, -3),
                  //   ),
                  //   BoxShadow(
                  //     color: AppColor.appShadow,
                  //     spreadRadius: 2,
                  //     blurRadius: 3,
                  //     offset: Offset(3, 4),
                  //   ),
                  // ],
                  color: AppColor.appWhite,
                  borderRadius: BorderRadius.circular(width * 0.06)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    model.data.notification!.paymentList!,
                    style: TextStyle(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                    ),
                  ),
                   Text(
                    model.data.notification!.paypalAccounts!,
                    style: TextStyle(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                    ),
                  ),
                   Text(
                    model.data.notification!.primaryPaymentMethod!,
                    style: TextStyle(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    'Click Here',
                    style: TextStyle(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                      color: AppColor.appPrimary
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
