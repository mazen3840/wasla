import 'package:flutter/material.dart';

import '../../../../../model/loglist_model.dart';
import '../../../../../utils/colors.dart';

class LogsCardDetail extends StatefulWidget {
  Click data;
  LogsCardDetail({super.key, required this.data});

  @override
  State<LogsCardDetail> createState() => _LogsCardDetailState();
}

class _LogsCardDetailState extends State<LogsCardDetail> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          itemList(width, 'URL', widget.data.baseUrl),
          itemList(width, 'Browser Name', widget.data.browserName),
          itemList(width, 'Browser Version', widget.data.browserVersion),
          itemList(width, 'System String', widget.data.systemString),
          itemList(width, 'Os Platform', widget.data.osPlatform),
          itemList(width, 'Os Version', widget.data.osVersion),
          itemList(width, 'Os Short Verison', widget.data.osShortVersion),
          itemList(width, 'Is Mobile', widget.data.isMobile),
          itemList(width, 'Os Arch', widget.data.osArch),
          itemList(width, 'Is Itel', widget.data.isIntel),
          itemList(width, 'Country Code', widget.data.countryCode),
          itemList(width, 'IP', widget.data.ip),
          itemList(width, 'Id', widget.data.id),
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
