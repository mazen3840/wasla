import 'package:flutter/material.dart';
import '../../../../../model/Payments_model.dart';
import '../../../../../utils/colors.dart';
import '../../../wallet/components/dateConverter.dart';

class CardDetail extends StatefulWidget {
  PaymentsData data;
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
          itemList(width, 'Module', widget.data.module),
          itemList(width, 'ID', widget.data.id),
          itemList(width, 'User Id', widget.data.userId),
          itemList(width, 'Username', widget.data.username),
          itemList(width, 'Price', widget.data.price),
          itemList(width, 'Payment Gateway', widget.data.paymentGateway),
          itemList(width, 'Status Id', widget.data.statusId),
          itemList(width, 'DateTime', formatDate(widget.data.datetime)),
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
