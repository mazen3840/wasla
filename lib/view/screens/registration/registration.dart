import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:affiliatepro_mobile/utils/text.dart';
import 'package:http/http.dart' as http;
import 'package:affiliatepro_mobile/view/screens/login/login.dart';
import '../../../controller/login_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../base/custom_loader.dart';
import '../../base/custom_text_field.dart';
import '/service/api_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  List<Map<String, dynamic>> formFields = [];
  bool loading = true;
  bool TandCAccepted = true;
  int isVendor = 0; // 0 = Affiliate, 1 = Vendor

  @override
  void initState() {
    super.initState();
    _getRegistrationForm();
  }

  void _getRegistrationForm() async {
    final response = await http.get(
      Uri.parse('${ApiService.instance.baseUrl}user/get_registration_form'),
    );
    if (response.statusCode == 200) {
      setState(() {
        formFields = List<Map<String, dynamic>>.from(
          json.decode(response.body)['data'],
        );
        print(formFields);
      });
    } else {
      print('Error fetching form fields');
    }
    setState(() {
      loading = false;
    });
  }

  stringToController(label, LoginController loginController) {
    switch (label) {
      case 'Firstname':
        return loginController.firstNameController;
      case 'Lastname':
        return loginController.lastNameController;
      case 'Email':
        return loginController.emailController;
      case 'Mobile Phone':
        return loginController.phoneNumberController;
      case 'Username':
        return loginController.userNameController;
      case 'Password':
        return loginController.passwordController;
      case 'Confirm_password':
        return loginController.ConfirmPasswordController;
      default:
        return loginController.firstNameController;
    }
  }

  stringToHintText(label) {
    switch (label) {
      case 'Firstname':
        return AppText.fName;
      case 'Lastname':
        return AppText.lName;
      case 'Email':
        return AppText.email;
      case 'Mobile Phone':
        return AppText.pNumber;
      case 'Username':
        return AppText.userName;
      case 'Password':
        return AppText.password;
      case 'Confirm_password':
        return AppText.ConfirmPassword;
      default:
        return AppText.fName;
    }
  }

  stringToKeyboardType(label) {
    switch (label) {
      case 'Firstname':
        return TextInputType.name;
      case 'Lastname':
        return TextInputType.name;
      case 'Email':
        return TextInputType.emailAddress;
      case 'Mobile Phone':
        return TextInputType.phone;
      case 'Username':
        return TextInputType.name;
      case 'Password':
        return TextInputType.name;
      case 'Confirm_password':
        return TextInputType.name;

      default:
        return TextInputType.name;
    }
  }

  stringToValidator(label, LoginController loginController) {
    switch (label) {
      case 'Firstname':
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Please input Firstname';
          }
          return null;
        };
      case 'Lastname':
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Please input Lastname';
          }
          return null;
        };
      case 'Email':
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Please input Email';
          } else if (!RegExp(
                  r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                  r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                  r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                  r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                  r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                  r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                  r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])')
              .hasMatch(value)) {
            return 'Please input a valid Email';
          }
          return null;
        };
      case 'Mobile Phone':
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Please input Mobile Phone';
          }
          return null;
        };
      case 'Username':
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Please input Username';
          }
          return null;
        };
      case 'Password':
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Please input Password';
          }
          return null;
        };
      case 'Confirm_password':
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Please input Password';
          }
          if (loginController.ConfirmPasswordController.text !=
              loginController.passwordController.text) {
            return 'Passwords are not identical';
          }
          return null;
        };
      default:
        return (value) {
          if (value == null || value.isEmpty) {
            return 'Please input Password';
          }
          return null;
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Get.find<LoginController>();
    return GetBuilder<LoginController>(builder: (loginController) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.background),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: ListView(
              children: [
                // Image.asset(
                //   AppImages.phoneImage,
                //   // width: width * 0.3,
                //   height: height * 0.35,
                // ),
                SizedBox(height: height * 0.012),
                Text(
                  AppText.createAccount,
                  style: TextStyle(
                    fontSize: height * 0.03,
                    fontWeight: FontWeight.bold,
                    color: AppColor.appWhite,
                  ),
                ),
                loading
                    ? const Center(child: CustomLoader())
                    : Form(
                        key: loginController.formKeyRegister,
                        child: ListView.builder(
                          itemCount: formFields.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final field = formFields[index];
                            return field['label'] == 'Text Area'
                                ? Container()
                                : Column(
                                    children: [
                                      SizedBox(height: height * 0.02),
                                      CustomTextField(
                                        textEditingController:
                                            stringToController(field['label'],
                                                loginController),
                                        // loginController.firstNameController,
                                        hintText:
                                            stringToHintText(field['label']),
                                        // AppText.fName,
                                        textInputType: stringToKeyboardType(
                                            field['label']),
                                        type: 2,
                                        validator: stringToValidator(
                                            field['label'], loginController),
                                      ),
                                    ],
                                  );
                          },
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Type',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isVendor = 0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isVendor == 0 ? Colors.white : Colors.transparent,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Affiliate',
                                    style: TextStyle(
                                      color: isVendor == 0 ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isVendor = 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isVendor == 1 ? Colors.white : Colors.transparent,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Vendor',
                                    style: TextStyle(
                                      color: isVendor == 1 ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CheckboxListTile(
                  title: Text(AppText.acceptTandC,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColor.appShadow,
                      )),
                  value: loginController.terms,
                  side: const BorderSide(
                    color: AppColor.appShadow,
                  ),
                  onChanged: (value) {
                    setState(() {
                      loginController.terms = value!;
                    });
                  },
                ),
                Visibility(
                  visible: !TandCAccepted,
                  child: Center(
                    child: Text('Please ${AppText.acceptTandC}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.red,
                        )),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: loginController.isLoading
                      ? const Center(child: CustomLoader())
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              TandCAccepted = true;
                            });
                            if (loginController.terms) {
                              loginController.registerUser(context, isVendor);
                            } else {
                              setState(() {
                                TandCAccepted = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(AppText.registration,
                              style: TextStyle(
                                  fontSize: width * 0.042,
                                  color: AppColor.appBlack)),
                        ),
                ),
                SizedBox(height: height * 0.025),
                RichText(
                  text: TextSpan(
                    text: AppText.alreadyAccount,
                    children: <TextSpan>[
                      TextSpan(
                          text: AppText.loginNow,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) =>
                                    // RegistrationFormPage(),
                                    const LoginPage(),
                              ));
                            }),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.022),
              ],
            ),
          ),
        ),
      );
    });
  }
}
