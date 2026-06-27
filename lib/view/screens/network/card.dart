import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';
import '../../../model/network_model.dart';

class NetworkCard extends StatelessWidget {
  Userslist data;
  NetworkCard({super.key, required this.data});
  splitName(String name, int part) {
    int idx = name.indexOf("<");
    int idx2 = name.indexOf("src='");
    int idx3 = name.indexOf("'>");
    List parts = [
      name.substring(0, idx).trim(),
      name.substring(idx2 + 5, idx3).trim(),
    ];
    print('Image link: ' + parts[1]);
    return part == 1 ? parts[0] : parts[1];
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // height: width * 0.5,
          // width:  width / 3.3,

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
            color:AppColor.appPrimaryLight,
            borderRadius: BorderRadius.circular(width * 0.04),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: width * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  splitName(data.name, 1),
                  style: TextStyle(
                      fontFamily: 'Poppin',
                      fontSize: width * 0.03,
                      color: AppColor.appPrimary,
                      fontWeight: FontWeight.w800),
                ),
                Container(
                  //image
                  width: width / 7.5,
                  height: width / 7.5,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: splitName(data.name, 2) != ''
                      ? ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: splitName(data.name, 2),
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
