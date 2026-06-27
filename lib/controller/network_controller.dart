import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/network_model.dart';
import '../service/api_service.dart';
import '../utils/preference.dart';

class NetworkController extends GetxController {
  NetworkController({required this.preferences});
  SharedPreferences preferences;

  bool _isLoading = false;
  bool _isNetworkLoading = false;
  NetworkModel? _networkModel;

  bool get isLoading => _isLoading;
  bool get isNetworkLoading => _isNetworkLoading;
  NetworkModel? get networkData => _networkModel;

  changeIsLoading(bool data) {
    _isLoading = data;
    update();
  }

  changeNetworkLoading(bool data) {
    _isNetworkLoading = data;
    update();
  }

  updateNetworkData(NetworkModel model) {
    _networkModel = model;
    update();
  }

  getNetworkData() async {
    changeNetworkLoading(true);
    try {
      final userModel = await SharedPreference.getUserData();
      final token = userModel?.data?.token;
      String endPoint = 'My_Network/my_network';

      var value = await ApiService.instance.getData(endPoint, token: token);
      debugPrint('Get Network : $value');

      if (value != null &&
          value is Map<String, dynamic> &&
          value.containsKey('status') &&
          value['status'] == true &&
          value.containsKey('data') &&
          value['data'] != null) {
        updateNetworkData(NetworkModel.fromJson(value));
      } else {
        updateNetworkData(NetworkModel(
          status: false,
          message: 'No data available',
          data: NetworkData.fromJson({}),
        ));
      }
    } catch (e) {
      debugPrint('Error getting network data: $e');
      updateNetworkData(NetworkModel(
        status: false,
        message: 'Failed to load',
        data: NetworkData.fromJson({}),
      ));
    }
    changeNetworkLoading(false);
  }
}