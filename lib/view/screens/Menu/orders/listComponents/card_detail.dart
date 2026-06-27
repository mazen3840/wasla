import 'package:flutter/material.dart';

import '../../../../../model/Orders_model.dart';
import '../../../../../utils/colors.dart';

class CardDetail extends StatefulWidget {
  Order data;
  CardDetail({super.key, required this.data});

  @override
  State<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          itemList(width, 'Commission Type', widget.data.commissionType),
          itemList(width, 'Product ids', widget.data.productIds),
          itemList(width, 'Currency', widget.data.currency),
          itemList(width, 'IP', widget.data.ip),
          itemList(width, 'Id', widget.data.id),
          itemList(width, 'Country Code', widget.data.countryCode),
          itemList(width, 'URL', widget.data.baseUrl),
          itemList(width, 'Username', widget.data.userName),
        ],
      ),
    );
  }

  Widget itemList(width, text1, text2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: TextStyle(
                fontFamily: 'Poppin',
                fontSize: width * 0.03,
                color: AppColor.appPrimary,
                fontWeight: FontWeight.w300),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.appSuperPrimaryLight,
                borderRadius: BorderRadius.circular(width * 0.01),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Text(
                  text2,
                  style: TextStyle(
                      fontFamily: 'Poppin',
                      fontSize: width * 0.03,
                      color: AppColor.appPrimary,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
