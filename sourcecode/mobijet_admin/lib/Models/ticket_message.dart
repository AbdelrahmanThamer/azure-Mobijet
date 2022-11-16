//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Definition attached with source code. *********************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';

class TicketMessage {
  final String tktMssgCONTENT;
  final bool tktMssgISDELETED;
  final int tktMssgTIME;
  final int tktMssgTYPE;
  final String tktMsgCUSTOMERID;
  final List<dynamic> tktMssgLISToptional;
  final String tktMssgSENDBY;
  final List<dynamic> tktMssgSENDFOR;
  final bool tktMssgISREPLY;
  final Map tktMssgREPLYTOMSSGDOC;
  final bool tktMssgISFORWARD;
  final String tktMssgTicketName;
  final String tktMssgTicketIDflitered;
  final String tktMssgSENDERNAME;
  final String tktMsgDELETEREASON;
  final String tktMsgDELETEDby;
  final String ttktMsgString3;
  final String tktMsgString4;
  final String tktMsgString5;
  final List<dynamic> notificationActiveList;
  final List<dynamic> tktMsgList2;
  final List<dynamic> tktMsgList3;
  final int tktMsgSenderIndex;
  final int tktMsgInt2;
  final bool isShowSenderNameInNotification;
  final bool tktMsgBool2;
  final Map tktMsgMap1;
  final Map tktMsgMap2;
  TicketMessage({
    required this.tktMssgCONTENT,
    required this.tktMssgISDELETED,
    required this.tktMssgTIME,
    required this.tktMsgCUSTOMERID,
    required this.tktMssgTYPE,
    required this.tktMssgLISToptional,
    required this.tktMssgSENDBY,
    required this.tktMssgSENDFOR,
    required this.tktMssgISREPLY,
    required this.tktMssgREPLYTOMSSGDOC,
    required this.tktMssgISFORWARD,
    required this.tktMssgTicketName,
    required this.tktMssgTicketIDflitered,
    required this.tktMssgSENDERNAME,
    required this.tktMsgDELETEREASON,
    required this.tktMsgDELETEDby,
    required this.ttktMsgString3,
    required this.tktMsgString4,
    required this.tktMsgString5,
    required this.notificationActiveList,
    required this.tktMsgList2,
    required this.tktMsgList3,
    required this.tktMsgSenderIndex,
    required this.tktMsgInt2,
    required this.isShowSenderNameInNotification,
    required this.tktMsgBool2,
    required this.tktMsgMap1,
    required this.tktMsgMap2,
  });

  TicketMessage copyWith({
    final String? tktMssgCONTENT,
    final bool? tktMssgISDELETED,
    final int? tktMssgTIME,
    final String? tktMsgCUSTOMERID,
    final int? tktMssgTYPE,
    final List<dynamic>? tktMssgLISToptional,
    final String? tktMssgSENDBY,
    final List<dynamic>? tktMssgSENDFOR,
    final bool? tktMssgISREPLY,
    final Map? tktMssgREPLYTOMSSGDOC,
    final bool? tktMssgISFORWARD,
    final String? tktMssgTicketName,
    final String? tktMssgTicketIDflitered,
    final String? tktMssgSENDERNAME,
    final String? tktMsgDELETEREASON,
    final String? tktMsgDELETEDby,
    final String? ttktMsgString3,
    final String? tktMsgString4,
    final String? tktMsgString5,
    final List<dynamic>? notificationActiveList,
    final List<dynamic>? tktMsgList2,
    final List<dynamic>? tktMsgList3,
    final int? tktMsgSenderIndex,
    final int? tktMsgInt2,
    final bool? isShowSenderNameInNotification,
    final bool? tktMsgBool2,
    final Map? tktMsgMap1,
    final Map? tktMsgMap2,
  }) {
    return TicketMessage(
      tktMssgCONTENT: tktMssgCONTENT ?? this.tktMssgCONTENT,
      tktMssgISDELETED: tktMssgISDELETED ?? this.tktMssgISDELETED,
      tktMssgTIME: tktMssgTIME ?? this.tktMssgTIME,
      tktMssgTYPE: tktMssgTYPE ?? this.tktMssgTYPE,
      tktMsgCUSTOMERID: tktMsgCUSTOMERID ?? this.tktMsgCUSTOMERID,
      tktMssgLISToptional: tktMssgLISToptional ?? this.tktMssgLISToptional,
      tktMssgSENDBY: tktMssgSENDBY ?? this.tktMssgSENDBY,
      tktMssgSENDFOR: tktMssgSENDFOR ?? this.tktMssgSENDFOR,
      tktMssgISREPLY: tktMssgISREPLY ?? this.tktMssgISREPLY,
      tktMssgREPLYTOMSSGDOC:
          tktMssgREPLYTOMSSGDOC ?? this.tktMssgREPLYTOMSSGDOC,
      tktMssgISFORWARD: tktMssgISFORWARD ?? this.tktMssgISFORWARD,
      tktMssgTicketName: tktMssgTicketName ?? this.tktMssgTicketName,
      tktMssgTicketIDflitered:
          tktMssgTicketIDflitered ?? this.tktMssgTicketIDflitered,
      tktMssgSENDERNAME: tktMssgSENDERNAME ?? this.tktMssgSENDERNAME,
      tktMsgDELETEREASON: tktMsgDELETEREASON ?? this.tktMsgDELETEREASON,
      tktMsgDELETEDby: tktMsgDELETEDby ?? this.tktMsgDELETEDby,
      ttktMsgString3: ttktMsgString3 ?? this.ttktMsgString3,
      tktMsgString4: tktMsgString4 ?? this.tktMsgString4,
      tktMsgString5: tktMsgString5 ?? this.tktMsgString5,
      notificationActiveList:
          notificationActiveList ?? this.notificationActiveList,
      tktMsgList2: tktMsgList2 ?? this.tktMsgList2,
      tktMsgList3: tktMsgList2 ?? this.tktMsgList3,
      tktMsgSenderIndex: tktMsgSenderIndex ?? this.tktMsgSenderIndex,
      tktMsgInt2: tktMsgInt2 ?? this.tktMsgInt2,
      isShowSenderNameInNotification:
          isShowSenderNameInNotification ?? this.isShowSenderNameInNotification,
      tktMsgBool2: tktMsgBool2 ?? this.tktMsgBool2,
      tktMsgMap1: tktMsgMap1 ?? this.tktMsgMap1,
      tktMsgMap2: tktMsgMap2 ?? this.tktMsgMap2,
    );
  }

