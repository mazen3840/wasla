import 'package:flutter/material.dart';
import 'package:affiliatepro_mobile/model/wallet_model.dart';

import '../../../base/expense_card.dart';

class WalletDataTripplets extends StatelessWidget {
  const WalletDataTripplets({super.key, required this.model});
  final WalletModel model;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.19,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(
            width: 10,
          ),
          Center(
            child: ExpenseCard(
              title: "Balance",
              data: "\$${model.data.userTotals.userBalance}",
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Center(
            child: ExpenseCard(
              title: "Paid Balance",
              data: "\$" "${model.data.userTotals.clickFormTotal}",
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Center(
            child: ExpenseCard(
              title: "Actions",
              data:
                  "${model.data.userTotals.clickActionTotal.toInt()}/\$${model.data.userTotals.clickActionTotal}",
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Center(
            child: ExpenseCard(
              title: "Clicks",
              data:
                  "${model.data.userTotals.totalClicksCount.toInt()}/\$${model.data.userTotals.totalClicksCommission}",
            ),
          )
        ],
      ),
    );
  }
}
