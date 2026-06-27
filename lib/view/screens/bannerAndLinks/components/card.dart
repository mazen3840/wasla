import 'package:flutter/material.dart';

import '../../../../model/bannerAndLinks_model.dart';
import '../../../../utils/colors.dart';
import 'card_components/comissions.dart';
import 'card_components/ratio.dart';
import 'image.dart';

class BannerAndLinksCard extends StatelessWidget {
  BannerData data;
  BannerAndLinksCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: width * 0.5,
      width: width * 0.43,
      padding: EdgeInsets.all(width * 0.04),
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
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ImageWidget(
                data: data,
                width: width / 1.4,
                image: data.fevi_icon,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: TextStyle(
                        fontFamily: 'Poppin',
                        fontSize: width * 0.05,
                        color: AppColor.appPrimary,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: width * 0.015,
                  ),
                  Commissions(
                    data: data,
                  ),
                  SizedBox(
                    height: width * 0.02,
                  ),
                  Ratio(
                    data: data,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
