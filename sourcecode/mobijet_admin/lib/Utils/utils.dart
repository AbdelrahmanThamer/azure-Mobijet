import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';

class Utils {
  static Future<int> getNTPOffset() {
    return NTP.getNtpOffset();
  }

  static void toast(String message) {
    unawaited(Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black87,
        textColor: Colors.white));
  }

  static void errortoast(String message) {
    unawaited(Fluttertoast.showToast(
        msg: message, backgroundColor: Colors.red, textColor: Colors.white));
  }

  static Widget getNTPWrappedWidget(Widget child) {
    return FutureBuilder(
        future: NTP.getNtpOffset(),
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data! > Duration(minutes: 1).inMilliseconds ||
                snapshot.data! < -Duration(minutes: 1).inMilliseconds)
              return Material(
                  color: Colors.white,
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            "Your device clock time is out of sync with the server time. Please set it right to continue.",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 18),
                          ))));
          }
          return child;
        });
  }

  static bool isValidPassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static Color randomColorgenratorBasedOnFirstLetter(String fullstring) {
    String firstletter = fullstring.trim().length < 2
        ? fullstring
        : fullstring.trim().substring(0, 1);
    firstletter = firstletter == "" ? firstletter : firstletter.toLowerCase();

    switch (firstletter) {
      case "a":
        {
          return Mycolors.red;
        }

      case "b":
        {
          return Mycolors.blue;
        }
      case "c":
        {
          return Mycolors.purple;
        }
      case "d":
        {
          return Mycolors.green;
        }
      case "e":
        {
          return Mycolors.orange;
        }
      case "f":
        {
          return Mycolors.cyan;
        }
      case "g":
        {
          return Mycolors.pink;
        }
      case "h":
        {
          return Mycolors.orange;
        }
      case "i":
        {
          return Mycolors.green;
        }
      case "j":
        {
          return Mycolors.yellow;
        }

      case "k":
        {
          return Mycolors.blue;
        }
      case "l":
        {
          return Mycolors.purple;
        }
      case "m":
        {
          return Mycolors.green;
        }
      case "n":
        {
          return Mycolors.pink;
        }
      case "o":
        {
          return Mycolors.cyan;
        }
      case "p":
        {
          return Mycolors.red;
        }
      case "q":
        {
          return Mycolors.pink;
        }
      case "r":
        {
          return Mycolors.yellow;
        }
      case "s":
        {
          return Mycolors.orange;
        }

      case "t":
        {
          return Mycolors.blue;
        }
      case "u":
        {
          return Mycolors.red;
        }
      case "v":
        {
          return Mycolors.green;
        }
      case "w":
        {
          return Mycolors.blue;
        }
      case "x":
        {
          return Mycolors.cyan;
        }
      case "y":
        {
          return Mycolors.pink;
        }
      case "z":
        {
          return Mycolors.orange;
        }

      default:
        {
          return Mycolors.primary;
        }
    }
  }

  static String getInitials(String string) => string.isNotEmpty
      ? string.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';

  static Future<bool> checkAndRequestPermission(Permission permission) {
    Completer<bool> completer = new Completer<bool>();
    permission.request().then((status) {
      if (status != PermissionStatus.granted) {
        permission.request().then((_status) {
          bool granted = _status == PermissionStatus.granted;
          completer.complete(granted);
        });
      } else
        completer.complete(true);
    });
    return completer.future;
  }

  static squareAvatarIcon(
      {required Color backgroundColor,
      required IconData iconData,
      Color? iconColor,
      double? radius,
      required double size}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 10.0), //or 15.0
      child: Container(
        height: size,
        width: size,
        color: backgroundColor,
        child: Icon(iconData, color: Colors.white, size: size / 2),
      ),
    );
  }

  static squareAvatarImage(
      {Color? backgroundColor,
      required String url,
      double? radius,
      required double size}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 10.0), //or 15.0
      child: Container(
        height: size,
        width: size,
        color: backgroundColor ?? Colors.transparent,
        child: CachedNetworkImage(
          placeholder: (context, url) => Container(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey[400]!),
            ),
            width: size,
            height: size,
            padding: EdgeInsets.all(size / 2),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.all(
                Radius.circular(0.0),
              ),
            ),
          ),
          errorWidget: (context, str, error) => Material(
            child: Image.asset(
              'assets/COMMON_ASSETS/img_not_available.jpeg',
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(0.0),
            ),
            clipBehavior: Clip.hardEdge,
          ),
          imageUrl: url,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
        //  Icon(iconData, color: Colors.white, size: size / 2),
      ),
    );
  }

  static sendDirectNotification(
      {required String title,
      required String parentID,
      required String plaindesc,
      String? styleddesc,
      required DocumentReference docRef,
      String? imageurl = "",
      required String postedbyID,
      bool? isOnlyAlertNoSave = false}) async {
    await docRef.set({
      Dbkeys.nOTIFICATIONxxtitle: title,
      Dbkeys.nOTIFICATIONxxdesc: plaindesc,
      Dbkeys.nOTIFICATIONxxlastupdateepoch:
          DateTime.now().millisecondsSinceEpoch,
      Dbkeys.nOTIFICATIONxxaction: Dbkeys.nOTIFICATIONactionPUSH,
      Dbkeys.list: FieldValue.arrayUnion([
        {
          Dbkeys.docid: DateTime.now().millisecondsSinceEpoch.toString(),
          Dbkeys.nOTIFICATIONxxdesc: styleddesc ?? plaindesc,
          Dbkeys.nOTIFICATIONxxtitle: title,
          Dbkeys.nOTIFICATIONxximageurl: imageurl,
          Dbkeys.nOTIFICATIONxxlastupdateepoch:
              DateTime.now().millisecondsSinceEpoch,
          Dbkeys.nOTIFICATIONxxauthor: postedbyID,
          Dbkeys.nOTIFICATIONxxextrafield: parentID
        }
      ])
    }, SetOptions(merge: true));
  }

  static String getboolText(bool val) {
    if (val == true) {
      return "ON";
    } else {
      return "OFF";
    }
  }

  static String getCallValueText(int val) {
    if (val == CallType.audio.index) {
      return "Audio";
    } else if (val == CallType.video.index) {
      return "Video";
    } else {
      return "Both";
    }
  }
}
