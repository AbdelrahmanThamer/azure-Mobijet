//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/custom_buttons.dart';

class OpenSettings extends StatefulWidget {
  @override
  State<OpenSettings> createState() => _OpenSettingsState();
}

class _OpenSettingsState extends State<OpenSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Utils.getNTPWrappedWidget(Material(
        color: Mycolors.primary,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                "Neccessary Permission Required to use the app. Please allow the permission.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                "1. Open App Settings.\n\n2. Go to Permissions.\n\n3.Allow permission for the required service.\n\n4. Return to app & reload the page.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: MySimpleButton(
                  buttontext: "OPEN SETTINGS",
                  onpressed: () {
                    openAppSettings();
                  },
                )),
            SizedBox(height: 20),
          ],
        ))));
  }
}
