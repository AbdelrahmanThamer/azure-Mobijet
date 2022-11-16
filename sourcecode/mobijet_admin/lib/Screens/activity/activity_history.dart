import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:provider/provider.dart';
import 'package:styled_text/styled_text.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/number_limits.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Screens/users/SearchByName.dart';
import 'package:thinkcreative_technologies/Screens/users/SearchUser.dart';
import 'package:thinkcreative_technologies/Services/my_providers/liveListener.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Utils/custom_time_formatter.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Widgets/WarningWidgets/warning_tile.dart';
import 'package:thinkcreative_technologies/Widgets/boxdecoration.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Widgets/nodata_widget.dart';

class ActivityHistory extends StatefulWidget {
  const ActivityHistory({Key? key}) : super(key: key);

  @override
  _ActivityHistoryState createState() => _ActivityHistoryState();
}

class _ActivityHistoryState extends State<ActivityHistory> {
  bool isloading = true;
  String error = "";
  List<dynamic> list = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    setState(() {
      isloading = true;
      error = "";
    });
    await FirebaseFirestore.instance
        .collection(DbPaths.adminapp)
        .doc(DbPaths.collectionhistory)
        .get()
        .then((doc) {
      if (doc.exists) {
        list = doc[Dbkeys.list].reversed.toList();
        setState(() {
          isloading = false;
        });
      } else {
        setState(() {
          error =
              "Error fetching history data. History Document does not exist in cloud Firestore database. Please contact the developer.";
        });
      }
    }).catchError((onError) {
      setState(() {
        error = "Error fetching history data.\n\n ERROR: ${onError.toString()}";
      });
    });
  }

  searchWidget(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          // return your layout
          return Container(
            padding: EdgeInsets.all(3),
            height: 380,
            child: Column(children: [
              SizedBox(
                height: 18,
              ),
              MtCustomfontBold(
                color: Mycolors.black,
                fontsize: 18,
                text: getTranslatedForCurrentUser(context, 'xxxsearchxxx'),
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myinkwell(
                    onTap: () {
                      Navigator.of(context).pop();
                      pageNavigator(
                          context,
                          SearchUserByName(
                            serchusertype: Usertype.agent.index,
                            colRef: FirebaseFirestore.instance
                                .collection(DbPaths.collectionagents),
                          ));
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      width: w / 3.35,
                      decoration: boxDecoration(
                        showShadow: true,
                        radius: 7,
                        bgColor: Mycolors.pink,
                      ),
                      height: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sort_by_alpha_outlined,
                              size: 28, color: Mycolors.yellow),
                          SizedBox(
                            height: 7,
                          ),
                          MtCustomfontMedium(
                            text: getTranslatedForCurrentUser(
                                    context, 'xxxbyxxxxnamexxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                            color: Colors.white,
                            textalign: TextAlign.center,
                            lineheight: 1.3,
                          )
                        ],
                      ),
                    ),
                  ),
                  //  myinkwell(
                  //   onTap: () {
                  //     Navigator.of(context).pop();
                  //     pageNavigator(
                  //         context,
                  //         SearchUser(
                  //             pageuserKeyword: widget.usertypenamekeyword,
                  //             colRef: colRef,
                  //             currentuserid: widget.currentuserid,
                  //             searchtype: 'byphone'));
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.all(8),
                  //     width: w / 3.35,
                  //     decoration: boxDecoration(
                  //       showShadow: true,
                  //       radius: 7,
                  //       bgColor: Mycolors.purple,
                  //     ),
                  //     height: 90,
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(Icons.phone_enabled,
                  //             size: 28, color: Mycolors.yellow),
                  //         SizedBox(
                  //           height: 7,
                  //         ),
                  //         MtCustomfontMedium(
                  //           text: 'Search by Phone ',
                  //           color: Colors.white,
                  //           textalign: TextAlign.center,
                  //           lineheight: 1.3,
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  myinkwell(
                    onTap: () {
                      Navigator.of(context).pop();
                      pageNavigator(
                          context,
                          SearchUser(
                              serchusertype: Usertype.agent.index,
                              colRef: FirebaseFirestore.instance
                                  .collection(DbPaths.collectionagents),
                              searchtype: 'byid'));
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      width: w / 3.35,
                      decoration: boxDecoration(
                        showShadow: true,
                        radius: 7,
                        bgColor: Mycolors.cyan,
                      ),
                      height: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.account_box,
                              size: 28, color: Mycolors.yellow),
                          SizedBox(
                            height: 7,
                          ),
                          MtCustomfontMedium(
                            text: getTranslatedForCurrentUser(
                                    context, 'xxxbyxxxxidxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                            color: Colors.white,
                            textalign: TextAlign.center,
                            lineheight: 1.3,
                          )
                        ],
                      ),
                    ),
                  ),
                  myinkwell(
                      onTap: () {
                        Navigator.of(context).pop();
                        pageNavigator(
                            context,
                            SearchUser(
                                colRef: FirebaseFirestore.instance
                                    .collection(DbPaths.collectionagents),
                                serchusertype: Usertype.agent.index,
                                searchtype: 'byphone'));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: w / 3.35,
                        decoration: boxDecoration(
                          showShadow: true,
                          radius: 7,
                          bgColor: Mycolors.blue,
                        ),
                        height: 90,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone,
                                size: 28,
                                color: Colors.yellowAccent.withOpacity(0.8)),
                            SizedBox(
                              height: 9,
                            ),
                            MtCustomfontMedium(
                              text: getTranslatedForCurrentUser(
                                      context, 'xxxbyxxxxphonexxx')
                                  .replaceAll('(####)',
                                      '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                              color: Colors.white,
                              textalign: TextAlign.center,
                              lineheight: 1.3,
                            )
                          ],
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myinkwell(
                    onTap: () {
                      Navigator.of(context).pop();
                      pageNavigator(
                          context,
                          SearchUser(
                              serchusertype: Usertype.agent.index,
                              colRef: FirebaseFirestore.instance
                                  .collection(DbPaths.collectionagents),
                              searchtype: 'byemailid'));
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      width: w / 3.35,
                      decoration: boxDecoration(
                        showShadow: true,
                        radius: 7,
                        bgColor: Mycolors.red,
                      ),
                      height: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, size: 28, color: Mycolors.yellow),
                          SizedBox(
                            height: 7,
                          ),
                          MtCustomfontMedium(
                            text: getTranslatedForCurrentUser(
                                    context, 'xxxbyxxxxemailxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                            color: Colors.white,
                            textalign: TextAlign.center,
                            lineheight: 1.3,
                          )
                        ],
                      ),
                    ),
                  ),
                  //  myinkwell(
                  //   onTap: () {
                  //     Navigator.of(context).pop();
                  //     pageNavigator(
                  //         context,
                  //         SearchUser(
                  //             pageuserKeyword: widget.usertypenamekeyword,
                  //             colRef: colRef,
                  //             currentuserid: widget.currentuserid,
                  //             searchtype: 'byphone'));
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.all(8),
                  //     width: w / 3.35,
                  //     decoration: boxDecoration(
                  //       showShadow: true,
                  //       radius: 7,
                  //       bgColor: Mycolors.purple,
                  //     ),
                  //     height: 90,
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(Icons.phone_enabled,
                  //             size: 28, color: Mycolors.yellow),
                  //         SizedBox(
                  //           height: 7,
                  //         ),
                  //         MtCustomfontMedium(
                  //           text: 'Search by Phone ',
                  //           color: Colors.white,
                  //           textalign: TextAlign.center,
                  //           lineheight: 1.3,
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  myinkwell(
                    onTap: () {
                      Navigator.of(context).pop();
                      pageNavigator(
                          context,
                          SearchUser(
                              serchusertype: Usertype.customer.index,
                              colRef: FirebaseFirestore.instance
                                  .collection(DbPaths.collectioncustomers),
                              searchtype: 'byid'));
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      width: w / 3.35,
                      decoration: boxDecoration(
                        showShadow: true,
                        radius: 7,
                        bgColor: Mycolors.orange,
                      ),
                      height: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.perm_identity_outlined,
                              size: 28, color: Colors.yellow),
                          SizedBox(
                            height: 7,
                          ),
                          MtCustomfontMedium(
                            text: getTranslatedForCurrentUser(
                                    context, 'xxxbyxxxxidxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                            color: Colors.white,
                            textalign: TextAlign.center,
                            lineheight: 1.3,
                          )
                        ],
                      ),
                    ),
                  ),
                  myinkwell(
                      onTap: () {
                        Navigator.of(context).pop();
                        pageNavigator(
                            context,
                            SearchUser(
                                colRef: FirebaseFirestore.instance
                                    .collection(DbPaths.collectioncustomers),
                                serchusertype: Usertype.customer.index,
                                searchtype: 'byphone'));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: w / 3.35,
                        decoration: boxDecoration(
                          showShadow: true,
                          radius: 7,
                          bgColor: Mycolors.cyan,
                        ),
                        height: 90,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone,
                                size: 28,
                                color: Colors.yellowAccent.withOpacity(0.8)),
                            SizedBox(
                              height: 9,
                            ),
                            MtCustomfontMedium(
                              text: getTranslatedForCurrentUser(
                                      context, 'xxxbyxxxxphonexxx')
                                  .replaceAll('(####)',
                                      '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                              color: Colors.white,
                              textalign: TextAlign.center,
                              lineheight: 1.3,
                            )
                          ],
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myinkwell(
                    onTap: () {
                      Navigator.of(context).pop();
                      pageNavigator(
                          context,
                          SearchUser(
                              serchusertype: Usertype.customer.index,
                              colRef: FirebaseFirestore.instance
                                  .collection(DbPaths.collectioncustomers),
                              searchtype: 'byemailid'));
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      width: w / 3.35,
                      decoration: boxDecoration(
                        showShadow: true,
                        radius: 7,
                        bgColor: Mycolors.green,
                      ),
                      height: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, size: 28, color: Mycolors.yellow),
                          SizedBox(
                            height: 7,
                          ),
                          MtCustomfontMedium(
                            text: getTranslatedForCurrentUser(
                                    context, 'xxxbyxxxxemailxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                            color: Colors.white,
                            textalign: TextAlign.center,
                            lineheight: 1.3,
                          )
                        ],
                      ),
                    ),
                  ),
                  myinkwell(
                    onTap: () {
                      Navigator.of(context).pop();
                      pageNavigator(
                          context,
                          SearchUserByName(
                            serchusertype: Usertype.customer.index,
                            colRef: FirebaseFirestore.instance
                                .collection(DbPaths.collectioncustomers),
                          ));
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      width: w / 3.35,
                      decoration: boxDecoration(
                        showShadow: true,
                        radius: 7,
                        bgColor: Mycolors.purple,
                      ),
                      height: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sort_by_alpha_outlined,
                              size: 28, color: Mycolors.yellow),
                          SizedBox(
                            height: 7,
                          ),
                          MtCustomfontMedium(
                            text: getTranslatedForCurrentUser(
                                    context, 'xxxbyxxxxnamexxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                            color: Colors.white,
                            textalign: TextAlign.center,
                            lineheight: 1.3,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: w / 3.35,
                    color: Colors.transparent,
                  )
                ],
              ),
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    SpecialLiveConfigData? livedata =
        Provider.of<SpecialLiveConfigData?>(context, listen: true);

    var registry = Provider.of<UserRegistry>(context, listen: true);
    bool isready = livedata == null
        ? false
        : !livedata.docmap.containsKey(Dbkeys.secondadminID) ||
                livedata.docmap[Dbkeys.secondadminID] == '' ||
                livedata.docmap[Dbkeys.secondadminID] == null
            ? false
            : true;
    return MyScaffold(
      icondata2: Icons.search,
      icon2press: () {
        searchWidget(context);
      },
      icon1press: () {
        fetchData();
      },
      icondata1: Icons.refresh,
      title: getTranslatedForCurrentUser(context, 'xxxactivityhistoryxxx'),
      body: error != ""
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Mycolors.red),
                ),
              ),
            )
          : isloading == true
              ? circularProgress()
              : list.length == 0
                  ? noDataWidget(
                      context: context,
                      title: getTranslatedForCurrentUser(
                          context, 'xxxnoactivityxxx'),
                      iconData: Icons.history)
                  : ListView(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        warningTile(
                            isstyledtext: true,
                            title: "${getTranslatedForCurrentUser(context, 'xxxshowingprevxxxx').replaceAll('(####)', '<bold>${list.length}')}</bold> " +
                                "${getTranslatedForCurrentUser(context, 'xxxxyoucanfindxxxx').replaceAll('(####)', '<bold>${Numberlimits.totalhistorystore}')}</bold>",
                            warningTypeIndex: WarningType.alert.index),
                        ExpandedTileList.builder(
                          itemCount: list.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          maxOpened: 1,
                          itemBuilder: (context, index, controller) {
                            var item = list[index];
                            return ExpandedTile(
                              trailing: Icon(Icons.keyboard_arrow_down),
                              trailingRotation: 180,
                              leading: SizedBox(
                                width: 70,
                                child: Text(
                                  formatTimeDateCOMLPETEString(
                                      isdateTime: true,
                                      isshowutc: false,
                                      context: context,
                                      datetimetargetTime:
                                          DateTime.fromMillisecondsSinceEpoch(
                                        item[Dbkeys
                                            .nOTIFICATIONxxlastupdateepoch],
                                      )),
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 11,
                                      height: 1.4,
                                      color: Mycolors.grey.withOpacity(0.7),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              theme: ExpandedTileThemeData(
                                headerColor: Colors.white,
                                headerRadius: 5.0,
                                headerPadding: EdgeInsets.all(15.0),
                                headerSplashColor:
                                    Mycolors.primary.withOpacity(0.1),
                                //
                                contentBackgroundColor:
                                    Mycolors.backgroundcolor,
                                contentPadding: EdgeInsets.all(4.0),
                                contentRadius: 15.0,
                              ),
                              controller: index == 2
                                  ? controller.copyWith(isExpanded: true)
                                  : controller,
                              title: Text(item[Dbkeys.nOTIFICATIONxxtitle]),
                              content: Container(
                                margin: EdgeInsets.only(bottom: 50),
                                decoration: boxDecoration(
                                    color: Mycolors.primary,
                                    radius: 10,
                                    bgColor: Mycolors.primary),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 70,
                                            child: Icon(
                                              Icons.message,
                                              color: Colors.yellow[200],
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                120,
                                            child: StyledText(
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  height: 1.3),
                                              text: item[
                                                  Dbkeys.nOTIFICATIONxxdesc],
                                              tags: {
                                                'bold': StyledTextTag(
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        height: 1.3)),
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.white30,
                                      height: 20,
                                    ),
                                    Center(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 70,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.yellow[200],
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  120,
                                              child: Text(
                                                item[Dbkeys.nOTIFICATIONxxauthor] ==
                                                            "admin" ||
                                                        item[Dbkeys
                                                                .nOTIFICATIONxxauthor] ==
                                                            "Admin"
                                                    ? getTranslatedForCurrentUser(
                                                        context,
                                                        'xxadminxx')
                                                    : item[Dbkeys
                                                                .nOTIFICATIONxxauthor] ==
                                                            "sys"
                                                        ? getTranslatedForCurrentUser(
                                                            context,
                                                            'xxsystemxx')
                                                        : isready == false
                                                            ? " ${getTranslatedForCurrentUser(context, 'xxidxx')} ${item[Dbkeys.nOTIFICATIONxxauthor]}"
                                                            : item[Dbkeys
                                                                        .nOTIFICATIONxxauthor] ==
                                                                    livedata!
                                                                            .docmap[
                                                                        Dbkeys
                                                                            .secondadminID]
                                                                ? "${registry.getUserData(context, item[Dbkeys.nOTIFICATIONxxauthor]).fullname} (${getTranslatedForCurrentUser(context, 'xxidxx')} ${item[Dbkeys.nOTIFICATIONxxauthor]}) - ${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}"
                                                                : "${registry.getUserData(context, item[Dbkeys.nOTIFICATIONxxauthor]).fullname} (${getTranslatedForCurrentUser(context, 'xxidxx')} ${item[Dbkeys.nOTIFICATIONxxauthor]})",
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.white30,
                                      height: 20,
                                    ),
                                    Center(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 70,
                                            child: Icon(
                                              EvaIcons.pricetags,
                                              color: Colors.yellow[200],
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  120,
                                              child: Text(
                                                item[Dbkeys
                                                    .nOTIFICATIONxxextrafield],
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    // MaterialButton(
                                    //     onPressed: () {
                                    //       controller.collapse();
                                    //     },
                                    //     child: Icon(Icons.close_rounded))
                                  ],
                                ),
                              ),
                              onTap: () {},
                              onLongTap: () {},
                            );
                          },
                        ),
                        // ListView.builder(
                        //     itemCount: list.length,
                        //     physics: NeverScrollableScrollPhysics(),
                        //     shrinkWrap: true,
                        //     itemBuilder: (BuildContext context, int i) {
                        //       var item = list[i];
                        //       return Card(
                        //         color: Colors.white,
                        //         margin: EdgeInsets.all(6),
                        //         child: Container(
                        //           padding: EdgeInsets.all(7),
                        //           child: StyledText(
                        //             text: item[Dbkeys.nOTIFICATIONxxdesc],
                        //             tags: {
                        //               'bold': StyledTextTag(
                        //                   style: TextStyle(
                        //                       fontWeight: FontWeight.bold)),
                        //             },
                        //           ),
                        //         ),
                        //       );
                        //     })
                      ],
                    ),
    );
  }
}
