import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/number_limits.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/customer_model.dart';
import 'package:thinkcreative_technologies/Models/ticket_model.dart';
import 'package:thinkcreative_technologies/Models/userapp_settings_model.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/ticketStatus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/customCircleAvatars.dart';
import 'package:thinkcreative_technologies/Widgets/boxdecoration.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/late_load.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';

Widget ticketWidgetForAgents(
    {required BuildContext context,
    required Function(String s, String uid) ontap,
    required TicketModel ticket,
    required bool isMini,
    required UserAppSettingsModel userAppSettingsDoc}) {
  var registry = Provider.of<UserRegistry>(context, listen: true);
  return myinkwell(
    onTap: () {
      ontap(ticket.ticketID, ticket.ticketcustomerID);
    },
    child: Stack(
      children: [
        Container(
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
                color:
                    (ticket.ticketStatus == TicketStatus.needsAttention.index)
                        ? Colors.yellow[200]
                        : Colors.white,
                width: 0,
              ),
              Expanded(
                  child: Container(
                color:
                    (ticket.ticketStatus == TicketStatus.needsAttention.index)
                        ? Colors.yellow[200]
                        : Colors.white,
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
                                        backgroundColor:
                                            ticketStatusColorForAgents(
                                                    ticket.ticketStatus)
                                                .withOpacity(0.2),
                                        child: customCircleAvatar(
                                          radius: 14,
                                          url: registry
                                              .getUserData(context,
                                                  ticket.ticketcustomerID)
                                              .photourl,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 13,
                                      ),
                                      Text(
                                          registry
                                              .getUserData(context,
                                                  ticket.ticketcustomerID)
                                              .fullname,
                                          // registry
                                          //     .getUserData(
                                          //         context, ticket.ticketcustomerID)
                                          //     .fullname,
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Mycolors.grey)),
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
                                                  .photourl,
                                            ),
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
                                                              ticket
                                                                  .ticketStatus)
                                                          .withOpacity(0.2),
                                                  child: customCircleAvatar(
                                                    radius: 14,
                                                    url: customer.photoUrl,
                                                  ),
                                                ),
                                                customer.lastSeen == true
                                                    ? Positioned(
                                                        top: 0,
                                                        left: 0,
                                                        child: CircleAvatar(
                                                          radius: 5,
                                                          backgroundColor:
                                                              Mycolors
                                                                  .greensqaush,
                                                        ))
                                                    : SizedBox(),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 13,
                                            ),
                                            Text(customer.nickname,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Mycolors.grey)),
                                          ],
                                        ),
                                      );
                                    })
                            //  FutureBuilder(
                            //     future: customerprovider
                            //         .getparticularCustomerFromProvider(
                            //             ticket.ticketcustomerID),
                            //     builder:
                            //         (BuildContext context, AsyncSnapshot snapshot) {
                            //       if (snapshot.hasData && snapshot.data.exists) {
                            //         var doc = snapshot.data;
                            //         return
                            //       }
                            //       return Row(
                            //         children: [
                            //           CircleAvatar(
                            //             radius: 16,
                            //             backgroundColor:
                            //                 ticketStatusColor(ticket.ticketStatus)
                            //                     .withOpacity(0.2),
                            //             child:
                            //                 customCircleAvatar(radius: 14, url: ''),
                            //           ),
                            //           SizedBox(
                            //             width: 13,
                            //           ),
                            //           Text('ID: ${ticket.ticketcosmeticID}',
                            //               style: TextStyle(
                            //                   fontSize: 11, color: fiberchatGrey)),
                            //         ],
                            //       );
                            //     }),
                            ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Stack(
                              //   children: [
                              //     // Icon(Boxicons.bx_message_rounded,
                              //     //     color: Mycolors.greylight),
                              //     // Positioned(
                              //     //   right: 0,
                              //     //   top: 0,
                              //     //   child: CircleAvatar(
                              //     //     radius: 5,
                              //     //     backgroundColor: Mycolors.red,
                              //     //   ),
                              //     // )
                              //   ],
                              // ),

                              SizedBox(
                                width: 30,
                              ),
                              Icon(
                                EvaIcons.messageCircle,
                                color: Mycolors.grey.withOpacity(0.3),
                                size: 15,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                getonlyTime(context,
                                    ticket.ticketlatestTimestampForAgents),
                                style: TextStyle(
                                  fontSize: 13,
                                ),
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
                          // child: Text('',
                          //     style: TextStyle(
                          //         fontSize: 14,
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.bold)),
                          // padding: const EdgeInsets.all(7.0),
                          // decoration: new BoxDecoration(
                          //   shape: BoxShape.circle,
                          //   color: Colors.blue[400],
                          // ),
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
                                color: ticketStatusColorForAgents(
                                    ticket.ticketStatus),
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
                        userAppSettingsDoc.departmentBasedContent == false
                            ? Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      LineAwesomeIcons.user_friends,
                                      color: ticketStatusColorForAgents(
                                          ticket.ticketStatus),
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    MtCustomfontBoldSemi(
                                      fontsize: 13,
                                      lineheight: 1.4,
                                      color: Mycolors.black,
                                      text:
                                          '${ticket.tktMEMBERSactiveList.length}',
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      LineAwesomeIcons.tag,
                                      color: ticketStatusColorForAgents(
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
                                          color: Mycolors.grey,
                                        )),
                                  ],
                                ),
                              ),
                        SizedBox(
                          width: 13,
                        ),
                        isMini == true || ticket.rating != 0
                            ? SizedBox()
                            : Text(
                                "${getTranslatedForCurrentUser(context, 'xxticketidxx')} " +
                                    ticket.ticketID,
                                // registry
                                //     .getUserData(
                                //         context, ticket.ticketcustomerID)
                                //     .fullname,
                                style: TextStyle(
                                    fontSize: 11, color: Mycolors.grey)),
                        ticket.ticketStatusShort ==
                                    TicketStatusShort.close.index &&
                                ticket.rating != 0
                            ? Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MtCustomfontBoldSemi(
                                        fontsize: 14,
                                        text: ticket.rating.toString()),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Mycolors.yellow,
                                      size: 15,
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(),
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
                            color:
                                ticketStatusColorForAgents(ticket.ticketStatus)
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
        ticket.tktMEMBERSactiveList.length == 0
            ? Positioned(
                top: 6,
                right: 10,
                child: Container(
                    padding: EdgeInsets.all(3),
                    color: Colors.pinkAccent,
                    child: Text(
                      "  No agents assigned in this ticket ",
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    )))
            : SizedBox()
      ],
    ),
  );

  // Container(
  //   decoration: boxDecoration(showShadow: true),
  //   margin: EdgeInsets.all(8),
  //   padding: EdgeInsets.fromLTRB(14, 15, 14, 18),
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Container(
  //             child: Row(
  //               children: [
  //                 CircleAvatar(
  //                   radius: 12,
  //                   backgroundColor: Colors.yellow[300],
  //                   child: Icon(
  //                     LineAwesomeIcons.alternate_ticket,
  //                     size: 12,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 5,
  //                 ),
  //                 Text('ID: 747474747',
  //                     style: TextStyle(fontSize: 10, color: fiberchatGrey)),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             child: Text(
  //               '10:73 AM',
  //               style: TextStyle(fontSize: 13),
  //             ),
  //           )
  //         ],
  //       ),
  //       SizedBox(
  //         height: 11,
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text('User not getting uplaoded',
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 color: fiberchatGrey,
  //               )),
  //           Container(
  //             child: Text('23',
  //                 style: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold)),
  //             padding: const EdgeInsets.all(7.0),
  //             decoration: new BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: Colors.blue[400],
  //             ),
  //           )
  //         ],
  //       ),
  //       Divider(),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Container(
  //             child: Row(
  //               children: [
  //                 Icon(
  //                   LineAwesomeIcons.user_friends,
  //                   color: Mycolors.getColor(prefs, Colortype.primary.index),
  //                   size: 16,
  //                 ),
  //                 SizedBox(
  //                   width: 4,
  //                 ),
  //                 Text('16',
  //                     style: TextStyle(
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.bold,
  //                       color: Mycolors.getColor(prefs, Colortype.button.index),
  //                     )),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             child: Row(
  //               children: [
  //                 Icon(
  //                   LineAwesomeIcons.tag,
  //                   color: Mycolors.getColor(prefs, Colortype.primary.index),
  //                   size: 16,
  //                 ),
  //                 SizedBox(
  //                   width: 4,
  //                 ),
  //                 Text('Servicing',
  //                     style: TextStyle(
  //                       fontSize: 11,
  //                       fontWeight: FontWeight.normal,
  //                       color: Mycolors.getColor(prefs, Colortype.button.index),
  //                     )),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             width: 70,
  //             child: Center(
  //               child: Text(
  //                 'ACTIVE',
  //                 style: TextStyle(color: Colors.white, fontSize: 11),
  //               ),
  //             ),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(10),
  //               color: Colors.red,
  //             ),
  //             height: 20,
  //           ),
  //         ],
  //       )
  //     ],
  //   ),
  //   // ListTile(
  //   //   leading: CircleAvatar(
  //   //     radius: 12,
  //   //     backgroundColor: Colors.yellow[300],
  //   //     child: Icon(
  //   //       LineAwesomeIcons.alternate_ticket,
  //   //       size: 12,
  //   //     ),
  //   //   ),
  //   // ),c
  // );
}

getonlyTime(BuildContext context, int millisecondsepoch) {
  DateTime now = DateTime.now();
  DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsepoch);
  String when;
  if (date.day == now.day)
    // when = getTranslated(context, 'today');
    when = DateFormat("h:mm a").format(date).toString();
  else if (date.day == now.subtract(Duration(days: 1)).day)
    when = "Yesterday";
  else
    when = when = DateFormat.MMMd().format(date);
  return when;
}

