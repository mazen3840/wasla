import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affiliatepro_mobile/components/SnackBar.dart';
import 'package:affiliatepro_mobile/utils/colors.dart';
import 'package:affiliatepro_mobile/utils/text.dart';
import 'package:affiliatepro_mobile/view/screens/main_container/main_container.dart';
import 'package:affiliatepro_mobile/view/screens/reniew/renew_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affiliatepro_mobile/view/screens/blocked_user/blocked_user_page.dart';
import '../model/user_model.dart';
import '../service/api_service.dart';
import '../utils/preference.dart';
import '../utils/util.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../view/screens/login/login.dart';
import 'dashboard_controller.dart';

class LoginController extends GetxController {
  LoginController({
    required this.preferences,
  });
  SharedPreferences preferences;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyRegister = GlobalKey<FormState>();
  bool terms = false;
  int isVendor = 0; // 0 = Affiliate, 1 = Vendor

  bool _isLoading = false;
  bool _AutoisLoading = true;
  bool _rememberMe = false;

  bool get isLoading => _isLoading;
  bool get autoIsLoading => _AutoisLoading;
  bool get rememberMe => _rememberMe;

  @override
  void onInit() {
    super.onInit();
    checkRememberData();
  }

  checkRememberData() async {
    var userName = preferences.getString(AppText.userName) ?? "";
    userNameController.text = userName;
    print('username$userName');
    var password = preferences.getString(AppText.password) ?? "";
    passwordController.text = password;
    print('password$password');
    update();
  }

  chnageLoading(bool data) {
    _isLoading = data;
    update();
  }

  changeAutoLoading(bool data) {
    _AutoisLoading = data;
    update();
  }

  chnageRemeber() {
    _rememberMe = !_rememberMe;
    update();
  }

  void setData(fName, lName, email, phone) {
    firstNameController.text = fName;
    lastNameController.text = lName;
    emailController.text = email;
    phoneNumberController.text = phone;
    userNameController.text =
        preferences.getString('${AppText.userName}saved') ??
            preferences.getString(AppText.userName) ??
            "";
    passwordController.text =
        preferences.getString('${AppText.password}saved') ??
            preferences.getString(AppText.password) ??
            "";
  }

