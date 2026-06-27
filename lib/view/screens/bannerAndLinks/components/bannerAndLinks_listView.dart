import 'package:flutter/material.dart';

import '../../../../controller/bannerAndLinks_controller.dart';
import 'card.dart';

class BannerAndLinksListView extends StatelessWidget {
  const BannerAndLinksListView({super.key, required this.controller});

  final BannerAndLinksController controller;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var bannModel = controller.bannerAndLinksData!.data;
    return SizedBox(
      height: height*0.8,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemCount: bannModel.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => ProductDetail(
              //             product: products[index],
              //           )),
              // );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: BannerAndLinksCard(
                data: bannModel[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
