import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affiliatepro_mobile/controller/login_controller.dart';
import 'package:affiliatepro_mobile/utils/text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../base/custom_loader.dart';
import '../../base/custom_text_field.dart';
import '../../base/loading.dart';
import '../../base/validations.dart';
import '../registration/registration.dart';
import '../../../service/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool logingIn = true;
  bool licenseValid = true;

  @override
  void initState() {
    super.initState();
    initSetup();
  }

  void initSetup() async {
    setState(() {
      logingIn = true;
    });

    bool isValid = await ApiService.instance.validateLicense();
    setState(() {
      licenseValid = isValid;
      logingIn = false;
    });

    if (isValid) {
      checkRememberData();
    }
  }

  void checkRememberData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(AppText.userName) != null) {
      LoginController(preferences: sharedPreferences).autoLogin(
        context,
        sharedPreferences.getString(AppText.userName) ?? "",
        sharedPreferences.getString(AppText.password) ?? "",
      );
    }
    setState(() {
      logingIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (!licenseValid) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 80, color: Colors.redAccent),
                const SizedBox(height: 20),
                const Text(
                  'Invalid License Key',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'This app is not activated.\nPlease contact the administrator.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final url = ApiService.instance.baseUrl;
                    Uri uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      launchUrl(uri);
                    }
                  },
                  child: Text(
                    ApiService.instance.baseUrl,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Please make sure your license key matches the one in the website installation.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => initSetup(),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reload License"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Get.find<LoginController>();
    return GetBuilder<LoginController>(
      builder: (loginController) {
        return logingIn
            ? Loading()
            : Scaffold(
          body: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.background),
                fit: BoxFit.cover,
                opacity: 0.9,
              ),
            ),
            child: Form(
              key: loginController.formKeyLogin,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  reverse: true,
                  children: [
                    Center(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColor.appWhite,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  const SizedBox(height: 30),
                                  Text(
                                    AppText.welcome,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: height * 0.032,
                                      fontWeight: FontWeight.w300,
                                      color: AppColor.appPrimary,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.025),
                                  CustomTextField(
                                    textEditingController: loginController.userNameController,
                                    hintText: AppText.userName,
                                    validator: (value) => Validations.validateEmptyField(value, AppText.userName),
                                    type: 1,
                                  ),
                                  SizedBox(height: height * 0.025),
                                  CustomTextField(
                                    textEditingController: loginController.passwordController,
                                    hintText: AppText.password,
                                    obscureText: true,
                                    validator: (value) => Validations.validateEmptyField(value, AppText.password),
                                    type: 1,
                                  ),
                                  SizedBox(height: height * 0.013),
                                  CheckboxListTile(
                                    title: Text(
                                      AppText.rememberMe,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        color: AppColor.appPrimary,
                                      ),
                                    ),
                                    value: loginController.rememberMe,
                                    side: const BorderSide(color: AppColor.appPrimary),
                                    onChanged: (value) {
                                      loginController.chnageRemeber();
                                    },
                                  ),
                                  SizedBox(height: height * 0.025),
                                  SizedBox(
                                    width: double.infinity,
                                    child: loginController.isLoading
                                        ? const Center(child: CustomLoader())
                                        : ElevatedButton(
                                      onPressed: () {
                                        loginController.loginUser(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        backgroundColor: AppColor.appPrimary,
                                      ),
                                      child: Text(
                                        AppText.login,
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: AppColor.appWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.025),
                                  RichText(
                                    text: TextSpan(
                                      text: AppText.dontHaveAccount,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        color: AppColor.appPrimary,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: AppText.registration,
                                          style: const TextStyle(
                                            color: AppColor.appPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) => const RegistrationScreen(),
                                                ),
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: height * 0.025),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        AppImages.phoneImage,
                        height: height * 0.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}