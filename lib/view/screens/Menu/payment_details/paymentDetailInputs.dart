import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/payments_detail_controller.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/text.dart';

class PaymentDetailInputs extends StatefulWidget {
  PaymentDetailController paymentDetailController;
  PaymentDetailInputs({super.key, required this.paymentDetailController});

  @override
  State<PaymentDetailInputs> createState() => _PaymentDetailInputsState();
}

class _PaymentDetailInputsState extends State<PaymentDetailInputs> {
  TextEditingController bankName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController accountName = TextEditingController();
  TextEditingController paypalEmail = TextEditingController();
  TextEditingController countrySpecificFieldController = TextEditingController();

  GlobalKey<FormState> formKeyBankDetails = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyAddPaypal = GlobalKey<FormState>();

  String selectedOption1 = 'bank_transfer';
  String selectedCountry = '';
  List<String> availableCountries = [];
  List<String> options1 = ['bank_transfer', 'paypal'];

  // Map for country-specific field labels
  Map<String, String> countrySpecificFieldLabels = {
    'US': 'Routing Number',
    'IN': 'IFSC Code',
    'GB': 'Sort Code',
    'AU': 'BSB Number',
    'CA': 'Transit/Institution Number',
    'DE': 'IBAN/BIC',
    'CN': 'CNAPS Code',
    'SG': 'SWIFT Code',
    'HK': 'Clearing Code',
    'NZ': 'Bank Branch Number',
  };

  // Map for country-specific field keys (matching backend)
  Map<String, String> countrySpecificFieldKeys = {
    'US': 'payment_routing_number',
    'IN': 'payment_ifsc_code',
    'GB': 'payment_sort_code',
    'AU': 'payment_bsb_number',
    'CA': 'payment_transit_institution_number',
    'DE': 'payment_iban_bic',
    'CN': 'payment_cnaps_code',
    'SG': 'payment_swift_code',
    'HK': 'payment_clearing_code',
    'NZ': 'payment_bank_branch_number',
  };

