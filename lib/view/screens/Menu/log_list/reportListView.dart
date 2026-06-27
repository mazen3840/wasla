import 'package:flutter/material.dart';
import '../../../../controller/loglist_controller.dart';
import '../../../../utils/colors.dart';
import 'listComponents/list_card.dart';

class LoglistListView extends StatelessWidget {
  const LoglistListView({super.key, required this.controller});

  final LoglistController controller;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var bannModel = controller.LoglistData!.data.clicks;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.appWhite.withOpacity(0.8),
          borderRadius: BorderRadius.circular(width * 0.03),
        ),
        height: height*0.82 ,
        child:bannModel.isNotEmpty? ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: bannModel.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: LoglistCard(
                  data: bannModel[index],
                ),
              ),
            );
          },
        ): Image.asset('assets/images/empty-inbox-outline.png'),
      ),
    );
  }
}
