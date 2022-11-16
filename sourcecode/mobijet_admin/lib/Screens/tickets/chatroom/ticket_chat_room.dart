//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Models/ticket_message.dart';
import 'package:thinkcreative_technologies/Models/ticket_model.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/TicketUtils/ticket_utils.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/ticket_chat_room_details.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/isRoboticResponse.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/messageTypeWidgets/close_message.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/messageTypeWidgets/created_message.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/messageTypeWidgets/deniedclosingrequest_message.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/messageTypeWidgets/removeattention_message.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/messageTypeWidgets/reopen_message.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/messageTypeWidgets/requestclose_message.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/messageTypeWidgets/requireattention_message.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/ticketStatus.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/ticket_chat_bubble.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseApi.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Services/my_providers/liveListener.dart';
import 'package:thinkcreative_technologies/Services/my_providers/TicketChatProvider.dart';
import 'package:thinkcreative_technologies/Utils/color_light_dark.dart';
import 'package:thinkcreative_technologies/Utils/custom_url_launcher.dart';
import 'package:thinkcreative_technologies/Utils/downloadMedia.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Widgets/InfiniteCOLLECTIONListViewWidget.dart';
import 'package:thinkcreative_technologies/Widgets/MultiPlayback/soundPlayerPro.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/customCircleAvatars.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dynamic_modal_bottomsheet.dart';
import 'package:thinkcreative_technologies/Widgets/late_load.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Widgets/pdf_viewer/PdfViewFromCachedUrl.dart';
import 'package:thinkcreative_technologies/Widgets/photo_view.dart';
import 'package:thinkcreative_technologies/Widgets/pickers/VideoPicker/VideoPreview.dart';
import 'package:thinkcreative_technologies/Widgets/timeWidgets/getwhen.dart';
import 'package:thinkcreative_technologies/widgets/WarningWidgets/warning_tile.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';

class TicketChatRoom extends StatefulWidget {
  // final String currentUserID;
  final String ticketID;
  final String customerUID;
  // final SharedPreferences prefs;
  final MessageType? sharedFilestype;
  final bool isSharingIntentForwarded;
  final String? sharedText;
  final String currentuserfullname;
  final bool cuurentUserCanSeeCustomerNamePhoto;
  final bool cuurentUserCanSeeAgentNamePhoto;
  final String? ticketTitle;

  final List<dynamic> agentsListinParticularDepartment;

  TicketChatRoom({
    Key? key,
    // required this.currentUserID,
    required this.ticketID,
    required this.customerUID,
    // required this.prefs,
    required this.cuurentUserCanSeeAgentNamePhoto,
    required this.cuurentUserCanSeeCustomerNamePhoto,
    required this.currentuserfullname,
    required this.isSharingIntentForwarded,
    required this.agentsListinParticularDepartment,
    this.ticketTitle,
    this.sharedFilestype,
    this.sharedText,
  }) : super(key: key);

  @override
  _TicketChatRoomState createState() => _TicketChatRoomState();
}

