//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Utils/color_light_dark.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

Widget warningTile(
    {required String title,
    required int warningTypeIndex,
    bool? isbold = false,
    bool? isstyledtext = false,
    bool? marginnarrow = false}) {
  Color backupColor = warningTypeIndex == WarningType.success.index
      ? Colors.green
      : warningTypeIndex == WarningType.error.index
          ? Colors.red
          : warningTypeIndex == WarningType.alert.index
              ? Colors.orange
              : Colors.blue;
  Color bgColor = warningTypeIndex == WarningType.success.index
      ? lighten(Colors.green, .43)
      : warningTypeIndex == WarningType.error.index
          ? lighten(Colors.red, .38)
          : warningTypeIndex == WarningType.alert.index
              ? lighten(Colors.orange, .48)
              : lighten(Colors.blue, .48);

  IconData iconData = warningTypeIndex == WarningType.success.index
      ? Icons.check_circle_outline
      : warningTypeIndex == WarningType.error.index
          ? Icons.error_outline
          : warningTypeIndex == WarningType.alert.index
              ? Icons.lightbulb
              : Icons.lightbulb;
  return Container(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: EdgeInsets.all(marginnarrow == true ? 1 : 10),
      child: Card(
        elevation: 0.1,
        color: bgColor,
        child: Container(
            padding: marginnarrow == true
                ? EdgeInsets.all(2)
                : EdgeInsets.fromLTRB(17, 10, 17, 10),
            child: isstyledtext == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.5, right: 9),
                        child: Icon(
                          iconData,
                          color: backupColor,
                          size: 14,
                        ),
                      ),
                      Expanded(
                        child: StyledText(
                          textAlign: TextAlign.start,
                          maxLines: 10,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: backupColor,
                              height: 1.3,
                              fontSize: 11.6,
                              fontWeight: isbold == false
                                  ? FontWeight.w400
                                  : FontWeight.w600),
                          text: title,
                          tags: {
                            'bold': StyledTextTag(
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: backupColor,
                                    height: 1.3,
                                    fontSize: 11.6,
                                    fontWeight: isbold == false
                                        ? FontWeight.w700
                                        : FontWeight.w900)),
                            'italic': StyledTextTag(
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    overflow: TextOverflow.ellipsis,
                                    color: backupColor,
                                    height: 1.3,
                                    fontSize: 11.6,
                                    fontWeight: isbold == false
                                        ? FontWeight.w400
                                        : FontWeight.w600)),
                          },
                        ),
                      ),
                    ],
                  )
                : RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 2.5, right: 6),
                            child: Icon(
                              iconData,
                              color: backupColor,
                              size: 14,
                            ),
                          ),
                        ),
                        TextSpan(
                            text: title,
                            style: TextStyle(
                                color: backupColor,
                                height: 1.3,
                                fontSize: 11.6,
                                fontWeight: isbold == false
                                    ? FontWeight.w400
                                    : FontWeight.w600)),
                      ],
                    ),
                  )),
      ),
    ),
  );
}
