//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/ticket_message.dart';
import 'package:thinkcreative_technologies/Screens/agents/agent_profile_details.dart';
import 'package:thinkcreative_technologies/Screens/customers/customer_profile_details.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/customCircleAvatars.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Widgets/timeWidgets/getwhen.dart';

class TicketBubble extends StatelessWidget {
  const TicketBubble(
      {required this.child,
      required this.timestamp,
      required this.mssg,
      required this.delivered,
      required this.isMe,
      required this.isContinuing,
      required this.messagetype,
      required this.postedbyname,
      // required this.prefs,
      required this.postedbyUID,
      required this.isRobotic,
      required this.isSecretMessage,
      required this.isHideAgentsNameToCustomer,
      required this.customerUID,
      this.savednameifavailable,
      required this.is24hrsFormat});

  final dynamic messagetype;
  final int? timestamp;
  final Widget child;
  final TicketMessage mssg;
  final dynamic delivered;
  final String postedbyname;
  final String postedbyUID;
  final String customerUID;
  final String? savednameifavailable;
  final bool isMe, isContinuing;
  final bool isRobotic, isSecretMessage, isHideAgentsNameToCustomer;
  // final SharedPreferences prefs;
  final bool is24hrsFormat;
  humanReadableTime() => DateFormat(is24hrsFormat == true ? 'HH:mm' : 'h:mm a')
      .format(DateTime.fromMillisecondsSinceEpoch(timestamp!));

  @override
  Widget build(BuildContext context) {
    final bool isCurrentUserIsCustomer = false;
    final bool isMessageSendByCustomer = postedbyUID == customerUID;
    final bg =
        isMessageSendByCustomer == true && isCurrentUserIsCustomer == true
            ? Mycolors.chatBubbleColor
            : !isMessageSendByCustomer && isCurrentUserIsCustomer == true
                ? Colors.white
                : isRobotic == true
                    ? Colors.blueGrey[100]
                    : isSecretMessage == true
                        ? Colors.cyan[50]
                        : isMessageSendByCustomer && !isCurrentUserIsCustomer
                            ? Colors.yellow[50]
                            : Colors.white;
    final align = isCurrentUserIsCustomer == true
        ? (isMe == true ? CrossAxisAlignment.end : CrossAxisAlignment.start)
        : isMessageSendByCustomer
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end;
    dynamic icon = Icons.done;
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
                return Icon((Icons.done), size: 13.0, color: color);
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
      margin = const EdgeInsets.fromLTRB(2, 3, 2, 3);
    }
    var registry = Provider.of<UserRegistry>(context, listen: true);
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: align,
      children: <Widget>[
        SizedBox(
          height: 7,
        ),
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
                  InkWell(
                    onTap: () {
                      // hidekeyboard(context);
                      // Navigator.push(
                      //     context,
                      //     new MaterialPageRoute(
                      //         builder: (context) =>
                      //             new ProfileView(
                      //                 snapshot.data
                      //                     .data(),
                      //                 currentUserNo,
                      //                 model,
                      //                 prefs,
                      //                 firestoreUserDoc:
                      //                     snapshot
                      //                         .data)));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.67,
                      child: isCurrentUserIsCustomer == true &&
                              isHideAgentsNameToCustomer == true
                          ? SizedBox()
                          : isMessageSendByCustomer == true &&
                                  isCurrentUserIsCustomer == true
                              ? SizedBox()
                              : isMessageSendByCustomer &&
                                      !isCurrentUserIsCustomer
                                  ? myinkwell(
                                      onTap: () {
                                        pageNavigator(
                                            context,
                                            CustomerProfileDetails(
                                              customerID: customerUID,
                                              currentuserid: Optionalconstants
                                                  .currentAdminID,
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          customCircleAvatar(
                                              radius: 10,
                                              url: registry
                                                  .getUserData(
                                                      context, postedbyUID)
                                                  .photourl),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Text(
                                            getTranslatedForCurrentUser(
                                                context, 'xxcustomerxx'),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                !isSecretMessage
                                                    ? SizedBox()
                                                    : InkWell(
                                                        onTap: () {
                                                          Utils.toast(
                                                            getTranslatedForCurrentUser(
                                                                    context,
                                                                    'xxonlyvisblexx')
                                                                .replaceAll(
                                                                    '(####)',
                                                                    '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}')
                                                                .replaceAll(
                                                                    '(###)',
                                                                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons
                                                              .visibility_off_rounded,
                                                          size: 15,
                                                          color: Color.alphaBlend(
                                                              Colors.blueGrey,
                                                              bg ??
                                                                  Colors
                                                                      .lightGreen),
                                                        ),
                                                      ),
                                                !isRobotic
                                                    ? SizedBox()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Icon(
                                                          Icons.android_rounded,
                                                          size: 15,
                                                          color: Color.alphaBlend(
                                                              Colors.blueGrey,
                                                              bg ??
                                                                  Colors
                                                                      .lightGreen),
                                                        ),
                                                      ),
                                              ]),
                                          myinkwell(
                                            onTap: () {
                                              pageNavigator(
                                                  context,
                                                  AgentProfileDetails(
                                                    agentID: postedbyUID,
                                                    currentuserid:
                                                        Optionalconstants
                                                            .currentAdminID,
                                                  ));
                                            },
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    isMessageSendByCustomer
                                                        ? getTranslatedForCurrentUser(
                                                            context,
                                                            'xxcustomerxx')
                                                        : postedbyname,
                                                    textAlign: customerUID ==
                                                            postedbyUID
                                                        ? TextAlign.start
                                                        : TextAlign.end,
                                                    style: TextStyle(
                                                        color: customerUID ==
                                                                postedbyUID
                                                            ? Colors.red
                                                            : Color.alphaBlend(
                                                                Colors.blueGrey,
                                                                bg ??
                                                                    Colors
                                                                        .lightGreen),
                                                        fontSize: 13.5,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  customCircleAvatar(
                                                      radius: 10,
                                                      url: registry
                                                          .getUserData(context,
                                                              postedbyUID)
                                                          .photourl)
                                                ]),
                                          ),
                                        ]),
                    ),
                  ),

                  //------

                  SizedBox(
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
                                  right: isMe ? 5.0 : 25.0, bottom: 25),
                      child: isMessageSendByCustomer
                          ? child
                          : Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: child,
                            )),
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
