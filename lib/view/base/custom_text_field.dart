import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // Add this import
import '../../utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final int? maxLines;
  final String? hintText;
  final bool? obscureText;
  int? type;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;

  CustomTextField({
    super.key,
    required this.textEditingController,
    this.maxLines,
    this.obscureText,
    this.textInputType,
    required this.type,
    this.hintText = 'Describe your post',
    this.validator,
    this.inputFormatters,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter>? formatters = inputFormatters;
    if (textInputType == TextInputType.phone) {
      formatters = [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9\s\-+()]')),
      ];
    }

    String? defaultValidator(String? value) {
      if (textInputType == TextInputType.phone) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required';
        }
        String digitsOnly = value.replaceAll(RegExp(r'[\s\-+()]'), '');
        if (digitsOnly.length < 10) {
          return 'Phone number must be at least 10 digits';
        }
        if (digitsOnly.length > 15) {
          return 'Phone number is too long';
        }
        String pattern = r'^\+?[0-9\s-()]+$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
      }
      return null;
    }

    return Container(
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColor.appWhite, width: 1)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        maxLines: maxLines ?? 1,
        obscureText: obscureText ?? false,
        controller: textEditingController,
        keyboardType: textInputType,
        inputFormatters: formatters,
        readOnly: readOnly,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          border: InputBorder.none,
          counterStyle: const TextStyle(fontSize: 0),
          hintText: hintText,
          errorStyle: TextStyle(color: Colors.blue),
          hintStyle: TextStyle(
            color: type == 2
                ? AppColor.appWhite.withOpacity(0.5)
                : AppColor.appGrey.withOpacity(0.5),
          ),
        ),
        validator: validator ?? defaultValidator,
        style: const TextStyle(color: AppColor.appBlack),
      ),
    );
  }
}