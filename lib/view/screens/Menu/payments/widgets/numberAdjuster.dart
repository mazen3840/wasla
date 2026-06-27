import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controller/Payments_controller.dart';
import '../../../../../utils/colors.dart';

class NumberAdjuster extends StatefulWidget {
  PaymentsController paymentsController;

  NumberAdjuster({super.key, required this.paymentsController});

  @override
  _NumberAdjusterState createState() => _NumberAdjusterState();
}

class _NumberAdjusterState extends State<NumberAdjuster> {
  void _showAdjustDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(title),
          // content:
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // if (title == 'Page Number') {
                //   currentPage = newValue;
                // } else if (title == 'Items Per Page') {
                //   itemsPerPage = newValue;
                // }
                // widget.onValuesChanged(currentPage, itemsPerPage);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    showbottomSheet(PaymentsController PaymentsController) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColor.appWhite,
              ),
              height: width * 0.7,
              child: Center(
                  child: DialogScreen(
                paymentsController: PaymentsController,
              )),
            ),
          );
        },
      );
    }

    return GetBuilder<PaymentsController>(builder: (PaymentsController) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                showbottomSheet(PaymentsController);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  itemList(width, 'Page Number:',
                      PaymentsController.pageIdd.toString()),
                  itemList(width, 'Items Per Page:',
                      PaymentsController.perPagee.toString()),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget itemList(width, text1, text2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: TextStyle(
                fontFamily: 'Poppin',
                fontSize: width * 0.03,
                color: AppColor.appPrimary,
                fontWeight: FontWeight.w300),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.appSuperPrimaryLight,
                borderRadius: BorderRadius.circular(width * 0.01),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Text(
                  text2,
                  style: TextStyle(
                      fontFamily: 'Poppin',
                      fontSize: width * 0.03,
                      color: AppColor.appPrimary,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DialogScreen extends StatefulWidget {
  PaymentsController paymentsController;

  DialogScreen({super.key, required this.paymentsController});

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  late int pageId;
  late int itemsPerPage;

  @override
  void initState() {
    super.initState();

    pageId = widget.paymentsController.pageIdd;
    itemsPerPage = widget.paymentsController.perPagee;
  }

  refresh(int pageIdNew, int perPageNew) {
    Get.find<PaymentsController>()
        .updatePageIdandPerPage(pageIdNew, perPageNew);
    Get.find<PaymentsController>().getPaymentsData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Page Number',
            style: TextStyle(
                fontFamily: 'Poppin',
                fontSize: 25,
                color: AppColor.appPrimary,
                fontWeight: FontWeight.w300),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (pageId > 0) {
                      pageId--;
                    }
                  });
                },
              ),
              Text(pageId.toString()),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    pageId++;
                  });
                },
              ),
            ],
          ),
          const Text(
            'Items Per Page',
            style: TextStyle(
                fontFamily: 'Poppin',
                fontSize: 25,
                color: AppColor.appPrimary,
                fontWeight: FontWeight.w300),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (itemsPerPage > 0) {
                      itemsPerPage--;
                    }
                  });
                },
              ),
              Text(itemsPerPage.toString()),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    itemsPerPage++;
                  });
                },
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              refresh(pageId, itemsPerPage);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
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
                  color: AppColor.appPrimaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontFamily: 'Poppin',
                        fontSize: 25,
                        color: AppColor.appWhite,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
