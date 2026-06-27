import 'package:get/get.dart';
import 'package:affiliatepro_mobile/controller/dashboard_controller.dart';
import 'package:affiliatepro_mobile/controller/login_controller.dart';
import 'package:affiliatepro_mobile/controller/main_controller.dart';
import 'package:affiliatepro_mobile/controller/wallet_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/Payments_controller.dart';
import '../controller/bannerAndLinks_controller.dart';
import '../controller/loglist_controller.dart';
import '../controller/network_controller.dart';
import '../controller/orders_controller.dart';
import '../controller/payments_detail_controller.dart';
import '../controller/report_controller.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  ///controllers
  Get.lazyPut(() => LoginController(preferences: sharedPreferences));
  Get.lazyPut(() => MainController());
  Get.lazyPut(() => DashboardController(preferences: sharedPreferences));
  Get.lazyPut(() => BannerAndLinksController(preferences: sharedPreferences));
  Get.lazyPut(() => NetworkController(preferences: sharedPreferences));
  Get.lazyPut(() => WalletController(preferences: sharedPreferences));
  Get.lazyPut(() => ReportController(preferences: sharedPreferences));
  Get.lazyPut(() => OrderController(preferences: sharedPreferences));
  Get.lazyPut(() => LoglistController(preferences: sharedPreferences));
  Get.lazyPut(() => PaymentsController(preferences: sharedPreferences));
  Get.lazyPut(() => PaymentDetailController());
}
