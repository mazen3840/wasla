import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/bannerAndLinks_model.dart';
import '../service/api_service.dart';
import '../utils/preference.dart';

class BannerAndLinksController extends GetxController {
  BannerAndLinksController({required this.preferences});
  SharedPreferences preferences;

  bool _isLoading = false;
  bool _isbannerAndLinksLoading = false;
  BannerAndLinksModel? _bannerAndLinksModel;

  bool get isLoading => _isLoading;
  bool get isBannerAndLinksLoading => _isbannerAndLinksLoading;
  BannerAndLinksModel? get bannerAndLinksData => _bannerAndLinksModel;

  changeIsLoading(bool data) {
    _isLoading = data;
    update();
  }

  changeBannerAndLinksLoading(bool data) {
    _isbannerAndLinksLoading = data;
    update();
  }

  updateBannerAndLinksData(BannerAndLinksModel model) {
    _bannerAndLinksModel = model;
    update();
  }

  getBannerAndLinksData() async {
    changeBannerAndLinksLoading(true);
    final userModel = await SharedPreference.getUserData();
    final token = userModel?.data?.token;
    String endPoint = 'User/my_affiliate_links';
    Map<String, String> bodyParams = {};

    try {
      final value = await ApiService.instance.postData2(endPoint, bodyParams, token: token);
      debugPrint('Get BannerAndLinks : $value');

      if (value != null &&
          value is Map<String, dynamic> &&
          value.containsKey('status') &&
          value['status'] == true &&
          value.containsKey('data') &&
          value['data'] != null) {
        updateBannerAndLinksData(BannerAndLinksModel.fromJson(value));
      } else {
        updateBannerAndLinksData(BannerAndLinksModel(
          status: false,
          message: 'No data found',
          data: [],
        ));
      }
    } catch (e) {
      debugPrint('Error loading banners: $e');
      updateBannerAndLinksData(BannerAndLinksModel(
        status: false,
        message: 'Error occurred',
        data: [],
      ));
    }

    changeBannerAndLinksLoading(false);
  }
}