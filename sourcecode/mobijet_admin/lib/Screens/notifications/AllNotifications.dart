import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:styled_text/styled_text.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Screens/networkSensitiveUi/NetworkSensitiveUi.dart';
import 'package:thinkcreative_technologies/Screens/notifications/NotificationViewer.dart';
import 'package:thinkcreative_technologies/Screens/notifications/SendNotification.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Utils/color_light_dark.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseUploader.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/custom_buttons.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart' as btab;
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Utils/custom_time_formatter.dart';
import 'package:thinkcreative_technologies/Widgets/boxdecoration.dart';
import 'package:thinkcreative_technologies/Widgets/custom_dividers.dart';
import 'package:thinkcreative_technologies/Widgets/nodata_widget.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';

class NotificationCentre extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationCentreState();
  }
}

class _NotificationCentreState extends State<NotificationCentre>
    with TickerProviderStateMixin {
  //add with TickerProviderStateMixin at the end of  state declaration
  GlobalKey<State> _keyLoader =
      new GlobalKey<State>(debugLabel: 'nffjfjjfjjhhgg');
  GlobalKey<State> _keyLoader1 =
      new GlobalKey<State>(debugLabel: 'nffjfjjfjjhhgg1');

  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: '_hhh');
  TabController? tabController; //controller for tab
  bool isloading = true;
  String errmessage = "";
  List customernotificationlist = [];
  List agentnotificationlist = [];
  List adminnotificationlist = [];
  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
    //set tabcontroller with lengther
    //vsync:this will show error if you do not add with TickerProviderStateMixin above

    tabController!.addListener(() {
      //listiner for tab events
      if (tabController!.indexIsChanging) {
        //if tab is changed
        int tabindex = tabController!.index;
        print("Current Tab is $tabindex");
        if (tabindex == 0) {
          loadAdminNotifications();
        } else if (tabindex == 1) {
          loadCustomerNotifications();
        } else if (tabindex == 2) {
          loadAgentNotifications();
        }
      }
    });
    loadAdminNotifications();
  }

  DocumentReference agentDocref = FirebaseFirestore.instance
      .collection(DbPaths.userapp)
      .doc(DbPaths.agentnotifications);
  DocumentReference customerDocref = FirebaseFirestore.instance
      .collection(DbPaths.userapp)
      .doc(DbPaths.customernotifications);
  DocumentReference adminDocref = FirebaseFirestore.instance
      .collection(DbPaths.adminapp)
      .doc(DbPaths.adminnotifications);

  loadAdminNotifications() async {
    await adminDocref.get().then((doc) {
      if (doc.exists) {
        errmessage = "";
        adminnotificationlist = doc[Dbkeys.list].reversed.toList()
          ..where((element) =>
              element.containsKey(Dbkeys.nOTIFICATIONxxtitle) == true).toList();
        setState(() {
          isloading = false;
        });
      } else {
        errmessage =
            "Admin notification doc does not exists. Installation is not completed properly";
        setState(() {});
      }
    }).catchError((err) {
      errmessage = "Error fetching Admin notification doc $err";
      setState(() {});
    });
  }

  loadCustomerNotifications() async {
    await customerDocref.get().then((doc) {
      if (doc.exists) {
        errmessage = "";
        customernotificationlist = doc[Dbkeys.list]
            .reversed
            .toList()
            .where((element) =>
                element.containsKey(Dbkeys.nOTIFICATIONxxtitle) == true)
            .toList();
        setState(() {
          isloading = false;
        });
      } else {
        errmessage =
            "Admin notification doc does not exists. Installation is not completed properly";
        setState(() {});
      }
    }).catchError((err) {
      errmessage = "Error fetching Admin notification doc $err";
      setState(() {});
    });
  }

  loadAgentNotifications() async {
    await agentDocref.get().then((doc) {
      if (doc.exists) {
        errmessage = "";
        agentnotificationlist = doc[Dbkeys.list].reversed.toList()
          ..where((element) =>
              element.containsKey(Dbkeys.nOTIFICATIONxxtitle) == true).toList();
        setState(() {
          isloading = false;
        });
      } else {
        errmessage =
            "Admin notification doc does not exists. Installation is not completed properly";
        setState(() {});
      }
    }).catchError((err) {
      errmessage = "Error fetching Admin notification doc $err";
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController!.dispose(); //destroy tabcontroller to release memory
    super.dispose();
  }

  deleteNotification(Map<String, dynamic> map, DocumentReference docRef) async {
    ShowLoading().open(key: _keyLoader, context: context);
    if (map[Dbkeys.nOTIFICATIONxximageurl] != "") {
      await FirebaseUploader().deleteFile(
        context: context,
        scaffoldkey: _scaffoldKey,
        mykeyLoader: _keyLoader1,
        isDeleteUsingUrl: true,
        fileType: 'image',
        filename: "",
        url: map[Dbkeys.nOTIFICATIONxximageurl],
      );
    }
    await docRef.update({
      Dbkeys.nOTIFICATIONxxaction: Dbkeys.nOTIFICATIONactionNOPUSH,
      Dbkeys.nOTIFICATIONxximageurl: null,
      Dbkeys.nOTIFICATIONxxtitle: "",
      Dbkeys.nOTIFICATIONxxdesc: "",
      Dbkeys.list: FieldValue.arrayRemove([map]),
    });
    if (docRef == adminDocref) {
      adminnotificationlist.remove(map);
      setState(() {});
    } else if (docRef == agentDocref) {
      agentnotificationlist.remove(map);
      setState(() {});
    } else if (docRef == customerDocref) {
      customernotificationlist.remove(map);
      setState(() {});
    }
    ShowLoading().close(key: _keyLoader, context: context);
  }

  Widget recievedToAdminWidget(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        padding: EdgeInsets.all(12),
        //list of names of guides
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            adminnotificationlist.length == 0
                ? noDataWidget(
                    padding: EdgeInsets.fromLTRB(30, w / 2.18, 30, 30),
                    context: context,
                    iconColor: Mycolors.orange,
                    iconData: Icons.notifications,
                    title: getTranslatedForCurrentUser(
                        context, 'xxnonotificationsxx'),
                    subtitle: '')
                : ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: adminnotificationlist.length,
                    itemBuilder: (BuildContext context, int i) {
                      var doc = adminnotificationlist[i];

                      return doc[Dbkeys.nOTIFICATIONxxtitle] == ""
                          ? SizedBox()
                          // : Text(doc[Dbkeys.nOTIFICATIONxxtitle]);
                          : notificationcard(
                              doc: doc,
                              isForAdmin: true,
                              isSent: true,
                            );
                    }),
          ],
        ));
  }

  Widget sentToCustomerWidget(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        padding: EdgeInsets.all(12),
        //list of names of guides
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            MySimpleButton(
              onpressed: AppConstants.isdemomode == true
                  ? () {
                      Utils.toast(getTranslatedForCurrentUser(
                          context, 'xxxnotalwddemoxxaccountxx'));
                    }
                  : () {
                      pageNavigator(
                          context,
                          SendNotification(
                            storagefoldername:
                                DbStoragePaths.allcustomernotification,
                            currentuserid: Optionalconstants.currentAdminID,
                            issendtosingleuser: false,
                            refdata: customerDocref,
                            notificationid: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            optionalOnUpdateCallback: () {
                              loadCustomerNotifications();
                            },
                          ));
                    },
              height: 56,
              buttoncolor: Mycolors.green,
              icon: Icon(Icons.send_rounded, color: Mycolors.white),
              spacing: 0.3,
              buttontext:
                  getTranslatedForCurrentUser(context, 'xxsendnewnotixx'),
            ),
            SizedBox(
              height: 25,
            ),
            MtCustomfontBold(
              text: getTranslatedForCurrentUser(context, 'xxallsentxx'),
              fontsize: 16,
              textalign: TextAlign.start,
            ),
            myvhorizontaldivider(width: w, thickness: 1),
            customernotificationlist.length == 0
                ? noDataWidget(
                    context: context,
                    iconColor: Mycolors.orange,
                    iconData: Icons.notifications,
                    title: getTranslatedForCurrentUser(
                        context, 'xxnonotificationsxx'),
                    subtitle: '')
                : ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: customernotificationlist.length,
                    itemBuilder: (BuildContext context, int i) {
                      return notificationcard(
                        doc: customernotificationlist[i],
                        isForAdmin: false,
                        isSent: true,
                      );
                    }),
          ],
        ));
  }

  Widget sentToAgentWidget(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        padding: EdgeInsets.all(12),
        //list of names of guides
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            MySimpleButton(
                onpressed: AppConstants.isdemomode == true
                    ? () {
                        Utils.toast(getTranslatedForCurrentUser(
                            context, 'xxxnotalwddemoxxaccountxx'));
                      }
                    : () {
                        pageNavigator(
                            context,
                            SendNotification(
                              storagefoldername:
                                  DbStoragePaths.allcustomernotification,
                              currentuserid: Optionalconstants.currentAdminID,
                              issendtosingleuser: false,
                              refdata: agentDocref,
                              notificationid: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              optionalOnUpdateCallback: () {
                                loadAgentNotifications();
                              },
                            ));
                      },
                height: 56,
                buttoncolor: Mycolors.green,
                icon: Icon(Icons.send_rounded, color: Mycolors.white),
                spacing: 0.3,
                buttontext:
                    getTranslatedForCurrentUser(context, 'xxsendnewnotixx')),
            SizedBox(
              height: 25,
            ),
            MtCustomfontBold(
              text: '  ${getTranslatedForCurrentUser(context, 'xxallsentxx')}',
              fontsize: 16,
              textalign: TextAlign.start,
            ),
            myvhorizontaldivider(width: w, thickness: 1),
            agentnotificationlist.length == 0
                ? noDataWidget(
                    context: context,
                    iconColor: Mycolors.orange,
                    iconData: Icons.notifications,
                    title: getTranslatedForCurrentUser(
                        context, 'xxnonotificationsxx'),
                    subtitle: '')
                : ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: agentnotificationlist.length,
                    itemBuilder: (BuildContext context, int i) {
                      return notificationcard(
                        doc: agentnotificationlist[i],
                        isForAdmin: false,
                        isSent: true,
                      );
                    }),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return NetworkSensitive(
        child: Utils.getNTPWrappedWidget(Consumer<Observer>(
            builder: (context, observer, _child) => Scaffold(
                key: _scaffoldKey,
                backgroundColor: Mycolors.backgroundcolor,
                body: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool isscrolled) {
                      return <Widget>[
                        SliverAppBar(
                          elevation: 1,
                          title: new MtPoppinsSemiBold(
                            lineheight: 1.5,
                            text: getTranslatedForCurrentUser(
                                context, 'xxallnotificationsxx'),
                            fontsize: 19,
                            color: Mycolors.white,
                          ),
                          backgroundColor: Mycolors.primary,
                          pinned: true,
                          floating: true,
                          forceElevated: isscrolled,

                          actions: <Widget>[
                            IconButton(
                                onPressed: () {
                                  Utils.toast(getTranslatedForCurrentUser(
                                      context, 'xxloadingxx'));
                                  tabController!.index == 0
                                      ? loadAdminNotifications()
                                      : tabController!.index == 1
                                          ? loadCustomerNotifications()
                                          : loadAgentNotifications();
                                },
                                icon: Icon(Icons.refresh))
                          ],

                          //set bottom if you want to add tabbar

                          bottom: new TabBar(
                            indicatorPadding: EdgeInsets.all(0),
                            isScrollable: true,
                            labelColor: Mycolors.white,
                            indicatorSize: TabBarIndicatorSize.tab,
                            unselectedLabelColor: Mycolors.whitedim,
                            indicator: new btab.BubbleTabIndicator(
                              indicatorHeight: 36.0,
                              indicatorColor: Mycolors.secondary,
                              tabBarIndicatorSize: TabBarIndicatorSize.tab,
                            ),
                            indicatorColor: Mycolors.white,
                            tabs: <Tab>[
                              new Tab(
                                  text:
                                      " ${getTranslatedForCurrentUser(context, 'xxrcvtoadminxx')} "),
                              new Tab(
                                  text:
                                      " ${getTranslatedForCurrentUser(context, 'xxsenttoxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')} "),
                              new Tab(
                                  text:
                                      " ${getTranslatedForCurrentUser(context, 'xxsenttoxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')} ")
                            ],
                            controller: tabController,
                          ),
                        ),
                      ];
                    },
                    body: errmessage != ""
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child:
                                  Text(errmessage, textAlign: TextAlign.center),
                            ),
                          )
                        : isloading == true
                            ? circularProgress()
                            : TabBarView(

                                //set TabBarView  if you have added Tabbar at bottom of Appbar
                                controller: tabController,
                                children: <Widget>[
                                    recievedToAdminWidget(context),
                                    sentToCustomerWidget(context),
                                    sentToAgentWidget(context),
                                  ]))))));
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
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  decoration: boxDecoration(showShadow: true),
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
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
                          color: Mycolors.grey,
                          height: 1.4,
                        ),
                        text: doc[Dbkeys.nOTIFICATIONxxdesc] ?? '',
                        tags: {
                          'bold': StyledTextTag(
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Mycolors.grey,
                                  height: 1.4)),
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
                            ),
                            text: doc[Dbkeys.nOTIFICATIONxxdesc] ?? '',
                            tags: {
                              'bold': StyledTextTag(
                                  style: TextStyle(
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
        Positioned(
            bottom: 2,
            right: 2,
            child: AppConstants.isMultiDeviceLoginEnabled == true
                ? SizedBox()
                : IconButton(
                    onPressed: AppConstants.isdemomode == true
                        ? () {
                            Utils.toast(getTranslatedForCurrentUser(
                                context, 'xxxnotalwddemoxxaccountxx'));
                          }
                        : () async {
                            await deleteNotification(
                                doc,
                                tabController!.index == 0
                                    ? adminDocref
                                    : tabController!.index == 1
                                        ? customerDocref
                                        : agentDocref);
                          },
                    icon:
                        Icon(Icons.delete_outline, color: Colors.red, size: 17),
                  ))
      ],
    );
  }
}