  @override
  void dispose() {
    bankName.dispose();
    accountName.dispose();
    accountNumber.dispose();
    paypalEmail.dispose();
    countrySpecificFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var data = widget.paymentDetailController.PaymentDetailData!.data;
    setState(() {
      bankName.text = data.paymentList.paymentBankName;
      accountNumber.text = data.paymentList.paymentAccountNumber;
      accountName.text = data.paymentList.paymentAccountName;
      paypalEmail.text = data.paypalAccounts.paypalEmail;
      selectedOption1 = data.primaryPaymentMethod == 'bank_transfer'
          ? 'bank_transfer'
          : 'paypal';
      selectedCountry = data.paymentList.paymentCountry;
      availableCountries = data.availableCountries;

      // Set the country-specific field if it exists
      if (selectedCountry.isNotEmpty && countrySpecificFieldKeys.containsKey(selectedCountry)) {
        String fieldKey = countrySpecificFieldKeys[selectedCountry]!;
        // Get the value dynamically based on the field name
        String? value;

        switch(fieldKey) {
          case 'payment_routing_number':
            value = data.paymentList.paymentRoutingNumber;
            break;
          case 'payment_ifsc_code':
            value = data.paymentList.paymentIfscCode;
            break;
          case 'payment_sort_code':
            value = data.paymentList.paymentSortCode;
            break;
          case 'payment_bsb_number':
            value = data.paymentList.paymentBsbNumber;
            break;
          case 'payment_transit_institution_number':
            value = data.paymentList.paymentTransitInstitutionNumber;
            break;
          case 'payment_iban_bic':
            value = data.paymentList.paymentIbanBic;
            break;
          case 'payment_cnaps_code':
            value = data.paymentList.paymentCnapsCode;
            break;
          case 'payment_swift_code':
            value = data.paymentList.paymentSwiftCode;
            break;
          case 'payment_clearing_code':
            value = data.paymentList.paymentClearingCode;
            break;
          case 'payment_bank_branch_number':
            value = data.paymentList.paymentBankBranchNumber;
            break;
        }

        if (value != null) {
          countrySpecificFieldController.text = value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: _boxDecoration(),
            child: Form(
              key: formKeyBankDetails,
              child: Column(
                children: [
                  _titleText(AppText.bankDetails),
                  _textField(AppText.bankName, bankName),
                  _textField(AppText.accountNumber, accountNumber),
                  _textField(AppText.accountName, accountName),

                  // Country Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                    child: DropdownButtonFormField<String>(
                      decoration: _dropdownDecoration('Select Country'),
                      value: selectedCountry.isNotEmpty ? selectedCountry : null,
                      items: availableCountries.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCountry = value!;

                          // Load the saved country-specific field value (if exists)
                          if (countrySpecificFieldKeys.containsKey(selectedCountry)) {
                            String fieldKey = countrySpecificFieldKeys[selectedCountry]!;
                            var data = widget.paymentDetailController.PaymentDetailData!.data;
                            String? value;

                            switch (fieldKey) {
                              case 'payment_routing_number':
                                value = data.paymentList.paymentRoutingNumber;
                                break;
                              case 'payment_ifsc_code':
                                value = data.paymentList.paymentIfscCode;
                                break;
                              case 'payment_sort_code':
                                value = data.paymentList.paymentSortCode;
                                break;
                              case 'payment_bsb_number':
                                value = data.paymentList.paymentBsbNumber;
                                break;
                              case 'payment_transit_institution_number':
                                value = data.paymentList.paymentTransitInstitutionNumber;
                                break;
                              case 'payment_iban_bic':
                                value = data.paymentList.paymentIbanBic;
                                break;
                              case 'payment_cnaps_code':
                                value = data.paymentList.paymentCnapsCode;
                                break;
                              case 'payment_swift_code':
                                value = data.paymentList.paymentSwiftCode;
                                break;
                              case 'payment_clearing_code':
                                value = data.paymentList.paymentClearingCode;
                                break;
                              case 'payment_bank_branch_number':
                                value = data.paymentList.paymentBankBranchNumber;
                                break;
                            }

                            countrySpecificFieldController.text = value ?? '';
                          } else {
                            countrySpecificFieldController.clear();
                          }
                        });
                      },
                      validator: (value) =>
                      (value == null || value.isEmpty) ? 'Country is required' : null,
                    ),
                  ),

                  // Dynamic country-specific field
                  if (selectedCountry.isNotEmpty && countrySpecificFieldLabels.containsKey(selectedCountry))
                    _textField(
                      countrySpecificFieldLabels[selectedCountry]!,
                      countrySpecificFieldController,
                    ),

                  GestureDetector(
                    onTap: () {
                      if (formKeyBankDetails.currentState!.validate()) {
                        // Create country-specific fields map
                        Map<String, String> countrySpecificFields = <String, String>{};

                        if (selectedCountry.isNotEmpty &&
                            countrySpecificFieldKeys.containsKey(selectedCountry) &&
                            countrySpecificFieldController.text.isNotEmpty) {
                          countrySpecificFields[countrySpecificFieldKeys[selectedCountry]!] =
                              countrySpecificFieldController.text;
                        }

                        Get.find<PaymentDetailController>().addBankAccount(
                          bankName.text,
                          accountNumber.text,
                          accountName.text,
                          selectedCountry,
                          countrySpecificFields,
                        );
                      }
                    },
                    child: CustomButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: _boxDecoration(),
            child: Form(
              key: formKeyAddPaypal,
              child: Column(
                children: [
                  _titleText(AppText.addPaypalAccount),
                  _textField(AppText.paypalEmail, paypalEmail),
                  GestureDetector(
                    onTap: () {
                      if (formKeyAddPaypal.currentState!.validate()) {
                        Get.find<PaymentDetailController>().addPaypalAccount(paypalEmail.text);
                      }
                    },
                    child: CustomButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: _boxDecoration(),
            child: Column(
              children: [
                _titleText(AppText.primaryPaymentMethod),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButtonFormField<String>(
                    decoration: _dropdownDecoration('Select Method'),
                    value: selectedOption1,
                    items: options1.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(convertSnakeCaseToTitleCase(value)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedOption1 = newValue!;
                      });
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.find<PaymentDetailController>().addPrimaryPaymentMethod(selectedOption1);
                  },
                  child: CustomButton(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleText(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Text(
      title,
      style: const TextStyle(
        color: AppColor.appPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _textField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColor.appPrimary)),
          Container(
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.appWhite, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) =>
              (value == null || value.isEmpty) ? 'This field is required' : null,
              style: const TextStyle(color: AppColor.appBlack),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _dropdownDecoration(String hint) => InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
    filled: true,
    fillColor: Colors.grey.withOpacity(0.2),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: AppColor.appWhite),
    ),
    hintText: hint,
  );

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: AppColor.appPrimaryLight,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(
        color: AppColor.appWhite,
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(-3, -3),
      ),
      BoxShadow(
        color: AppColor.appShadow,
        spreadRadius: 2,
        blurRadius: 3,
        offset: Offset(3, 4),
      ),
    ],
  );

  String convertSnakeCaseToTitleCase(String input) {
    return input
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Widget CustomButton() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    child: Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: AppColor.appPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColor.appWhite,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(-3, -3),
          ),
          BoxShadow(
            color: AppColor.appShadow,
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(3, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Submit',
          style: TextStyle(
            fontFamily: 'Poppin',
            fontSize: 20,
            color: AppColor.appWhite,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    ),
  );
}