class _TicketChatRoomState extends State<TicketChatRoom>
    with WidgetsBindingObserver {
  TextEditingController _controller = new TextEditingController();
  bool isgeneratingSomethingLoader = false;
  int tempSendIndex = 0;
  late String messageReplyOwnerName;
  bool isPreLoading = false;
  late Query firestoreChatquery;
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  GlobalKey<State> _keyLoader =
      new GlobalKey<State>(debugLabel: 'qqqeqeqsssaadqeqe');
  final ScrollController realtime = new ScrollController();
  Map<String, dynamic>? replyDoc;
  bool isReplyKeyboard = false;

  late Stream<DocumentSnapshot> streamTicketSnapshots;
  late Stream<DocumentSnapshot> customerLiveSnapshots;
  bool isSecretChat = false;
  int finalrating = 0;

  StreamController<String> controller = StreamController();

  @override
  void initState() {
    super.initState();

    streamTicketSnapshots = FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(widget.ticketID)
        .snapshots();
    customerLiveSnapshots = FirebaseFirestore.instance
        .collection(DbPaths.collectioncustomers)
        .doc(widget.customerUID)
        .snapshots();
    firestoreChatquery = FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(widget.ticketID)
        .collection(DbPaths.collectionticketChats)
        .orderBy(Dbkeys.tktMssgTIME, descending: true)
        .limit(20 * 1);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var firestoreProvider =
          Provider.of<FirestoreDataProviderMESSAGESforTICKETCHAT>(this.context,
              listen: false);

      firestoreProvider.reset();
      Future.delayed(const Duration(milliseconds: 1700), () {
        loadMessagesAndListen();
      });
    });
    // Future.delayed(const Duration(milliseconds: 200), () {
    //   isPreLoading = false;
    // });
  }

  // ignore: cancel_subscriptions
  StreamSubscription<QuerySnapshot>? subscription;
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  loadMessagesAndListen() async {
    subscription = firestoreChatquery.snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          var chatprovider =
              Provider.of<FirestoreDataProviderMESSAGESforTICKETCHAT>(
                  this.context,
                  listen: false);
          DocumentSnapshot newDoc = change.doc;
          // if (chatprovider.datalistSnapshot.length == 0) {
          // } else if ((chatprovider.checkIfDocAlreadyExits(
          //       newDoc: newDoc,
          //     ) ==
          //     false)) {

          // if (newmssg.tktMssgSENDBY != widget.currentUserID) {
          chatprovider.addDoc(newDoc);
          // unawaited(realtime.animateTo(0.0,
          //     duration: Duration(milliseconds: 300), curve: Curves.easeOut));
          // }
          // }
        } else if (change.type == DocumentChangeType.modified) {
          var chatprovider =
              Provider.of<FirestoreDataProviderMESSAGESforTICKETCHAT>(
                  this.context,
                  listen: false);
          DocumentSnapshot updatedDoc = change.doc;
          if (chatprovider.checkIfDocAlreadyExits(
                  newDoc: updatedDoc,
                  timestamp: updatedDoc[Dbkeys.tktMssgTIME]) ==
              true) {
            chatprovider.updateparticulardocinProvider(updatedDoc: updatedDoc);
          }
        } else if (change.type == DocumentChangeType.removed) {
          var chatprovider =
              Provider.of<FirestoreDataProviderMESSAGESforTICKETCHAT>(
                  this.context,
                  listen: false);
          DocumentSnapshot deletedDoc = change.doc;
          if (chatprovider.checkIfDocAlreadyExits(
                  newDoc: deletedDoc,
                  timestamp: deletedDoc[Dbkeys.tktMssgTIME]) ==
              true) {
            chatprovider.deleteparticulardocinProvider(deletedDoc: deletedDoc);
          }
        }
      });
    });

    setStateIfMounted(() {});
  }

  void setStateIfMounted(f) {
    if (mounted == true) {
      setState(f);
    }
  }

  @override
  void dispose() {
    subscription!.cancel();
    _controller.dispose();
    controller.close();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  File? pickedFile;
  File? thumbnailFile;

  bool isAmTyping = false;
  final TextEditingController textEditingController =
      new TextEditingController();
  final TextEditingController attentionMessageController =
      new TextEditingController();

  final TextEditingController feedbacktextEditingController =
      new TextEditingController();
  FocusNode keyboardFocusNode = new FocusNode();

  buildEachMessage(TicketMessage mssg, TicketModel tkt) {
    if (mssg.tktMssgTYPE == MessageType.rROBOTdepartmentChanged.index) {
      return buildDepartmentChanged(mssg, tkt);
    } else if (mssg.tktMssgTYPE ==
        MessageType.rROBOTassignAgentForACustomerCall.index) {
      return buildAssignCallMessage(mssg, tkt);
    } else if (mssg.tktMssgTYPE ==
        MessageType.rROBOTremoveAssignAgentForACustomerCall.index) {
      return buildRemoveCallAssignMessage(mssg, tkt);
    } else if (mssg.tktMssgTYPE == MessageType.rROBOTcallHistory.index) {
      return buildCallHistoryMessage(mssg, tkt);
    } else if (mssg.tktMssgTYPE == MessageType.image.index ||
        mssg.tktMssgTYPE == MessageType.doc.index ||
        mssg.tktMssgTYPE == MessageType.text.index ||
        mssg.tktMssgTYPE == MessageType.video.index ||
        mssg.tktMssgTYPE == MessageType.audio.index ||
        mssg.tktMssgTYPE == MessageType.contact.index ||
        mssg.tktMssgTYPE == MessageType.location.index) {
      return mssg.tktMssgCONTENT == ''
          ? buildMediaMessages(mssg, tkt)
          : buildMediaMessages(mssg, tkt);
    } else if (mssg.tktMssgTYPE == MessageType.rROBOTticketclosed.index) {
      return getTicketClosedMessage(
          context: this.context,
          mssg: mssg,
          customerUID: widget.customerUID,
          cuurentUserCanSeeAgentNamePhoto:
              widget.cuurentUserCanSeeAgentNamePhoto);
    } else if (mssg.tktMssgTYPE == MessageType.rROBOTticketreopened.index) {
      return getTicketReopenedMessage(
          context: this.context,
          mssg: mssg,
          customerUID: widget.customerUID,
          cuurentUserCanSeeAgentNamePhoto:
              widget.cuurentUserCanSeeAgentNamePhoto);
    } else if (mssg.tktMssgTYPE == MessageType.rROBOTrequestedtoclose.index) {
      return getTicketRequestCloseMessage(
          context: this.context,
          mssg: mssg,
          customerUID: widget.customerUID,
          cuurentUserCanSeeAgentNamePhoto:
              widget.cuurentUserCanSeeAgentNamePhoto);
    } else if (mssg.tktMssgTYPE == MessageType.rROBOTrequireattention.index) {
      return getTicketRequireAttentionMessage(
          context: this.context,
          mssg: mssg,
          customerUID: widget.customerUID,
          cuurentUserCanSeeAgentNamePhoto:
              widget.cuurentUserCanSeeAgentNamePhoto);
    } else if (mssg.tktMssgTYPE == MessageType.rROBOTremovettention.index) {
      return getTicketRemoveAttentionMessage(
          context: this.context,
          mssg: mssg,
          customerUID: widget.customerUID,
          cuurentUserCanSeeAgentNamePhoto:
              widget.cuurentUserCanSeeAgentNamePhoto);
    } else if (mssg.tktMssgTYPE == MessageType.rROBOTticketcreated.index) {
      return getTicketCreatedMessage(
          title: widget.ticketTitle ?? "",
          context: this.context,
          mssg: mssg,
          customerUID: widget.customerUID,
          cuurentUserCanSeeAgentNamePhoto:
              widget.cuurentUserCanSeeAgentNamePhoto);
    } else if (mssg.tktMssgTYPE ==
            MessageType.rROBOTclosingDeniedByCustomer.index ||
        mssg.tktMssgTYPE == MessageType.rROBOTclosingDeniedByAgent.index) {
      return getTicketClosingRequestDenied(
          context: this.context,
          mssg: mssg,
          customerUID: widget.customerUID,
          cuurentUserCanSeeAgentNamePhoto:
              widget.cuurentUserCanSeeAgentNamePhoto);
    } else {
      return Text(mssg.tktMssgCONTENT);
    }
  }

  onDismiss(
    TicketMessage mssg,
  ) {
    // if ((mssg.tktMssgCONTENT == '') == false) {
    //   setStateIfMounted(() {
    //     isReplyKeyboard = true;
    //     replyDoc = mssg.toMap();
    //     messageReplyOwnerName = mssg.tktMssgSENDBY.toString();
    //   });
    //   HapticFeedback.heavyImpact();
    //   keyboardFocusNode.requestFocus();
    // }
  }

  contextMenu(BuildContext context, TicketMessage mssg, {bool saved = false}) {
    HapticFeedback.heavyImpact();
    ShowConfirmWithInputTextDialog().open(
        context: context,
        controller: _controller,
        title:
            "${getTranslatedForCurrentUser(context, 'xxdeletexx')} ${getTranslatedForCurrentUser(context, 'xxmssgxx')}",
        subtitle: getTranslatedForCurrentUser(
                context, 'xxxxcannotseethimssgxxx')
            .replaceAll('(####)',
                '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}')
            .replaceAll('(###)',
                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
        rightbtntext:
            getTranslatedForCurrentUser(context, 'xxdeletexx').toUpperCase(),
        rightbtnonpress: () async {
          Navigator.of(context).pop();
          ShowLoading().open(context: context, key: _keyLoader);
          await FirebaseFirestore.instance
              .collection(DbPaths.collectiontickets)
              .doc(widget.ticketID)
              .collection(DbPaths.collectionticketChats)
              .doc(mssg.tktMssgTIME.toString() + "--" + mssg.tktMssgSENDBY)
              .update({
            Dbkeys.tktMssgISDELETED: true,
            Dbkeys.tktMsgDELETEREASON: _controller.text.trim().length < 1
                ? ""
                : _controller.text.trim(),
            Dbkeys.tktMsgDELETEDby: Optionalconstants.currentAdminID,
          }).then((value) {
            ShowLoading().close(context: context, key: _keyLoader);
            Utils.toast(
                getTranslatedForCurrentUser(context, 'xxmsgdltdbyadminxx'));
          }).catchError((e) {
            ShowLoading().close(context: context, key: _keyLoader);
            Utils.toast(
                "${getTranslatedForCurrentUser(context, 'xxfailedxx')}   ERROR: $e");
          });
        });
  }

  // }else if (mssg.tktMssgTYPE == MessageType.rROBOTremoveAssignAgentForACustomerCall.index) {
  //   return buildRemoveCallAssignMessage(mssg, tkt);

  Widget buildDepartmentChanged(
    TicketMessage mssg,
    TicketModel tkt,
  ) {
    final registry = Provider.of<UserRegistry>(this.context, listen: false);
    bool is24hrsFormat = true;
    humanReadableTime() =>
        DateFormat(is24hrsFormat == true ? 'HH:mm' : 'h:mm a')
            .format(DateTime.fromMillisecondsSinceEpoch(mssg.tktMssgTIME));
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(this.context).size.width / 1.3,
            padding: EdgeInsets.fromLTRB(12, 7, 12, 7),
            decoration: BoxDecoration(
                color: Color(0xff3d297a),
                border: Border.all(
                  color: Color(0xff3d297a),
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: MtCustomfontBoldSemi(
              color: Colors.yellowAccent.withOpacity(0.9),
              textalign: TextAlign.center,
              lineheight: 1.3,
              fontsize: 13,
              text: getTranslatedForCurrentUser(context, 'xxchangedfromxx')
                  .replaceAll('(####)',
                      '${getTranslatedForCurrentUser(context, 'xxtktsx')} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                  .replaceAll('(###)',
                      '${mssg.tktMssgCONTENT.split('-xx-').toList()[1]}')
                  .replaceAll('(##)',
                      '${mssg.tktMssgCONTENT.split('-xx-').toList()[0]}'),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                mssg.tktMssgSENDBY == widget.customerUID
                    ? SizedBox()
                    : Icon(
                        Icons.person,
                        color: Mycolors.greytext,
                        size: 12,
                      ),
                mssg.tktMssgSENDBY == widget.customerUID
                    ? SizedBox()
                    : Text(
                        widget.cuurentUserCanSeeAgentNamePhoto
                            ? "  ${registry.getUserData(this.context, mssg.tktMssgSENDBY).fullname}"
                            : "  ${getTranslatedForCurrentUser(context, 'xxagentidxx')} ${registry.getUserData(this.context, mssg.tktMssgSENDBY).id}",
                        style:
                            TextStyle(fontSize: 12, color: Mycolors.greytext),
                      ),
                mssg.tktMssgSENDBY == widget.customerUID
                    ? SizedBox()
                    : SizedBox(
                        width: 30,
                      ),
                Text(
                    getWhen(
                          DateTime.fromMillisecondsSinceEpoch(mssg.tktMssgTIME),
                        ) +
                        ', ',
                    style: TextStyle(
                      color: Mycolors.greytext,
                      fontSize: 11.0,
                    )),
                Text(' ' + humanReadableTime().toString(),
                    style: TextStyle(
                      color: Mycolors.greytext,
                      fontSize: 11.0,
                    )),
                // isMe ? icon : SizedBox()
                // ignore: unnecessary_null_comparison
              ].where((o) => o != null).toList()),
          SizedBox(
            height: 15,
          ),
        ]);
  }

  Widget buildAssignCallMessage(
    TicketMessage mssg,
    TicketModel tkt,
  ) {
    final registry = Provider.of<UserRegistry>(this.context, listen: false);
    bool is24hrsFormat = true;
    humanReadableTime() =>
        DateFormat(is24hrsFormat == true ? 'HH:mm' : 'h:mm a')
            .format(DateTime.fromMillisecondsSinceEpoch(mssg.tktMssgTIME));
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(this.context).size.width / 1.3,
            padding: EdgeInsets.fromLTRB(12, 7, 12, 7),
            decoration: BoxDecoration(
                color: Color(0xff8fffe0),
                border: Border.all(
                  color: Color(0xff8fffe0),
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: MtCustomfontBoldSemi(
                color: Color(0xff0f267d),
                textalign: TextAlign.center,
                lineheight: 1.3,
                fontsize: 13,
                text: getTranslatedForCurrentUser(
                        this.context, 'xxassignedforcall')
                    .replaceAll(
                        '(####)',
                        getTranslatedForCurrentUser(
                                this.context, 'xxagentidxx') +
                            " ${mssg.tktMssgCONTENT}")
                    .replaceAll(
                        '(###)',
                        getTranslatedForCurrentUser(
                            this.context, 'xxcustomerxx'))),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                mssg.tktMssgSENDBY == widget.customerUID
                    ? SizedBox()
                    : Icon(
                        Icons.person,
                        color: Mycolors.greytext,
                        size: 12,
                      ),
                mssg.tktMssgSENDBY == widget.customerUID
                    ? SizedBox()
                    : Text(
                        widget.cuurentUserCanSeeAgentNamePhoto
                            ? "  ${registry.getUserData(this.context, mssg.tktMssgSENDBY).fullname}"
                            : "  ${getTranslatedForCurrentUser(this.context, 'xxagentidxx')} ${registry.getUserData(this.context, mssg.tktMssgSENDBY).id}",
                        style:
                            TextStyle(fontSize: 12, color: Mycolors.greytext),
                      ),
                mssg.tktMssgSENDBY == widget.customerUID
                    ? SizedBox()
                    : SizedBox(
                        width: 30,
                      ),
                Text(
                    getWhen(
                          DateTime.fromMillisecondsSinceEpoch(mssg.tktMssgTIME),
                        ) +
                        ', ',
                    style: TextStyle(
                      color: Mycolors.greytext,
                      fontSize: 11.0,
                    )),
                Text(' ' + humanReadableTime().toString(),
                    style: TextStyle(
                      color: Mycolors.greytext,
                      fontSize: 11.0,
                    )),
                // isMe ? icon : SizedBox()
                // ignore: unnecessary_null_comparison
              ].where((o) => o != null).toList()),
          SizedBox(
            height: 15,
          ),
        ]);
  }

  Widget buildRemoveCallAssignMessage(
    TicketMessage mssg,
    TicketModel tkt,
  ) {
    final registry = Provider.of<UserRegistry>(this.context, listen: false);
    bool is24hrsFormat = true;
    humanReadableTime() =>
        DateFormat(is24hrsFormat == true ? 'HH:mm' : 'h:mm a')
            .format(DateTime.fromMillisecondsSinceEpoch(mssg.tktMssgTIME));
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
              width: MediaQuery.of(this.context).size.width / 1.3,
              padding: EdgeInsets.fromLTRB(12, 7, 12, 7),
              decoration: BoxDecoration(
                  color: Color(0xffffccff),
                  border: Border.all(
                    color: Color(0xffffccff),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: MtCustomfontBoldSemi(
                  color: Color(0xff660066),
                  textalign: TextAlign.center,
                  lineheight: 1.3,
                  fontsize: 13,
                  text: getTranslatedForCurrentUser(
                          context, 'xxaremovedorcalllong')
                      .replaceAll(
                          '(####)',
                          getTranslatedForCurrentUser(context, 'xxagentidxx') +
                              " ${mssg.tktMssgCONTENT}")
                      .replaceAll(
                          '(###)',
                          getTranslatedForCurrentUser(
                              context, 'xxcustomerxx')))),
          SizedBox(
            height: 5,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                mssg.tktMssgSENDBY == widget.customerUID
                    ? SizedBox()
                    : Icon(
                        Icons.person,
                        color: Mycolors.greytext,
                        size: 12,
                      ),
                mssg.tktMssgSENDBY == widget.customerUID
                    ? SizedBox()
                    : Text(
                        widget.cuurentUserCanSeeAgentNamePhoto
                            ? "  ${registry.getUserData(this.context, mssg.tktMssgSENDBY).fullname}"
                            : "  ${getTranslatedForCurrentUser(context, 'xxagentidxx')} ${registry.getUserData(this.context, mssg.tktMssgSENDBY).id}",
                        style:
                            TextStyle(fontSize: 12, color: Mycolors.greytext),
                      ),
                mssg.tktMssgSENDBY == widget.customerUID
                    ? SizedBox()
                    : SizedBox(
                        width: 30,
                      ),
                Text(
                    getWhen(
                          DateTime.fromMillisecondsSinceEpoch(mssg.tktMssgTIME),
                        ) +
                        ', ',
                    style: TextStyle(
                      color: Mycolors.greytext,
                      fontSize: 11.0,
                    )),
                Text(' ' + humanReadableTime().toString(),
                    style: TextStyle(
                      color: Mycolors.greytext,
                      fontSize: 11.0,
                    )),
                // isMe ? icon : SizedBox()
                // ignore: unnecessary_null_comparison
              ].where((o) => o != null).toList()),
          SizedBox(
            height: 15,
          ),
        ]);
  }

  Widget buildCallHistoryMessage(
    TicketMessage mssg,
    TicketModel tkt,
  ) {
    final registry = Provider.of<UserRegistry>(this.context, listen: false);
    bool is24hrsFormat = true;
    humanReadableTime() =>
        DateFormat(is24hrsFormat == true ? 'HH:mm' : 'h:mm a')
            .format(DateTime.fromMillisecondsSinceEpoch(mssg.tktMssgTIME));
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xffe0f5ff),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: EdgeInsets.all(9),
            width: MediaQuery.of(this.context).size.width / 1.7,
            child: Center(
              child: futureLoad(
                  future: FirebaseFirestore.instance
                      .collection(DbPaths.collectionagents)
                      .doc(mssg.tktMsgDELETEREASON)
                      .collection(DbPaths.collectioncallhistory)
                      .doc(mssg.tktMssgTIME.toString())
                      .get(),
                  placeholder: Center(
                    child: MtCustomfontBoldSemi(
                        fontsize: 12,
                        color: Mycolors.grey,
                        text: mssg.tktMssgSENDBY == widget.customerUID
                            ? getTranslatedForCurrentUser(
                                    this.context, 'xxcallbyxxtoxx')
                                .replaceAll(
                                    '(####)',
                                    getTranslatedForCurrentUser(
                                        this.context, 'xxcustomerxx'))
                                .replaceAll(
                                    '(###)',
                                    getTranslatedForCurrentUser(
                                            this.context, 'xxagentidxx') +
                                        " ${mssg.tktMsgDELETEREASON}")
                            : getTranslatedForCurrentUser(
                                    this.context, 'xxcallbyxxtoxx')
                                .replaceAll(
                                    '(###)',
                                    getTranslatedForCurrentUser(
                                        this.context, 'xxcustomerxx'))
                                .replaceAll(
                                    '(####)',
                                    getTranslatedForCurrentUser(
                                            this.context, 'xxagentidxx') +
                                        " ${mssg.tktMsgDELETEREASON}")),
                  ),
                  onfetchdone: (dc) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MtCustomfontBoldSemi(
                          color: Mycolors.grey,
                          fontsize: 12,
                          text: mssg.tktMssgSENDBY == widget.customerUID
                              ? getTranslatedForCurrentUser(
                                      this.context, 'xxcallbyxxtoxx')
                                  .replaceAll(
                                      '(####)',
                                      getTranslatedForCurrentUser(
                                          this.context, 'xxcustomerxx'))
                                  .replaceAll(
                                      '(###)',
                                      getTranslatedForCurrentUser(
                                              this.context, 'xxagentidxx') +
                                          " ${mssg.tktMsgDELETEREASON}")
                              : getTranslatedForCurrentUser(
                                      this.context, 'xxcallbyxxtoxx')
                                  .replaceAll(
                                      '(###)',
                                      getTranslatedForCurrentUser(
                                          this.context, 'xxcustomerxx'))
                                  .replaceAll(
                                      '(####)',
                                      getTranslatedForCurrentUser(
                                              this.context, 'xxagentidxx') +
                                          " ${mssg.tktMsgDELETEREASON}"),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              dc['ISVIDEOCALL'] == true
                                  ? Icons.video_call
                                  : Icons.call,
                              color: Mycolors.primary,
                              size: 18,
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Icon(
                              dc['TYPE'] == 'INCOMING'
                                  ? (dc['STARTED'] == null
                                      ? Icons.call_missed
                                      : Icons.call_received)
                                  : (dc['STARTED'] == null
                                      ? Icons.call_made_rounded
                                      : Icons.call_made_rounded),
                              size: 15,
                              color: dc['TYPE'] == 'INCOMING'
                                  ? (dc['STARTED'] == null
                                      ? Colors.redAccent
                                      : Mycolors.secondary)
                                  : (dc['STARTED'] == null
                                      ? Colors.redAccent
                                      : Mycolors.secondary),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            dc['STARTED'] == null || dc['ENDED'] == null
                                ? SizedBox(
                                    height: 0,
                                    width: 0,
                                  )
                                : Container(
                                    padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                    decoration: BoxDecoration(
                                        color: Mycolors.secondary,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Text(
                                      dc['ENDED']
                                                  .toDate()
                                                  .difference(
                                                      dc['STARTED'].toDate())
                                                  .inMinutes <
                                              1
                                          ? dc['ENDED']
                                                  .toDate()
                                                  .difference(
                                                      dc['STARTED'].toDate())
                                                  .inSeconds
                                                  .toString() +
                                              's'
                                          : dc['ENDED']
                                                  .toDate()
                                                  .difference(
                                                      dc['STARTED'].toDate())
                                                  .inMinutes
                                                  .toString() +
                                              'm',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  )
                          ],
                        ),
                      ],
                    );
                  }),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                mssg.tktMssgSENDBY == widget.customerUID
                    ? SizedBox()
                    : Icon(
                        Icons.person,
                        color: Mycolors.greytext,
                        size: 12,
                      ),
                mssg.tktMssgSENDBY == widget.customerUID
                    ? SizedBox()
                    : Text(
                        widget.cuurentUserCanSeeAgentNamePhoto
                            ? "  ${registry.getUserData(this.context, mssg.tktMssgSENDBY).fullname}"
                            : "  ${getTranslatedForCurrentUser(context, 'xxagentidxx')} ${registry.getUserData(this.context, mssg.tktMssgSENDBY).id}",
                        style:
                            TextStyle(fontSize: 12, color: Mycolors.greytext),
                      ),
                mssg.tktMssgSENDBY == widget.customerUID
                    ? SizedBox()
                    : SizedBox(
                        width: 30,
                      ),
                Text(
                    getWhen(
                          DateTime.fromMillisecondsSinceEpoch(mssg.tktMssgTIME),
                        ) +
                        ', ',
                    style: TextStyle(
                      color: Mycolors.greytext,
                      fontSize: 11.0,
                    )),
                Text(' ' + humanReadableTime().toString(),
                    style: TextStyle(
                      color: Mycolors.greytext,
                      fontSize: 11.0,
                    )),
                // isMe ? icon : SizedBox()
                // ignore: unnecessary_null_comparison
              ].where((o) => o != null).toList()),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget buildMediaMessages(
    TicketMessage mssg,
    TicketModel tkt,
  ) {
    bool isMe = mssg.tktMssgSENDBY != widget.customerUID;
    bool saved = false;
    final registry = Provider.of<UserRegistry>(this.context, listen: false);

    return InkWell(
      onLongPress: mssg.tktMssgISDELETED == false
          ? () {
              contextMenu(this.context, mssg);
            }
          : null,
      child: TicketBubble(
        isHideAgentsNameToCustomer: true,
        isSecretMessage:
            !mssg.tktMssgSENDFOR.contains(MssgSendFor.customer.index),
        isRobotic: isRobotic(mssg.tktMssgTYPE),
        customerUID: widget.customerUID,
        mssg: mssg,
        is24hrsFormat: true,
        postedbyname: mssg.tktMssgSENDBY == "sys" ||
                mssg.tktMssgSENDBY == "Admin"
            ? "${getTranslatedForCurrentUser(context, 'xxadminxx')}"
            : widget.customerUID == mssg.tktMssgSENDBY
                ? widget.cuurentUserCanSeeCustomerNamePhoto
                    ? registry
                        .getUserData(this.context, mssg.tktMssgSENDBY)
                        .fullname
                    : "${getTranslatedForCurrentUser(context, 'xxcustomerxx')}"
                : widget.cuurentUserCanSeeAgentNamePhoto
                    ? registry
                        .getUserData(this.context, mssg.tktMssgSENDBY)
                        .fullname
                    : "${getTranslatedForCurrentUser(context, 'xxagentidxx')} ${mssg.tktMssgSENDBY}",
        postedbyUID: mssg.tktMssgSENDBY,
        messagetype: mssg.tktMssgISDELETED == true
            ? MessageType.text
            : mssg.tktMssgTYPE == MessageType.text.index
                ? MessageType.text
                : mssg.tktMssgTYPE == MessageType.contact.index
                    ? MessageType.contact
                    : mssg.tktMssgTYPE == MessageType.location.index
                        ? MessageType.location
                        : mssg.tktMssgTYPE == MessageType.image.index
                            ? MessageType.image
                            : mssg.tktMssgTYPE == MessageType.video.index
                                ? MessageType.video
                                : mssg.tktMssgTYPE == MessageType.doc.index
                                    ? MessageType.doc
                                    : mssg.tktMssgTYPE ==
                                            MessageType.audio.index
                                        ? MessageType.audio
                                        : MessageType.text,
        child: mssg.tktMssgISDELETED == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  mssg.tktMssgTYPE == MessageType.text.index
                      ? getTextMessage(isMe, mssg, saved)
                      : mssg.tktMssgTYPE == MessageType.location.index
                          ? getLocationMessage(mssg.tktMssgCONTENT, mssg,
                              saved: false)
                          : mssg.tktMssgTYPE == MessageType.doc.index
                              ? getDocmessage(
                                  this.context, mssg.tktMssgCONTENT, mssg,
                                  saved: false)
                              : mssg.tktMssgTYPE == MessageType.audio.index
                                  ? getAudiomessage(
                                      this.context, mssg.tktMssgCONTENT, mssg,
                                      isMe: isMe, saved: false)
                                  : mssg.tktMssgTYPE == MessageType.video.index
                                      ? getVideoMessage(this.context,
                                          mssg.tktMssgCONTENT, mssg,
                                          saved: false)
                                      : mssg.tktMssgTYPE ==
                                              MessageType.contact.index
                                          ? getContactMessage(this.context,
                                              mssg.tktMssgCONTENT, mssg,
                                              saved: false)
                                          : getImageMessage(
                                              mssg,
                                              saved: saved,
                                            ),
                  SizedBox(
                    height: 7,
                  ),
                  myinkwell(
                    onTap: () {
                      Utils.toast(
                        getTranslatedForCurrentUser(
                                context, 'xxxnolongervisiblexxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: lighten(Mycolors.pink, 0.3),
                      child: Text(
                        mssg.tktMsgDELETEDby == widget.customerUID
                            ? getTranslatedForCurrentUser(
                                    this.context, 'xxdeletedbyxx')
                                .replaceAll(
                                    '(####)',
                                    getTranslatedForCurrentUser(
                                        this.context, 'xxcustomerxx'))
                            : mssg.tktMsgDELETEDby == "Admin"
                                ? mssg.tktMsgDELETEREASON != ""
                                    ? getTranslatedForCurrentUser(this.context,
                                            'xxmsgdltdbyadminforreasonxx')
                                        .replaceAll('(####)',
                                            "${mssg.tktMsgDELETEREASON}")
                                    : getTranslatedForCurrentUser(
                                        this.context, 'xxmsgdltdbyadminxx')
                                : getTranslatedForCurrentUser(
                                        this.context, 'xxdeletedbyxx')
                                    .replaceAll(
                                        '(####)',
                                        getTranslatedForCurrentUser(
                                            this.context, 'xxagentxx')),
                        style: TextStyle(
                            color: Mycolors.pink,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
              )
            : mssg.tktMssgTYPE == MessageType.text.index
                ? getTextMessage(isMe, mssg, saved)
                : mssg.tktMssgTYPE == MessageType.location.index
                    ? getLocationMessage(mssg.tktMssgCONTENT, mssg,
                        saved: false)
                    : mssg.tktMssgTYPE == MessageType.doc.index
                        ? getDocmessage(this.context, mssg.tktMssgCONTENT, mssg,
                            saved: false)
                        : mssg.tktMssgTYPE == MessageType.audio.index
                            ? getAudiomessage(
                                this.context, mssg.tktMssgCONTENT, mssg,
                                isMe: isMe, saved: false)
                            : mssg.tktMssgTYPE == MessageType.video.index
                                ? getVideoMessage(
                                    this.context, mssg.tktMssgCONTENT, mssg,
                                    saved: false)
                                : mssg.tktMssgTYPE == MessageType.contact.index
                                    ? getContactMessage(
                                        this.context, mssg.tktMssgCONTENT, mssg,
                                        saved: false)
                                    : getImageMessage(
                                        mssg,
                                        saved: saved,
                                      ),
        isMe: isMe,
        delivered: true,
        isContinuing: true,
        timestamp: mssg.tktMssgTIME,
      ),
    );
  }

  Widget getVideoMessage(
      BuildContext context, String message, TicketMessage mssg,
      {bool saved = false}) {
    Map<dynamic, dynamic>? meta =
        jsonDecode((message.split('-BREAK-')[2]).toString());
    final bool isMe = mssg.tktMssgSENDBY != widget.customerUID;
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
              this.context,
              new MaterialPageRoute(
                  builder: (context) => new PreviewVideo(
                        isdownloadallowed: true,
                        filename: message.split('-BREAK-')[1],
                        id: null,
                        videourl: message.split('-BREAK-')[0],
                        aspectratio: meta!["width"] / meta["height"],
                      )));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mssg.tktMssgISFORWARD == true
                ? Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                        mainAxisAlignment: isMe == true
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FontAwesomeIcons.share,
                            size: 12,
                            color: Mycolors.grey.withOpacity(0.5),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                              getTranslatedForCurrentUser(
                                  context, 'xxforwardedxx'),
                              maxLines: 1,
                              style: TextStyle(
                                  color: Mycolors.grey.withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 13))
                        ]))
                : SizedBox(height: 0, width: 0),
            Container(
              color: Colors.blueGrey,
              width: 245,
              height: 245,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blueGrey[400]!),
                        ),
                      ),
                      width: 245,
                      height: 245,
                      padding: EdgeInsets.all(80.0),
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
                        width: 245,
                        height: 245,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(0.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                    ),
                    imageUrl: message.split('-BREAK-')[1],
                    width: 245,
                    height: 245,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    width: 245,
                    height: 245,
                  ),
                  Center(
                    child: Icon(Icons.play_circle_fill_outlined,
                        color: Colors.white70, size: 65),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getContactMessage(
      BuildContext context, String message, TicketMessage mssg,
      {bool saved = false}) {
    final bool isMe = mssg.tktMssgSENDBY != widget.customerUID;
    return SizedBox(
      width: 210,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mssg.tktMssgISFORWARD == true
              ? Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: isMe == true
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.share,
                          size: 12,
                          color: Mycolors.grey.withOpacity(0.5),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            getTranslatedForCurrentUser(
                                context, 'xxforwardedxx'),
                            maxLines: 1,
                            style: TextStyle(
                                color: Mycolors.grey.withOpacity(0.7),
                                fontStyle: FontStyle.italic,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 13))
                      ]))
              : SizedBox(height: 0, width: 0),
          ListTile(
            isThreeLine: false,
            leading: customCircleAvatar(url: null, radius: 20),
            title: Text(
              message.split('-BREAK-')[0],
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue[400]),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                message.split('-BREAK-')[1],
                style: TextStyle(
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
            ),
          ),

          // ignore: deprecated_member_use
        ],
      ),
    );
  }

  Widget getTextMessage(bool isMe, TicketMessage mssg, bool saved) {
    return mssg.tktMssgISREPLY == true
        ? Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              replyAttachedWidget(this.context, mssg.tktMssgREPLYTOMSSGDOC),
              SizedBox(
                height: 10,
              ),
              selectablelinkify(mssg.tktMssgCONTENT, 15.5, TextAlign.left),
            ],
          )
        : mssg.tktMssgISFORWARD == true
            ? Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      child: Row(
                          mainAxisAlignment: isMe == true
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        Icon(
                          FontAwesomeIcons.share,
                          size: 12,
                          color: Mycolors.grey.withOpacity(0.5),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            getTranslatedForCurrentUser(
                                context, 'xxforwardedxx'),
                            maxLines: 1,
                            style: TextStyle(
                                color: Mycolors.grey.withOpacity(0.7),
                                fontStyle: FontStyle.italic,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 13))
                      ])),
                  SizedBox(
                    height: 10,
                  ),
                  selectablelinkify(mssg.tktMssgCONTENT, 15.5, TextAlign.left)
                ],
              )
            : selectablelinkify(mssg.tktMssgCONTENT, 15.5, TextAlign.left);
  }

  Widget getLocationMessage(String? message, TicketMessage mssg,
      {bool saved = false}) {
    final bool isMe = mssg.tktMssgSENDBY != widget.customerUID;
    return InkWell(
      onTap: AppConstants.isdemomode == true
          ? () {
              Utils.toast(getTranslatedForCurrentUser(
                  context, 'xxxnotalwddemoxxaccountxx'));
            }
          : () {
              custom_url_launcher(message!);
            },
      child: mssg.tktMssgISFORWARD == true
          ? Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    child: Row(
                        mainAxisAlignment: isMe == true
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      Icon(
                        FontAwesomeIcons.share,
                        size: 12,
                        color: Mycolors.grey.withOpacity(0.5),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                          getTranslatedForCurrentUser(context, 'xxforwardedxx'),
                          maxLines: 1,
                          style: TextStyle(
                              color: Mycolors.grey.withOpacity(0.7),
                              fontStyle: FontStyle.italic,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 13))
                    ])),
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'assets/COMMON_ASSETS/mapview.jpg',
                  width: MediaQuery.of(this.context).size.width / 1.7,
                  height: (MediaQuery.of(this.context).size.width / 1.7) * 0.6,
                ),
              ],
            )
          : Image.asset(
              'assets/COMMON_ASSETS/mapview.jpg',
              width: MediaQuery.of(this.context).size.width / 1.7,
              height: (MediaQuery.of(this.context).size.width / 1.7) * 0.6,
            ),
    );
  }

  Widget getAudiomessage(
      BuildContext context, String message, TicketMessage mssg,
      {bool saved = false, bool isMe = true}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mssg.tktMssgISFORWARD == true
              ? Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: isMe == true
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.share,
                          size: 12,
                          color: Mycolors.grey.withOpacity(0.5),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            getTranslatedForCurrentUser(
                                context, 'xxforwardedxx'),
                            maxLines: 1,
                            style: TextStyle(
                                color: Mycolors.grey.withOpacity(0.7),
                                fontStyle: FontStyle.italic,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 13))
                      ]))
              : SizedBox(height: 0, width: 0),
          SizedBox(
            width: 200,
            height: 80,
            child: MultiPlayback(
              isMe: isMe,
              onTapDownloadFn: Platform.isIOS || Platform.isAndroid
                  ? () {
                      custom_url_launcher(message.split('-BREAK-')[0]);
                    }
                  : () async {
                      await downloadFile(
                        context: _scaffold.currentContext!,
                        fileName:
                            'Recording_' + message.split('-BREAK-')[1] + '.mp3',
                        isonlyview: false,
                        keyloader: _keyLoader,
                        uri: message.split('-BREAK-')[0],
                      );
                    },
              url: message.split('-BREAK-')[0],
            ),
          )
        ],
      ),
    );
  }

  Widget getDocmessage(BuildContext context, String message, TicketMessage mssg,
      {bool saved = false}) {
    final bool isMe = mssg.tktMssgSENDBY != widget.customerUID;
    return SizedBox(
      width: 220,
      height: 126,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mssg.tktMssgISFORWARD == true
              ? Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: isMe == true
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.share,
                          size: 12,
                          color: Mycolors.grey.withOpacity(0.5),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            getTranslatedForCurrentUser(
                                context, 'xxforwardedxx'),
                            maxLines: 1,
                            style: TextStyle(
                                color: Mycolors.grey.withOpacity(0.7),
                                fontStyle: FontStyle.italic,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 13))
                      ]))
              : SizedBox(height: 0, width: 0),
          ListTile(
            contentPadding: EdgeInsets.all(4),
            isThreeLine: false,
            leading: Container(
              decoration: BoxDecoration(
                color: Colors.yellow[800],
                borderRadius: BorderRadius.circular(7.0),
              ),
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.insert_drive_file,
                size: 25,
                color: Colors.white,
              ),
            ),
            title: Text(
              message.split('-BREAK-')[1],
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87),
            ),
          ),
          Divider(
            height: 3,
          ),
          message.split('-BREAK-')[1].endsWith('.pdf')
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (_) => PDFViewerCachedFromUrl(
                                title: message.split('-BREAK-')[1],
                                url: message.split('-BREAK-')[0],
                              ),
                            ),
                          );
                        },
                        child: Text(
                            getTranslatedForCurrentUser(context, 'xxpreviewxx'),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.blue[400]))),
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: Platform.isIOS || Platform.isAndroid
                            ? () {
                                custom_url_launcher(
                                    message.split('-BREAK-')[0]);
                              }
                            : () async {
                                await downloadFile(
                                  context: _scaffold.currentContext!,
                                  fileName: message.split('-BREAK-')[1],
                                  isonlyview: false,
                                  keyloader: _keyLoader,
                                  uri: message.split('-BREAK-')[0],
                                );
                              },
                        child: Text(
                            getTranslatedForCurrentUser(
                                context, 'xxdownloadxx'),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.blue[400]))),
                  ],
                )
              // ignore: deprecated_member_use
              : FlatButton(
                  onPressed: Platform.isIOS || Platform.isAndroid
                      ? () {
                          custom_url_launcher(message.split('-BREAK-')[0]);
                        }
                      : () async {
                          await downloadFile(
                            context: _scaffold.currentContext!,
                            fileName: message.split('-BREAK-')[1],
                            isonlyview: false,
                            keyloader: _keyLoader,
                            uri: message.split('-BREAK-')[0],
                          );
                        },
                  child: Text(
                      getTranslatedForCurrentUser(context, 'xxdownloadxx'),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.blue[400]))),
        ],
      ),
    );
  }

  Widget getImageMessage(TicketMessage mssg, {bool saved = false}) {
    final bool isMe = mssg.tktMssgSENDBY != widget.customerUID;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          mssg.tktMssgISFORWARD == true
              ? Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: isMe == true
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.share,
                          size: 12,
                          color: Mycolors.grey.withOpacity(0.5),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            getTranslatedForCurrentUser(
                                context, 'xxforwardedxx'),
                            maxLines: 1,
                            style: TextStyle(
                                color: Mycolors.grey.withOpacity(0.7),
                                fontStyle: FontStyle.italic,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 13))
                      ]))
              : SizedBox(height: 0, width: 0),
          InkWell(
            onTap: () => Navigator.push(
                this.context,
                MaterialPageRoute(
                  builder: (context) => PhotoViewWrapper(
                    keyloader: _keyLoader,
                    imageUrl: mssg.tktMssgCONTENT,
                    message: mssg.tktMssgCONTENT,
                    tag: mssg.tktMssgTIME.toString(),
                    imageProvider:
                        CachedNetworkImageProvider(mssg.tktMssgCONTENT),
                  ),
                )),
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: Center(
                  child: SizedBox(
                    height: 60.0,
                    width: 60.0,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueGrey[400]!),
                    ),
                  ),
                ),
                width: mssg.tktMssgCONTENT.contains('giphy') ? 160 : 245.0,
                height: mssg.tktMssgCONTENT.contains('giphy') ? 160 : 245.0,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              errorWidget: (context, str, error) => Material(
                child: Image.asset(
                  'assets/COMMON_ASSETS/img_not_available.jpeg',
                  width: mssg.tktMssgCONTENT.contains('giphy') ? 160 : 245.0,
                  height: mssg.tktMssgCONTENT.contains('giphy') ? 160 : 245.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              imageUrl: mssg.tktMssgCONTENT,
              width: mssg.tktMssgCONTENT.contains('giphy') ? 160 : 245.0,
              height: mssg.tktMssgCONTENT.contains('giphy') ? 160 : 245.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  replyAttachedWidget(BuildContext context, var doc) {
    return Flexible(
      child: Container(
          // width: 280,
          height: 70,
          margin: EdgeInsets.only(left: 0, right: 0),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.55),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Stack(
            children: [
              Container(
                  margin: EdgeInsetsDirectional.all(4),
                  decoration: BoxDecoration(
                      color: Mycolors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Row(children: [
                    Container(
                      decoration: BoxDecoration(
                        color: doc[Dbkeys.tktMssgSENDBY] != widget.customerUID
                            ? Mycolors.primary
                            : Colors.purple,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                      ),
                      height: 75,
                      width: 3.3,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Container(
                      padding: EdgeInsetsDirectional.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 30),
                            child: Text(
                              doc[Dbkeys.tktMssgSENDBY].toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: doc[Dbkeys.tktMssgSENDBY] !=
                                          widget.customerUID
                                      ? Mycolors.primary
                                      : Colors.purple),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          doc[Dbkeys.tktMssgTYPE] == MessageType.text.index
                              ? Text(
                                  doc[Dbkeys.tktMssgCONTENT],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                )
                              : doc[Dbkeys.tktMssgTYPE] == MessageType.doc.index
                                  ? Container(
                                      padding: const EdgeInsets.only(right: 75),
                                      child: Text(
                                        doc[Dbkeys.tktMssgCONTENT]
                                            .split('-BREAK-')[1],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    )
                                  : Text(
                                      doc[Dbkeys.tktMssgTYPE] ==
                                              MessageType.image.index
                                          ? getTranslatedForCurrentUser(
                                              context, 'xxnimxx')
                                          : doc[Dbkeys.tktMssgTYPE] ==
                                                  MessageType.video.index
                                              ? getTranslatedForCurrentUser(
                                                  context, 'xxnvmxx')
                                              : doc[Dbkeys.tktMssgTYPE] ==
                                                      MessageType.audio.index
                                                  ? getTranslatedForCurrentUser(
                                                      context, 'xxnamxx')
                                                  : doc[Dbkeys.tktMssgTYPE] ==
                                                          MessageType
                                                              .contact.index
                                                      ? getTranslatedForCurrentUser(
                                                          context, 'xxncmxx')
                                                      : doc[Dbkeys.tktMssgTYPE] ==
                                                              MessageType
                                                                  .location
                                                                  .index
                                                          ? getTranslatedForCurrentUser(
                                                              context,
                                                              'xxnlmxx')
                                                          : doc[Dbkeys.tktMssgTYPE] ==
                                                                  MessageType
                                                                      .doc.index
                                                              ? getTranslatedForCurrentUser(
                                                                  context,
                                                                  'xxndmxx')
                                                              : '',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                        ],
                      ),
                    ))
                  ])),
              doc[Dbkeys.tktMssgTYPE] == MessageType.text.index ||
                      doc[Dbkeys.tktMssgTYPE] == MessageType.location.index
                  ? SizedBox(
                      width: 0,
                      height: 0,
                    )
                  : doc[Dbkeys.tktMssgTYPE] == MessageType.image.index
                      ? Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: 74.0,
                            height: 74.0,
                            padding: EdgeInsetsDirectional.all(6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                  topLeft: Radius.circular(0),
                                  bottomLeft: Radius.circular(0)),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Mycolors.secondary),
                                  ),
                                  width: doc[Dbkeys.tktMssgCONTENT]
                                          .contains('giphy')
                                      ? 60
                                      : 60.0,
                                  height: doc[Dbkeys.tktMssgCONTENT]
                                          .contains('giphy')
                                      ? 60
                                      : 60.0,
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[200],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, str, error) => Material(
                                  child: Image.asset(
                                    'assets/COMMON_ASSETS/img_not_available.jpeg',
                                    width: 60.0,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                imageUrl: doc[Dbkeys.tktMssgTYPE] ==
                                        MessageType.video.index
                                    ? ''
                                    : doc[Dbkeys.tktMssgCONTENT],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : doc[Dbkeys.tktMssgTYPE] == MessageType.video.index
                          ? Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                  width: 74.0,
                                  height: 74.0,
                                  padding: EdgeInsetsDirectional.all(6),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                          topLeft: Radius.circular(0),
                                          bottomLeft: Radius.circular(0)),
                                      child: Container(
                                        color: Colors.blueGrey[200],
                                        height: 74,
                                        width: 74,
                                        child: Stack(
                                          children: [
                                            CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Container(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Mycolors.secondary),
                                                ),
                                                width: 74,
                                                height: 74,
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.blueGrey[200],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(0.0),
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, str, error) =>
                                                      Material(
                                                child: Image.asset(
                                                  'assets/COMMON_ASSETS/img_not_available.jpeg',
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(0.0),
                                                ),
                                                clipBehavior: Clip.hardEdge,
                                              ),
                                              imageUrl:
                                                  doc[Dbkeys.tktMssgCONTENT]
                                                      .split('-BREAK-')[1],
                                              width: 74,
                                              height: 74,
                                              fit: BoxFit.cover,
                                            ),
                                            Container(
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                              height: 74,
                                              width: 74,
                                            ),
                                            Center(
                                              child: Icon(
                                                  Icons
                                                      .play_circle_fill_outlined,
                                                  color: Colors.white70,
                                                  size: 25),
                                            ),
                                          ],
                                        ),
                                      ))))
                          : Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                  width: 74.0,
                                  height: 74.0,
                                  padding: EdgeInsetsDirectional.all(6),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                          topLeft: Radius.circular(0),
                                          bottomLeft: Radius.circular(0)),
                                      child: Container(
                                          color: doc[Dbkeys.tktMssgTYPE] ==
                                                  MessageType.doc.index
                                              ? Colors.yellow[800]
                                              : doc[Dbkeys.tktMssgTYPE] ==
                                                      MessageType.audio.index
                                                  ? Colors.green[400]
                                                  : doc[Dbkeys.tktMssgTYPE] ==
                                                          MessageType
                                                              .location.index
                                                      ? Colors.red[700]
                                                      : doc[Dbkeys.tktMssgTYPE] ==
                                                              MessageType
                                                                  .contact.index
                                                          ? Colors.blue[400]
                                                          : Colors.cyan[700],
                                          height: 74,
                                          width: 74,
                                          child: Icon(
                                            doc[Dbkeys.tktMssgTYPE] ==
                                                    MessageType.doc.index
                                                ? Icons.insert_drive_file
                                                : doc[Dbkeys.tktMssgTYPE] ==
                                                        MessageType.audio.index
                                                    ? Icons.mic_rounded
                                                    : doc[Dbkeys.tktMssgTYPE] ==
                                                            MessageType
                                                                .location.index
                                                        ? Icons.location_on
                                                        : doc[Dbkeys.tktMssgTYPE] ==
                                                                MessageType
                                                                    .contact
                                                                    .index
                                                            ? Icons
                                                                .contact_page_sharp
                                                            : Icons
                                                                .insert_drive_file,
                                            color: Colors.white,
                                            size: 35,
                                          ))))),
            ],
          )),
    );
  }

  Widget buildMessagesUsingProvider(
      BuildContext context, TicketModel currentTicket) {
    return Consumer<SpecialLiveConfigData?>(
        builder: (context, livedata, _child) =>
            Consumer<FirestoreDataProviderMESSAGESforTICKETCHAT>(
                builder: (context, firestoreDataProvider, _) =>
                    InfiniteCOLLECTIONListViewWidget(
                      scrollController: realtime,
                      isreverse: true,
                      firestoreDataProviderMESSAGESforTICKETCHAT:
                          firestoreDataProvider,
                      datatype: Dbkeys.datatypeTICKETMSSGS,
                      refdata: firestoreChatquery,
                      list: ListView.builder(
                          reverse: true,
                          padding: EdgeInsets.all(7),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: firestoreDataProvider.recievedDocs.length,
                          itemBuilder: (BuildContext context, int i) {
                            var dc = firestoreDataProvider.recievedDocs[i];

                            return buildEachMessage(
                                TicketMessage.fromJson(dc), currentTicket);
                          }),
                    )));
  }

  Widget buildLoadingThumbnail() {
    return Positioned(
      child: isgeneratingSomethingLoader
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Mycolors.secondary)),
              ),
              color: Colors.white.withOpacity(0.6),
            )
          : Container(),
    );
  }

  Future<bool> onWillPop() {
    if (isemojiShowing == true) {
      setStateIfMounted(() {
        isemojiShowing = false;
      });
      Future.value(false);
    } else {
      return Future.value(true);
    }
    return Future.value(false);
  }

  bool isemojiShowing = false;
  refreshInput() {
    setStateIfMounted(() {
      if (isemojiShowing == false) {
        keyboardFocusNode.unfocus();
        isemojiShowing = true;
      } else {
        isemojiShowing = false;
        keyboardFocusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Utils.getNTPWrappedWidget(WillPopScope(
      onWillPop: isgeneratingSomethingLoader == true
          ? () async {
              return Future.value(false);
            }
          : isemojiShowing == true
              ? () {
                  setStateIfMounted(() {
                    isemojiShowing = false;
                    keyboardFocusNode.unfocus();
                  });
                  return Future.value(false);
                }
              : () async {
                  return Future.value(true);
                },
      child: Stack(
        children: [
          StreamBuilder(
              stream: streamTicketSnapshots,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData &&
                    snapshot.data.exists &&
                    snapshot.data != null) {
                  TicketModel liveTicketData =
                      TicketModel.fromSnapshot(snapshot.data);
                  return Scaffold(
                      appBar: AppBar(
                        actions: [
                          IconButton(
                              onPressed: () {
                                showDynamicModalBottomSheet(
                                    title: "",
                                    context: context,
                                    widgetList: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        children: [
                                          ListTile(
                                              leading: Icon(
                                                Icons.menu,
                                                color: Colors.cyan,
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                pageNavigator(
                                                    context,
                                                    TicketDetails(
                                                      ticketCosmeticID:
                                                          widget.ticketID,
                                                      ticketID: widget.ticketID,
                                                      onrefreshPreviousPage:
                                                          () {},
                                                    ));
                                              },
                                              title: MtCustomfontBoldSemi(
                                                text: getTranslatedForCurrentUser(
                                                        context,
                                                        'xxseetktdetailsxx')
                                                    .replaceAll(
                                                        '(####)',
                                                        getTranslatedForCurrentUser(
                                                            context,
                                                            'xxtktsxx')),
                                                fontsize: 16,
                                              )),
                                          Divider(),
                                        ],
                                      ),
                                      liveTicketData.ticketStatusShort ==
                                              TicketStatusShort.active.index
                                          ? Column(children: [
                                              ListTile(
                                                  leading: Icon(
                                                    Icons.close,
                                                    color: Colors.pink,
                                                  ),
                                                  onTap: AppConstants
                                                              .isdemomode ==
                                                          true
                                                      ? () {
                                                          Utils.toast(
                                                              getTranslatedForCurrentUser(
                                                                  context,
                                                                  'xxxnotalwddemoxxaccountxx'));
                                                        }
                                                      : () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          await TicketUtils.closeTicket(
                                                              ticketID:
                                                                  liveTicketData
                                                                      .ticketID,
                                                              context:
                                                                  this.context,
                                                              isCustomer: false,
                                                              liveTicketModel:
                                                                  liveTicketData,
                                                              agents: liveTicketData
                                                                  .tktMEMBERSactiveList);
                                                        },
                                                  title: MtCustomfontBoldSemi(
                                                    text: getTranslatedForCurrentUser(
                                                            context,
                                                            'xxclosexxxx')
                                                        .replaceAll(
                                                            '(####)',
                                                            getTranslatedForCurrentUser(
                                                                context,
                                                                'xxtktsxx')),
                                                    fontsize: 16,
                                                  )),
                                              Divider(),
                                            ])
                                          : SizedBox(),
                                      liveTicketData.ticketStatus ==
                                                  TicketStatus
                                                      .reOpenedByAgent.index ||
                                              liveTicketData.ticketStatus ==
                                                  TicketStatus
                                                      .reOpenedByCustomer
                                                      .index ||
                                              liveTicketData.ticketStatus ==
                                                  TicketStatus.active.index
                                          ? Column(children: [
                                              ListTile(
                                                  leading: Icon(
                                                    Icons.query_builder,
                                                    color: Colors.purple,
                                                  ),
                                                  onTap: AppConstants
                                                              .isdemomode ==
                                                          true
                                                      ? () {
                                                          Utils.toast(
                                                              getTranslatedForCurrentUser(
                                                                  context,
                                                                  'xxxnotalwddemoxxaccountxx'));
                                                        }
                                                      : () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          await TicketUtils.askToClose(
                                                              ticketID:
                                                                  liveTicketData
                                                                      .ticketID,
                                                              context:
                                                                  this.context,
                                                              isCustomer: false,
                                                              liveTicketModel:
                                                                  liveTicketData,
                                                              agents: liveTicketData
                                                                  .tktMEMBERSactiveList);
                                                        },
                                                  title: MtCustomfontBoldSemi(
                                                    text: getTranslatedForCurrentUser(
                                                            context,
                                                            'xxxaskxxx')
                                                        .replaceAll(
                                                            '(####)',
                                                            getTranslatedForCurrentUser(
                                                                context,
                                                                'xxcustomerxx'))
                                                        .replaceAll(
                                                            '(###)',
                                                            getTranslatedForCurrentUser(
                                                                context,
                                                                'xxtktsxx')),
                                                    fontsize: 16,
                                                  )),
                                              Divider(),
                                            ])
                                          : SizedBox(),
                                      liveTicketData.ticketStatus ==
                                                  TicketStatus.active.index ||
                                              (liveTicketData.ticketStatus ==
                                                      TicketStatus
                                                          .reOpenedByCustomer
                                                          .index ||
                                                  liveTicketData.ticketStatus ==
                                                      TicketStatus
                                                          .reOpenedByAgent
                                                          .index)
                                          ? Column(children: [
                                              ListTile(
                                                  leading: Icon(
                                                    EvaIcons.bulb,
                                                    color: Colors.orange,
                                                  ),
                                                  onTap:
                                                      AppConstants.isdemomode ==
                                                              true
                                                          ? () {
                                                              Utils.toast(
                                                                  getTranslatedForCurrentUser(
                                                                      context,
                                                                      'xxxnotalwddemoxxaccountxx'));
                                                            }
                                                          : () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              ShowConfirmWithInputTextDialog()
                                                                  .open(
                                                                      rightbtntext:
                                                                          getTranslatedForCurrentUser(context, 'xxconfirmxx')
                                                                              .toUpperCase(),
                                                                      rightbtnonpress:
                                                                          () async {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        await TicketUtils.markNeedsAttention(
                                                                            ticketID: liveTicketData
                                                                                .ticketID,
                                                                            context: this
                                                                                .context,
                                                                            attentionResaon: _controller.text
                                                                                .trim(),
                                                                            liveTicketModel:
                                                                                liveTicketData,
                                                                            agents:
                                                                                liveTicketData.tktMEMBERSactiveList);
                                                                      },
                                                                      context:
                                                                          context,
                                                                      controller:
                                                                          _controller,
                                                                      title: getTranslatedForCurrentUser(
                                                                          context,
                                                                          'xxrmarkneedsattentionxx'),
                                                                      subtitle: getTranslatedForCurrentUser(
                                                                              context,
                                                                              'xxxmarkneedattentionxxx')
                                                                          .replaceAll(
                                                                              '(######)',
                                                                              '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                                                          .replaceAll(
                                                                              '(#####)',
                                                                              '${getTranslatedForCurrentUser(context, 'xxtktssxx')}')
                                                                          .replaceAll(
                                                                              '(####)',
                                                                              '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                                                          .replaceAll(
                                                                              '(###)',
                                                                              '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}')
                                                                          .replaceAll(
                                                                              '(##)',
                                                                              '${getTranslatedForCurrentUser(context, 'xxagentsxx').toUpperCase()}'));
                                                            },
                                                  title: MtCustomfontBoldSemi(
                                                    text: getTranslatedForCurrentUser(
                                                        context,
                                                        'xxrmarkneedsattentionxx'),
                                                    fontsize: 16,
                                                  )),
                                              Divider(),
                                            ])
                                          : liveTicketData.ticketStatus ==
                                                  TicketStatus
                                                      .needsAttention.index
                                              ? Column(children: [
                                                  ListTile(
                                                      leading: Icon(
                                                        EvaIcons.bulb,
                                                        color: Colors.green,
                                                      ),
                                                      onTap: AppConstants
                                                                  .isdemomode ==
                                                              true
                                                          ? () {
                                                              Utils.toast(
                                                                  getTranslatedForCurrentUser(
                                                                      context,
                                                                      'xxxnotalwddemoxxaccountxx'));
                                                            }
                                                          : () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              ShowConfirmDialog()
                                                                  .open(
                                                                rightbtntext:
                                                                    getTranslatedForCurrentUser(
                                                                        context,
                                                                        'xxconfirmxx'),
                                                                rightbtnonpress:
                                                                    () async {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  await TicketUtils.markNeedsAttentionOFF(
                                                                      ticketID:
                                                                          liveTicketData
                                                                              .ticketID,
                                                                      context: this
                                                                          .context,
                                                                      liveTicketModel:
                                                                          liveTicketData,
                                                                      agents: liveTicketData
                                                                          .tktMEMBERSactiveList);
                                                                },
                                                                context:
                                                                    context,
                                                                title: getTranslatedForCurrentUser(
                                                                    context,
                                                                    'xxremoveattentionmarkxx'),
                                                                subtitle: getTranslatedForCurrentUser(
                                                                        context,
                                                                        'xxxattentionmarkwillberemovedxx')
                                                                    .replaceAll(
                                                                        '(####)',
                                                                        '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                                                              );
                                                            },
                                                      title:
                                                          MtCustomfontBoldSemi(
                                                        text: getTranslatedForCurrentUser(
                                                            context,
                                                            'xxremoveattentionmarkxx'),
                                                        fontsize: 16,
                                                      )),
                                                  Divider(),
                                                ])
                                              : SizedBox(),
                                      Column(children: [
                                        ListTile(
                                            leading: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onTap: AppConstants.isdemomode ==
                                                    true
                                                ? () {
                                                    Utils.toast(
                                                        getTranslatedForCurrentUser(
                                                            context,
                                                            'xxxnotalwddemoxxaccountxx'));
                                                  }
                                                : () {
                                                    Navigator.of(context).pop();
                                                    ShowConfirmWithInputTextDialog()
                                                        .open(
                                                      controller: _controller,
                                                      rightbtnonpress:
                                                          () async {
                                                        TicketModel ticket =
                                                            liveTicketData;
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(DbPaths
                                                                .collectiontickets)
                                                            .doc(
                                                                widget.ticketID)
                                                            .delete()
                                                            .then(
                                                                (value) async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  DbPaths
                                                                      .userapp)
                                                              .doc(DbPaths
                                                                  .docdashboarddata)
                                                              .update({
                                                            Dbkeys.totalopentickets:
                                                                FieldValue
                                                                    .increment(
                                                                        -1)
                                                          });

                                                          ticket
                                                              .tktMEMBERSactiveList
                                                              .forEach(
                                                                  (agent) async {
                                                            await Utils.sendDirectNotification(
                                                                title: getTranslatedForCurrentUser(context, 'xxxshasdeletedbyxxxxx')
                                                                    .replaceAll(
                                                                        '(####)', '${getTranslatedForCurrentUser(context, 'xxtktsxx')}')
                                                                    .replaceAll(
                                                                        '(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
                                                                parentID:
                                                                    "TICKET--${widget.ticketID}",
                                                                plaindesc: _controller
                                                                        .text
                                                                        .isEmpty
                                                                    ? getTranslatedForCurrentUser(context, 'xxxshasdeletedbyxxxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxticketidxx')} ${widget.ticketID} (${widget.ticketTitle})').replaceAll(
                                                                        '(###)',
                                                                        '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                                                    : getTranslatedForCurrentUser(context, 'xxxshasdeletedbyxxxxx')
                                                                        .replaceAll(
                                                                            '(####)', '${getTranslatedForCurrentUser(context, 'xxticketidxx')} ${widget.ticketID} (${widget.ticketTitle})')
                                                                        .replaceAll(
                                                                            '(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}. ${getTranslatedForCurrentUser(context, 'xxreasonxxx')} ${_controller.text.trim()}'),
                                                                docRef: FirebaseFirestore
                                                                    .instance
                                                                    .collection(DbPaths.collectionagents)
                                                                    .doc(agent)
                                                                    .collection(DbPaths.agentnotifications)
                                                                    .doc(DbPaths.agentnotifications),
                                                                postedbyID: 'Admin');
                                                          });
                                                          await Utils.sendDirectNotification(
                                                              title: getTranslatedForCurrentUser(context, 'xxxshasdeletedbyxxxxx')
                                                                  .replaceAll(
                                                                      '(####)', '${getTranslatedForCurrentUser(context, 'xxtktsxx')}')
                                                                  .replaceAll(
                                                                      '(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
                                                              parentID:
                                                                  "TICKET--${widget.ticketID}",
                                                              plaindesc: _controller.text.isEmpty
                                                                  ? getTranslatedForCurrentUser(context, 'xxxshasdeletedbyxxxxx')
                                                                      .replaceAll(
                                                                          '(####)', '${getTranslatedForCurrentUser(context, 'xxticketidxx')} ${widget.ticketID} (${widget.ticketTitle})')
                                                                      .replaceAll(
                                                                          '(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                                                  : getTranslatedForCurrentUser(context, 'xxxshasdeletedbyxxxxx')
                                                                      .replaceAll(
                                                                          '(####)', '${getTranslatedForCurrentUser(context, 'xxticketidxx')} ${widget.ticketID} (${widget.ticketTitle})')
                                                                      .replaceAll(
                                                                          '(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}. ${getTranslatedForCurrentUser(context, 'xxreasonxxx')} ${_controller.text.trim()}'),
                                                              docRef: FirebaseFirestore
                                                                  .instance
                                                                  .collection(DbPaths.collectioncustomers)
                                                                  .doc(widget.customerUID)
                                                                  .collection(DbPaths.customernotifications)
                                                                  .doc(DbPaths.customernotifications),
                                                              postedbyID: 'Admin');

                                                          await FirebaseApi
                                                              .runTransactionRecordActivity(
                                                            parentid:
                                                                "TICKET--${widget.ticketID}",
                                                            title: getTranslatedForCurrentUser(
                                                                    context,
                                                                    'xxxshasdeletedbyxxxxx')
                                                                .replaceAll(
                                                                    '(####)',
                                                                    '${getTranslatedForCurrentUser(context, 'xxtktsxx')}')
                                                                .replaceAll(
                                                                    '(###)',
                                                                    '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
                                                            postedbyID: 'Admin',
                                                            onErrorFn: (e) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Utils.toast(
                                                                  "${getTranslatedForCurrentUser(context, 'xxfailedxx')}  $e");
                                                            },
                                                            onSuccessFn: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            plainDesc: _controller
                                                                    .text
                                                                    .isEmpty
                                                                ? getTranslatedForCurrentUser(
                                                                        context,
                                                                        'xxxshasdeletedbyxxxxx')
                                                                    .replaceAll(
                                                                        '(####)',
                                                                        '${getTranslatedForCurrentUser(context, 'xxticketidxx')} ${widget.ticketID} (${widget.ticketTitle})')
                                                                    .replaceAll(
                                                                        '(###)',
                                                                        '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                                                : getTranslatedForCurrentUser(
                                                                        context,
                                                                        'xxxshasdeletedbyxxxxx')
                                                                    .replaceAll(
                                                                        '(####)',
                                                                        '${getTranslatedForCurrentUser(context, 'xxticketidxx')} ${widget.ticketID} (${widget.ticketTitle})')
                                                                    .replaceAll(
                                                                        '(###)',
                                                                        '${getTranslatedForCurrentUser(context, 'xxadminxx')}. ${getTranslatedForCurrentUser(context, 'xxreasonxxx')} ${_controller.text.trim()}'),
                                                          );
                                                        }).catchError((e) {
                                                          Utils.toast(
                                                              "${getTranslatedForCurrentUser(context, 'xxfailedxx')}  $e");
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      },
                                                      rightbtntext:
                                                          "${getTranslatedForCurrentUser(context, 'xxdeletexx').toUpperCase()}",
                                                      context: context,
                                                      title:
                                                          "${getTranslatedForCurrentUser(context, 'xxdeletexx')} ${getTranslatedForCurrentUser(context, 'xxtktsxx')}",
                                                      subtitle: getTranslatedForCurrentUser(
                                                              context,
                                                              'xxxdeleteingthisxxx')
                                                          .replaceAll('(####)',
                                                              '${getTranslatedForCurrentUser(context, 'xxtktsxx')}')
                                                          .replaceAll('(###)',
                                                              '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}')
                                                          .replaceAll('(##)',
                                                              '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                                                    );
                                                  },
                                            title: MtCustomfontBoldSemi(
                                              text:
                                                  "${getTranslatedForCurrentUser(context, 'xxdeletexx')} ${getTranslatedForCurrentUser(context, 'xxtktsxx')}",
                                              fontsize: 16,
                                            ))
                                      ]),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ]);
                              },
                              icon: Icon(
                                Icons.more_vert_rounded,
                                color: Colors.white,
                              ))
                        ],
                        elevation: 0.1,
                        backgroundColor: Mycolors.primary,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MtCustomfontBoldSemi(
                              text: "${widget.ticketTitle}",
                              fontsize: 18,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            MtCustomfontLight(
                              text:
                                  "${getTranslatedForCurrentUser(context, 'xxsupportchatxx')} | ${getTranslatedForCurrentUser(context, 'xxticketidxx')} ${widget.ticketID}",
                              color: Colors.white,
                              fontsize: 12,
                            )
                          ],
                        ),
                      ),
                      key: _scaffold,
                      body: Stack(children: <Widget>[
                        new Container(
                          decoration: new BoxDecoration(
                            color: Mycolors.backgroundcolor,
                            image: new DecorationImage(
                                image: AssetImage(
                                    "assets/COMMON_ASSETS/background.png"),
                                fit: BoxFit.cover),
                          ),
                        ),
                        PageView(children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: liveTicketData.ticketStatusShort ==
                                          TicketStatusShort.close.index
                                      ? 70
                                      : 0,
                                ),
                                Expanded(
                                    child: isPreLoading == true
                                        ? circularProgress()
                                        : buildMessagesUsingProvider(
                                            context, liveTicketData)),
                              ]),
                        ]),
                        Container(
                          height: 29,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(6),
                          margin: EdgeInsets.only(top: 0, bottom: 3),
                          child: MtCustomfontBoldSemi(
                            maxlines: 1,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.center,
                            text: ticketStatusTextLongForAgent(
                                context, liveTicketData.ticketStatus),
                            color: Colors.white,
                            fontsize: 13,
                          ),
                          width: MediaQuery.of(context).size.width,
                          color: ticketStatusColorForAgents(
                              liveTicketData.ticketStatus),
                        ),
                        liveTicketData.ticketStatusShort ==
                                TicketStatusShort.close.index
                            ? Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Consumer<Observer>(
                                    builder: (context, observer, _child) => warningTile(
                                        title: observer.userAppSettingsDoc!
                                                    .defaultTicketMssgsDeletingTimeAfterClosing ==
                                                0
                                            ? getTranslatedForCurrentUser(
                                                context,
                                                'xxmssgautodeletenotxxx')
                                            : getTranslatedForCurrentUser(
                                                    context,
                                                    'xxxmssgautodeletexxx')
                                                .replaceAll('(####)',
                                                    '<bold>${observer.userAppSettingsDoc!.defaultTicketMssgsDeletingTimeAfterClosing}</bold>'),
                                        warningTypeIndex:
                                            WarningType.alert.index,
                                        isstyledtext: true)),
                              )
                            : SizedBox()
                      ]));
                }
                return Scaffold(
                  backgroundColor: Mycolors.backgroundcolor,
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
          buildLoadingThumbnail()
        ],
      ),
    ));
  }

  // Widget selectablelinkify(
  //     String? text, double? fontsize, TextAlign? textalign) {
  //   return SelectableLinkify(
  //     style: TextStyle(
  //         fontSize: fontsize,
  //         color: Colors.black87,
  //         height: 1.3,
  //         fontStyle: FontStyle.normal),
  //     text: text ?? "",
  //     textAlign: textalign,
  //     onOpen: (link) async {
  //       if (1 == 1) {
  //         await custom_url_launcher(link.url);
  //       } else {
  //         throw 'Could not launch $link';
  //       }
  //     },
  //   );
  // }

  Widget selectablelinkify(
      String? text, double? fontsize, TextAlign? textalign) {
    bool _validURL = false;
    try {
      _validURL = text!.contains("http") || text.contains("https");
    } catch (e) {
      // print(e);
    }

    return _validURL == false
        ? SelectableLinkify(
            style: TextStyle(fontSize: fontsize, color: Colors.black87),
            text: text!,
            onOpen: (link) async {
              custom_url_launcher(link.url);
            },
          )
        : LinkPreviewGenerator(
            removeElevation: true,
            graphicFit: BoxFit.contain,
            borderRadius: 5,
            showDomain: true,
            titleStyle: TextStyle(
                fontSize: 13, height: 1.4, fontWeight: FontWeight.bold),
            showBody: true,
            bodyStyle: TextStyle(fontSize: 11.6, color: Colors.black45),
            placeholderWidget: SelectableLinkify(
              textAlign: textalign,
              style: TextStyle(fontSize: fontsize, color: Colors.black87),
              text: text!,
              onOpen: (link) async {
                custom_url_launcher(link.url);
              },
            ),
            errorWidget: SelectableLinkify(
              style: TextStyle(fontSize: fontsize, color: Colors.black87),
              text: "",
              textAlign: textalign,
              onOpen: (link) async {
                custom_url_launcher(link.url);
              },
            ),
            link: text,
            linkPreviewStyle: LinkPreviewStyle.large,
          );
  }
}
