import 'package:flutter/material.dart';
import 'package:affiliatepro_mobile/controller/dashboard_controller.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/text.dart';

class MembershipPlan extends StatelessWidget {
  const MembershipPlan({super.key, required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var model = controller.loginModel!;
    var dashModel = controller.dashboardData!.data;
    return Container(
      padding: EdgeInsets.all(width * 0.03),
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
      child: Column(children: <Widget>[
        Text(
          AppText.memberShipPlan,
          style: TextStyle(
            fontSize: width * 0.05,
            fontWeight: FontWeight.w300,
            fontFamily: 'Poppins',
            color: AppColor.appPrimary,
          ),
        ),
        const Divider(),
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.appSuperPrimaryLight,
                  borderRadius: BorderRadius.circular(width * 0.06),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    controller.convertDate(dashModel.userPlan.startedAt),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColor.appPrimary,
                        fontFamily: 'Poppins',
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Text(
              "to",
              style: TextStyle(fontSize: width * 0.035),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.appSuperPrimaryLight,
                  borderRadius: BorderRadius.circular(width * 0.06),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    controller.convertDate(dashModel.userPlan.expireAt),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColor.appPrimary,
                        fontFamily: 'Poppins',
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.01,
        ),
        const Divider(),
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Remaining Time ",
              style: TextStyle(
                  fontSize: width * 0.035,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300),
            ),
            Text(
              "${controller.daysBetween(dashModel.userPlan.expireAt)} days",
              style: TextStyle(
                  color: AppColor.appPrimary,
                  fontSize: width * 0.04,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300),
            )
          ],
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Plan ",
              style: TextStyle(
                  fontSize: width * 0.035,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300),
            ),
            Text(
              model.data?.isVendor == "1" ? "Vendor Plan" : "Affiliate Plan",
              style: TextStyle(
                  color: AppColor.appPrimary,
                  fontSize: width * 0.04,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300),
            )
          ],
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Payment Status ",
              style: TextStyle(
                  fontSize: width * 0.035,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300),
            ),
            CircleAvatar(
              backgroundColor: AppColor.appPrimary.withOpacity(0.7),
              radius: 15,
              child: const Icon(
                Icons.check,
                size: 15,
                color: AppColor.appWhite,
              ),
            )
          ],
        ),
      ]),
    );
  }
}
