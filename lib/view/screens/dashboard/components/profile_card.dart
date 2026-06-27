import 'package:flutter/material.dart';
import 'package:affiliatepro_mobile/controller/dashboard_controller.dart';

import '../../../../utils/colors.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var model = controller.loginModel;
    var dashModel = controller.dashboardData!.data;
    return model == null
        ? const SizedBox()
        : Container(
            padding: EdgeInsets.all(width * 0.04),
            width: double.infinity,
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
                borderRadius: BorderRadius.circular(width * 0.06)),
            child: Row(
              children: [
                Container(
                  height: width * 0.24,
                  width: width * 0.24,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(model.data!.profileAvatar!)),
                      shape: BoxShape.circle,
                      color: AppColor.dashboardBgColor),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${model.data!.firstname!.toUpperCase()} ${model.data!.lastname!.toUpperCase()}",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: AppColor.appPrimary,
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          model.data!.email!,
                          style: TextStyle(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          );
  }
}
