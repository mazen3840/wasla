import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../model/bannerAndLinks_model.dart';
import '../../../../utils/colors.dart';
import "package:share_plus/share_plus.dart";
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
// import 'package:qr_flutter/qr_flutter.dart';

class ImageWidget extends StatelessWidget {
  String image;
  var width;
  BannerData data;
  ImageWidget(
      {super.key,
        required this.image,
        required this.width,
        required this.data});

  Future<void> share() async {
    await Share.share(
      data.share_url,
      subject: 'Share Item',
    );
  }

  @override
  Widget build(BuildContext context) {
    showbottomSheet() {
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
              height: width * 2,
              child: Center(
                child: SizedBox(
                  height: width,
                  child: SfBarcodeGenerator(
                    value: data.share_url,
                    symbology: QRCode(),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return SizedBox(
      width: width / 2.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            //image
            width: width / 2.2,
            height: width / 3.5,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            child: image != ''
                ? ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: image,
                progressIndicatorBuilder:
                    (context, url, downloadProgress) => Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.grey[300]!),
                        value: downloadProgress.progress),
                  ),
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
              ),
            )
                : Center(
              child: Icon(
                Icons.image,
                size: 10,
                color: Colors.grey[400],
              ),
            ),
          ),
          SizedBox(
            height: width * 0.04,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  showbottomSheet();
                },
                child: Container(
                  height: width * 0.20,
                  width: width * 0.20,
                  padding: EdgeInsets.all(width * 0.04),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 194, 161, 255),
                    borderRadius: BorderRadius.circular(width * 0.06),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.appWhite,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(-3, -3),
                      ),
                      BoxShadow(
                        color: Color.fromARGB(255, 170, 121, 255),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(3, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.qr_code_2_rounded),
                ),
              ),
              GestureDetector(
                onTap: () {
                  share();
                },
                child: Container(
                  height: width * 0.20,
                  width: width * 0.20,
                  padding: EdgeInsets.all(width * 0.04),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 194, 161, 255),
                    borderRadius: BorderRadius.circular(width * 0.06),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.appWhite,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(-3, -3),
                      ),
                      BoxShadow(
                        color: Color.fromARGB(255, 170, 121, 255),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(3, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.share_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}