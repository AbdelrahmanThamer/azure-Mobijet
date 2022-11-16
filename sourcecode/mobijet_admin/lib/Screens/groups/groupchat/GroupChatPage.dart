//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Screens/groups/groupchat/GroupDetails.dart';
import 'package:thinkcreative_technologies/Screens/groups/groupchat/groupChatBubble.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseApi.dart';
import 'package:thinkcreative_technologies/Services/my_providers/GroupChatProvider.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Utils/custom_url_launcher.dart';
import 'package:thinkcreative_technologies/Utils/download_all_file_type.dart';
import 'package:thinkcreative_technologies/Utils/hide_keyboard.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thinkcreative_technologies/Widgets/InfiniteCOLLECTIONListViewWidget.dart';
import 'package:thinkcreative_technologies/Widgets/MultiPlayback/soundPlayerPro.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/customCircleAvatars.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dynamic_modal_bottomsheet.dart';
import 'package:thinkcreative_technologies/Widgets/pdf_viewer/PdfViewFromCachedUrl.dart';
import 'package:thinkcreative_technologies/Widgets/photo_view.dart';
import 'package:thinkcreative_technologies/Widgets/pickers/VideoPicker/VideoPreview.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/widgets/WarningWidgets/warning_tile.dart';

class GroupChatPage extends StatefulWidget {
  final String groupID;
  final Map<String, dynamic> groupMap;
  final bool isCurrentUserMuted;
  final Function onDelete;
  GroupChatPage({
    Key? key,
    required this.groupID,
    required this.groupMap,
    required this.onDelete,
    required this.isCurrentUserMuted,
  }) : super(key: key);

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage>
    with WidgetsBindingObserver {
  final _reason = TextEditingController();
  bool isgeneratingSomethingLoader = false;
  int tempSendIndex = 0;
  late String messageReplyOwnerName;
  late Stream<QuerySnapshot> groupChatMessages;
  final TextEditingController reportEditingController =
      new TextEditingController();
  late Query firestoreChatquery;
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  GlobalKey<State> _keyLoader =
      new GlobalKey<State>(debugLabel: 'qqqeqeqsssaadqeqe');
  final ScrollController realtime = new ScrollController();
  Map<String, dynamic>? replyDoc;
  bool isReplyKeyboard = false;

  bool isCurrentUserMuted = false;
  @override
  void initState() {
    super.initState();
    isCurrentUserMuted = widget.isCurrentUserMuted;
    firestoreChatquery = FirebaseFirestore.instance
        .collection(DbPaths.collectionAgentGroups)
        .doc(widget.groupID)
        .collection(DbPaths.collectiongroupChats)
        .orderBy(Dbkeys.groupmsgTIME, descending: true)
        .limit(20);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var firestoreProvider =
          Provider.of<FirestoreDataProviderMESSAGESforGROUPCHAT>(this.context,
              listen: false);
      firestoreProvider.reset();
      Future.delayed(const Duration(milliseconds: 1700), () {
        loadMessagesAndListen();
      });
    });
  }

  // ignore: cancel_subscriptions
  StreamSubscription<QuerySnapshot>? subscription;
  loadMessagesAndListen() async {
    subscription = firestoreChatquery.snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          var chatprovider =
              Provider.of<FirestoreDataProviderMESSAGESforGROUPCHAT>(
                  this.context,
                  listen: false);
          DocumentSnapshot newDoc = change.doc;
          // if (chatprovider.datalistSnapshot.length == 0) {
          // } else if ((chatprovider.checkIfDocAlreadyExits(
          //       newDoc: newDoc,
          //     ) ==
          //     false)) {

          // if (newDoc[Dbkeys.groupmsgSENDBY] != widget.currentUserno) {
          chatprovider.addDoc(newDoc);
          // unawaited(realtime.animateTo(0.0,
          //     duration: Duration(milliseconds: 300), curve: Curves.easeOut));
          // }
          // }
        } else if (change.type == DocumentChangeType.modified) {
          var chatprovider =
              Provider.of<FirestoreDataProviderMESSAGESforGROUPCHAT>(
                  this.context,
                  listen: false);
          DocumentSnapshot updatedDoc = change.doc;
          if (chatprovider.checkIfDocAlreadyExits(
                  newDoc: updatedDoc,
                  timestamp: updatedDoc[Dbkeys.timestamp]) ==
              true) {
            chatprovider.updateparticulardocinProvider(updatedDoc: updatedDoc);
          }
        } else if (change.type == DocumentChangeType.removed) {
          var chatprovider =
              Provider.of<FirestoreDataProviderMESSAGESforGROUPCHAT>(
                  this.context,
                  listen: false);
          DocumentSnapshot deletedDoc = change.doc;
          if (chatprovider.checkIfDocAlreadyExits(
                  newDoc: deletedDoc,
                  timestamp: deletedDoc[Dbkeys.timestamp]) ==
              true) {
            chatprovider.deleteparticulardocinProvider(deletedDoc: deletedDoc);
          }
        }
      });
    });

    setStateIfMounted(() {});

