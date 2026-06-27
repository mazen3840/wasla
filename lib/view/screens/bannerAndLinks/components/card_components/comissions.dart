import 'package:flutter/material.dart';

import '../../../../../model/bannerAndLinks_model.dart';
import '../../../../../utils/colors.dart';

class Commissions extends StatelessWidget {
  BannerData data;
  Commissions({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: AppColor.appSuperPrimaryLight,
        borderRadius: BorderRadius.circular(width * 0.02),
      ),
      child: Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            data.sale_commision_you_will_get != ''
                ? Row(
                    children: [
                      Text(
                        'You will get: ',
                        style: TextStyle(
                            fontFamily: 'Poppin',
                            fontSize: width * 0.033,
                            color: AppColor.appPrimary,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        data.sale_commision_you_will_get,
                        style: TextStyle(
                            fontFamily: 'Poppin',
                            fontSize: width * 0.033,
                            color: AppColor.appPrimary,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  )
                : Container(),
            data.click_commision_you_will_get != ''
                ? Row(
                    children: [
                      Text(
                        'You will get: ',
                        style: TextStyle(
                            fontFamily: 'Poppin',
                            fontSize: width * 0.033,
                            color: AppColor.appPrimary,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        data.click_commision_you_will_get,
                        style: TextStyle(
                            fontFamily: 'Poppin',
                            fontSize: width * 0.033,
                            color: AppColor.appPrimary,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  )
                : Container(),
            data.recurring != ''
                ? Row(
                    children: [
                      Text(
                        'Recurring: ',
                        style: TextStyle(
                            fontFamily: 'Poppin',
                            fontSize: width * 0.033,
                            color: AppColor.appPrimary,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        data.recurring,
                        style: TextStyle(
                            fontFamily: 'Poppin',
                            fontSize: width * 0.033,
                            color: AppColor.appPrimary,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
