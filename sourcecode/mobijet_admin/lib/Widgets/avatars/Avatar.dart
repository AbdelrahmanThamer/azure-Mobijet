import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';

Widget avatar(
    {String? imageUrl, double radius = 22.5, String? backgroundColor}) {
  if (imageUrl == null || imageUrl == "") {
    return CircleAvatar(
      backgroundColor: Mycolors.backgroundcolor,
      backgroundImage:
          Image.network(AppConstants.defaultprofilepicfromnetworklink).image,
      radius: radius,
    );
  }
  return CircleAvatar(
      backgroundColor: Mycolors.backgroundcolor,
      backgroundImage: Image.network(imageUrl).image,
      radius: radius);
}
