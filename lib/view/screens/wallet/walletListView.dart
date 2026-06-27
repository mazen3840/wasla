import 'package:flutter/material.dart';
import 'package:affiliatepro_mobile/controller/wallet_controller.dart';

import '../../../utils/colors.dart';
import 'listComponents/list_card.dart';

class WalletTransactionsListView extends StatelessWidget {
  const WalletTransactionsListView({super.key, required this.controller});

  final WalletController controller;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var bannModel = controller.walletData?.data.transaction ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.appWhite.withOpacity(0.8),
          borderRadius: BorderRadius.circular(width * 0.03),
        ),
        height: height * 0.459,
        child: bannModel.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: bannModel.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: WalletCard(
                        data: bannModel[index],
                      ),
                    ),
                  );
                },
              )
            : Image.asset('assets/images/empty-inbox-outline.png'),
      ),
    );
  }
}
