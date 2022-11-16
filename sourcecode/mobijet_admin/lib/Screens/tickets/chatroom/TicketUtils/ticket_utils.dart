//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Definition attached with source code. *********************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/ticket_message.dart';
import 'package:thinkcreative_technologies/Models/ticket_model.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseApi.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketUtils {
  static bool isTimeOverToReopen(
      {required int closedOn, required BuildContext context}) {
    var observer = Provider.of<Observer>(context, listen: false);
    return DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(closedOn))
                .inDays >
            observer.userAppSettingsDoc!.reopenTicketTillDays!
        ? true
        : false;
  }

  static closeTicket(
      {required String ticketID,
      required BuildContext context,
      required bool isCustomer,
      required TicketModel liveTicketModel,
      required List<dynamic> agents}) async {
    var observer = Provider.of<Observer>(context, listen: false);
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(ticketID)
        .update({
      Dbkeys.ticketClosedOn: DateTime.now().millisecondsSinceEpoch,
      Dbkeys.ticketlatestTimestampForAgents:
          DateTime.now().millisecondsSinceEpoch,
      Dbkeys.ticketlatestTimestampForCustomer:
          DateTime.now().millisecondsSinceEpoch,
      Dbkeys.ticketclosedby: 'Admin',
      Dbkeys.ticketStatus: isCustomer == true
          ? TicketStatus.closedByCustomer.index
          : TicketStatus.closedByAgent.index,
      Dbkeys.ticketStatusShort: TicketStatusShort.close.index,
    });
    await FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(ticketID)
        .collection(DbPaths.collectionticketChats)
        .doc(timestamp.toString() + '--' + 'admin')
        .set(
            TicketMessage(
              // tktMssgCONTENT: "Ticket Closed",
              tktMssgCONTENT: "",
              tktMssgISDELETED: false,
              tktMssgTIME: DateTime.now().millisecondsSinceEpoch,
              tktMssgSENDBY: 'Admin',
              tktMssgTYPE: MessageType.rROBOTticketclosed.index,
              tktMssgSENDERNAME: 'Admin',
              tktMssgISREPLY: false,
              tktMssgISFORWARD: false,
              tktMssgREPLYTOMSSGDOC: {},
              tktMssgTicketName: liveTicketModel.ticketTitle,
              tktMssgTicketIDflitered: liveTicketModel.ticketidFiltered,
              tktMssgSENDFOR: isCustomer
                  ? [
                      // MssgSendFor.agent.index,
                      MssgSendFor.agent.index,
                      MssgSendFor.customer.index,
                    ]
                  : [
                      MssgSendFor.agent.index,
                      MssgSendFor.customer.index,
                    ],
              tktMsgSenderIndex:
                  isCustomer ? Usertype.customer.index : Usertype.agent.index,
              tktMsgInt2: 0,
              isShowSenderNameInNotification: true,
              tktMsgBool2: true,
              notificationActiveList:
                  observer.userAppSettingsDoc!.departmentBasedContent == true
                      ? [
                          liveTicketModel.ticketDepartmentID,
                        ]
                      : agents,
              tktMssgLISToptional: [],
              tktMsgList2: [],
              tktMsgList3: [],
              tktMsgMap1: {},
              tktMsgMap2: {},
              tktMsgDELETEDby: '',
              tktMsgDELETEREASON: '',
              tktMsgString4: '',
              tktMsgString5: '',
              ttktMsgString3: '',
              tktMsgCUSTOMERID: liveTicketModel.ticketcustomerID,
            ).toMap(),
            SetOptions(merge: true));

    FirebaseApi.runTransactionRecordActivity(
      parentid: "TICKET--$ticketID",
      title: getTranslatedForCurrentUser(context, 'xxclosedxxxx').replaceAll(
          '(####)', '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
      postedbyID: 'Admin',
      onErrorFn: (e) {},
      onSuccessFn: () {},
      plainDesc: getTranslatedForCurrentUser(context, 'xxxxisclosedbyxxx')
          .replaceAll('(####)',
              '${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${liveTicketModel.ticketTitle} (${getTranslatedForCurrentUser(context, 'xxidxx')} $ticketID)')
          .replaceAll(
              '(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
    );
  }

  static askToClose(
      {required String ticketID,
      required BuildContext context,
      required bool isCustomer,
      required TicketModel liveTicketModel,
      required List<dynamic> agents}) async {
    var observer = Provider.of<Observer>(context, listen: false);
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(ticketID)
        .update({
      Dbkeys.ticketlatestTimestampForCustomer:
          DateTime.now().millisecondsSinceEpoch,
      Dbkeys.ticketStatus: isCustomer == true
          ? TicketStatus.canWeCloseByCustomer.index
          : TicketStatus.canWeCloseByAgent.index,
      Dbkeys.ticketStatusShort: TicketStatusShort.active.index,
    });
    await FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(ticketID)
        .collection(DbPaths.collectionticketChats)
        .doc(timestamp.toString() + '--' + 'admin')
        .set(
            TicketMessage(
              tktMssgCONTENT: "",
              // tktMssgCONTENT: "Request to Close ticket",
              tktMssgISDELETED: false,
              tktMssgTIME: DateTime.now().millisecondsSinceEpoch,
              tktMssgSENDBY: 'Admin',
              tktMssgTYPE: MessageType.rROBOTrequestedtoclose.index,
              tktMssgSENDERNAME: 'Admin',
              tktMssgISREPLY: false,
              tktMssgISFORWARD: false,
              tktMssgREPLYTOMSSGDOC: {},
              tktMssgTicketName: liveTicketModel.ticketTitle,
              tktMssgTicketIDflitered: liveTicketModel.ticketidFiltered,
              tktMssgSENDFOR: isCustomer
                  ? [
                      // MssgSendFor.agent.index,
                      MssgSendFor.agent.index,
                      MssgSendFor.customer.index,
                    ]
                  : [
                      MssgSendFor.agent.index,
                      MssgSendFor.customer.index,
                    ],
              tktMsgSenderIndex:
                  isCustomer ? Usertype.customer.index : Usertype.agent.index,
              tktMsgInt2: 0,
              isShowSenderNameInNotification: true,
              tktMsgBool2: true,
              notificationActiveList:
                  observer.userAppSettingsDoc!.departmentBasedContent == true
                      ? [
                          liveTicketModel.ticketDepartmentID,
                        ]
                      : agents,
              tktMssgLISToptional: [],
              tktMsgList2: [],
              tktMsgList3: [],
              tktMsgMap1: {},
              tktMsgMap2: {},
              tktMsgDELETEDby: '',
              tktMsgDELETEREASON: '',
              tktMsgString4: '',
              tktMsgString5: '',
              ttktMsgString3: '',
              tktMsgCUSTOMERID: liveTicketModel.ticketcustomerID,
            ).toMap(),
            SetOptions(merge: true));

    FirebaseApi.runTransactionRecordActivity(
      parentid: "TICKET--$ticketID",
      title: getTranslatedForCurrentUser(context, 'xxxxclosingrequestxxx')
          .replaceAll(
              '(####)', '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
      postedbyID: 'Admin',
      onErrorFn: (e) {},
      onSuccessFn: () {},
      plainDesc: getTranslatedForCurrentUser(context, 'xxrequestedxxtoxx')
          .replaceAll(
              '(####)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
          .replaceAll(
              '(###)', '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
          .replaceAll('(##)',
              '${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${liveTicketModel.ticketTitle} (${getTranslatedForCurrentUser(context, 'xxidxx')} $ticketID)'),
    );
  }

  static reopenTicket(
      {required String ticketID,
      required BuildContext context,
      required bool isCustomer,
      required TicketModel liveTicketModel,
      required List<dynamic> agents}) async {
    var observer = Provider.of<Observer>(context, listen: false);
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(ticketID)
        .update({
      Dbkeys.ticketlatestTimestampForAgents:
          DateTime.now().millisecondsSinceEpoch,
      Dbkeys.ticketlatestTimestampForCustomer:
          DateTime.now().millisecondsSinceEpoch,
      Dbkeys.ticketStatus: isCustomer
          ? TicketStatus.reOpenedByCustomer.index
          : TicketStatus.reOpenedByAgent.index,
      Dbkeys.ticketStatusShort: TicketStatusShort.active.index,
    });
    await FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(ticketID)
        .collection(DbPaths.collectionticketChats)
        .doc(timestamp.toString() + '--' + 'admin')
        .set(
            TicketMessage(
              tktMssgCONTENT: "",
              // tktMssgCONTENT: "Ticket Re-Opened",
              tktMssgISDELETED: false,
              tktMssgTIME: DateTime.now().millisecondsSinceEpoch,
              tktMssgSENDBY: 'Admin',
              tktMssgTYPE: MessageType.rROBOTticketreopened.index,
              tktMssgSENDERNAME: 'Admin',
              tktMssgISREPLY: false,
              tktMssgISFORWARD: false,
              tktMssgREPLYTOMSSGDOC: {},
              tktMssgTicketName: liveTicketModel.ticketTitle,
              tktMssgTicketIDflitered: liveTicketModel.ticketidFiltered,
              tktMssgSENDFOR: isCustomer
                  ? [
                      // MssgSendFor.agent.index,
                      MssgSendFor.agent.index,
                      MssgSendFor.customer.index,
                    ]
                  : [
                      MssgSendFor.agent.index,
                      MssgSendFor.customer.index,
                    ],
              tktMsgSenderIndex:
                  isCustomer ? Usertype.customer.index : Usertype.agent.index,
              tktMsgInt2: 0,
              isShowSenderNameInNotification: true,
              tktMsgBool2: true,
              notificationActiveList:
                  observer.userAppSettingsDoc!.departmentBasedContent == true
                      ? [
                          liveTicketModel.ticketDepartmentID,
                        ]
                      : agents,
              tktMssgLISToptional: [],
              tktMsgList2: [],
              tktMsgList3: [],
              tktMsgMap1: {},
              tktMsgMap2: {},
              tktMsgDELETEDby: '',
              tktMsgDELETEREASON: '',
              tktMsgString4: '',
              tktMsgString5: '',
              ttktMsgString3: '',
              tktMsgCUSTOMERID: liveTicketModel.ticketcustomerID,
            ).toMap(),
            SetOptions(merge: true));

    FirebaseApi.runTransactionRecordActivity(
      parentid: "TICKET--$ticketID",
      title: getTranslatedForCurrentUser(context, 'xxreopenedxxxx').replaceAll(
          '(####)', '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
      postedbyID: 'Admin',
      onErrorFn: (e) {},
      onSuccessFn: () {},
      plainDesc: getTranslatedForCurrentUser(context, 'xxxxtktreopenedafterxxx')
          .replaceAll('(####)',
              '${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${liveTicketModel.ticketTitle} (${getTranslatedForCurrentUser(context, 'xxidxx')} $ticketID)')
          .replaceAll(
              '(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
          .replaceAll('(##)',
              '${DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(liveTicketModel.ticketClosedOn!)).inDays}'),
    );
  }

  static markNeedsAttention(
      {required String ticketID,
      required String attentionResaon,
      required BuildContext context,

      // required String currentUserID,
      required TicketModel liveTicketModel,
      required List<dynamic> agents}) async {
    Observer observer = Provider.of<Observer>(context, listen: false);
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(ticketID)
        .update({
      Dbkeys.ticketlatestTimestampForAgents:
          DateTime.now().millisecondsSinceEpoch,
      Dbkeys.ticketStatus: TicketStatus.needsAttention.index,
      Dbkeys.ticketStatusShort: TicketStatusShort.active.index,
    });
    await FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(ticketID)
        .collection(DbPaths.collectionticketChats)
        .doc(timestamp.toString() + '--' + 'admin')
        .set(
            TicketMessage(
              tktMssgCONTENT: "$attentionResaon",
              tktMssgISDELETED: false,
              tktMssgTIME: DateTime.now().millisecondsSinceEpoch,
              tktMssgSENDBY: 'Admin',
              tktMssgTYPE: MessageType.rROBOTrequireattention.index,
              tktMssgSENDERNAME: 'Admin',
              tktMssgISREPLY: false,
              tktMssgISFORWARD: false,
              tktMssgREPLYTOMSSGDOC: {},
              tktMssgTicketName: liveTicketModel.ticketTitle,
              tktMssgTicketIDflitered: liveTicketModel.ticketidFiltered,
              tktMssgSENDFOR: [
                MssgSendFor.agent.index,
              ],
              tktMsgSenderIndex: Usertype.agent.index,
              tktMsgInt2: 0,
              isShowSenderNameInNotification: true,
              tktMsgBool2: true,
              notificationActiveList:
                  observer.userAppSettingsDoc!.departmentBasedContent == true
                      ? [
                          liveTicketModel.ticketDepartmentID,
                        ]
                      : agents,
              tktMssgLISToptional: [],
              tktMsgList2: [],
              tktMsgList3: [],
              tktMsgMap1: {},
              tktMsgMap2: {},
              tktMsgDELETEDby: '',
              tktMsgDELETEREASON: '',
              tktMsgString4: '',
              tktMsgString5: '',
              ttktMsgString3: '',
              tktMsgCUSTOMERID: liveTicketModel.ticketcustomerID,
            ).toMap(),
            SetOptions(merge: true));

    FirebaseApi.runTransactionRecordActivity(
      parentid: "TICKET--$ticketID",
      title: getTranslatedForCurrentUser(context, 'xxxxrequiteattentionxxx')
          .replaceAll(
              '(####)', '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
      postedbyID: 'Admin',
      onErrorFn: (e) {},
      onSuccessFn: () {},
      plainDesc: getTranslatedForCurrentUser(
              context, 'xxxtktrequireattentiondescxxx')
          .replaceAll('(###)',
              '${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${liveTicketModel.ticketTitle} (${getTranslatedForCurrentUser(context, 'xxidxx')} $ticketID)')
          .replaceAll(
              '(##)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
    );
  }

  static markNeedsAttentionOFF(
      {required String ticketID,
      required BuildContext context,

      // required String currentUserID,
      required TicketModel liveTicketModel,
      required List<dynamic> agents}) async {
    var observer = Provider.of<Observer>(context, listen: false);
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(ticketID)
        .update({
      Dbkeys.ticketlatestTimestampForAgents:
          DateTime.now().millisecondsSinceEpoch,
      Dbkeys.ticketStatus: TicketStatus.active.index,
      Dbkeys.ticketStatusShort: TicketStatusShort.active.index,
    });
    await FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(ticketID)
        .collection(DbPaths.collectionticketChats)
        .doc(timestamp.toString() + '--' + 'admin')
        .set(
            TicketMessage(
              // tktMssgCONTENT: "Removed Attention mark",
              tktMssgCONTENT: "",
              tktMssgISDELETED: false,
              tktMssgTIME: DateTime.now().millisecondsSinceEpoch,
              tktMssgSENDBY: 'Admin',
              tktMssgTYPE: MessageType.rROBOTremovettention.index,
              tktMssgSENDERNAME: 'Admin',
              tktMssgISREPLY: false,
              tktMssgISFORWARD: false,
              tktMssgREPLYTOMSSGDOC: {},
              tktMssgTicketName: liveTicketModel.ticketTitle,
              tktMssgTicketIDflitered: liveTicketModel.ticketidFiltered,
              tktMssgSENDFOR: [
                MssgSendFor.agent.index,
              ],
              tktMsgSenderIndex: Usertype.agent.index,
              tktMsgInt2: 0,
              isShowSenderNameInNotification: true,
              tktMsgBool2: true,
              notificationActiveList:
                  observer.userAppSettingsDoc!.departmentBasedContent == true
                      ? [
                          liveTicketModel.ticketDepartmentID,
                        ]
                      : agents,
              tktMssgLISToptional: [],
              tktMsgList2: [],
              tktMsgList3: [],
              tktMsgMap1: {},
              tktMsgMap2: {},
              tktMsgDELETEDby: '',
              tktMsgDELETEREASON: '',
              tktMsgString4: '',
              tktMsgString5: '',
              ttktMsgString3: '',
              tktMsgCUSTOMERID: liveTicketModel.ticketcustomerID,
            ).toMap(),
            SetOptions(merge: true));

    FirebaseApi.runTransactionRecordActivity(
      parentid: "TICKET--$ticketID",
      title: getTranslatedForCurrentUser(context, 'xxattentionremovedxx')
          .replaceAll(
              '(####)', '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
      postedbyID: 'Admin',
      onErrorFn: (e) {},
      onSuccessFn: () {},
      plainDesc: getTranslatedForCurrentUser(
              context, 'xxxtktattentionremovedxxx')
          .replaceAll('(####)',
              '${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${liveTicketModel.ticketTitle} (${getTranslatedForCurrentUser(context, 'xxidxx')} $ticketID)')
          .replaceAll(
              '(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
    );
  }

  static bool isReopenAllowedForUserType(
      BuildContext context, int closedOn, int usertype) {
    var observer = Provider.of<Observer>(context, listen: false);
    bool isallowednow = DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(closedOn))
                .inDays >
            observer.userAppSettingsDoc!.reopenTicketTillDays!
        ? false
        : true;
    if (usertype == Usertype.agent.index) {
      if (observer.userAppSettingsDoc!.agentCanReopenTicket! &&
          isallowednow == true) {
        return true;
      } else {
        return false;
      }
    } else if (usertype == Usertype.customer.index) {
      if (observer.userAppSettingsDoc!.customerCanReopenTicket! &&
          isallowednow == true) {
        return true;
      } else {
        return false;
      }
    } else if (usertype == Usertype.departmentmanager.index) {
      if (observer.userAppSettingsDoc!.departmentManagerCanReopenTicket! &&
          isallowednow == true) {
        return true;
      } else {
        return false;
      }
    } else if (usertype == Usertype.secondadmin.index) {
      if (observer.userAppSettingsDoc!.secondadminCanReopenTicket! &&
          isallowednow == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static int totalReopenDays(BuildContext context) {
    var observer = Provider.of<Observer>(context, listen: false);

    return observer.userAppSettingsDoc!.reopenTicketTillDays!;
  }

  static int totalDeletingdays(BuildContext context) {
    var observer = Provider.of<Observer>(context, listen: false);

    return observer
        .userAppSettingsDoc!.defaultTicketMssgsDeletingTimeAfterClosing!;
  }

  static submitRating(
      {required BuildContext context,
      required String ticketID,
      required String feedback,
      required int rating,
      required String customeruid,
      List<dynamic>? agents = const [],
      String? departmentName = ""}) async {
    await FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(ticketID)
        .update({
      Dbkeys.rating: rating,
      Dbkeys.feedback: feedback,
    });
    if (departmentName != null) {
      await FirebaseApi.runUPDATEmapobjectinListField(
          docrefdata: FirebaseFirestore.instance
              .collection(DbPaths.userapp)
              .doc(DbPaths.appsettings),
          compareKey: Dbkeys.departmentTitle,
          compareVal: departmentName,
          onErrorFn: (e) {},
          isshowloader: false,
          onSuccessFn: () {},
          replaceableMapObjectWithOnlyFieldsRequired: {
            Dbkeys.departmentRatingsList: FieldValue.arrayUnion([
              {Dbkeys.rating: rating, Dbkeys.ticketID: ticketID}
            ])
          },
          listkeyname: Dbkeys.departmentList);
    }
    if (agents != null) {
      agents.forEach((agent) async {
        await FirebaseFirestore.instance
            .collection(DbPaths.collectionagents)
            .doc(agent)
            .update({
          Dbkeys.ratings: FieldValue.arrayUnion([
            {Dbkeys.rating: rating, Dbkeys.ticketID: ticketID}
          ])
        });
      });
    }

    await FirebaseApi.runTransactionRecordActivity(
      parentid: "TICKET--$ticketID",
      title: feedback == ""
          ? getTranslatedForCurrentUser(context, 'xxxonlyratingrecievedforxxx')
              .replaceAll('(####)',
                  '${getTranslatedForCurrentUser(context, 'xxtktsxx')}')
          : getTranslatedForCurrentUser(
                  context, 'xxxonlyratingfeedbackrecievedforxxx')
              .replaceAll('(####)',
                  '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
      postedbyID: customeruid,
      onErrorFn: (e) {},
      onSuccessFn: () {},
      plainDesc: getTranslatedForCurrentUser(context, 'xxxxratingdesc')
          .replaceAll('(####)',
              '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}')
          .replaceAll('(###)',
              '${getTranslatedForCurrentUser(context, 'xxtktsxx')} (${getTranslatedForCurrentUser(context, 'xxidxx')} $ticketID)')
          .replaceAll(
              '(##)', '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
    );
  }
}
