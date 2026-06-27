import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affiliatepro_mobile/utils/colors.dart';
import 'package:affiliatepro_mobile/utils/text.dart';
import 'package:affiliatepro_mobile/view/screens/Menu/orders/shimmer_widget.dart';
import '../../../../controller/dashboard_controller.dart';
import '../../../../controller/orders_controller.dart';
import 'ordersListView.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    Get.find<OrderController>().getOrderData(1, 100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GetBuilder<OrderController>(
      builder: (OrderController) {
        if (OrderController.isLoading || OrderController.isOrderLoading) {
          return OrdersShimmerWidget(
            controller: OrderController,
          );
        } else {
          // ignore: non_constant_identifier_names
          var OrderModel = OrderController.OrderData;
          return Scaffold(
            appBar: AppBar(
              foregroundColor: AppColor.appWhite,
              backgroundColor: AppColor.appPrimary,
              toolbarHeight: height * 0.08,
              centerTitle: true,
              title: Text(
                AppText.my_orders,
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                Container(
                  height: width * 0.13,
                  width: width * 0.13,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(Get.find<DashboardController>()
                              .loginModel!
                              .data!
                              .profileAvatar!)),
                      color: AppColor.dashboardCardColor),
                ),
                SizedBox(
                  width: width * 0.03,
                )
              ],
            ),
            backgroundColor: AppColor.dashboardBgColor,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.03),
                      child: Column(
                        children: <Widget>[
                         OrdersListView(controller: OrderController,)
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
