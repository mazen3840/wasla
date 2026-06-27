import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Orders_model.dart';
import '../service/api_service.dart';
import '../utils/preference.dart';

class OrderController extends GetxController {
  OrderController({required this.preferences});
  SharedPreferences preferences;

  bool _isLoading = false;
  bool _isOrderLoading = false;
  OrderListModel? _OrderModel;

  bool get isLoading => _isLoading;
  bool get isOrderLoading => _isOrderLoading;
  OrderListModel? get OrderData => _OrderModel;

  String paid = 'paid';
  String action = 'actions';

  changeIsLoading(bool data) {
    _isLoading = data;
    update();
  }

  changeOrderLoading(bool data) {
    _isOrderLoading = data;
    update();
  }

  updateOrderData(OrderListModel model) {
    _OrderModel = model;
    update();
  }

  updateActionAndPaid(paidStatus, type) {
    if (paidStatus != null) paid = paidStatus;
    if (type != null) action = type;
  }

  getOrderData(int pageId, int perPage) async {
    changeOrderLoading(true);
    final userModel = await SharedPreference.getUserData();
    final token = userModel?.data?.token;
    String endPoint = 'Order/my_orders_list';

    final Map<String, dynamic> requestBody = {
      'page_id': pageId,
      'per_page': perPage,
    };

    try {
      final value = await ApiService.instance.postData(endPoint, requestBody);
      debugPrint('Get Order : ${jsonEncode(value)}');

      if (value != null &&
          value is Map<String, dynamic> &&
          value.containsKey('status') &&
          value['status'] == true &&
          value.containsKey('data') &&
          value['data'] != null) {
        updateOrderData(OrderListModel.fromJson(value));
      } else {
        updateOrderData(OrderListModel(
          status: false,
          message: 'No data found',
          data: OrderListData(orders: [], startFrom: 0, walletStatus: []),
        ));
      }
    } catch (e) {
      debugPrint('Error loading orders: $e');
      updateOrderData(OrderListModel(
        status: false,
        message: 'Error occurred',
        data: OrderListData(orders: [], startFrom: 0, walletStatus: []),
      ));
    }

    changeOrderLoading(false);
  }
}