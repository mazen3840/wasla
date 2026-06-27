import 'package:flutter/material.dart';
import 'package:affiliatepro_mobile/model/dashboard_model.dart';

import '../../../base/expense_card.dart';

class DataCubic extends StatelessWidget {
  const DataCubic({super.key, required this.model});
  final DashboardModel model;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ExpenseCard(
              title: "Balance",
              data: model.data.userTotals.userBalance,
            ),
            ExpenseCard(
              title: "Action",
              data:
                  "${model.data.userTotals.clickActionTotal.toInt()}/${model.data.userTotals.clickActionCommission}",
            ),
          ],
        ),
        SizedBox(
          height: height * 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ExpenseCard(
              title: "Clicks",
              data:
              "${model.data.userTotals.totalClicksCount.toInt()}/${model.data.userTotals.totalClicksCommission}",
            ),
            ExpenseCard(
              title: "Refer Total (Year)",
              data: model.data.userTotalsYear,
            ),
          ],
        )
      ],
    );
  }
}
