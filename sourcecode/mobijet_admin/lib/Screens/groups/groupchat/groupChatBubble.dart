//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Screens/agents/agent_profile_details.dart';
import 'package:thinkcreative_technologies/Screens/callHistory/callHistory.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Utils/hide_keyboard.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/timeWidgets/getwhen.dart';

class GroupChatBubble extends StatelessWidget {
  const GroupChatBubble(
      {required this.child,
      required this.isURLtext,
      required this.isdeleted,
      required this.timestamp,
      required this.delivered,
      required this.isMe,
      required this.isContinuing,
      required this.messagetype,
      required this.postedbyname,
      required this.postedbyID,
      this.savednameifavailable,
      required this.is24hrsFormat});
  final dynamic isURLtext;
  final dynamic messagetype;
  final int? timestamp;
  final Widget child;
  final bool isdeleted;
  final dynamic delivered;
  final String postedbyname;
  final String postedbyID;
  final String? savednameifavailable;
  final bool isMe, isContinuing;

  final bool is24hrsFormat;
  humanReadableTime() => DateFormat(is24hrsFormat == true ? 'HH:mm' : 'h:mm a')
      .format(DateTime.fromMillisecondsSinceEpoch(timestamp!));

  @override
  Widget build(BuildContext context) {
    final bg = isMe
        ? Mycolors.backgroundcolor
        : isdeleted
            ? Colors.red[50]
            : Colors.white;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    dynamic icon = Icons.done_all;
    final color = isMe
        ? Mycolors.black.withOpacity(0.5)
        : Mycolors.black.withOpacity(0.5);
    icon = Icon(icon, size: 14.0, color: color);
    if (delivered is Future) {
      icon = FutureBuilder(
          future: delivered,
          builder: (context, res) {
            switch (res.connectionState) {
              case ConnectionState.done:
                return Icon((Icons.done_all), size: 13.0, color: color);
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
              default:
                return Icon(Icons.access_time, size: 13.0, color: color);
            }
          });
    }
    dynamic radius = isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          );
    dynamic margin = const EdgeInsets.only(top: 20.0, bottom: 1.5);
    if (isContinuing) {
      radius = BorderRadius.all(Radius.circular(5.0));
      margin = const EdgeInsets.all(5.9);
    }
    var registry = Provider.of<UserRegistry>(context, listen: true);
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: margin,
          padding: const EdgeInsets.all(8.0),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.67),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: align,
                children: [
                  isMe
                      ? Container(
                          width: 110,
                        )
                      : InkWell(
                          onTap: () {
                            hidekeyboard(context);
                            pageNavigator(
                                context,
                                AgentProfileDetails(
                                  currentuserid: 'Admin',
                                  agentID: postedbyID,
                                ));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.87,
                            padding: EdgeInsets.fromLTRB(2, 2, 7, 7),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customCircleAvatar(
                                    url: registry
                                        .getUserData(context, postedbyID)
                                        .photourl,
                                    radius: 10),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  postedbyname,
                                  style: TextStyle(
                                      color: Utils
                                          .randomColorgenratorBasedOnFirstLetter(
                                              postedbyname),
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                  //------

                  isMe
                      ? Container(
                          height: 0,
                          width: 0,
                        )
                      : SizedBox(
                          height: 10,
                        ),
                  Padding(
                      padding: this.messagetype == null ||
                              this.messagetype == MessageType.location ||
                              this.messagetype == MessageType.image ||
                              this.messagetype == MessageType.video
                          ? child is Container
                              ? EdgeInsets.fromLTRB(0, 0, 0, 27)
                              : EdgeInsets.only(
                                  right:
                                      this.messagetype == MessageType.location
                                          ? 0
                                          : isMe
                                              ? is24hrsFormat == true
                                                  ? 50
                                                  : 65.0
                                              : is24hrsFormat == true
                                                  ? 36
                                                  : 50.0)
                          : child is Container
                              ? EdgeInsets.all(0.0)
                              : EdgeInsets.only(
                                  right: isMe ? 5.0 : 5.0, bottom: 25),
                      child: child),
                ],
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                          getWhen(
                                DateTime.fromMillisecondsSinceEpoch(timestamp!),
                              ) +
                              ', ',
                          style: TextStyle(
                            color: color,
                            fontSize: 11.0,
                          )),
                      Text(
                          ' ' +
                              humanReadableTime().toString() +
                              (isMe ? ' ' : ''),
                          style: TextStyle(
                            color: color,
                            fontSize: 11.0,
                          )),
                      isMe ? icon : SizedBox()
                      // ignore: unnecessary_null_comparison
                    ].where((o) => o != null).toList()),
              ),
            ],
          ),
        )
      ],
    ));
  }

  Color randomColorgenrator(int digit) {
    switch (digit) {
      case 1:
        {
          return Colors.red;
        }

      case 2:
        {
          return Colors.blue;
        }
      case 3:
        {
          return Colors.purple;
        }
      case 4:
        {
          return Colors.green;
        }
      case 5:
        {
          return Colors.orange;
        }
      case 6:
        {
          return Colors.cyan;
        }
      case 7:
        {
          return Colors.pink;
        }
      case 8:
        {
          return Colors.red;
        }
      case 9:
        {
          return Colors.red;
        }

      default:
        {
          return Colors.blue;
        }
    }
  }
}