  Future<void> autoLogin(BuildContext context, String userName, String password) async {
    if (preferences.getString(AppText.userName) == null) {
      changeAutoLoading(false);
    }
    changeAutoLoading(true);

    String deviceType;
    if (kIsWeb) {
      deviceType = "3";
    } else {
      deviceType = Platform.isAndroid ? "1" : Platform.isIOS ? "2" : "1";
    }

    Map<String, String> bodyParams = {
      "username": userName.trim(),
      "password": password.trim(),
      "device_type": deviceType,
      "device_token": '0',
      "is_vendor": isVendor.toString(),
    };

    try {
      final value = await ApiService.instance.postData('User/login', bodyParams);
      UserModel userModel = UserModel.fromJson(value);
      String status = userModel.data?.userStatus ?? "";

      if (status == "membership-status-expired") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ReniewPage()),
        );
        return;
      }

      if (status != "ok") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BlockedUserPage()),
        );
        return;
      }

      if (userModel.status != null && userModel.status!) {
        userNameController.text = userName; // important fix
        SharedPreference.setUserData(userModel);
        if (rememberMe) {
          SharedPreference.setRememberData(
            userName: userNameController.text,
            password: passwordController.text,
          );
        }
        SharedPreference.saveUserNameandPassword(
          userName: userNameController.text,
          password: passwordController.text,
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainPage()),
              (route) => false,
        );
        Utils.showSnackBar(context, userModel.message);
      } else {
        Utils.showSnackBar(context, userModel.message);
      }

      changeAutoLoading(false);
    } catch (e) {
      print("User not found");
      print(e);
      changeAutoLoading(false);
    }
  }

  Future<void> loginUser(BuildContext context) async {
    debugPrint('inputText : ${userNameController.text}');
    if (formKeyLogin.currentState!.validate()) {
      chnageLoading(true);
      update();

      // Handle device type for both web and mobile
      String deviceType;
      if (kIsWeb) {
        deviceType = "3"; // Web platform
      } else {
        deviceType = Platform.isAndroid
            ? "1"
            : Platform.isIOS
                ? "2"
                : "1";
      }

      Map<String, String> bodyParams = {
        "username": userNameController.text.trim(),
        "password": passwordController.text.trim(),
        "device_type": deviceType,
        "device_token": '0',
      };

      try {
        await ApiService.instance
            .postData('User/login', bodyParams)
            .then((value) {
          UserModel userModel = UserModel.fromJson(value);
          String status = userModel.data?.userStatus ?? "";

          if (status == "membership-status-expired") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ReniewPage()),
            );
            return;
          }

          if (status != "ok") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const BlockedUserPage()),
            );
            return;
          }

          if (userModel.status != null && userModel.status!) {
            SharedPreference.setUserData(userModel);
            if (rememberMe) {
              SharedPreference.setRememberData(
                userName: userNameController.text,
                password: passwordController.text,
              );
            }
            SharedPreference.saveUserNameandPassword(
              userName: userNameController.text,
              password: passwordController.text,
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainPage()),
              (route) => false,
            );
            Utils.showSnackBar(context, userModel.message);
          } else {
            Utils.showSnackBar(context, userModel.message);
          }
        });
      } catch (e) {
        print("User not found");
        print(e.toString());
        snackBar(context, "User is not registered", AppColor.appPrimary,
            AppColor.appWhite);
      }

      chnageLoading(false);
      update();
    }
  }

  Future<void> registerUser(BuildContext context, isVendor) async {
    if (formKeyRegister.currentState!.validate()) {
      chnageLoading(true);
      update();

      String deviceType;
      if (kIsWeb) {
        deviceType = "3";
      } else {
        deviceType = Platform.isAndroid ? "1" : Platform.isIOS ? "2" : "1";
      }

      Map<String, String> bodyParams = {
        "firstname": firstNameController.text.trim(),
        "lastname": lastNameController.text.trim(),
        "username": userNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "cpassword": ConfirmPasswordController.text.trim(),
        "device_type": deviceType,
        "device_token": '0',
        "phone": phoneNumberController.text.trim(),
        "terms": terms.toString(),
        "is_vendor": isVendor.toString(),
      };

      try {
        final value = await ApiService.instance.postData('User/registarion', bodyParams);

        if (value != null && value is Map<String, dynamic>) {
          if (value['status'] == true) {
            snackBar(context, "Registration Successful", AppColor.appPrimary, AppColor.appWhite);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ));
          } else {
            String errorMessage = 'Registration failed';
            if (value['errors'] != null) {
              errorMessage = (value['errors'] as Map).values.join('\n');
            } else if (value['message'] != null) {
              errorMessage = value['message'];
            }

            snackBar(context, errorMessage, Colors.red, AppColor.appWhite);
          }
        } else {
          snackBar(context, "Unexpected response from server", Colors.red, AppColor.appWhite);
        }
      } catch (e) {
        print("Exception:");
        print(e.toString());
        snackBar(context, "Unable to register", Colors.red, AppColor.appWhite);
      }

      chnageLoading(false);
      update();
    }
  }

  Future<void> updateUser(BuildContext context) async {
    chnageLoading(true);
    update();

    // Handle device type for both web and mobile
    String deviceType;
    if (kIsWeb) {
      deviceType = "3"; // Web platform
    } else {
      deviceType = Platform.isAndroid
          ? "1"
          : Platform.isIOS
              ? "2"
              : "1";
    }

    Map<String, String> bodyParams = {
      "firstname": firstNameController.text.trim(),
      "lastname": lastNameController.text.trim(),
      "username": userNameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "cpassword": passwordController.text.trim(),
      "device_type": deviceType,
      "device_token": '0',
      "phone": phoneNumberController.text.trim(),
      "country_id": 'Fr',
      // "terms": "true",
    };

    try {
      final userModel = await SharedPreference.getUserData();
      final token = userModel?.data?.token;
      await ApiService.instance
          .postData2('User/update_my_profile', bodyParams, token: token)
          .then((value) {
        UserModel userModel = UserModel.fromJson(value);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              return MainPage();
            },
          ),
          (route) => false,
        );
        snackBar(context, "Update Successful", AppColor.appPrimary,
            AppColor.appWhite);
      });
    } catch (e) {
      print("User not found");
      print(e.toString());
      snackBar(
          context, "Unable to update", AppColor.appPrimary, AppColor.appWhite);
    }

    chnageLoading(false);
    update();
  }

  Future<void> updateProfile(context, {File? imageFile}) async {
    chnageLoading(true);
    update();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiService.instance.baseUrl}User/update_my_profile'),
      );
      request.fields['firstname'] = firstNameController.text.trim();
      request.fields['lastname'] = lastNameController.text.trim();
      request.fields['username'] = userNameController.text.trim();
      request.fields['email'] = emailController.text.trim();
      request.fields['password'] = passwordController.text.trim();
      request.fields['cpassword'] = passwordController.text.trim();

      // Handle device type for both web and mobile
      String deviceType;
      if (kIsWeb) {
        deviceType = "3"; // Web platform
      } else {
        deviceType = Platform.isAndroid
            ? "1"
            : Platform.isIOS
                ? "2"
                : "1";
      }
      request.fields['device_type'] = deviceType;

      request.fields['device_token'] = '0';
      request.fields['phone'] = phoneNumberController.text.trim();
      request.fields['country_id'] = 'Fr';

      if (imageFile != null) {
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile(
          'avatar',
          stream,
          length,
          filename: imageFile.path.split('/').last,
        );
        request.files.add(multipartFile);
      } else {
        // send an empty file to the server to indicate that the user does not want to change their profile image
        var emptyFile = http.MultipartFile.fromBytes(
          'image',
          Uint8List.fromList([]),
          filename: 'empty.jpg',
        );
        request.files.add(emptyFile);
      }
      final userModel = await SharedPreference.getUserData();
      final token = userModel?.data?.token;
      request.headers['Authorization'] = token!;
      var response = await request.send();
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Profile updated successfully.');
        }
        var responseJson = await response.stream.bytesToString();
        print('API Response: $responseJson');

        // Add this to refresh dashboard data
        await Get.find<DashboardController>().getUser();

        Future.delayed(const Duration(milliseconds: 500), () {});

        snackBar(context, "Update Successful", AppColor.appPrimary,
            AppColor.appWhite);
      } else {
        print('Failed to update profile. ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating profile: $error');
      snackBar(
          context, "Unable to update", AppColor.appPrimary, AppColor.appWhite);
    }
    chnageLoading(false);
    update();
  }
}
