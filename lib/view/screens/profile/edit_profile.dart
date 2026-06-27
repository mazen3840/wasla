import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affiliatepro_mobile/view/base/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controller/login_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/text.dart';
import '../../base/custom_loader.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class EditProfile extends StatefulWidget {
  var image;
  EditProfile({super.key, required this.image});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final formKey = GlobalKey<FormState>();
  File? _image;

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      img.Image? image = img.decodeImage(file.readAsBytesSync());
      img.Image resizedImage = img.copyResize(image!, width: 128, height: 128);
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Get.find<LoginController>();
    return GetBuilder<LoginController>(builder: (loginController) {
      return Scaffold(
        backgroundColor: AppColor.dashboardBgColor,
        appBar: AppBar(
          foregroundColor: AppColor.appWhite,
          backgroundColor: AppColor.appPrimary,
          toolbarHeight: height * 0.08,
          centerTitle: true,
          title: Text(
            AppText.editProfile,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Form(
              // Add Form
              key: formKey,
              child: ListView(
                children: [
                  SizedBox(height: height * 0.022),
                  SizedBox(height: height * 0.012),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : NetworkImage(widget.image) as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _getImageFromGallery,
                            child: CircleAvatar(
                              backgroundColor: AppColor.appPrimary,
                              radius: 16,
                              child: const Icon(Icons.edit, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Text(
                    AppText.EditAccount,
                    style: TextStyle(
                      fontSize: height * 0.03,
                      fontWeight: FontWeight.bold,
                      color: AppColor.appPrimary,
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  CustomTextField(
                    textEditingController: loginController.firstNameController,
                    hintText: AppText.fName,
                    textInputType: TextInputType.name,
                    type: 1,
                  ),
                  SizedBox(height: height * 0.03),
                  CustomTextField(
                    textEditingController: loginController.lastNameController,
                    hintText: AppText.lName,
                    textInputType: TextInputType.name,
                    type: 1,
                  ),
                  SizedBox(height: height * 0.03),
                  CustomTextField(
                    textEditingController: loginController.emailController,
                    hintText: AppText.email,
                    type: 1,
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: height * 0.03),
                  CustomTextField(
                    textEditingController:
                        loginController.phoneNumberController,
                    hintText: AppText.pNumber,
                    type: 1,
                    textInputType: TextInputType.phone,
                  ),
                  SizedBox(height: height * 0.025),
                  CustomTextField(
                    textEditingController: loginController.userNameController,
                    hintText: AppText.userName,
                    type: 1,
                    textInputType: TextInputType.name,
                    readOnly: true,
                  ),

                  SizedBox(height: height * 0.025),
                  CustomTextField(
                    textEditingController: loginController.passwordController,
                    hintText: AppText.password,
                    obscureText: true,
                    type: 1,
                  ),
                  SizedBox(height: height * 0.045),
                  SizedBox(
                    width: double.infinity,
                    child: loginController.isLoading
                        ? const Center(child: CustomLoader())
                        : ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                loginController.updateProfile(context,
                                    imageFile: _image);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.appPrimary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(AppText.edit,
                                style: TextStyle(
                                    fontSize: width * 0.042,
                                    color: AppColor.appWhite)),
                          ),
                  ),
                  SizedBox(height: height * 0.025),
                  SizedBox(height: height * 0.022),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
