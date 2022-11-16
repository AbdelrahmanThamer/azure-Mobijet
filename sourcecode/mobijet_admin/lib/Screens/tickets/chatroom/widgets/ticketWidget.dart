//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Definition attached with source code. *********************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/number_limits.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/customer_model.dart';
import 'package:thinkcreative_technologies/Models/ticket_model.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/ticketStatus.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/customCircleAvatars.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/late_load.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';

Widget ticketWidgetForAgents({
  required BuildContext context,
  required SharedPreferences prefs,
  required Function(String s, String uid) ontap,
  required TicketModel ticket,
  required var ticketdoc,
}) {
  var registry = Provider.of<UserRegistry>(context, listen: true);
  return myinkwell(
    onTap: () {
      final observer = Provider.of<Observer>(context, listen: false);

      ontap(ticket.ticketID, ticket.ticketcustomerID);

      observer.fetchUserAppSettings(context);
    },
    child: Container(
        margin: EdgeInsets.fromLTRB(8, 5, 8, 5),
        decoration: boxDecoration(
          showShadow: false,
          radius: 10,
        ),
        child: Row(children: [
          Container(
            decoration: BoxDecoration(
              color: ticketStatusColorForAgents(ticket.ticketStatus),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
            ),
            height: 125,
            width: 5.9,
          ),
          Container(
            color: (ticket.ticketStatus == TicketStatus.needsAttention.index
                ? Colors.yellow[200]
                : Colors.white),
            width: 0,
          ),
          Expanded(
              child: Container(
            color: (ticket.ticketStatus == TicketStatus.needsAttention.index
                ? Colors.yellow[200]
                : Colors.white),
            padding: EdgeInsets.fromLTRB(12, 8, 18, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: ticket.ticketStatusShort !=
                                TicketStatusShort.active.index
                            ? Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: ticketStatusColorForAgents(
                                            ticket.ticketStatus)
                                        .withOpacity(0.2),
                                    child: customCircleAvatar(
                                        radius: 14,
                                        url: registry
                                            .getUserData(context,
                                                ticket.ticketcustomerID)
                                            .photourl),
                                  ),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Text(
                                      registry
                                          .getUserData(
                                              context, ticket.ticketcustomerID)
                                          .fullname,
                                      style: TextStyle(
                                          fontSize: 11, color: Mycolors.grey)),
                                ],
                              )
                            : streamLoad(
                                stream: FirebaseFirestore.instance
                                    .collection(DbPaths.collectioncustomers)
                                    .doc(ticket.ticketcustomerID)
                                    .snapshots(),
                                placeholder: Container(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            ticketStatusColorForAgents(
                                                    ticket.ticketStatus)
                                                .withOpacity(0.2),
                                        child: customCircleAvatar(
                                            radius: 14,
                                            url: registry
                                                .getUserData(context,
                                                    ticket.ticketcustomerID)
                                                .photourl),
                                      ),
                                      SizedBox(
                                        width: 13,
                                      ),
                                      Text(
                                          registry
                                              .getUserData(context,
                                                  ticket.ticketcustomerID)
                                              .fullname,
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Mycolors.grey)),
                                    ],
                                  ),
                                ),
                                onfetchdone: (map) {
                                  CustomerModel customer =
                                      CustomerModel.fromJson(map);
                                  return Container(
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor:
                                                  ticketStatusColorForAgents(
                                                          ticket.ticketStatus)
                                                      .withOpacity(0.2),
                                              child: customCircleAvatar(
                                                  radius: 14,
                                                  url: registry
                                                      .getUserData(
                                                          context,
                                                          ticket
                                                              .ticketcustomerID)
                                                      .photourl),
                                            ),
                                            customer.lastSeen == true
                                                ? Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    child: CircleAvatar(
                                                      radius: 5,
                                                      backgroundColor:
                                                          Mycolors.onlinetag,
                                                    ))
                                                : SizedBox(),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                            customer.nickname +
                                                " | ${getTranslatedForCurrentUser(context, 'xxidxx')} ${ticket.ticketcustomerID}",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Mycolors.grey)),
                                      ],
                                    ),
                                  );
                                })),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            getonlyTime(
                                context, ticket.ticketlatestTimestampForAgents),
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 30,
                    )
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            LineAwesomeIcons.user_friends,
                            color:
                                ticketStatusColorForAgents(ticket.ticketStatus),
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          MtCustomfontBoldSemi(
                            fontsize: 13,
                            lineheight: 1.4,
                            color: Mycolors.black,
                            text: '${ticket.tktMEMBERSactiveList.length}',
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            LineAwesomeIcons.tag,
                            color:
                                ticketStatusColorForAgents(ticket.ticketStatus),
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text('${ticket.ticketDepartmentID}',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Mycolors.secondary)),
                        ],
                      ),
                    ),
                    Container(
                      width: 70,
                      child: Center(
                        child: Text(
                          ticketStatusTextShortForAgents(
                              context, ticket.ticketStatus),
                          style: TextStyle(
                              color: ticketStatusColorForAgents(
                                  ticket.ticketStatus),
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ticketStatusColorForAgents(ticket.ticketStatus)
                            .withOpacity(0.2),
                      ),
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
          ))
        ])),
  );
}

BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.grey,
    Color bgColor = Colors.white,
    var showShadow = false}) {
  return BoxDecoration(
      color: bgColor,
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      boxShadow: showShadow == true
          ? [
              BoxShadow(
                  color: Color(0xfff1f4fb).withOpacity(0.4),
                  blurRadius: 0.5,
                  spreadRadius: 1)
            ]
          : [BoxShadow(color: bgColor)],
      border: showShadow == true
          ? Border.all(
              color: Color(0xfff1f4fb).withOpacity(0.99),
              style: BorderStyle.solid,
              width: 0)
          : null,
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

getonlyTime(BuildContext context, int millisecondsepoch) {
  DateTime now = DateTime.now();
  DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsepoch);
  String when;
  if (date.day == now.day)
    // when = getTranslated(context, 'today');
    when = Jiffy(date).Hm.toString();
  else if (date.day == now.subtract(Duration(days: 1)).day)
    when = getTranslatedForCurrentUser(context, 'xxyesterdayxx');
  else
    when = DateFormat.MMMd().format(date);
  return when;
}

Widget ticketWidgetForCustomers(
    {required BuildContext context,
    required SharedPreferences prefs,
    required Function(String s, String uid) ontap,
    required TicketModel ticket,
    required var ticketdoc,
    required String currentUserID,
    required bool customerCanAgentOnline}) {
  return myinkwell(
    onTap: () {
      final observer = Provider.of<Observer>(context, listen: false);

      ontap(ticket.ticketID, ticket.ticketcustomerID);
      observer.fetchUserAppSettings(context);
    },
    child: Container(
        margin: EdgeInsets.fromLTRB(8, 5, 8, 5),
        decoration: boxDecoration(
          showShadow: false,
          radius: 10,
        ),
        child: Row(children: [
          Container(
            decoration: BoxDecoration(
              color: ticket.ticketcustomerID == currentUserID
                  ? ticketStatusColorForCustomers(ticket.ticketStatus)
                  : ticketStatusColorForAgents(ticket.ticketStatus),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
            ),
            height: 125,
            width: 5.9,
          ),
          Container(
            color: (ticket.ticketStatus == TicketStatus.needsAttention.index &&
                        currentUserID != ticket.ticketcustomerID
                    ? Colors.yellow[200]
                    : Colors.white) ??
                Colors.white,
            width: 0,
          ),
          Expanded(
              child: Container(
            color: (ticket.ticketStatus == TicketStatus.needsAttention.index &&
                        currentUserID != ticket.ticketcustomerID
                    ? Colors.yellow[200]
                    : Colors.white) ??
                Colors.white,
            padding: EdgeInsets.fromLTRB(12, 8, 18, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  ticket.ticketcustomerID == currentUserID
                                      ? ticketStatusColorForCustomers(
                                              ticket.ticketStatus)
                                          .withOpacity(0.2)
                                      : ticketStatusColorForAgents(
                                              ticket.ticketStatus)
                                          .withOpacity(0.2),
                              child: Icon(
                                LineAwesomeIcons.alternate_ticket,
                                size: 14,
                                color: ticket.ticketcustomerID == currentUserID
                                    ? ticketStatusColorForCustomers(
                                        ticket.ticketStatus)
                                    : ticketStatusColorForAgents(
                                        ticket.ticketStatus),
                              ),
                            ),
                            ticket.liveAgentID == "" ||
                                    ticket.liveAgentLastonline == 0 ||
                                    // customerCanAgentOnline == false ||
                                    ticket.ticketStatusShort ==
                                        TicketStatusShort.close.index ||
                                    ticket.ticketStatusShort ==
                                        TicketStatusShort.expired.index ||
                                    ticket.ticketStatusShort ==
                                        TicketStatusShort.notstarted.index
                                ? SizedBox()
                                : DateTime.now()
                                            .difference(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    ticket
                                                        .liveAgentLastonline!))
                                            .inMinutes >
                                        Numberlimits
                                            .maxOnlineDurationShowForAgent
                                    ? SizedBox()
                                    : streamLoad(
                                        stream: FirebaseFirestore.instance
                                            .collection(
                                                DbPaths.collectionagents)
                                            .doc(ticket.liveAgentID!.trim())
                                            .snapshots(),
                                        placeholder: SizedBox(),
                                        onfetchdone: (m) {
                                          if (m[Dbkeys.lastSeen] == true) {
                                            return Positioned(
                                                left: 0,
                                                top: 0,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Mycolors.onlinetag,
                                                  radius: 5,
                                                ));
                                          }
                                        }),
                          ],
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Text(
                            '${getTranslatedForCurrentUser(context, 'xxidxx')} ${ticket.ticketcosmeticID}',
                            style:
                                TextStyle(fontSize: 11, color: Mycolors.grey)),
                      ],
                    )),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            getonlyTime(context,
                                ticket.ticketlatestTimestampForCustomer),
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MtCustomfontBoldSemi(
                      text: '${ticket.ticketTitle}',
                      fontsize: 14,
                    ),
                    Container(
                      height: 30,
                    )
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            LineAwesomeIcons.tag,
                            color: ticket.ticketcustomerID == currentUserID
                                ? ticketStatusColorForCustomers(
                                    ticket.ticketStatus)
                                : ticketStatusColorForAgents(
                                    ticket.ticketStatus),
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text('${ticket.ticketDepartmentID}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Mycolors.secondary,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      width: 70,
                      child: Center(
                        child: Text(
                          ticket.ticketcustomerID == currentUserID
                              ? ticketStatusTextShortForCustomers(
                                  context, ticket.ticketStatus)
                              : ticketStatusTextShortForAgents(
                                  context, ticket.ticketStatus),
                          style: TextStyle(
                              color: ticket.ticketcustomerID == currentUserID
                                  ? ticketStatusColorForCustomers(
                                      ticket.ticketStatus)
                                  : ticketStatusColorForAgents(
                                      ticket.ticketStatus),
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ticket.ticketcustomerID == currentUserID
                            ? ticketStatusColorForCustomers(ticket.ticketStatus)
                                .withOpacity(0.2)
                            : ticketStatusColorForAgents(ticket.ticketStatus)
                                .withOpacity(0.2),
                      ),
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
          ))
        ])),
  );
}
