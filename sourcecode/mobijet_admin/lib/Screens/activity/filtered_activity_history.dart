//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Definition attached with source code. *********************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Services/my_providers/liveListener.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:provider/provider.dart';
import 'package:styled_text/styled_text.dart';
import 'package:thinkcreative_technologies/Utils/custom_time_formatter.dart';
import 'package:thinkcreative_technologies/Widgets/boxdecoration.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Widgets/nodata_widget.dart';

class FilteredActivityHistory extends StatefulWidget {
  final String extrafieldid;
  final String? subtitle;
  final bool isShowDesc;
  const FilteredActivityHistory(
      {Key? key,
      required this.extrafieldid,
      required this.isShowDesc,
      this.subtitle})
      : super(key: key);

  @override
  _FilteredActivityHistoryState createState() =>
      _FilteredActivityHistoryState();
}

class _FilteredActivityHistoryState extends State<FilteredActivityHistory> {
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
        list = widget.isShowDesc == false
            ? doc[Dbkeys.list]
                .where((element) =>
                    element[Dbkeys.nOTIFICATIONxxextrafield]
                        .toString()
                        .contains(widget.extrafieldid) &&
                    element[Dbkeys.nOTIFICATIONxxtitle]
                            .toString()
                            .toLowerCase()
                            .contains("attention") ==
                        false)
                .toList()
                .reversed
                .toList()
            : doc[Dbkeys.list]
                .where((element) => element[Dbkeys.nOTIFICATIONxxextrafield]
                    .toString()
                    .contains(widget.extrafieldid))
                .toList()
                .reversed
                .toList();
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
      icon1press: () {
        fetchData();
      },
      icondata1: Icons.refresh,
      title: "Activity History",
      subtitle: widget.subtitle,
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
                      title: "No activity recorded yet",
                      iconData: Icons.history)
                  : ListView(
                      padding: EdgeInsets.all(5),
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
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
                              content: widget.isShowDesc == false
                                  ? SizedBox()
                                  : Container(
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
                                                    text: item[Dbkeys
                                                        .nOTIFICATIONxxdesc],
                                                    tags: {
                                                      'bold': StyledTextTag(
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                    width:
                                                        MediaQuery.of(context)
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
                                                              context, 'xxadminxx')
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
                                                                              .docmap[Dbkeys.secondadminID]
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
                                                    width:
                                                        MediaQuery.of(context)
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
