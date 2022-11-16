import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/agent_model.dart';
import 'package:thinkcreative_technologies/Screens/agents/agent_profile_details.dart';
import 'package:thinkcreative_technologies/Screens/callHistory/callHistory.dart';
import 'package:thinkcreative_technologies/Utils/custom_url_launcher.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/MultiPlayback/soundPlayerPro.dart';
import 'package:thinkcreative_technologies/Widgets/boxdecoration.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Widgets/pdf_viewer/PdfViewFromCachedUrl.dart';
import 'package:thinkcreative_technologies/Widgets/pickers/VideoPicker/VideoPreview.dart';
import 'package:thinkcreative_technologies/Widgets/timeWidgets/getwhen.dart';

Widget chatBubble({
  required BuildContext context,
  var chatRoomDoc,
  var chatMssgDoc,
  required bool isLHS,
  required String rhsUsername,
  required String rhsUserID,
  required String rhsUserPhoto,
  required String lhsUsername,
  required String lhsUserID,
  required String lhsUserPhoto,
}) {
  humanReadableTime() => DateFormat(
          Optionalconstants.is24hrsFormat == true ? 'HH:mm' : 'h:mm a')
      .format(
          DateTime.fromMillisecondsSinceEpoch(chatMssgDoc[Dbkeys.timestamp]));
  return Padding(
    padding: const EdgeInsets.all(13.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isLHS ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        !isLHS
            ? chatMssgDoc[Dbkeys.hasSenderDeleted] == true ||
                    chatMssgDoc[Dbkeys.deletedType] != "" ||
                    chatMssgDoc[Dbkeys.deletedType] != ""
                ? Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: MtCustomfontRegular(
                      text: chatMssgDoc[Dbkeys.deletedType] == "Admin" ||
                              chatMssgDoc[Dbkeys.deletedType] ==
                                  DeletedType.adminDeleted.index.toString()
                          ? chatMssgDoc[Dbkeys.deletedReason] == ""
                              ? getTranslatedForCurrentUser(
                                  context, 'xxmsgdeletedbyadminxx')
                              : "${getTranslatedForCurrentUser(context, 'xxmsgdeletedbyadminxx')}\n${getTranslatedForCurrentUser(context, 'xxreasonxxx').toUpperCase()} \"${chatMssgDoc[Dbkeys.deletedReason]}\""
                          : chatMssgDoc[Dbkeys.deletedType] ==
                                  DeletedType.peerHasAlreadyRead.index
                                      .toString()
                              ? getTranslatedForCurrentUser(
                                  context, 'xxxmsgdeltdbysenderxxx')
                              : chatMssgDoc[Dbkeys.deletedType] ==
                                      DeletedType.peerHasNotReadYet.index
                                          .toString()
                                  ? getTranslatedForCurrentUser(
                                      context, 'xxxmsgdeltdbysenderbeforexxx')
                                  : getTranslatedForCurrentUser(
                                      context, 'xxxmsgdeltdbysendershortxxx'),
                      color: Colors.red,
                      fontsize: 12,
                      textalign: TextAlign.right,
                      isitalic: true,
                    ),
                  )
                : SizedBox()
            : SizedBox(),
        InkWell(
          onTap: () {
            Utils.toast(
                getTranslatedForCurrentUser(context, 'xxloadinguserxx'));
            FirebaseFirestore.instance
                .collection(DbPaths.collectionagents)
                .doc(isLHS ? lhsUserID : rhsUserID)
                .get()
                .then((agent) {
              pageNavigator(
                  context,
                  AgentProfileDetails(
                    agent: AgentModel.fromSnapshot(agent),
                    currentuserid: Optionalconstants.currentAdminID,
                  ));
            });
          },
          child: isLHS
              ? customCircleAvatar(url: lhsUserPhoto, radius: 19)
              : SizedBox(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment:
                isLHS ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Utils.toast(getTranslatedForCurrentUser(
                          context, 'xxloadinguserxx'));
                      FirebaseFirestore.instance
                          .collection(DbPaths.collectionagents)
                          .doc(isLHS ? lhsUserID : rhsUserID)
                          .get()
                          .then((agent) {
                        pageNavigator(
                            context,
                            AgentProfileDetails(
                              agent: AgentModel.fromSnapshot(agent),
                              currentuserid: Optionalconstants.currentAdminID,
                            ));
                      });
                    },
                    child: MtCustomfontBoldSemi(
                      text: isLHS ? lhsUsername : rhsUsername,
                      fontsize: 13.4,
                      color: Mycolors.grey,
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(0, 8, 8, 8),
                  alignment:
                      isLHS ? Alignment.centerLeft : Alignment.centerRight,
                  decoration: boxDecoration(
                      showShadow: false,
                      radius: 5,
                      bgColor: isLHS
                          ? chatMssgDoc[Dbkeys.hasSenderDeleted] == true ||
                                  chatMssgDoc[Dbkeys.deletedType] != "" ||
                                  chatMssgDoc[Dbkeys.deletedType] != ""
                              ? Color(0xffffbfbf)
                              : Colors.white
                          : chatMssgDoc[Dbkeys.hasSenderDeleted] == true ||
                                  chatMssgDoc[Dbkeys.deletedType] != "" ||
                                  chatMssgDoc[Dbkeys.deletedType] != ""
                              ? Color(0xffffbfbf)
                              : Mycolors.chatBubbleColor),
                  child: buildMssgByType(
                    context: context,
                    doc: chatMssgDoc,
                    isRHS: !isLHS,
                    rhsUserid: rhsUserID,
                    lhsUserName: lhsUsername,
                    rhsUsername: rhsUsername,
                    lhsUserid: lhsUserID,
                  ),
                ),
              ),
              Row(
                children: !isLHS
                    ? [
                        chatRoomDoc.data().containsKey(lhsUserID)
                            ? chatRoomDoc[lhsUserID] is int
                                ? chatMssgDoc[Dbkeys.timestamp] >=
                                        chatRoomDoc[lhsUserID]
                                    ? myinkwell(
                                        onTap: () {
                                          Utils.toast(
                                            getTranslatedForCurrentUser(context,
                                                    'xxxmssgnotseenbyxxxxx')
                                                .replaceAll(
                                                    '(####)', '$lhsUsername'),
                                          );
                                        },
                                        child: Icon(
                                          Icons.visibility,
                                          color: Mycolors.grey,
                                          size: 12,
                                        ),
                                      )
                                    : myinkwell(
                                        onTap: () {
                                          Utils.toast(
                                              getTranslatedForCurrentUser(
                                                      context,
                                                      'xxxmssgseenbyxxx')
                                                  .replaceAll('(####)',
                                                      '$lhsUsername'));
                                        },
                                        child: Icon(
                                          Icons.visibility,
                                          color: Mycolors.blue,
                                          size: 12,
                                        ),
                                      )
                                : SizedBox()
                            : myinkwell(
                                onTap: () {
                                  Utils.toast(
                                    getTranslatedForCurrentUser(
                                            context, 'xxxmssgnotseenbyxxxxx')
                                        .replaceAll('(####)', '$lhsUsername'),
                                  );
                                },
                                child: Icon(
                                  Icons.visibility,
                                  color: Mycolors.grey,
                                  size: 12,
                                ),
                              ),
                        SizedBox(
                          width: 13,
                        ),
                        MtCustomfontLight(
                          text: getWhen(
                                DateTime.fromMillisecondsSinceEpoch(
                                    chatMssgDoc[Dbkeys.timestamp]),
                              ) +
                              ', ' +
                              humanReadableTime(),
                          fontsize: 11,
                          color: Mycolors.black.withOpacity(0.6),
                        ),
                      ]
                    : [
                        MtCustomfontLight(
                          text: getWhen(
                                DateTime.fromMillisecondsSinceEpoch(
                                    chatMssgDoc[Dbkeys.timestamp]),
                              ) +
                              ', ' +
                              humanReadableTime(),
                          fontsize: 11,
                          color: Mycolors.black.withOpacity(0.6),
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        chatRoomDoc.data().containsKey(rhsUserID)
                            ? chatRoomDoc[rhsUserID] is int
                                ? chatMssgDoc[Dbkeys.timestamp] >=
                                        chatRoomDoc[rhsUserID]
                                    ? myinkwell(
                                        onTap: () {
                                          Utils.toast(
                                            getTranslatedForCurrentUser(context,
                                                    'xxxmssgnotseenbyxxxxx')
                                                .replaceAll(
                                                    '(####)', '$rhsUsername'),
                                          );
                                        },
                                        child: Icon(
                                          Icons.visibility,
                                          color: Mycolors.grey,
                                          size: 12,
                                        ),
                                      )
                                    : myinkwell(
                                        onTap: () {
                                          Utils.toast(
                                              getTranslatedForCurrentUser(
                                                      context,
                                                      'xxxmssgseenbyxxx')
                                                  .replaceAll('(####)',
                                                      '$rhsUsername'));
                                        },
                                        child: Icon(
                                          Icons.visibility,
                                          color: Mycolors.blue,
                                          size: 12,
                                        ),
                                      )
                                : SizedBox()
                            : myinkwell(
                                onTap: () {
                                  Utils.toast(
                                    getTranslatedForCurrentUser(
                                            context, 'xxxmssgnotseenbyxxxxx')
                                        .replaceAll('(####)', '$rhsUsername'),
                                  );
                                },
                                child: Icon(
                                  Icons.visibility,
                                  color: Mycolors.grey,
                                  size: 12,
                                ),
                              ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
              )
            ],
          ),
        ),
        !isLHS
            ? InkWell(
                onTap: () {
                  Utils.toast(
                      getTranslatedForCurrentUser(context, 'xxloadinguserxx'));
                  FirebaseFirestore.instance
                      .collection(DbPaths.collectionagents)
                      .doc(isLHS ? lhsUserID : rhsUserID)
                      .get()
                      .then((agent) {
                    pageNavigator(
                        context,
                        AgentProfileDetails(
                          agent: AgentModel.fromSnapshot(agent),
                          currentuserid: Optionalconstants.currentAdminID,
                        ));
                  });
                },
                child: customCircleAvatar(url: rhsUserPhoto, radius: 19))
            : SizedBox(),
        isLHS
            ? chatMssgDoc[Dbkeys.hasSenderDeleted] == true ||
                    chatMssgDoc[Dbkeys.deletedType] != "" ||
                    chatMssgDoc[Dbkeys.deletedType] != ""
                ? Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: MtCustomfontRegular(
                      text: chatMssgDoc[Dbkeys.deletedType] == "Admin" ||
                              chatMssgDoc[Dbkeys.deletedType] ==
                                  DeletedType.adminDeleted.index.toString()
                          ? chatMssgDoc[Dbkeys.deletedReason] == ""
                              ? getTranslatedForCurrentUser(
                                  context, 'xxmsgdltdbyadminxx')
                              : "${getTranslatedForCurrentUser(context, 'xxmsgdltdbyadminxx')}\n${getTranslatedForCurrentUser(context, 'xxreasonxx').toUpperCase()} \"${chatMssgDoc[Dbkeys.deletedReason]}\""
                          : chatMssgDoc[Dbkeys.deletedType] ==
                                  DeletedType.peerHasAlreadyRead.index
                                      .toString()
                              ? getTranslatedForCurrentUser(
                                  context, 'xxxmsgdeltdbysenderxxx')
                              : chatMssgDoc[Dbkeys.deletedType] ==
                                      DeletedType.peerHasNotReadYet.index
                                          .toString()
                                  ? getTranslatedForCurrentUser(
                                      context, 'xxxmsgdeltdbysenderbeforexxx')
                                  : getTranslatedForCurrentUser(
                                      context, 'xxxmsgdeltdbysendershortxxx'),
                      color: Colors.red,
                      fontsize: 12,
                      lineheight: 1.2,
                      textalign: TextAlign.left,
                      isitalic: true,
                    ),
                  )
                : SizedBox()
            : SizedBox()
      ],
    ),
  );
}

