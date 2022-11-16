//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Definition attached with source code. *********************

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

Future<File?> pickSingleImage(BuildContext context) async {
  final List<AssetEntity>? result = await AssetPicker.pickAssets(
    context,
    pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        pathThumbnailSize: ThumbnailSize.square(84),
        gridCount: 3,
        pageSize: 900,
        requestType: RequestType.image,
        textDelegate: EnglishAssetPickerTextDelegate()),
  );
  if (result != null) {
    return result.first.file;
  }
  return null;
}