//       //----sharing intent action:
  }

  int currentUploadingIndex = 0;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    subscription!.cancel();
  }

  final TextEditingController textEditingController =
      new TextEditingController();
  FocusNode keyboardFocusNode = new FocusNode();

  buildEachMessage(Map<String, dynamic> doc) {
    if (doc[Dbkeys.groupmsgTYPE] == Dbkeys.groupmsgTYPEnotificationAddedUser) {
      return Center(
          child: Chip(
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        backgroundColor: Colors.blueGrey[50],
        label: Text(
          doc[Dbkeys.groupmsgLISToptional].length == 1
              ? doc[Dbkeys.groupmsgSENDBY] ==
                      widget.groupMap[Dbkeys.groupCREATEDBY]
                  ? '${getTranslatedForCurrentUser(context, 'xxxgroupadminidxxx')} ${widget.groupMap[Dbkeys.groupCREATEDBY]} ${getTranslatedForCurrentUser(context, 'xxaddedxx')} ${getTranslatedForCurrentUser(context, 'xxagentidxx')}${doc[Dbkeys.groupmsgLISToptional][0]}'
                  : '${getTranslatedForCurrentUser(context, 'xxagentidxx')} ${doc[Dbkeys.groupmsgSENDBY]}  ${getTranslatedForCurrentUser(context, 'xxaddedxx')} ${getTranslatedForCurrentUser(context, 'xxagentidxx')}${doc[Dbkeys.groupmsgLISToptional][0]}'
              : doc[Dbkeys.groupmsgSENDBY] ==
                      widget.groupMap[Dbkeys.groupCREATEDBY]
                  ? '${getTranslatedForCurrentUser(context, 'xxxgroupadminidxxx')} ${widget.groupMap[Dbkeys.groupCREATEDBY]}  ${getTranslatedForCurrentUser(context, 'xxaddedxx')} ${doc[Dbkeys.groupmsgLISToptional].length} ${getTranslatedForCurrentUser(context, 'agents')}'
                  : '${getTranslatedForCurrentUser(context, 'xxagentidxx')} ${doc[Dbkeys.groupmsgSENDBY]}  ${getTranslatedForCurrentUser(context, 'xxaddedxx')} ${doc[Dbkeys.groupmsgLISToptional].length} ${getTranslatedForCurrentUser(context, 'agents')}',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ));
    } else if (doc[Dbkeys.groupmsgTYPE] ==
        Dbkeys.groupmsgTYPEnotificationCreatedGroup) {
      return Center(
          child: Chip(
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        backgroundColor: Colors.blueGrey[50],
        label: Text(
          '${getTranslatedForCurrentUser(context, 'xxagentidxx')} ${widget.groupMap[Dbkeys.groupCREATEDBY]} ${getTranslatedForCurrentUser(context, 'xxhascreatedthisgroupxx')}',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ));
    } else if (doc[Dbkeys.groupmsgTYPE] ==
        Dbkeys.groupmsgTYPEnotificationUpdatedGroupDetails) {
      return Center(
          child: Chip(
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        backgroundColor: Colors.blueGrey[50],
        label: Text(
          '${getTranslatedForCurrentUser(context, 'xxagentidxx')}${doc[Dbkeys.groupmsgSENDBY]}${getTranslatedForCurrentUser(context, 'xxhasupdatedgrpdetailsxx')}'
                  .contains(widget.groupMap[Dbkeys.groupCREATEDBY])
              ? "${getTranslatedForCurrentUser(context, 'xxxgroupadminidxxx')}${widget.groupMap[Dbkeys.groupCREATEDBY]} ${getTranslatedForCurrentUser(context, 'xxhasupdatedgrpdetailsxx')}"
              : '${getTranslatedForCurrentUser(context, 'xxagentidxx')}${doc[Dbkeys.groupmsgSENDBY]} ${getTranslatedForCurrentUser(context, 'xxhasupdatedgrpdetailsxx')}',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ));
    } else if (doc[Dbkeys.groupmsgTYPE] ==
        Dbkeys.groupmsgTYPEnotificationUserSetAsAdmin) {
      return Center(
          child: Chip(
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        backgroundColor: Colors.blueGrey[50],
        label: Text(
          '${getTranslatedForCurrentUser(context, 'xxagentidxx')}${doc[Dbkeys.groupmsgSENDBY]} ${getTranslatedForCurrentUser(context, 'xxxhassetxxx')} ${getTranslatedForCurrentUser(context, 'xxagentidxx')}${doc[Dbkeys.groupmsgLISToptional][0]} ${getTranslatedForCurrentUser(context, 'xxxasgroupadminxxx')}',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ));
    } else if (doc[Dbkeys.groupmsgTYPE] ==
        Dbkeys.groupmsgTYPEnotificationUserRemovedAsAdmin) {
      return Center(
          child: Chip(
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        backgroundColor: Colors.blueGrey[50],
        label: Text(
          '${getTranslatedForCurrentUser(context, 'xxagentidxx')} ${doc[Dbkeys.groupmsgSENDBY]} ${getTranslatedForCurrentUser(context, 'xxxhasremovedxxx')} ${getTranslatedForCurrentUser(context, 'xxagentidxx')}${doc[Dbkeys.groupmsgLISToptional][0]} ${getTranslatedForCurrentUser(context, 'xxxfromgroupadminxxx')}',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ));
    } else if (doc[Dbkeys.groupmsgTYPE] ==
        Dbkeys.groupmsgTYPEnotificationUpdatedGroupicon) {
      return Center(
          child: Chip(
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        backgroundColor: Colors.blueGrey[50],
        label: Text(
          '${getTranslatedForCurrentUser(context, 'xxagentidxx')}${doc[Dbkeys.groupmsgSENDBY]} ${getTranslatedForCurrentUser(context, 'xxhasupdatedgrpiconxx')}',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ));
    } else if (doc[Dbkeys.groupmsgTYPE] ==
        Dbkeys.groupmsgTYPEnotificationDeletedGroupicon) {
      return Center(
          child: Chip(
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        backgroundColor: Colors.blueGrey[50],
        label: Text(
          '${getTranslatedForCurrentUser(context, 'xxagentidxx')} ${doc[Dbkeys.groupmsgSENDBY]} ${getTranslatedForCurrentUser(context, 'xxhasremovedgrpiconxx')}',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ));
    } else if (doc[Dbkeys.groupmsgTYPE] ==
        Dbkeys.groupmsgTYPEnotificationRemovedUser) {
      return Center(
          child: Chip(
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        backgroundColor: Colors.blueGrey[50],
        label: Text(
          doc[Dbkeys.groupmsgSENDBY] == widget.groupMap[Dbkeys.groupCREATEDBY]
              ? '${getTranslatedForCurrentUser(context, 'xxagentidxx')}${doc[Dbkeys.groupmsgLISToptional][0]} ${getTranslatedForCurrentUser(context, 'xxxisremovedbyadminxx')} (${getTranslatedForCurrentUser(context, 'xxagentidxx')}${widget.groupMap[Dbkeys.groupCREATEDBY]})'
              : '${getTranslatedForCurrentUser(context, 'xxagentidxx')}${doc[Dbkeys.groupmsgSENDBY]} ${getTranslatedForCurrentUser(context, 'xxhasremovedxx')} ${getTranslatedForCurrentUser(context, 'xxagentidxx')} ${doc[Dbkeys.groupmsgLISToptional][0]} ${getTranslatedForCurrentUser(context, 'xxxfromgroupxxx')}',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ));
    } else if (doc[Dbkeys.groupmsgTYPE] ==
        Dbkeys.groupmsgTYPEnotificationUserLeft) {
      return Center(
          child: Chip(
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        backgroundColor: Colors.blueGrey[50],
        label: Text(
          '${doc[Dbkeys.groupmsgCONTENT]}',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ));
    } else if (doc[Dbkeys.groupmsgTYPE] == MessageType.image.index ||
        doc[Dbkeys.groupmsgTYPE] == MessageType.doc.index ||
        doc[Dbkeys.groupmsgTYPE] == MessageType.text.index ||
        doc[Dbkeys.groupmsgTYPE] == MessageType.video.index ||
        doc[Dbkeys.groupmsgTYPE] == MessageType.audio.index ||
        doc[Dbkeys.groupmsgTYPE] == MessageType.contact.index ||
        doc[Dbkeys.groupmsgTYPE] == MessageType.location.index) {
      return buildMediaMessages(doc, widget.groupMap);
    }

    return Text(doc[Dbkeys.groupmsgCONTENT]);
  }

  // contextMenu(BuildContext context, Map<String, dynamic> mssgDoc,
  //     {bool saved = false}) {
  //   List<Widget> tiles = List.from(<Widget>[]);

  // if (mssgDoc[Dbkeys.groupmsgSENDBY] == widget.currentUserno) {
  //   tiles.add(ListTile(
  //       dense: true,
  //       leading: Icon(Icons.delete),
  //       title: Text(
  //         getTranslated(context, 'dltforeveryone'),
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //       ),
  //       onTap: () async {
  //         Navigator.of(this.context).pop();
  //         if (mssgDoc[Dbkeys.messageType] == MessageType.image.index &&
  //             !mssgDoc[Dbkeys.groupmsgCONTENT].contains('giphy')) {
  //           FirebaseStorage.instance
  //               .refFromURL(mssgDoc[Dbkeys.groupmsgCONTENT])
  //               .delete();
  //         } else if (mssgDoc[Dbkeys.messageType] == MessageType.doc.index) {
  //           FirebaseStorage.instance
  //               .refFromURL(
  //                   mssgDoc[Dbkeys.groupmsgCONTENT].split('-BREAK-')[0])
  //               .delete();
  //         } else if (mssgDoc[Dbkeys.messageType] == MessageType.audio.index) {
  //           FirebaseStorage.instance
  //               .refFromURL(
  //                   mssgDoc[Dbkeys.groupmsgCONTENT].split('-BREAK-')[0])
  //               .delete();
  //         } else if (mssgDoc[Dbkeys.messageType] == MessageType.video.index) {
  //           FirebaseStorage.instance
  //               .refFromURL(
  //                   mssgDoc[Dbkeys.groupmsgCONTENT].split('-BREAK-')[0])
  //               .delete();
  //           FirebaseStorage.instance
  //               .refFromURL(
  //                   mssgDoc[Dbkeys.groupmsgCONTENT].split('-BREAK-')[1])
  //               .delete();
  //         }

  //   FirebaseFirestore.instance
  //       .collection(DbPaths.collectionAgentGroups)
  //       .doc(widget.groupID)
  //       .collection(DbPaths.collectiongroupChats)
  //       .doc(
  //           '${mssgDoc[Dbkeys.groupmsgTIME]}--${mssgDoc[Dbkeys.groupmsgSENDBY]}')
  //       .update({
  //     Dbkeys.groupmsgISDELETED: true,
  //     Dbkeys.groupmsgCONTENT: '',
  //   });
  // }));
  // }
  // if (mssgDoc[Dbkeys.groupmsgISDELETED] == false) {
  //   tiles.add(ListTile(
  //       dense: true,
  //       leading: Icon(FontAwesomeIcons.share, size: 22),
  //       title: Text(
  //         getTranslated(this.context, 'forward'),
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //       ),
  //       onTap: () async {
  //         Navigator.of(this.context).pop();
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => SelectContactsToForward(
  //                     messageOwnerPhone: widget.currentUserno,
  //                     currentUserNo: widget.currentUserno,
  //                     model: widget.model,
  //                     prefs: widget.prefs,
  //                     onSelect: (selectedlist) async {
  //                       if (selectedlist.length > 0) {
  //                         setStateIfMounted(() {
  //                           isgeneratingSomethingLoader = true;
  //                           tempSendIndex = 0;
  //                         });

  //                         String? privateKey =
  //                             await storage.read(key: Dbkeys.privateKey);

  //                         sendForwardMessageEach(
  //                             0, selectedlist, privateKey!, mssgDoc);
  //                       }
  //                     })));
  //       }));
  // }

  // showDialog(
  //     context: this.context,
  //     builder: (context) {
  //       return SimpleDialog(children: tiles);
  //     });
  // }

  Widget buildMediaMessages(
      Map<String, dynamic> doc, Map<String, dynamic> groupData) {
    bool isMe = false;
    bool saved = false;
    bool isContainURL = false;
    try {
      isContainURL = Uri.tryParse(doc[Dbkeys.content]!) == null
          ? false
          : Uri.tryParse(doc[Dbkeys.content]!)!.isAbsolute;
    } on Exception catch (_) {
      isContainURL = false;
    }
    return Consumer<UserRegistry>(
        builder: (context, registry, _child) => InkWell(
              onLongPress: doc[Dbkeys.groupmsgISDELETED] == false
                  ? () {
                      HapticFeedback.mediumImpact();
                      ShowConfirmWithInputTextDialog().open(
                          context: context,
                          controller: _reason,
                          title: getTranslatedForCurrentUser(
                              context, 'xxxdltmssgxxx'),
                          subtitle:
                              "${getTranslatedForCurrentUser(context, 'xxxdltmssgbyadminxx')} ${doc[Dbkeys.groupmsgTIME]}",
                          rightbtntext: getTranslatedForCurrentUser(
                              context, 'xxdeletexx'),
                          rightbtnonpress: () async {
                            Navigator.of(context).pop();
                            ShowLoading()
                                .open(context: context, key: _keyLoader);
                            await FirebaseFirestore.instance
                                .collection(DbPaths.collectionAgentGroups)
                                .doc(widget.groupID)
                                .collection(DbPaths.collectiongroupChats)
                                .doc(doc[Dbkeys.groupmsgTIME].toString() +
                                    "--" +
                                    doc[Dbkeys.groupmsgSENDBY].toString())
                                .update({
                              Dbkeys.groupmsgISDELETED: true,
                              Dbkeys.deletedReason:
                                  _reason.text.trim().length < 1
                                      ? getTranslatedForCurrentUser(
                                          context, 'xxmsgdltdbyadminxx')
                                      : getTranslatedForCurrentUser(context,
                                              'xxmsgdltdbyadminforreasonxx')
                                          .replaceAll('(####)',
                                              '\"${_reason.text.trim()}\"'),
                            }).then((value) {
                              var chatprovider = Provider.of<
                                      FirestoreDataProviderMESSAGESforGROUPCHAT>(
                                  this.context,
                                  listen: false);
                              chatprovider.reset();
                              chatprovider.fetchNextData(
                                  Dbkeys.datatypeGROUPCHATMSGS,
                                  FirebaseFirestore.instance
                                      .collection(DbPaths.collectionAgentGroups)
                                      .doc(widget.groupID)
                                      .collection(DbPaths.collectiongroupChats)
                                      .orderBy(Dbkeys.groupmsgTIME,
                                          descending: true)
                                      .limit(15),
                                  false);
                              ShowLoading()
                                  .close(context: context, key: _keyLoader);
                              Utils.toast(getTranslatedForCurrentUser(
                                  context, 'xxmsgdeletedxx'));
                            }).catchError((e) {
                              ShowLoading()
                                  .close(context: context, key: _keyLoader);
                              Utils.toast(
                                  "${getTranslatedForCurrentUser(context, 'xxfailedxx')} ERROR: $e");
                            });
                          });

                      hidekeyboard(context);
                    }
                  : null,
              child: GroupChatBubble(
                isdeleted: doc[Dbkeys.groupmsgISDELETED],
                isURLtext: doc[Dbkeys.messageType] == MessageType.text.index &&
                    isContainURL == true,
                is24hrsFormat: true,
                savednameifavailable: null,
                postedbyname: registry
                    .getUserData(context, doc[Dbkeys.groupmsgSENDBY])
                    .fullname,
                postedbyID: doc[Dbkeys.groupmsgSENDBY],
                messagetype: doc[Dbkeys.messageType] == MessageType.text.index
                    ? MessageType.text
                    : doc[Dbkeys.messageType] == MessageType.contact.index
                        ? MessageType.contact
                        : doc[Dbkeys.messageType] == MessageType.location.index
                            ? MessageType.location
                            : doc[Dbkeys.messageType] == MessageType.image.index
                                ? MessageType.image
                                : doc[Dbkeys.messageType] ==
                                        MessageType.video.index
                                    ? MessageType.video
                                    : doc[Dbkeys.messageType] ==
                                            MessageType.doc.index
                                        ? MessageType.doc
                                        : doc[Dbkeys.messageType] ==
                                                MessageType.audio.index
                                            ? MessageType.audio
                                            : MessageType.text,
                child: doc[Dbkeys.groupmsgISDELETED] == true
                    ? Column(
                        crossAxisAlignment: isMe == true
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          doc[Dbkeys.messageType] == MessageType.text.index
                              ? getTextMessage(isMe, doc, saved)
                              : doc[Dbkeys.messageType] ==
                                      MessageType.location.index
                                  ? getLocationMessage(
                                      context, doc[Dbkeys.content], doc,
                                      saved: false)
                                  : doc[Dbkeys.messageType] ==
                                          MessageType.doc.index
                                      ? getDocmessage(
                                          context, doc[Dbkeys.content], doc,
                                          saved: false)
                                      : doc[Dbkeys.messageType] ==
                                              MessageType.audio.index
                                          ? getAudiomessage(
                                              context, doc[Dbkeys.content], doc,
                                              isMe: isMe, saved: false)
                                          : doc[Dbkeys.messageType] ==
                                                  MessageType.video.index
                                              ? getVideoMessage(context,
                                                  doc[Dbkeys.content], doc,
                                                  saved: false)
                                              : doc[Dbkeys.messageType] ==
                                                      MessageType.contact.index
                                                  ? getContactMessage(context,
                                                      doc[Dbkeys.content], doc,
                                                      saved: false)
                                                  : getImageMessage(
                                                      context,
                                                      doc,
                                                      saved: saved,
                                                    ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            doc[Dbkeys.deletedReason] == ""
                                ? getTranslatedForCurrentUser(
                                    context, 'xxmsgdeletedxx')
                                : doc[Dbkeys.deletedReason],
                            style: TextStyle(
                                color: Mycolors.red.withOpacity(0.6),
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      )
                    : doc[Dbkeys.messageType] == MessageType.text.index
                        ? getTextMessage(isMe, doc, saved)
                        : doc[Dbkeys.messageType] == MessageType.location.index
                            ? getLocationMessage(
                                context, doc[Dbkeys.content], doc, saved: false)
                            : doc[Dbkeys.messageType] == MessageType.doc.index
                                ? getDocmessage(
                                    context, doc[Dbkeys.content], doc,
                                    saved: false)
                                : doc[Dbkeys.messageType] ==
                                        MessageType.audio.index
                                    ? getAudiomessage(
                                        context, doc[Dbkeys.content], doc,
                                        isMe: isMe, saved: false)
                                    : doc[Dbkeys.messageType] ==
                                            MessageType.video.index
                                        ? getVideoMessage(
                                            context, doc[Dbkeys.content], doc,
                                            saved: false)
                                        : doc[Dbkeys.messageType] ==
                                                MessageType.contact.index
                                            ? getContactMessage(context,
                                                doc[Dbkeys.content], doc,
                                                saved: false)
                                            : getImageMessage(
                                                context,
                                                doc,
                                                saved: saved,
                                              ),
                isMe: isMe,
                delivered: true,
                isContinuing: true,
                timestamp: doc[Dbkeys.groupmsgTIME],
              ),
            ));
  }

  Widget getVideoMessage(
      BuildContext context, String message, Map<String, dynamic> doc,
      {bool saved = false}) {
    Map<dynamic, dynamic>? meta =
        jsonDecode((message.split('-BREAK-')[2]).toString());
    final bool isMe = false;
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
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
            doc.containsKey(Dbkeys.isForward) == true
                ? doc[Dbkeys.isForward] == true
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
                    : SizedBox(height: 0, width: 0)
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
      BuildContext context, String message, Map<String, dynamic> doc,
      {bool saved = false}) {
    final bool isMe = false;
    return SizedBox(
      width: 210,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          doc.containsKey(Dbkeys.isForward) == true
              ? doc[Dbkeys.isForward] == true
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
                  : SizedBox(height: 0, width: 0)
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

  Widget getTextMessage(bool isMe, Map<String, dynamic> doc, bool saved) {
    return doc.containsKey(Dbkeys.isReply) == true
        ? doc[Dbkeys.isReply] == true
            ? Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  replyAttachedWidget(this.context, doc[Dbkeys.replyToMsgDoc]),
                  SizedBox(
                    height: 10,
                  ),
                  selectablelinkify(doc[Dbkeys.content], 15.5, TextAlign.left),
                ],
              )
            : doc.containsKey(Dbkeys.isForward) == true
                ? doc[Dbkeys.isForward] == true
                    ? Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
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
                          selectablelinkify(
                              doc[Dbkeys.content], 15.5, TextAlign.left)
                        ],
                      )
                    : selectablelinkify(
                        doc[Dbkeys.content], 15.5, TextAlign.left)
                : selectablelinkify(doc[Dbkeys.content], 15.5, TextAlign.left)
        : selectablelinkify(doc[Dbkeys.content], 15.5, TextAlign.left);
  }

  Widget getLocationMessage(
      BuildContext context, String? message, Map<String, dynamic> doc,
      {bool saved = false}) {
    final bool isMe = false;
    return InkWell(
      onTap: AppConstants.isdemomode == true
          ? () {
              Utils.toast(getTranslatedForCurrentUser(
                  context, 'xxxnotalwddemoxxaccountxx'));
            }
          : () {
              custom_url_launcher(message!);
            },
      child: doc.containsKey(Dbkeys.isForward) == true
          ? doc[Dbkeys.isForward] == true
              ? Column(
                  crossAxisAlignment: isMe == true
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
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
                    Image.asset(
                      'assets/images/mapview.jpg',
                      width: MediaQuery.of(context).size.width / 1.7,
                      height: (MediaQuery.of(context).size.width / 1.7) * 0.6,
                    ),
                  ],
                )
              : Image.asset(
                  'assets/images/mapview.jpg',
                  width: MediaQuery.of(context).size.width / 1.7,
                  height: (MediaQuery.of(context).size.width / 1.7) * 0.6,
                )
          : Image.asset(
              'assets/images/mapview.jpg',
              width: MediaQuery.of(context).size.width / 1.7,
              height: (MediaQuery.of(context).size.width / 1.7) * 0.6,
            ),
    );
  }

  Widget getAudiomessage(
      BuildContext context, String message, Map<String, dynamic> doc,
      {bool saved = false, bool isMe = true}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      // width: 250,
      // height: 116,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          doc.containsKey(Dbkeys.isForward) == true
              ? doc[Dbkeys.isForward] == true
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
                  : SizedBox(height: 0, width: 0)
              : SizedBox(height: 0, width: 0),
          SizedBox(
            width: 200,
            height: 80,
            child: MultiPlayback(
              isMe: isMe,
              onTapDownloadFn: () async {
                await MobileDownloadService().download(
                    keyloader: _keyLoader,
                    url: message.split('-BREAK-')[0],
                    fileName:
                        'Recording_' + message.split('-BREAK-')[1] + '.mp3',
                    context: this.context,
                    isOpenAfterDownload: true);
              },
              url: message.split('-BREAK-')[0],
            ),
          )
        ],
      ),
    );
  }

  Widget getDocmessage(
      BuildContext context, String message, Map<String, dynamic> doc,
      {bool saved = false}) {
    final bool isMe = false;
    return SizedBox(
      width: 220,
      height: 126,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          doc.containsKey(Dbkeys.isForward) == true
              ? doc[Dbkeys.isForward] == true
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
                  : SizedBox(height: 0, width: 0)
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
                        onPressed: () async {
                          await MobileDownloadService().download(
                              url: message.split('-BREAK-')[0],
                              fileName: message.split('-BREAK-')[1],
                              context: context,
                              keyloader: _keyLoader,
                              isOpenAfterDownload: true);
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
                  onPressed: () async {
                    await MobileDownloadService().download(
                        url: message.split('-BREAK-')[0],
                        fileName: message.split('-BREAK-')[1],
                        context: context,
                        keyloader: _keyLoader,
                        isOpenAfterDownload: true);
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

  Widget getImageMessage(BuildContext context, Map<String, dynamic> doc,
      {bool saved = false}) {
    final bool isMe = false;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          doc.containsKey(Dbkeys.isForward) == true
              ? doc[Dbkeys.isForward] == true
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
                  : SizedBox(height: 0, width: 0)
              : SizedBox(height: 0, width: 0),
          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoViewWrapper(
                    keyloader: _keyLoader,
                    imageUrl: doc[Dbkeys.content],
                    message: doc[Dbkeys.content],
                    tag: doc[Dbkeys.groupmsgTIME].toString(),
                    imageProvider:
                        CachedNetworkImageProvider(doc[Dbkeys.content]),
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
                width: doc[Dbkeys.content].contains('giphy') ? 160 : 245.0,
                height: doc[Dbkeys.content].contains('giphy') ? 160 : 245.0,
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
                  width: doc[Dbkeys.content].contains('giphy') ? 160 : 245.0,
                  height: doc[Dbkeys.content].contains('giphy') ? 160 : 245.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              imageUrl: doc[Dbkeys.content],
              width: doc[Dbkeys.content].contains('giphy') ? 160 : 245.0,
              height: doc[Dbkeys.content].contains('giphy') ? 160 : 245.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  replyAttachedWidget(BuildContext context, var doc) {
    return Consumer<UserRegistry>(
        builder: (context, registry, _child) => Flexible(
              child: Container(
                  // width: 280,
                  height: 70,
                  margin: EdgeInsets.only(left: 0, right: 0),
                  decoration: BoxDecoration(
                      color: Mycolors.white.withOpacity(0.55),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Stack(
                    children: [
                      Container(
                          margin: EdgeInsetsDirectional.all(4),
                          decoration: BoxDecoration(
                              color: Mycolors.grey.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Row(children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.purple,
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
                                      registry
                                          .getUserData(context,
                                              doc[Dbkeys.groupmsgSENDBY])
                                          .fullname,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  doc[Dbkeys.messageType] ==
                                          MessageType.text.index
                                      ? Text(
                                          doc[Dbkeys.content],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )
                                      : doc[Dbkeys.messageType] ==
                                              MessageType.doc.index
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  right: 75),
                                              child: Text(
                                                doc[Dbkeys.content]
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
                                                          MessageType
                                                              .video.index
                                                      ? getTranslatedForCurrentUser(
                                                          context, 'xxnvmxx')
                                                      : doc[Dbkeys.tktMssgTYPE] ==
                                                              MessageType
                                                                  .audio.index
                                                          ? getTranslatedForCurrentUser(
                                                              context, 'xxnamxx')
                                                          : doc[Dbkeys.tktMssgTYPE] ==
                                                                  MessageType
                                                                      .contact
                                                                      .index
                                                              ? getTranslatedForCurrentUser(
                                                                  context,
                                                                  'xxncmxx')
                                                              : doc[Dbkeys.tktMssgTYPE] ==
                                                                      MessageType
                                                                          .location
                                                                          .index
                                                                  ? getTranslatedForCurrentUser(
                                                                      context,
                                                                      'xxnlmxx')
                                                                  : doc[Dbkeys.tktMssgTYPE] ==
                                                                          MessageType
                                                                              .doc
                                                                              .index
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
                      doc[Dbkeys.messageType] == MessageType.text.index ||
                              doc[Dbkeys.messageType] ==
                                  MessageType.location.index
                          ? SizedBox(
                              width: 0,
                              height: 0,
                            )
                          : doc[Dbkeys.messageType] == MessageType.image.index
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
                                        placeholder: (context, url) =>
                                            Container(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Mycolors.loadingindicator),
                                          ),
                                          width: doc[Dbkeys.content]
                                                  .contains('giphy')
                                              ? 60
                                              : 60.0,
                                          height: doc[Dbkeys.content]
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
                                        errorWidget: (context, str, error) =>
                                            Material(
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
                                        imageUrl: doc[Dbkeys.messageType] ==
                                                MessageType.video.index
                                            ? ''
                                            : doc[Dbkeys.content],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              : doc[Dbkeys.messageType] ==
                                      MessageType.video.index
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
                                                  bottomRight:
                                                      Radius.circular(5),
                                                  topLeft: Radius.circular(0),
                                                  bottomLeft:
                                                      Radius.circular(0)),
                                              child: Container(
                                                color: Colors.blueGrey[200],
                                                height: 74,
                                                width: 74,
                                                child: Stack(
                                                  children: [
                                                    CachedNetworkImage(
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Mycolors
                                                                      .loadingindicator),
                                                        ),
                                                        width: 74,
                                                        height: 74,
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .blueGrey[200],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                0.0),
                                                          ),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              str, error) =>
                                                          Material(
                                                        child: Image.asset(
                                                          'assets/COMMON_ASSETS/img_not_available.jpeg',
                                                          width: 60,
                                                          height: 60,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(0.0),
                                                        ),
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                      ),
                                                      imageUrl:
                                                          doc[Dbkeys.content]
                                                              .split(
                                                                  '-BREAK-')[1],
                                                      width: 74,
                                                      height: 74,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Container(
                                                      color: Colors.black
                                                          .withOpacity(0.4),
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
                                                  bottomRight:
                                                      Radius.circular(5),
                                                  topLeft: Radius.circular(0),
                                                  bottomLeft:
                                                      Radius.circular(0)),
                                              child: Container(
                                                  color: doc[Dbkeys.messageType] ==
                                                          MessageType.doc.index
                                                      ? Colors.yellow[800]
                                                      : doc[Dbkeys.messageType] ==
                                                              MessageType
                                                                  .audio.index
                                                          ? Colors.green[400]
                                                          : doc[Dbkeys.messageType] ==
                                                                  MessageType
                                                                      .location
                                                                      .index
                                                              ? Colors.red[700]
                                                              : doc[Dbkeys.messageType] ==
                                                                      MessageType
                                                                          .contact
                                                                          .index
                                                                  ? Colors
                                                                      .blue[400]
                                                                  : Colors
                                                                      .cyan[700],
                                                  height: 74,
                                                  width: 74,
                                                  child: Icon(
                                                    doc[Dbkeys.messageType] ==
                                                            MessageType
                                                                .doc.index
                                                        ? Icons
                                                            .insert_drive_file
                                                        : doc[Dbkeys.messageType] ==
                                                                MessageType
                                                                    .audio.index
                                                            ? Icons.mic_rounded
                                                            : doc[Dbkeys.messageType] ==
                                                                    MessageType
                                                                        .location
                                                                        .index
                                                                ? Icons
                                                                    .location_on
                                                                : doc[Dbkeys.messageType] ==
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
            ));
  }

  Widget buildMessagesUsingProvider(BuildContext context) {
    return Consumer<FirestoreDataProviderMESSAGESforGROUPCHAT>(
        builder: (context, firestoreDataProvider, _) =>
            InfiniteCOLLECTIONListViewWidget(
              scrollController: realtime,
              isreverse: true,
              firestoreDataProviderMESSAGESforGROUPCHAT: firestoreDataProvider,
              datatype: Dbkeys.datatypeGROUPCHATMSGS,
              refdata: firestoreChatquery,
              list: ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(7),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: firestoreDataProvider.recievedDocs.length,
                  itemBuilder: (BuildContext context, int i) {
                    var dc = firestoreDataProvider.recievedDocs[i];

                    return buildEachMessage(dc);
                  }),
            ));
  }

  Widget buildLoadingThumbnail() {
    return Positioned(
      child: isgeneratingSomethingLoader
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Mycolors.loadingindicator)),
              ),
              color: Mycolors.white.withOpacity(0.2),
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
    return Scaffold(
        key: _scaffold,
        appBar: AppBar(
          elevation: 0.4,
          titleSpacing: -10,
          leading: Container(
            margin: EdgeInsets.only(right: 0),
            width: 10,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Mycolors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          backgroundColor: Mycolors.white,
          title: InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     new MaterialPageRoute(
              //         builder: (context) => new GroupDetails(
              //             model: widget.model,
              //             prefs: widget.prefs,
              //             currentUserID: widget.currentUserno,
              //             groupID: widget.groupID)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                    child: widget.groupMap[Dbkeys.groupPHOTOURL] == ""
                        ? CircleAvatar(
                            child: Icon(
                              Icons.people,
                              color: Colors.white,
                            ),
                            radius: 20,
                            backgroundColor:
                                Utils.randomColorgenratorBasedOnFirstLetter(
                                    widget.groupMap[Dbkeys.groupNAME]),
                          )
                        : customCircleAvatarGroup(
                            radius: 20,
                            url: widget.groupMap[Dbkeys.groupPHOTOURL])),
                SizedBox(
                  width: 7,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.groupMap[Dbkeys.groupNAME],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Mycolors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600),
                        ),
                        isCurrentUserMuted
                            ? Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Icon(
                                  Icons.volume_off,
                                  color: Mycolors.black.withOpacity(0.5),
                                  size: 17,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.7,
                      child: Text(
                        "${getTranslatedForCurrentUser(context, 'xxagentsxx').toUpperCase()} ${getTranslatedForCurrentUser(context, 'xxxgroupidxxx').toUpperCase()} ${widget.groupID}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Mycolors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                        Column(children: [
                          ListTile(
                              leading: Icon(
                                Icons.menu,
                                color: Colors.cyan,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                pageNavigator(
                                    context,
                                    GroupDetails(
                                      groupID: widget.groupID,
                                      groupMap: widget.groupMap,
                                    ));
                              },
                              title: MtCustomfontBoldSemi(
                                text: getTranslatedForCurrentUser(
                                    context, 'xxxseegroupdetailsxx'),
                                fontsize: 16,
                              )),
                          Divider(),
                        ]),
                        Column(
                          children: [
                            ListTile(
                                leading: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onTap: AppConstants.isdemomode == true
                                    ? () {
                                        Utils.toast(getTranslatedForCurrentUser(
                                            context,
                                            'xxxnotalwddemoxxaccountxx'));
                                      }
                                    : () {
                                        Navigator.of(context).pop();
                                        ShowConfirmWithInputTextDialog().open(
                                            context: context,
                                            title: getTranslatedForCurrentUser(
                                                context, 'xxxdltgroupxxx'),
                                            controller: _reason,
                                            subtitle:
                                                getTranslatedForCurrentUser(
                                                    context,
                                                    'xxxisdltgroupxxx'),
                                            rightbtntext:
                                                getTranslatedForCurrentUser(
                                                        context, 'xxdeletexx')
                                                    .toUpperCase(),
                                            rightbtnonpress: () async {
                                              List<dynamic> agents =
                                                  widget.groupMap[
                                                      Dbkeys.groupMEMBERSLIST];
                                              ShowLoading().open(
                                                  context: context,
                                                  key: _keyLoader);
                                              await FirebaseFirestore.instance
                                                  .collection(DbPaths
                                                      .collectionAgentGroups)
                                                  .doc(widget.groupID)
                                                  .delete()
                                                  .then((value) {
                                                agents.forEach((element) async {
                                                  await Utils.sendDirectNotification(
                                                      title: getTranslatedForCurrentUser(
                                                              context,
                                                              'xxxdeletedyourxxx')
                                                          .replaceAll('(####)',
                                                              '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                                          .replaceAll('(###)',
                                                              '${getTranslatedForCurrentUser(context, 'xxxgroupxxx')}'),
                                                      parentID:
                                                          "GROUP--${widget.groupID}",
                                                      plaindesc: _reason.text
                                                                  .trim()
                                                                  .length <
                                                              1
                                                          ? "${getTranslatedForCurrentUser(context, 'xxxdeletedyourxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxxgroupxxx')}')} ${widget.groupMap[Dbkeys.groupNAME]} ${getTranslatedForCurrentUser(context, 'xxidxx')} ${widget.groupID} (${agents.length} ${getTranslatedForCurrentUser(context, 'xxagentsxx')}"
                                                          : "${getTranslatedForCurrentUser(context, 'xxxdeletedyourxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxxgroupxxx')}')} ${widget.groupMap[Dbkeys.groupNAME]} ${getTranslatedForCurrentUser(context, 'xxidxx')} ${widget.groupID} (${agents.length} ${getTranslatedForCurrentUser(context, 'xxagentsxx')}" +
                                                              "\n  ${getTranslatedForCurrentUser(context, 'xxreasonxx')} ${_reason.text.trim()}",
                                                      docRef: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              DbPaths.collectionagents)
                                                          .doc(element)
                                                          .collection(DbPaths.agentnotifications)
                                                          .doc(DbPaths.agentnotifications),
                                                      postedbyID: 'Admin');
                                                });

                                                FirebaseApi
                                                    .runTransactionRecordActivity(
                                                  parentid:
                                                      "GROUP--${widget.groupID}",
                                                  title: getTranslatedForCurrentUser(
                                                          context,
                                                          'xxxchatroomdeletedxxx')
                                                      .replaceAll('(####)',
                                                          '${getTranslatedForCurrentUser(context, 'xxgroupchatxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')}')
                                                      .replaceAll('(###)',
                                                          '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
                                                  postedbyID: "sys",
                                                  onErrorFn: (e) {
                                                    ShowLoading().close(
                                                        key: _keyLoader,
                                                        context: context);
                                                    Utils.toast(
                                                        "${getTranslatedForCurrentUser(context, 'xxfailedxx')}. ERROR $e");
                                                  },
                                                  onSuccessFn: () {
                                                    ShowLoading().close(
                                                        key: _keyLoader,
                                                        context: context);
                                                    Utils.toast(
                                                        "${getTranslatedForCurrentUser(context, 'xxxgroupidxxx')} ${widget.groupID} ${getTranslatedForCurrentUser(context, 'xxxdltedsuccessxxx')}");

                                                    Navigator.of(this.context)
                                                        .pop();
                                                    Navigator.of(this.context)
                                                        .pop();

                                                    widget.onDelete();
                                                  },
                                                  plainDesc: _reason.text
                                                              .trim()
                                                              .length <
                                                          1
                                                      ? "${getTranslatedForCurrentUser(context, 'xxxdeletedyourxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxxgroupxxx')}')} ${widget.groupMap[Dbkeys.groupNAME]} ${getTranslatedForCurrentUser(context, 'xxidxx')} ${widget.groupID} (${agents.length} ${getTranslatedForCurrentUser(context, 'xxagentsxx')}"
                                                      : "${getTranslatedForCurrentUser(context, 'xxxdeletedyourxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxxgroupxxx')}')} ${widget.groupMap[Dbkeys.groupNAME]} ${getTranslatedForCurrentUser(context, 'xxidxx')} ${widget.groupID} (${agents.length} ${getTranslatedForCurrentUser(context, 'xxagentsxx')}" +
                                                          "\n  ${getTranslatedForCurrentUser(context, 'xxreasonxx')} ${_reason.text.trim()}",
                                                );
                                              });
                                            });
                                      },
                                title: MtCustomfontBoldSemi(
                                  text: getTranslatedForCurrentUser(
                                      context, 'xxxdltgroupxxx'),
                                  fontsize: 16,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ]);
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Mycolors.black,
                ))
          ],
        ),
        body: Stack(children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              color: Mycolors.backgroundcolor,
              image: new DecorationImage(
                  image: AssetImage("assets/COMMON_ASSETS/background.png"),
                  fit: BoxFit.cover),
            ),
          ),
          PageView(children: <Widget>[
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Consumer<Observer>(
                  builder: (context, observer, _child) => warningTile(
                      title: observer.userAppSettingsDoc!
                                  .defaultMessageDeletingTimeForOneToOneChat ==
                              0
                          ? getTranslatedForCurrentUser(
                              context, 'xxmssgautodeletenotxxx')
                          : getTranslatedForCurrentUser(
                                  context, 'xxxmssgautodeletexxx')
                              .replaceAll('(####)',
                                  '<bold>${observer.userAppSettingsDoc!.defaultMessageDeletingTimeForGroup}</bold>'),
                      warningTypeIndex: WarningType.alert.index,
                      isstyledtext: true)),
              Expanded(child: buildMessagesUsingProvider(context)),
              widget.groupMap[Dbkeys.groupTYPE] ==
                      Dbkeys.groupTYPEallusersmessageallowed
                  ? SizedBox()
                  : Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(14, 7, 14, 7),
                      color: Colors.white,
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        getTranslatedForEventsAndAlerts(
                            context, 'xxonlyadminsendxx'),
                        textAlign: TextAlign.center,
                        style: TextStyle(height: 1.3),
                      ),
                    ),
            ])
          ]),
        ]));
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
    bool isContainURL = false;
    try {
      isContainURL =
          Uri.tryParse(text!) == null ? false : Uri.tryParse(text)!.isAbsolute;
    } on Exception catch (_) {
      isContainURL = false;
    }
    return isContainURL == false
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
              text: text,
              textAlign: textalign,
              onOpen: (link) async {
                custom_url_launcher(link.url);
              },
            ),
            link: text,
            linkPreviewStyle: LinkPreviewStyle.large,
          );
  }

  deletedGroupWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              "${getTranslatedForCurrentUser(context, 'xxxgroupxxx')} " +
                  getTranslatedForCurrentUser(context, 'xxdeletedxx'),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