  factory TicketMessage.fromJson(Map<String, dynamic> doc) {
    return TicketMessage(
      tktMssgCONTENT: doc[Dbkeys.tktMssgCONTENT],
      tktMssgISDELETED: doc[Dbkeys.tktMssgISDELETED],
      tktMssgTIME: doc[Dbkeys.tktMssgTIME],
      tktMssgTYPE: doc[Dbkeys.tktMssgTYPE],
      tktMsgCUSTOMERID: doc[Dbkeys.tktMsgCUSTOMERID],
      tktMssgLISToptional: doc[Dbkeys.tktMssgLISToptional],
      tktMssgSENDBY: doc[Dbkeys.tktMssgSENDBY],
      tktMssgSENDFOR: doc[Dbkeys.tktMssgSENDFOR],
      tktMssgISREPLY: doc[Dbkeys.tktMssgISREPLY],
      tktMssgREPLYTOMSSGDOC: doc[Dbkeys.tktMssgREPLYTOMSSGDOC],
      tktMssgISFORWARD: doc[Dbkeys.tktMssgISFORWARD],
      tktMssgTicketName: doc[Dbkeys.tktMssgTicketName],
      tktMssgTicketIDflitered: doc[Dbkeys.tktMssgTicketIDflitered],
      tktMssgSENDERNAME: doc[Dbkeys.tktMssgSENDERNAME],
      tktMsgDELETEREASON: doc[Dbkeys.tktMsgDELETEREASON],
      tktMsgDELETEDby: doc[Dbkeys.tktMsgDELETEDby],
      ttktMsgString3: doc[Dbkeys.tktMsgString3],
      tktMsgString4: doc[Dbkeys.tktMsgString4],
      tktMsgString5: doc[Dbkeys.tktMsgString5],
      notificationActiveList: doc[Dbkeys.notificationActiveList],
      tktMsgList2: doc[Dbkeys.tktMsgList2],
      tktMsgList3: doc[Dbkeys.tktMsgList3],
      tktMsgSenderIndex: doc[Dbkeys.tktMsgSenderIndex],
      tktMsgInt2: doc[Dbkeys.tktMsgInt2],
      isShowSenderNameInNotification:
          doc[Dbkeys.isShowSenderNameInNotification],
      tktMsgBool2: doc[Dbkeys.tktMsgBool2],
      tktMsgMap1: doc[Dbkeys.tktMsgMap1],
      tktMsgMap2: doc[Dbkeys.tktMsgMap2],
    );
  }
  factory TicketMessage.fromSnapshot(DocumentSnapshot doc) {
    return TicketMessage(
      tktMssgCONTENT: doc[Dbkeys.tktMssgCONTENT],
      tktMssgISDELETED: doc[Dbkeys.tktMssgISDELETED],
      tktMssgTIME: doc[Dbkeys.tktMssgTIME],
      tktMssgTYPE: doc[Dbkeys.tktMssgTYPE],
      tktMsgCUSTOMERID: doc[Dbkeys.tktMsgCUSTOMERID],
      tktMssgLISToptional: doc[Dbkeys.tktMssgLISToptional],
      tktMssgSENDBY: doc[Dbkeys.tktMssgSENDBY],
      tktMssgSENDFOR: doc[Dbkeys.tktMssgSENDFOR],
      tktMssgISREPLY: doc[Dbkeys.tktMssgISREPLY],
      tktMssgREPLYTOMSSGDOC: doc[Dbkeys.tktMssgREPLYTOMSSGDOC],
      tktMssgISFORWARD: doc[Dbkeys.tktMssgISFORWARD],
      tktMssgTicketName: doc[Dbkeys.tktMssgTicketName],
      tktMssgTicketIDflitered: doc[Dbkeys.tktMssgTicketIDflitered],
      tktMssgSENDERNAME: doc[Dbkeys.tktMssgSENDERNAME],
      tktMsgDELETEREASON: doc[Dbkeys.tktMsgDELETEREASON],
      tktMsgDELETEDby: doc[Dbkeys.tktMsgDELETEDby],
      ttktMsgString3: doc[Dbkeys.tktMsgString3],
      tktMsgString4: doc[Dbkeys.tktMsgString4],
      tktMsgString5: doc[Dbkeys.tktMsgString5],
      notificationActiveList: doc[Dbkeys.notificationActiveList],
      tktMsgList2: doc[Dbkeys.tktMsgList2],
      tktMsgList3: doc[Dbkeys.tktMsgList3],
      tktMsgSenderIndex: doc[Dbkeys.tktMsgSenderIndex],
      tktMsgInt2: doc[Dbkeys.tktMsgInt2],
      isShowSenderNameInNotification:
          doc[Dbkeys.isShowSenderNameInNotification],
      tktMsgBool2: doc[Dbkeys.tktMsgBool2],
      tktMsgMap1: doc[Dbkeys.tktMsgMap1],
      tktMsgMap2: doc[Dbkeys.tktMsgMap2],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Dbkeys.tktMssgCONTENT: tktMssgCONTENT,
      Dbkeys.tktMssgISDELETED: tktMssgISDELETED,
      Dbkeys.tktMssgTIME: tktMssgTIME,
      Dbkeys.tktMssgTYPE: tktMssgTYPE,
      Dbkeys.tktMsgCUSTOMERID: tktMsgCUSTOMERID,
      Dbkeys.tktMssgLISToptional: tktMssgLISToptional,
      Dbkeys.tktMssgSENDBY: tktMssgSENDBY,
      Dbkeys.tktMssgSENDFOR: tktMssgSENDFOR,
      Dbkeys.tktMssgISREPLY: tktMssgISREPLY,
      Dbkeys.tktMssgREPLYTOMSSGDOC: tktMssgREPLYTOMSSGDOC,
      Dbkeys.tktMssgISFORWARD: tktMssgISFORWARD,
      Dbkeys.tktMssgTicketName: tktMssgTicketName,
      Dbkeys.tktMssgTicketIDflitered: tktMssgTicketIDflitered,
      Dbkeys.tktMssgSENDERNAME: tktMssgSENDERNAME,
      Dbkeys.tktMsgDELETEREASON: tktMsgDELETEREASON,
      Dbkeys.tktMsgDELETEDby: tktMsgDELETEDby,
      Dbkeys.tktMsgString3: ttktMsgString3,
      Dbkeys.tktMsgString4: tktMsgString4,
      Dbkeys.tktMsgString5: tktMsgString5,
      Dbkeys.notificationActiveList: notificationActiveList,
      Dbkeys.tktMsgList2: tktMsgList2,
      Dbkeys.tktMsgList3: tktMsgList3,
      Dbkeys.tktMsgSenderIndex: tktMsgSenderIndex,
      Dbkeys.tktMsgInt2: tktMsgInt2,
      Dbkeys.isShowSenderNameInNotification: isShowSenderNameInNotification,
      Dbkeys.tktMsgBool2: tktMsgBool2,
      Dbkeys.tktMsgMap1: tktMsgMap1,
      Dbkeys.tktMsgMap2: tktMsgMap2,
    };
  }
}
