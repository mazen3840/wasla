import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:affiliatepro_mobile/controller/dashboard_controller.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/text.dart';
import '../../../controller/login_controller.dart';
import '../dashboard/components/menu.dart';
import 'edit_profile.dart';

class ProfilePageProfile extends StatelessWidget {
  const ProfilePageProfile({super.key, required this.controller});

  final DashboardController controller;

  // Add these constants at the top of your class
  final double kVerticalSpacing = 16.0;
  final double kHorizontalPadding = 16.0;

  // Add these text style getters
  TextStyle _titleStyle(double width) =>
      TextStyle(
        fontFamily: 'Poppins',
        color: AppColor.appBlack.withOpacity(0.7),
        fontSize: width * 0.035,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      );

  TextStyle _contentStyle(double width, {bool isEmail = false}) =>
      TextStyle(
        fontFamily: 'Poppins',
        color: AppColor.appPrimary,
        fontSize: width * (isEmail ? 0.04 : 0.05),
        fontWeight: isEmail ? FontWeight.w400 : FontWeight.w600,
        letterSpacing: isEmail ? 0 : 0.3,
      );

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var model = controller.loginModel;
    var dashModel = controller.dashboardData!.data;
    return Scaffold(
      drawer: const Drawer(
        child: MenuPage(),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: AppBar(
          backgroundColor: AppColor.appPrimary,
          elevation: 0,
          centerTitle: true,
          leading: Builder(
            builder: (context) =>
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: width * 0.06,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  splashRadius: 24,
                ),
          ),
          title: Text(
            AppText.profile,
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.05,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: width * 0.04),
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.edit,
                  size: width * 0.055,
                  color: AppColor.appWhite,
                ),
                onPressed: () {
                  Get.find<LoginController>().setData(
                    model!.data!.firstname!,
                    model.data!.lastname,
                    model.data!.email,
                    model.data!.phoneNumber,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfile(
                            image: controller.loginModel!.data!.profileAvatar!,
                          ),
                    ),
                  );
                },
                splashRadius: 24,
              ),
            ),
          ],
        ),
      ),
      body: model == null
          ? const SizedBox()
          : Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.04, vertical: height * 0.03),
        child: ListView(
          children: [
            Container(
              height: width * 0.4,
              width: width * 0.4,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: AppColor.appWhite,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(-8, -8),
                    ),
                    BoxShadow(
                      color: AppColor.appShadow,
                      spreadRadius: 4,
                      blurRadius: 5,
                      offset: Offset(3, 4),
                    ),
                  ],
                  image: DecorationImage(
                      image: NetworkImage(
                          controller.loginModel!.data!.profileAvatar!)),
                  shape: BoxShape.circle,
                  color: AppColor.dashboardBgColor),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    columnWidget(width, 'First Name',
                        model.data!.firstname!.toUpperCase(), 0.06),
                    const Divider(height: 1, color: Colors.transparent),
                    columnWidget(width, 'Last Name',
                        model.data!.lastname!.toUpperCase(), 0.06),
                    const Divider(height: 1, color: Colors.transparent),
                    email(width, 'Email', model.data!.email!, 0.05),
                    const Divider(height: 1, color: Colors.transparent),
                    columnWidget(
                      width,
                      'Phone Number',
                      model.data?.phoneNumber?.isNotEmpty == true ? model.data!.phoneNumber! : 'N/A',
                      0.06,
                    ),
                    const Divider(height: 1, color: Colors.transparent),
                    plan(width, 'Plan',
                        model.data!.isVendor!.toUpperCase(), 0.05),
                    const Divider(height: 1, color: Colors.transparent),
                    status(
                      width,
                      'Payment Status',
                      model.data!.userStatus!.toUpperCase(),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  columnWidget(width, title, content, size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColor.appBlack,
                fontSize: width * 0.04,
                fontWeight: FontWeight.w300),
          ),
          Text(
            content,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColor.appPrimary,
                fontSize: width * size,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  email(width, title, content, size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColor.appBlack,
                fontSize: width * 0.04,
                fontWeight: FontWeight.w300),
          ),
          Text(
            content,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColor.appPrimary,
                fontSize: width * size,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  plan(width, title, content, size) {
    final isVendorPlan = controller.loginModel?.data?.isVendor == "1"; // Check if user is vendor

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColor.appBlack,
                fontSize: width * 0.04,
                fontWeight: FontWeight.w300),
          ),
          Text(
            isVendorPlan ? 'Vendor Plan' : 'Affiliate Plan',
            style: TextStyle(
                fontFamily: 'Poppins',
                color: isVendorPlan
                    ? AppColor.appPrimary.withOpacity(0.6)
                    : AppColor.appPrimary,
                fontSize: width * size,
                fontWeight: isVendorPlan ? FontWeight.w600 : FontWeight.w400),
          ),
        ],
      ),
    );
  }
  status(width,
      title,
      content,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColor.appBlack,
                fontSize: width * 0.04,
                fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: content == 'OK'
                  ? AppColor.appPrimary.withOpacity(0.1)
                  : AppColor.appPrimary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.appPrimary,
                  radius: 12,
                  child: Icon(
                    content == 'OK' ? Icons.check : Icons.cancel,
                    size: 14,
                    color: AppColor.appWhite,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  content == 'OK' ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColor.appPrimary,
                    fontSize: width * 0.035,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} // Class closing bracket
