import 'package:flutter/material.dart';
import '../../../../../utils/colors.dart';
import '../../../../model/wallet_model.dart';
import '../components/dateConverter.dart';

class WalletCardDetail extends StatefulWidget {
  Transaction data;
  WalletCardDetail({super.key, required this.data});

  @override
  State<WalletCardDetail> createState() => _WalletCardDetailState();
}

class _WalletCardDetailState extends State<WalletCardDetail> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          itemList(
            width,
            'Payment',
            widget.data.paymentMethod?.toString() ?? 'Unpaid',
          ),
          itemList(
            width,
            'Status',
            widget.data.status == '1' ? 'In Wallet' : 'On Hold',
          ),
          itemList(
            width,
            'Commission',
            widget.data.amount,
          ),
          itemList(
            width,
            'Date',
            formatDate(widget.data.createdAt),
          ),
          itemList(
            width,
            'Commission Type',
            widget.data.type,
          ),
          itemList(
            width,
            'Product IDs',
            widget.data.referenceId,
          ),
          itemList(
            width,
            'Currency',
            'IDR', // Since it's static in your API
          ),
          itemList(
            width,
            'IP',
            widget.data.domainName ?? 'N/A',
          ),
          itemList(
            width,
            'ID',
            widget.data.id,
          ),
          itemList(
            width,
            'Country Code',
            widget.data.wv ?? 'N/A',
          ),
          itemList(
            width,
            'URL',
            widget.data.pageName ?? 'N/A',
          ),
          itemList(
            width,
            'Username',
            '${widget.data.firstname} ${widget.data.lastname}',
          ),
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