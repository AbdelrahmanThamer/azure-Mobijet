//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Definition attached with source code. *********************

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';

class GalleryDownloader {
  static void saveNetworkVideoInGallery(BuildContext context, String url,
      bool isFurtherOpenFile, String fileName, GlobalKey keyloader) async {
    String path = url + "&ext=.mp4";
    Dialogs.showLoadingDialog(context, keyloader);
    GallerySaver.saveVideo(path).then((success) async {
      if (success == true) {
        Navigator.of(keyloader.currentContext!, rootNavigator: true).pop();

        Utils.toast(
            "$fileName  " + getTranslatedForCurrentUser(context, 'xxsavedxx'));
      } else {
        Navigator.of(keyloader.currentContext!, rootNavigator: true).pop();
        Utils.toast(getTranslatedForCurrentUser(context, 'xxfailedxx'));
      }
    }).catchError((err) {
      Navigator.of(keyloader.currentContext!, rootNavigator: true).pop();
      Utils.toast(err.toString());
    });
  }

  static void saveNetworkImage(BuildContext context, String url,
      bool isFurtherOpenFile, String fileName, GlobalKey keyloader) async {
    // String path =
    //     'https://image.shutterstock.com/image-photo/montreal-canada-july-11-2019-600w-1450023539.jpg';

    String path = url + "&ext=.jpg";
    Dialogs.showLoadingDialog(context, keyloader);
    GallerySaver.saveImage(path, toDcim: true).then((success) async {
      if (success == true) {
        Navigator.of(keyloader.currentContext!, rootNavigator: true).pop();
        Utils.toast(
            "$fileName  " + getTranslatedForCurrentUser(context, 'xxsavedxx'));
      } else {
        Utils.toast(getTranslatedForCurrentUser(context, 'xxfailedxx'));
        Navigator.of(keyloader.currentContext!, rootNavigator: true).pop();
      }
    }).catchError((err) {
      Navigator.of(keyloader.currentContext!, rootNavigator: true).pop();
      Utils.toast(err.toString());
    });
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 18,
                              ),
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Mycolors.loadingindicator),
                              ),
                              SizedBox(
                                width: 23,
                              ),
                              Text(
                                getTranslatedForCurrentUser(
                                    context, 'xxdownloadingxx'),
                                style: TextStyle(color: Colors.black87),
                              )
                            ]),
                      ),
                    )
                  ]));
        });
  }
}
