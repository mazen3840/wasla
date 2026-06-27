import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({super.key, required this.title, required this.data});

  final String title, data;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: width * 0.37,
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
          borderRadius: BorderRadius.circular(width * 0.06)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: width * 0.045,
                  color: AppColor.appPrimary,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: width * 0.01,
            ),
            Text(
              data,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                  fontSize: width * 0.04,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300),
            )
          ]),
    );
  }
}
