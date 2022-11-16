import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Screens/notifications/NotificationViewer.dart';
import 'package:thinkcreative_technologies/Utils/color_light_dark.dart';
import 'package:thinkcreative_technologies/Utils/custom_time_formatter.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/boxdecoration.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Widgets/nodata_widget.dart';

class UsersNotifiaction extends StatefulWidget {
  final DocumentReference docRef;
  const UsersNotifiaction({Key? key, required this.docRef}) : super(key: key);

  @override
  _UsersNotifiactionState createState() => _UsersNotifiactionState();
}

class _UsersNotifiactionState extends State<UsersNotifiaction> {
  List<dynamic> list = [];
  String error = "";
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  loadNotifications() async {
    await widget.docRef.get().then((doc) {
      if (doc.exists) {
        error = "";
        list = doc[Dbkeys.list]
            .reversed
            .toList()
            .where((element) =>
                element.containsKey(Dbkeys.nOTIFICATIONxxtitle) == true)
            .toList();
        setState(() {
          isloading = false;
        });
      } else {
        error =
            "Admin notification doc does not exists. Installation is not completed properly";
        setState(() {});
      }
    }).catchError((err) {
      error = "Error fetching Admin notification doc $err";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      icon1press: () {
        Utils.toast(getTranslatedForCurrentUser(context, 'xxloadingxx'));
        this.loadNotifications();
      },
      icondata1: Icons.refresh,
      title: list.length < 2
          ? getTranslatedForCurrentUser(context, 'xxallnotificationsxx')
          : "${list.length} ${getTranslatedForCurrentUser(context, 'xxallnotificationsxx')}",
      body: error != ""
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : isloading == true
              ? circularProgress()
              : list.length == 0
                  ? noDataWidget(
                      context: context,
                      title: getTranslatedForCurrentUser(
                          context, 'xxnonotificationsxx'),
                      iconData: Icons.notifications,
                      subtitle: getTranslatedForCurrentUser(
                          context, 'xxxallpersonalalertsxxx'))
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int i) {
                        return notificationcard(
                          doc: list[i],
                        );
                      }),
    );
  }

  //widget to show name in card
  Widget notificationcard(
      {bool? isSent,
      required Map<String, dynamic> doc,
      bool isForAdmin = true}) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        myinkwell(
          onTap: () {
            notificationViwer(
              context,
              doc[Dbkeys.nOTIFICATIONxxdesc],
              doc[Dbkeys.nOTIFICATIONxxtitle],
              doc[Dbkeys.nOTIFICATIONxxauthor],
              doc[Dbkeys.nOTIFICATIONxximageurl],
              formatTimeDateCOMLPETEString(
                isdateTime: true,
                datetimetargetTime: DateTime.fromMillisecondsSinceEpoch(
                    doc[Dbkeys.nOTIFICATIONxxlastupdateepoch]),
              ),
            );
          },
          child: h > w == true
              ? Container(
                  margin: EdgeInsets.fromLTRB(0, 3, 0, 4),
                  decoration: boxDecoration(showShadow: true),
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3, 5, 8, 9),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: lighten(Colors.yellow, 0.2),
                              radius: 13,
                              child: Icon(
                                Icons.notifications,
                                size: 13,
                                color: Mycolors.yellow,
                              ),
                            ),
                            MtCustomfontLight(
                              text: formatTimeDateCOMLPETEString(
                                  isdateTime: true,
                                  datetimetargetTime:
                                      DateTime.fromMillisecondsSinceEpoch(doc[
                                          Dbkeys
                                              .nOTIFICATIONxxlastupdateepoch])),
                              textalign: TextAlign.right,
                              fontsize: 11,
                              color: Mycolors.greytext,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height:
                            doc[Dbkeys.nOTIFICATIONxximageurl] == "" ? 5 : 10,
                      ),
                      doc[Dbkeys.nOTIFICATIONxximageurl] == ""
                          ? SizedBox()
                          : Container(
                              height: 190,
                              width: double.infinity,
                              color: Mycolors.greylightcolor,
                              child: doc[Dbkeys.nOTIFICATIONxximageurl] == ""
                                  ? Center(
                                      child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '  NO IMAGE  ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Mycolors.greytext
                                                .withOpacity(0.5)),
                                      ),
                                    ))
                                  : Image.network(
                                      doc[Dbkeys.nOTIFICATIONxximageurl],
                                      height: 80,
                                      width: 70,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                      SizedBox(
                        height:
                            doc[Dbkeys.nOTIFICATIONxximageurl] == "" ? 5 : 10,
                      ),
                      MtCustomfontBoldSemi(
                        text: doc[Dbkeys.nOTIFICATIONxxtitle] ?? '',
                        textalign: TextAlign.left,
                        color: Mycolors.black,
                        maxlines: 1,
                        overflow: TextOverflow.ellipsis,
                        lineheight: 1.25,
                        fontsize: 15,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      StyledText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Mycolors.grey,
                          height: 1.3,
                        ),
                        text: doc[Dbkeys.nOTIFICATIONxxdesc] ?? '',
                        tags: {
                          'bold': StyledTextTag(
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Mycolors.grey,
                                  fontSize: 13,
                                  height: 1.3)),
                        },
                      ),
                      // MtCustomfontLight(
                      //   text: doc[Dbkeys.nOTIFICATIONxxdesc] ??
                      //       'Hello test notifcations description',
                      //   textalign: TextAlign.left,
                      //   color: Mycolors.grey,
                      //   maxlines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      //   lineheight: 1.25,
                      //   fontsize: 13,
                      // )
                    ],
                  ))
              : Container(
                  margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
                  decoration: boxDecoration(showShadow: true),
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        height: 90,
                        width: 110,
                        color: Mycolors.greylightcolor,
                        child: doc[Dbkeys.nOTIFICATIONxximageurl] == ""
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '  NO IMAGE  ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Mycolors.greytext.withOpacity(0.5)),
                                ),
                              ))
                            : Image.network(
                                doc[Dbkeys.nOTIFICATIONxximageurl],
                                height: 80,
                                width: 70,
                                fit: BoxFit.contain,
                              ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(3, 5, 8, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor: lighten(Colors.yellow, 0.2),
                                  radius: 13,
                                  child: Icon(
                                    Icons.notifications,
                                    size: 13,
                                    color: Mycolors.yellow,
                                  ),
                                ),
                                // isSent == false
                                //     ? SizedBox(
                                //         height: 0,
                                //         width: 0,
                                //       )
                                //     : Container(
                                //         width: 80,
                                //         height: 20,
                                //         child: Row(
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.center,
                                //           children: [
                                //             Icon(
                                //               Icons.check_circle_outline_rounded,
                                //               size: 18,
                                //               color: Mycolors.green,
                                //             ),
                                //             SizedBox(
                                //               width: 7,
                                //             ),
                                //             MtCustomfontMedium(
                                //               text: 'Sent',
                                //               fontsize: 13,
                                //               color: Mycolors.green,
                                //             )
                                //           ],
                                //         ),
                                //       ),
                                MtCustomfontLight(
                                  text: formatTimeDateCOMLPETEString(
                                      isdateTime: true,
                                      datetimetargetTime: DateTime
                                          .fromMillisecondsSinceEpoch(doc[Dbkeys
                                              .nOTIFICATIONxxlastupdateepoch])),
                                  textalign: TextAlign.right,
                                  color: Mycolors.greytext,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          MtCustomfontBold(
                            text: doc[Dbkeys.nOTIFICATIONxxtitle] ?? ' ',
                            textalign: TextAlign.left,
                            color: Mycolors.black,
                            maxlines: 1,
                            overflow: TextOverflow.ellipsis,
                            lineheight: 1.25,
                            fontsize: 15,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          StyledText(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Mycolors.grey,
                                height: 1.3,
                                fontSize: 13),
                            text: doc[Dbkeys.nOTIFICATIONxxdesc] ?? '',
                            tags: {
                              'bold': StyledTextTag(
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Mycolors.grey,
                                      height: 1.3)),
                            },
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
