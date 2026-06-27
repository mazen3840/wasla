import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/wallet_controller.dart';
import '../../../../utils/colors.dart';

class FilterWidget extends StatefulWidget {
  final String parameter1;
  final String parameter2;
  final List<String> options1;
  final List<String> options2;
  final Function(String, String) onFilterChanged;
  final WalletController controller;

  const FilterWidget(
      {super.key, required this.parameter1,
      required this.parameter2,
      required this.options1,
      required this.options2,
      required this.onFilterChanged,
      required this.controller});

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String selectedOption1 = 'paid';
  String selectedOption2 = 'actions';
  updatePaid(
    String? paidStatus,
  ) {
    Get.find<WalletController>().updateActionAndPaid(paidStatus:paidStatus);
  }
  updatetype(
    String? type,
  ) {
    Get.find<WalletController>().updateActionAndPaid(type:type);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColor.appPrimaryLight,
            borderRadius: BorderRadius.circular(width * 0.01),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DropdownButton<String>(
              icon:
                  const Icon(Icons.arrow_drop_down, color: AppColor.appPrimary),
              underline: Container(),
              style: TextStyle(
                  fontFamily: 'Poppin',
                  fontSize: width * 0.04,
                  color: AppColor.appPrimary,
                  fontWeight: FontWeight.w800),
              dropdownColor: AppColor.appSuperPrimaryLight,
              focusColor: AppColor.appPrimary,
              borderRadius: BorderRadius.circular(15),
              value: widget.controller.paid,
              onChanged: (newValue) {
                setState(() {
                  selectedOption1 = newValue!;
                  widget.onFilterChanged(newValue, widget.controller.action);
                });
              },
              items:
                  widget.options1.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(convertSnakeCaseToTitleCase(value)),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColor.appPrimaryLight,
            borderRadius: BorderRadius.circular(width * 0.01),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DropdownButton<String>(
              icon:
                  const Icon(Icons.arrow_drop_down, color: AppColor.appPrimary),
              underline: Container(),
              style: TextStyle(
                  fontFamily: 'Poppin',
                  fontSize: width * 0.04,
                  color: AppColor.appPrimary,
                  fontWeight: FontWeight.w800),
              dropdownColor: AppColor.appSuperPrimaryLight,
              focusColor: AppColor.appPrimary,
              borderRadius: BorderRadius.circular(15),
              value: widget.controller.action,
              onChanged: (newValue) {
                setState(() {
                  selectedOption2 = newValue!;
                  widget.onFilterChanged(widget.controller.paid, newValue);
                });
              },
              items:
                  widget.options2.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(convertSnakeCaseToTitleCase(value)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

 String convertSnakeCaseToTitleCase(String input) {
  if (input.isEmpty) return 'None';

  List<String> words = input.split('_');
  List<String> capitalizedWords = [];

  for (String word in words) {
    String capitalizedWord = word[0].toUpperCase() + word.substring(1);
    capitalizedWords.add(capitalizedWord);
  }

  return capitalizedWords.join(' ');
}
}
