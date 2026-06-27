import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:affiliatepro_mobile/utils/colors.dart';
import 'package:affiliatepro_mobile/utils/text.dart';
import 'package:affiliatepro_mobile/view/screens/wallet/shimmer_widget.dart';
import 'package:affiliatepro_mobile/view/screens/wallet/walletListView.dart';
import '../../../controller/wallet_controller.dart';
import '../../base/custom_app_bar.dart';
import '../dashboard/components/menu.dart';
import 'components/wallet_data_tripplets.dart';
import 'listComponents/filter_widget.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    Get.find<WalletController>().getWalletData(1, 100);
    super.initState();
  }

  update(
    String? paidStatus,
    String? type,
  ) {
    Get.find<WalletController>().updateActionAndPaid(paidStatus:paidStatus,type:type);
    Get.find<WalletController>()
        .getWalletData(1, 100,);
  }

  refresh() {
    Get.find<WalletController>().updateActionAndPaid(paidStatus: '', type: '');
    Get.find<WalletController>().getWalletData(1, 100);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GetBuilder<WalletController>(
      builder: (WalletController) {
        if (WalletController.isLoading || WalletController.isWalletLoading) {
          return WalletShimmerWidget(
            controller: WalletController,
          );
        } else {
          var walletModel = WalletController.walletData;
          return Scaffold(
            drawer: const Drawer(
              child: MenuPage(),
            ),
            backgroundColor: AppColor.dashboardBgColor,
            body: Column(
              children: [
                CustomAppBar(
                  title: AppText.wallet,
                  isProfile: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.03),
                      child: Column(
                        children: <Widget>[
                          WalletDataTripplets(
                            model: walletModel!,
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FilterWidget(
                                parameter1: 'Paid Type',
                                parameter2: 'Withdraw Type',
                                options1: const ['','paid', 'unpaid'],
                                options2: const [
                                  '',
                                  'actions',
                                  'clicks',
                                  'sale',
                                  'external_integration',
                                ],
                                onFilterChanged: update,
                                controller: WalletController,
                              ),
                              GestureDetector(
                                onTap: () {
                                  refresh();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.appPrimaryLight,
                                    borderRadius: BorderRadius.circular(width),
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
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Icon(
                                      FontAwesomeIcons.rotateRight,
                                      color: AppColor.appBlack,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          WalletTransactionsListView(
                            controller: WalletController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
