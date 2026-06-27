import 'package:flutter/material.dart';
import '../../../../controller/Payments_controller.dart';
import '../../../../utils/colors.dart';
import 'listComponents/list_card.dart';

class PaymentsListView extends StatelessWidget {
  const PaymentsListView({super.key, required this.controller});

  final PaymentsController controller;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var bannModel = controller.PaymentsData!.data;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.appWhite.withOpacity(0.8),
          borderRadius: BorderRadius.circular(width * 0.03),
        ),
        height: height*0.82 ,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: bannModel.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: PaymentsCard(
                  data: bannModel[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
