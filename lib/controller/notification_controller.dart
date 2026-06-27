import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/notification_model.dart';
import '../service/api_service.dart';
import '../utils/preference.dart';

class NotificationsController extends GetxController {
  bool _isLoading = false;
  NotificationsListModel? _notificationsModel;
  int _pageId = 1;
  final int _perPage = 100;

  bool get isLoading => _isLoading;
  NotificationsListModel? get notificationsData => _notificationsModel;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🔄 NotificationsController: onInit called');
  }

  void changeLoading(bool value) {
    _isLoading = value;
    update();
  }

  void updateData(NotificationsListModel model) {
    _notificationsModel = model;
    update();
  }

  Future<void> getNotificationsData() async {
    if (_isLoading) return;
    changeLoading(true);

    try {
      final user = await SharedPreference.getUserData();
      final token = user?.data?.token;
      if (token == null) {
        changeLoading(false);
        return;
      }

      const endPoint = 'Notification/notification_list';
      final body = {'page_id': _pageId, 'per_page': _perPage};

      final res = await ApiService.instance.postData2(endPoint, body, token: token);

      if (res == null || res['status'] != true) {
        updateData(
          NotificationsListModel(status: false, message: res?['message'] ?? 'Failed', data: []),
        );
        changeLoading(false);
        return;
      }

      updateData(NotificationsListModel.fromJson(res));
    } catch (e) {
      updateData(NotificationsListModel(status: false, message: 'Error: $e', data: []));
    } finally {
      changeLoading(false);
    }
  }

  // helper
  int min(int a, int b) => math.min(a, b);
}