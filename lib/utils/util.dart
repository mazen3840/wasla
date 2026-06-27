import 'package:flutter/material.dart';
import 'package:affiliatepro_mobile/utils/reachability.dart';
import 'package:affiliatepro_mobile/utils/text.dart';

import 'colors.dart';

class Utils {
  factory Utils() {
    return _singleton;
  }

  static final Utils _singleton = Utils._internal();

  Utils._internal() {
    debugPrint("Instance created Utils");
  }

  static void showSnackBar(BuildContext context, String? message,
      {int duration = 2, SnackBarAction? action}) {
    if ((message ?? '').isEmpty) {
      return;
    }

    final snackBar = SnackBar(
      content: Text(
        message!,
      ),
      backgroundColor: AppColor.appBlack,
      duration: Duration(seconds: duration),
      action: action,
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static bool isInternetAvailable(BuildContext context,
      {bool isInternetMessageRequire = true}) {
    bool isInternet = Reachability.instance.isInterNetAvailable();
    if (!isInternet && isInternetMessageRequire) {
      Utils.showSnackBar(context, AppText.msgInternetMessage);
    }
    return isInternet;
  }
}