Widget buildMssgByType(
    {context, doc, isRHS, lhsUserName, lhsUserid, rhsUsername, rhsUserid}) {
  Widget selectablelinkify(String? text, double? fontsize) {
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
          )
        : LinkPreviewGenerator(
            removeElevation: true,
            graphicFit: BoxFit.contain,
            borderRadius: 5,
            showDomain: true,
            titleStyle: TextStyle(
                fontSize: 13, height: 1.3, fontWeight: FontWeight.bold),
            showBody: true,
            bodyStyle: TextStyle(fontSize: 11.6, color: Colors.black45),
            placeholderWidget: SelectableLinkify(
              style: TextStyle(fontSize: fontsize, color: Colors.black87),
              text: text!,
              onOpen: (link) async {
                custom_url_launcher(link.url);
              },
            ),
            errorWidget: SelectableLinkify(
              style: TextStyle(fontSize: fontsize, color: Colors.black87),
              text: text,
              onOpen: (link) async {
                custom_url_launcher(link.url);
              },
            ),
            link: text,
            linkPreviewStyle: LinkPreviewStyle.large,
          );
  }

  Widget getLocationMessage(isRHS, Map<String, dynamic> doc, String? message,
      {bool saved = false}) {
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
                  crossAxisAlignment:
                      isRHS ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        child: Row(
                            mainAxisAlignment: isRHS == true
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
                      'assets/COMMON_ASSETS/mapview.jpg',
                    )
                  ],
                )
              : Image.asset(
                  'assets/COMMON_ASSETS/mapview.jpg',
                )
          : Image.asset(
              'assets/COMMON_ASSETS/mapview.jpg',
            ),
    );
  }

  Widget getAudiomessage(
      BuildContext context, Map<String, dynamic> doc, String message,
      {bool saved = false, bool isMe = true}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      // width: 250,
      // height: 116,
      child: Column(
        crossAxisAlignment:
            isMe == true ? CrossAxisAlignment.start : CrossAxisAlignment.end,
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
                // await MobileDownloadService().download(
                //     keyloader: _keyLoader,
                //     url: message.split('-BREAK-')[0],
                //     fileName:
                //         'Recording_' + message.split('-BREAK-')[1] + '.mp3',
                //     context: this.context,
                //     isOpenAfterDownload: true);
              },
              url: message.split('-BREAK-')[0],
            ),
          )
        ],
      ),
    );
  }

  Widget getDocmessage(bool isRHS, BuildContext context,
      Map<String, dynamic> doc, String message,
      {bool saved = false}) {
    return SizedBox(
      width: 220,
      height: 116,
      child: Column(
        crossAxisAlignment:
            isRHS == true ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          doc.containsKey(Dbkeys.isForward) == true
              ? doc[Dbkeys.isForward] == true
                  ? Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                          mainAxisAlignment: isRHS == true
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
                          // await MobileDownloadService().download(
                          //     url: message.split('-BREAK-')[0],
                          //     fileName: message.split('-BREAK-')[1],
                          //     context: context,
                          //     keyloader: _keyLoader,
                          //     isOpenAfterDownload: true);
                        },
                        child: Text(
                            getTranslatedForCurrentUser(
                                context, 'xxdownloadxx'),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.blue[400]))),
                  ],
                )
              //ignore: deprecated_member_use
              : FlatButton(
                  onPressed: () async {
                    // await MobileDownloadService().download(
                    //     url: message.split('-BREAK-')[0],
                    //     fileName: message.split('-BREAK-')[1],
                    //     context: context,
                    //     keyloader: _keyLoader,
                    //     isOpenAfterDownload: true);
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

  Widget getImageMessage(bool isRHS, Map<String, dynamic> doc,
      {bool saved = false}) {
    return Container(
      child: Column(
        crossAxisAlignment:
            isRHS == true ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          doc.containsKey(Dbkeys.isForward) == true
              ? doc[Dbkeys.isForward] == true
                  ? Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                          mainAxisAlignment: isRHS == true
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
          CachedNetworkImage(
            placeholder: (context, url) => Container(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.blueGrey[400]!),
              ),
              width: doc[Dbkeys.content].contains('giphy') ? 120 : 200.0,
              height: doc[Dbkeys.content].contains('giphy') ? 120 : 200.0,
              padding: EdgeInsets.all(80.0),
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
                width: doc[Dbkeys.content].contains('giphy') ? 120 : 200.0,
                height: doc[Dbkeys.content].contains('giphy') ? 120 : 200.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              clipBehavior: Clip.hardEdge,
            ),
            imageUrl: doc[Dbkeys.content],
            width: doc[Dbkeys.content].contains('giphy') ? 120 : 200.0,
            height: doc[Dbkeys.content].contains('giphy') ? 120 : 200.0,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget getVideoMessage(bool isRHS, BuildContext context,
      Map<String, dynamic> doc, String message,
      {bool saved = false}) {
    Map<dynamic, dynamic>? meta =
        jsonDecode((message.split('-BREAK-')[2]).toString());

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new PreviewVideo(
                      isdownloadallowed: true,
                      filename: message.split('-BREAK-').length > 3
                          ? message.split('-BREAK-')[3]
                          : "Video-${DateTime.now().millisecondsSinceEpoch}.mp4",
                      id: null,
                      videourl: message.split('-BREAK-')[0],
                      aspectratio: meta!["width"] / meta["height"],
                    )));
      },
      child: Column(
        crossAxisAlignment:
            isRHS == true ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          doc.containsKey(Dbkeys.isForward) == true
              ? doc[Dbkeys.isForward] == true
                  ? Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                          mainAxisAlignment: isRHS == true
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
            height: 197,
            width: 197,
            child: Stack(
              children: [
                CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueGrey[400]!),
                    ),
                    width: 197,
                    height: 197,
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
                      width: 197,
                      height: 197,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(0.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: message.split('-BREAK-')[1],
                  width: 197,
                  height: 197,
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black.withOpacity(0.4),
                  height: 197,
                  width: 197,
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
    );
  }

  // Widget getContactMessage(bool isRHS, BuildContext context,
  //     Map<String, dynamic> doc, String message,
  //     {bool saved = false}) {
  //   return SizedBox(
  //     width: 250,
  //     height: 130,
  //     child: Column(
  //       crossAxisAlignment:
  //           isRHS == true ? CrossAxisAlignment.start : CrossAxisAlignment.end,
  //       children: [
  //         doc.containsKey(Dbkeys.isForward) == true
  //             ? doc[Dbkeys.isForward] == true
  //                 ? Container(
  //                     margin: EdgeInsets.only(bottom: 10),
  //                     child: Row(
  //                         mainAxisAlignment: isRHS == true
  //                             ? MainAxisAlignment.start
  //                             : MainAxisAlignment.end,
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Icon(
  //                             FontAwesomeIcons.share,
  //                             size: 12,
  //                             color: Mycolors.grey.withOpacity(0.5),
  //                           ),
  //                           SizedBox(
  //                             width: 5,
  //                           ),
  //                           Text('Forwarded',
  //                               maxLines: 1,
  //                               style: TextStyle(
  //                                   color: Mycolors.grey.withOpacity(0.7),
  //                                   fontStyle: FontStyle.italic,
  //                                   overflow: TextOverflow.ellipsis,
  //                                   fontSize: 13))
  //                         ]))
  //                 : SizedBox(height: 0, width: 0)
  //             : SizedBox(height: 0, width: 0),
  //         ListTile(
  //           isThreeLine: false,
  //           leading: customCircleAvatar(url: null),
  //           title: Text(
  //             message.split('-BREAK-')[0],
  //             overflow: TextOverflow.ellipsis,
  //             maxLines: 1,
  //             style: TextStyle(
  //                 height: 1.4,
  //                 fontWeight: FontWeight.w700,
  //                 color: Colors.blue[400]),
  //           ),
  //           subtitle: Padding(
  //             padding: const EdgeInsets.only(top: 3),
  //             child: Text(
  //               message.split('-BREAK-')[1],
  //               style: TextStyle(
  //                   height: 1.4,
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.black87),
  //             ),
  //           ),
  //         ),
  //         Divider(
  //           height: 7,
  //         ),
  //         // ignore: deprecated_member_use
  //         FlatButton(
  //             onPressed: () async {},
  //             child: Text("SEE PROFILE",
  //                 style: TextStyle(
  //                     fontWeight: FontWeight.w700, color: Colors.blue[400])))
  //       ],
  //     ),
  //   );
  // }

  replyAttachedWidget(BuildContext context, var doc, String rhsUsername,
      String lhsUsername, String rhsUserid, String lhsUserid) {
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
                        color: isRHS ? Mycolors.primary : Mycolors.secondary,
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
                              isRHS ? rhsUsername : lhsUsername,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isRHS
                                      ? Mycolors.primary
                                      : Mycolors.secondary),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          doc[Dbkeys.messageType] == MessageType.text.index
                              ? Text(
                                  doc[Dbkeys.content],
                                  overflow: TextOverflow.ellipsis,
                                  // textAlign:  doc[Dbkeys.from] == currentUserNo? TextAlign.end: TextAlign.start,
                                  maxLines: 1,
                                )
                              : doc[Dbkeys.messageType] == MessageType.doc.index
                                  ? Container(
                                      padding: const EdgeInsets.only(right: 70),
                                      child: Text(
                                        doc[Dbkeys.content].split('-BREAK-')[1],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    )
                                  : Text(
                                      doc[Dbkeys.messageType] ==
                                              MessageType.image.index
                                          ? getTranslatedForCurrentUser(
                                              context, 'xxnimxx')
                                          : doc[Dbkeys.messageType] ==
                                                  MessageType.video.index
                                              ? getTranslatedForCurrentUser(
                                                  context, 'xxnvmxx')
                                              : doc[Dbkeys.messageType] ==
                                                      MessageType.audio.index
                                                  ? getTranslatedForCurrentUser(
                                                      context, 'xxnamxx')
                                                  : doc[Dbkeys.messageType] ==
                                                          MessageType
                                                              .contact.index
                                                      ? getTranslatedForCurrentUser(
                                                          context, 'xxncmxx')
                                                      : doc[Dbkeys.messageType] ==
                                                              MessageType
                                                                  .location
                                                                  .index
                                                          ? getTranslatedForCurrentUser(
                                                              context,
                                                              'xxnlmxx')
                                                          : doc[Dbkeys.messageType] ==
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
              doc[Dbkeys.messageType] == MessageType.text.index ||
                      doc[Dbkeys.messageType] == MessageType.location.index
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
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Mycolors.loadingindicator),
                                  ),
                                  width: doc[Dbkeys.content].contains('giphy')
                                      ? 60
                                      : 60.0,
                                  height: doc[Dbkeys.content].contains('giphy')
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
                      : doc[Dbkeys.messageType] == MessageType.video.index
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
                                                          Mycolors
                                                              .loadingindicator),
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
                                              imageUrl: doc[Dbkeys.content]
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
                                          color: doc[Dbkeys.messageType] ==
                                                  MessageType.doc.index
                                              ? Colors.yellow[800]
                                              : doc[Dbkeys.messageType] ==
                                                      MessageType.audio.index
                                                  ? Colors.green[400]
                                                  : doc[Dbkeys.messageType] ==
                                                          MessageType
                                                              .location.index
                                                      ? Colors.red[700]
                                                      : doc[Dbkeys.messageType] ==
                                                              MessageType
                                                                  .contact.index
                                                          ? Colors.blue[400]
                                                          : Colors.cyan[700],
                                          height: 74,
                                          width: 74,
                                          child: Icon(
                                            doc[Dbkeys.messageType] ==
                                                    MessageType.doc.index
                                                ? Icons.insert_drive_file
                                                : doc[Dbkeys.messageType] ==
                                                        MessageType.audio.index
                                                    ? Icons.mic_rounded
                                                    : doc[Dbkeys.messageType] ==
                                                            MessageType
                                                                .location.index
                                                        ? Icons.location_on
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
    );
  }

  Widget getTextMessage(
      bool isRHS,
      Map<String, dynamic> doc,
      bool saved,
      String rhsUserid,
      String lhsUserid,
      String rhsUsername,
      String lhsUsername) {
    return doc.containsKey(Dbkeys.isReply) == true
        ? doc[Dbkeys.isReply] == true
            ? Column(
                crossAxisAlignment: isRHS == true
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  replyAttachedWidget(context, doc[Dbkeys.replyToMsgDoc],
                      rhsUsername, lhsUsername, rhsUserid, lhsUserid),
                  SizedBox(
                    height: 10,
                  ),
                  selectablelinkify(doc[Dbkeys.content], 14),
                ],
              )
            : doc.containsKey(Dbkeys.isForward) == true
                ? doc[Dbkeys.isForward] == true
                    ? Column(
                        crossAxisAlignment: isRHS
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              child: Row(
                                  mainAxisAlignment: isRHS == true
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
                          selectablelinkify(doc[Dbkeys.content], 14),
                        ],
                      )
                    : selectablelinkify(doc[Dbkeys.content], 14)
                : selectablelinkify(doc[Dbkeys.content], 14)
        : selectablelinkify(doc[Dbkeys.content], 14);
  }

  return doc[Dbkeys.messageType] == MessageType.text.index
      ? getTextMessage(
          isRHS, doc, false, rhsUserid, lhsUserid, rhsUsername, lhsUserName)
      : doc[Dbkeys.messageType] == MessageType.location.index
          ? getLocationMessage(isRHS, doc, doc[Dbkeys.content], saved: false)
          : doc[Dbkeys.messageType] == MessageType.doc.index
              ? getDocmessage(isRHS, context, doc, doc[Dbkeys.content],
                  saved: false)
              : doc[Dbkeys.messageType] == MessageType.audio.index
                  ? getAudiomessage(context, doc, doc[Dbkeys.content],
                      isMe: isRHS, saved: false)
                  : doc[Dbkeys.messageType] == MessageType.video.index
                      ? getVideoMessage(
                          isRHS, context, doc, doc[Dbkeys.content],
                          saved: false)
                      : doc[Dbkeys.messageType] == MessageType.contact.index
                          ? SizedBox()
                          : getImageMessage(
                              isRHS,
                              doc,
                              saved: false,
                            );
}