Widget ticketWidgetForCustomers(
    {required BuildContext context,
    required SharedPreferences prefs,
    required Function(String s, String uid) ontap,
    required TicketModel ticket,
    required var ticketdoc,
    required String currentUserID,
    required bool isMini,
    required bool customerCanAgentOnline}) {
  return myinkwell(
    onTap: () {
      ontap(ticket.ticketID, ticket.ticketcustomerID);
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
                                                      Mycolors.greensqaush,
                                                  radius: 5,
                                                ));
                                          }
                                        }),
                          ],
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Text('ID: ${ticket.ticketcosmeticID}',
                            style:
                                TextStyle(fontSize: 11, color: Mycolors.grey)),
                      ],
                    )),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Stack(
                          //   children: [
                          //     // Icon(Boxicons.bx_message_rounded,
                          //     //     color: Mycolors.greylight),
                          //     // Positioned(
                          //     //   right: 0,
                          //     //   top: 0,
                          //     //   child: CircleAvatar(
                          //     //     radius: 5,
                          //     //     backgroundColor: Mycolors.red,
                          //     //   ),
                          //     // )
                          //   ],
                          // ),

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
                      // child: Text('',
                      //     style: TextStyle(
                      //         fontSize: 14,
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.bold)),
                      // padding: const EdgeInsets.all(7.0),
                      // decoration: new BoxDecoration(
                      //   shape: BoxShape.circle,
                      //   color: Colors.blue[400],
                      // ),
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
                                color: Mycolors.primary,
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

  // Container(
  //   decoration: boxDecoration(showShadow: true),
  //   margin: EdgeInsets.all(8),
  //   padding: EdgeInsets.fromLTRB(14, 15, 14, 18),
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Container(
  //             child: Row(
  //               children: [
  //                 CircleAvatar(
  //                   radius: 12,
  //                   backgroundColor: Colors.yellow[300],
  //                   child: Icon(
  //                     LineAwesomeIcons.alternate_ticket,
  //                     size: 12,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 5,
  //                 ),
  //                 Text('ID: 747474747',
  //                     style: TextStyle(fontSize: 10, color: fiberchatGrey)),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             child: Text(
  //               '10:73 AM',
  //               style: TextStyle(fontSize: 13),
  //             ),
  //           )
  //         ],
  //       ),
  //       SizedBox(
  //         height: 11,
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text('User not getting uplaoded',
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 color: fiberchatGrey,
  //               )),
  //           Container(
  //             child: Text('23',
  //                 style: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold)),
  //             padding: const EdgeInsets.all(7.0),
  //             decoration: new BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: Colors.blue[400],
  //             ),
  //           )
  //         ],
  //       ),
  //       Divider(),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Container(
  //             child: Row(
  //               children: [
  //                 Icon(
  //                   LineAwesomeIcons.user_friends,
  //                   color: Mycolors.getColor(prefs, Colortype.primary.index),
  //                   size: 16,
  //                 ),
  //                 SizedBox(
  //                   width: 4,
  //                 ),
  //                 Text('16',
  //                     style: TextStyle(
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.bold,
  //                       color: Mycolors.getColor(prefs, Colortype.button.index),
  //                     )),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             child: Row(
  //               children: [
  //                 Icon(
  //                   LineAwesomeIcons.tag,
  //                   color: Mycolors.getColor(prefs, Colortype.primary.index),
  //                   size: 16,
  //                 ),
  //                 SizedBox(
  //                   width: 4,
  //                 ),
  //                 Text('Servicing',
  //                     style: TextStyle(
  //                       fontSize: 11,
  //                       fontWeight: FontWeight.normal,
  //                       color: Mycolors.getColor(prefs, Colortype.button.index),
  //                     )),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             width: 70,
  //             child: Center(
  //               child: Text(
  //                 'ACTIVE',
  //                 style: TextStyle(color: Colors.white, fontSize: 11),
  //               ),
  //             ),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(10),
  //               color: Colors.red,
  //             ),
  //             height: 20,
  //           ),
  //         ],
  //       )
  //     ],
  //   ),
  //   // ListTile(
  //   //   leading: CircleAvatar(
  //   //     radius: 12,
  //   //     backgroundColor: Colors.yellow[300],
  //   //     child: Icon(
  //   //       LineAwesomeIcons.alternate_ticket,
  //   //       size: 12,
  //   //     ),
  //   //   ),
  //   // ),c
  // );
}
