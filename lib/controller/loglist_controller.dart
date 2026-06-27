import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/loglist_model.dart';
import '../service/api_service.dart';
import '../utils/preference.dart';

class LoglistController extends GetxController {
  LoglistController({required this.preferences});
  SharedPreferences preferences;

  bool _isLoading = false;
  bool _isLoglistLoading = false;
  LogListModel? _LoglistModel;

  bool get isLoading => _isLoading;
  bool get isLoglistLoading => _isLoglistLoading;
  LogListModel? get LoglistData => _LoglistModel;

  String paid = 'paid';
  String action = 'actions';

  changeIsLoading(bool data) {
    _isLoading = data;
    update();
  }

  changeLoglistLoading(bool data) {
    _isLoglistLoading = data;
    update();
  }

  updateLoglistData(LogListModel model) {
    _LoglistModel = model;
    update();
  }

  updateActionAndPaid(paidStatus, type) {
    if (paidStatus != null) paid = paidStatus;
    if (type != null) action = type;
  }

  getLoglistData(int pageId, int perPage) async {
    changeLoglistLoading(true);
    final userModel = await SharedPreference.getUserData();
    final token = userModel?.data?.token;
    String endPoint = 'My_Log/my_log_list';
    final Map<String, dynamic> requestBody = {
      'page_id': pageId,
      'per_page': perPage,
    };

    try {
      final value = await ApiService.instance.postData(endPoint, requestBody);
      debugPrint('Get Loglist : ${jsonEncode(value)}');

      if (value != null &&
          value is Map<String, dynamic> &&
          value.containsKey('status') &&
          value['status'] == true &&
          value.containsKey('data') &&
          value['data'] != null) {
        updateLoglistData(LogListModel.fromJson(value));
      } else {
        updateLoglistData(LogListModel(
          status: false,
          message: 'No data found',
          data: LogListData(clicks: [], startFrom: 0),
        ));
      }
    } catch (e) {
      debugPrint('Error loading loglist: $e');
      updateLoglistData(LogListModel(
        status: false,
        message: 'Error occurred',
        data: LogListData(clicks: [], startFrom: 0),
      ));
    }

    changeLoglistLoading(false);
  }
}