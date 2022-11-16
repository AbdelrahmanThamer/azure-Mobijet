import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/agent_model.dart';
import 'package:thinkcreative_technologies/Models/basic_settings_model_userapp.dart';
import 'package:thinkcreative_technologies/Models/ticket_model.dart';
import 'package:thinkcreative_technologies/Models/userapp_settings_model.dart';
import 'package:thinkcreative_technologies/Screens/activity/activity_history.dart';
import 'package:thinkcreative_technologies/Screens/agents/agent_profile_details.dart';
import 'package:thinkcreative_technologies/Screens/chat/agent_agent_chatroom.dart';
import 'package:thinkcreative_technologies/Screens/chat/all_agents_chat.dart';
import 'package:thinkcreative_technologies/Screens/groups/all_groups.dart';
import 'package:thinkcreative_technologies/Screens/groups/groupchat/GroupChatPage.dart';
import 'package:thinkcreative_technologies/Screens/networkSensitiveUi/NetworkSensitiveUi.dart';
import 'package:thinkcreative_technologies/Screens/notifications/AllNotifications.dart';
import 'package:thinkcreative_technologies/Screens/reports/allreports.dart';
import 'package:thinkcreative_technologies/Screens/settings/department/all_departments_list.dart';
import 'package:thinkcreative_technologies/Screens/settings/department/department_settings.dart';
import 'package:thinkcreative_technologies/Screens/tickets/all_tickets.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/ticket_chat_room.dart';
import 'package:thinkcreative_technologies/Screens/tickets/ticketWidget.dart';
import 'package:thinkcreative_technologies/Services/my_providers/bottom_nav_bar.dart';
import 'package:thinkcreative_technologies/Services/my_providers/firestore_collections_data_admin.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';

import 'package:thinkcreative_technologies/Services/my_providers/liveListener.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';

import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Utils/custom_time_formatter.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Widgets/WarningWidgets/warning_tile.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/customCircleAvatars.dart';
import 'package:thinkcreative_technologies/Widgets/boxdecoration.dart';
import 'package:thinkcreative_technologies/Widgets/custom_buttons.dart';
import 'package:thinkcreative_technologies/Widgets/customcards/custom_card.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/dashboardElements/dashboardwidgets.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dynamic_modal_bottomsheet.dart';
import 'package:thinkcreative_technologies/Widgets/late_load.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/tiles.dart';
import 'package:thinkcreative_technologies/Widgets/others/userrole_based_sticker.dart';
import 'package:thinkcreative_technologies/Widgets/timeWidgets/timeAgo.dart';
import 'package:thinkcreative_technologies/main.dart';

class Admindashboard extends StatefulWidget {
  final SharedPreferences prefs;

  Admindashboard({required this.prefs});
  @override
  _AdmindashboardState createState() => _AdmindashboardState();
}

class _AdmindashboardState extends State<Admindashboard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: '_hhssssh');
  bool isloading = true;
  List recent5agents = [];
  List recent5customers = [];
  bool isSeenAllCountries = false;
  late Query countrywisequery;

  UserAppSettingsModel? userAppSettingsModel;
  @override
  void initState() {
    super.initState();
    fetchData();
    fetchUserAppSettingIfPresent();
    countrywisequery = FirebaseFirestore.instance
        .collection(Dbkeys.countrywisedata)
        .orderBy('totalusers', descending: true)
        .limit(6);
    // configurePushNotification();
  }

  fetchUserAppSettingIfPresent() async {
    await FirebaseFirestore.instance
        .collection(DbPaths.userapp)
        .doc(DbPaths.appsettings)
        .get()
        .then((value) {
      if (value.exists) {
        userAppSettingsModel = UserAppSettingsModel.fromSnapshot(value);
        setState(() {});
      }
    }).catchError((e) {});
  }

  setTemporaryUnavailable(String message) async {
    print(message);
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      )),
    );
  }

  String error = "";
  fetchData() async {
    final session = Provider.of<CommonSession>(context, listen: false);
    final observer = Provider.of<Observer>(context, listen: false);
    await FirebaseFirestore.instance
        .collection(Dbkeys.userapp)
        .doc(DbPaths.docdashboarddata)
        .get()
        .then((dashboard) async {
      if (dashboard.exists) {
        FirebaseFirestore.instance
            .collection('license')
            .doc('L4PECM3P7H4SEWQ')
            .get()
            .then((realtimedoc) async {
          if (realtimedoc.exists) {
            if (!realtimedoc.data()!.containsKey('f9846v')) {
              setState(() {
                error =
                    "${getTranslatedForCurrentUser(context, 'xxxuserappnotsetupxxx')} ERR_307";
              });
            } else {
              try {
                Codec<String, String> stringToBase64 = utf8.fuse(base64);
                String v = stringToBase64
                    .decode(realtimedoc.data()!['f9846v'])
                    .toString();

                var appSettings = json.decode(v) as Map<String, dynamic>;
                var basicuserappsettings =
                    BasicSettingModelUserApp.fromJson(appSettings);
                await FirebaseFirestore.instance
                    .collection(DbPaths.userapp)
                    .doc(DbPaths.docusercount)
                    .get()
                    .then((userCountDoc) async {
                  if (userCountDoc.exists) {
                    await FirebaseFirestore.instance
                        .collection(DbPaths.userapp)
                        .doc(DbPaths.docdashboarddata)
                        .get()
                        .then((dashboardData) async {
                      if (dashboardData.exists) {
                        await FirebaseFirestore.instance
                            .collection(DbPaths.userapp)
                            .doc(DbPaths.appsettings)
                            .get()
                            .then((appsetiingsuserapp) async {
                          if (!appsetiingsuserapp.exists) {
                            setState(() {
                              error =
                                  "${getTranslatedForCurrentUser(context, 'xxxuserappnotsetupxxx')} ERR_304";
                            });
                          } else {
                            await FirebaseFirestore.instance
                                .collection(DbPaths.collectionagents)
                                .where(Dbkeys.joinedOn,
                                    isGreaterThan: DateTime.now()
                                        .subtract(const Duration(days: 4))
                                        .millisecondsSinceEpoch)
                                .orderBy(Dbkeys.joinedOn, descending: true)
                                .limit(5)
                                .get()
                                .then((agents) async {
                              await FirebaseFirestore.instance
                                  .collection(DbPaths.collectioncustomers)
                                  .where(Dbkeys.joinedOn,
                                      isGreaterThan: DateTime.now()
                                          .subtract(const Duration(days: 4))
                                          .millisecondsSinceEpoch)
                                  .orderBy(Dbkeys.joinedOn, descending: true)
                                  .limit(5)
                                  .get()
                                  .then((customers) {
                                if (mounted) {
                                  session.setData(
                                    newbasicuserappsettings:
                                        basicuserappsettings,
                                    newuserSettings: appsetiingsuserapp.data(),
                                    newuserCount: userCountDoc.data(),
                                    newDashboardData: dashboardData.data(),
                                  );
                                  // print('HHHHHH  ${session.photourl}');
                                  // print('HHHHHH  ${session.fullname}');
                                  setState(() {
                                    recent5agents = agents.docs;
                                    recent5customers = customers.docs;
                                    isloading = false;
                                  });
                                  observer.fetchUserAppSettings(context);
                                }
                              });
                            });
                          }
                        });
                      } else {
                        setState(() {
                          error =
                              "${getTranslatedForCurrentUser(context, 'xxxuserappnotsetupxxx')} ERR_303";
                        });
                      }
                    });
                  } else {
                    setState(() {
                      error =
                          "${getTranslatedForCurrentUser(context, 'xxxuserappnotsetupxxx')} ERR_302";
                    });
                  }
                });
              } catch (e) {
                setState(() {
                  error =
                      "${getTranslatedForCurrentUser(context, 'xxxuserappnotsetuppropxxx')} ERR_307 ($e)";
                });
              }
            }
          } else {
            setState(() {
              error =
                  "${getTranslatedForCurrentUser(context, 'xxxuserappnotsetupxxx')} ERR_306";
            });
          }
        });
      } else {
        setState(() {
          error =
              "${getTranslatedForCurrentUser(context, 'xxxuserappnotsetupxxx')} ERR_301";
        });
      }
    }).catchError((err) {
      setState(() {
        error =
            "${getTranslatedForCurrentUser(context, 'xxxuserappnotsetupxxx')} ERR_305  ($err)";
      });
    });
  }

  Future getcountrywisedata(Query query) async {
    QuerySnapshot qn = await query.get();
    return qn.docs;
  }

  // ignore: unused_element
  void _changeLanguage(Language language) async {
    Locale _locale = await setLocaleForUsers(language.languageCode);
    AppWrapper.setLocale(this.context, _locale);

    await widget.prefs.setBool('islanguageselected', true);
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
    double expandHeight = 257;
    double w = MediaQuery.of(context).size.width;

    return NetworkSensitive(
        child: Utils.getNTPWrappedWidget(
      Consumer<Observer>(
          builder: (context, observer, _child) => Consumer<CommonSession>(
              builder: (context, session, _child) =>
                  Consumer<BottomNavigationBarProvider>(
                      builder: (context, provider, _child) => Container(
                            color: Mycolors.primary,
                            child: SafeArea(
                              child: Scaffold(
                                backgroundColor: Mycolors.backgroundcolor,
                                key: _scaffoldKey,
                                body: error != ""
                                    ? Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            error,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.red, height: 1.4),
                                          ),
                                        ),
                                      )
                                    : isloading == true
                                        ? circularProgress()
                                        : NestedScrollView(
                                            headerSliverBuilder:
                                                (BuildContext context,
                                                    bool innerBoxIsScrolled) {
                                              return <Widget>[
                                                SliverAppBar(
                                                  expandedHeight: expandHeight,
                                                  floating: true,
                                                  forceElevated:
                                                      innerBoxIsScrolled,
                                                  pinned: true,
                                                  titleSpacing: 0,
                                                  backgroundColor:
                                                      innerBoxIsScrolled
                                                          ? Mycolors.primary
                                                          : Mycolors.primary,
                                                  actionsIconTheme:
                                                      IconThemeData(
                                                          opacity: 0.0),
                                                  title: Container(
                                                    width: w / 2.3,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(16, 8, 6, 0),
                                                    child: MtPoppinsBold(
                                                      text:
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxxdashboardxxx'),
                                                      fontsize: 20,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxlines: 1,
                                                      color: Mycolors.white,
                                                    ),
                                                  ),
                                                  actions: [
                                                    Language.languageList()
                                                                .length <
                                                            2
                                                        ? SizedBox()
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    13,
                                                                    7,
                                                                    10),
                                                            child: myinkwell(
                                                                onTap: Language.languageList()
                                                                            .length <
                                                                        2
                                                                    ? () {}
                                                                    : () {
                                                                        showDynamicModalBottomSheet(
                                                                          title:
                                                                              "",
                                                                          context:
                                                                              context,
                                                                          widgetList: Language.languageList()
                                                                              .map(
                                                                                (e) => myinkwell(
                                                                                  onTap: () {
                                                                                    Navigator.of(context).pop();
                                                                                    _changeLanguage(e);
                                                                                  },
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.all(14),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: <Widget>[
                                                                                        Text(
                                                                                          e.flag + ' ' + '    ' + e.languageNameInEnglish,
                                                                                          style: TextStyle(color: Mycolors.black, fontWeight: FontWeight.w500, fontSize: 16),
                                                                                        ),
                                                                                        Language.languageList().length < 2
                                                                                            ? SizedBox()
                                                                                            : Icon(
                                                                                                Icons.done,
                                                                                                color: e.languageCode == widget.prefs.getString(LAGUAGE_CODE) ? Mycolors.green : Colors.transparent,
                                                                                              )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                              .toList(),
                                                                        );
                                                                      },
                                                                child:
                                                                    Container(
                                                                  width: 40,
                                                                  child: Row(
                                                                    children: [
                                                                      CircleAvatar(
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        radius:
                                                                            20,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            MtCustomfontBoldSemi(
                                                                              color: Mycolors.black,
                                                                              textalign: TextAlign.center,
                                                                              text: widget.prefs.getString(LAGUAGE_CODE) == null ? Language.languageList()[Language.languageList().indexWhere((element) => element.languageCode == DefaulLANGUAGEfileCodeForCURRENTuser)].flag.toString() : Language.languageList()[Language.languageList().indexWhere((element) => element.languageCode == widget.prefs.getString(LAGUAGE_CODE))].flag.toString(),
                                                                              fontsize: 16,
                                                                            ),
                                                                            Icon(
                                                                              Icons.keyboard_arrow_down_rounded,
                                                                              size: 20,
                                                                              color: Mycolors.secondary,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )),
                                                          ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          5, 13, 7, 10),
                                                      child: myinkwell(
                                                        onTap: () {
                                                          pageNavigator(
                                                            context,
                                                            ActivityHistory(),
                                                          );
                                                        },
                                                        child:
                                                            customNotification(
                                                                iconData: Icons
                                                                    .history),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          5, 13, 7, 10),
                                                      child: myinkwell(
                                                        onTap: () {
                                                          pageNavigator(
                                                            context,
                                                            NotificationCentre(),
                                                          );
                                                        },
                                                        child:
                                                            customNotification(),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          5, 13, 10, 10),
                                                      child: myinkwell(
                                                        onTap: () {
                                                          provider
                                                              .setcurrentIndex(
                                                                  4);
                                                        },
                                                        child:
                                                            customCircleAvatar(
                                                                radius: 17,
                                                                url: session
                                                                    .photourl),
                                                      ),
                                                    ),
                                                  ],
                                                  flexibleSpace:
                                                      FlexibleSpaceBar(
                                                    background: Container(
                                                      height: expandHeight,
                                                      margin: EdgeInsets.only(
                                                          top: 60),
                                                      color: Mycolors.primary,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: userAppSettingsModel ==
                                                                    null
                                                                ? [
                                                                    myinkwell(
                                                                        onTap:
                                                                            () {
                                                                          provider
                                                                              .setcurrentIndex(2);
                                                                        },
                                                                        child: dashboardCard(
                                                                            width: w /
                                                                                2.3,
                                                                            cardColor: Color(
                                                                                0xfff29b38),
                                                                            label: getTranslatedForCurrentUser(
                                                                                context, 'xxagentsxx'),
                                                                            value:
                                                                                '${session.userCount[Dbkeys.totalapprovedagents] + session.userCount[Dbkeys.totalblockedagents] + session.userCount[Dbkeys.totalpendingagents]}',
                                                                            iconData:
                                                                                Icons.verified_user)),
                                                                    myinkwell(
                                                                      onTap:
                                                                          () {
                                                                        provider
                                                                            .setcurrentIndex(1);
                                                                      },
                                                                      child: dashboardCard(
                                                                          width: w /
                                                                              2.3,
                                                                          cardColor: Color(
                                                                              0xffe15141),
                                                                          label: getTranslatedForCurrentUser(context,
                                                                              'xxcustomersxx'),
                                                                          value:
                                                                              '${session.userCount[Dbkeys.totalapprovedcustomers] + session.userCount[Dbkeys.totalblockedcustomers] + session.userCount[Dbkeys.totalpendingcustomers]}',
                                                                          iconData:
                                                                              Icons.people_alt),
                                                                    ),
                                                                  ]
                                                                : userAppSettingsModel!
                                                                            .departmentBasedContent ==
                                                                        true
                                                                    ? [
                                                                        myinkwell(
                                                                            onTap:
                                                                                () {
                                                                              provider.setcurrentIndex(2);
                                                                            },
                                                                            child: dashboardCard(
                                                                                width: w / 3.6,
                                                                                cardColor: Color(0xfff29b38),
                                                                                label: getTranslatedForCurrentUser(context, 'xxagentsxx'),
                                                                                value: '${session.userCount[Dbkeys.totalapprovedagents] + session.userCount[Dbkeys.totalblockedagents] + session.userCount[Dbkeys.totalpendingagents]}',
                                                                                iconData: Icons.verified_user)),
                                                                        myinkwell(
                                                                          onTap:
                                                                              () {
                                                                            provider.setcurrentIndex(1);
                                                                          },
                                                                          child: dashboardCard(
                                                                              width: w / 3.6,
                                                                              cardColor: Color(0xffe15141),
                                                                              label: getTranslatedForCurrentUser(context, 'xxcustomersxx'),
                                                                              value: '${session.userCount[Dbkeys.totalapprovedcustomers] + session.userCount[Dbkeys.totalblockedcustomers] + session.userCount[Dbkeys.totalpendingcustomers]}',
                                                                              iconData: Icons.people_alt),
                                                                        ),
                                                                        myinkwell(
                                                                          onTap:
                                                                              () {
                                                                            pageNavigator(context,
                                                                                AllDepartmentList(isShowForSignleAgent: false, filteragentid: "", currentuserid: Optionalconstants.currentAdminID, onbackpressed: () {}));
                                                                          },
                                                                          child: dashboardCard(
                                                                              width: w / 3.6,
                                                                              cardColor: Colors.pink[600],
                                                                              label: getTranslatedForCurrentUser(context, 'xxdepartmentsxx'),
                                                                              value: '${userAppSettingsModel!.departmentList!.length - 1}',
                                                                              iconData: Icons.location_city),
                                                                        ),
                                                                      ]
                                                                    : [
                                                                        myinkwell(
                                                                            onTap:
                                                                                () {
                                                                              provider.setcurrentIndex(2);
                                                                            },
                                                                            child: dashboardCard(
                                                                                width: w / 2.3,
                                                                                cardColor: Color(0xfff29b38),
                                                                                label: getTranslatedForCurrentUser(context, 'xxagentsxx'),
                                                                                value: '${session.userCount[Dbkeys.totalapprovedagents] + session.userCount[Dbkeys.totalblockedagents] + session.userCount[Dbkeys.totalpendingagents]}',
                                                                                iconData: Icons.verified_user)),
                                                                        myinkwell(
                                                                            onTap:
                                                                                () {
                                                                              provider.setcurrentIndex(1);
                                                                            },
                                                                            child: dashboardCard(
                                                                                width: w / 2.3,
                                                                                cardColor: Color(0xffe15141),
                                                                                label: getTranslatedForCurrentUser(context, 'xxcustomersxx'),
                                                                                value: '${session.userCount[Dbkeys.totalapprovedcustomers] + session.userCount[Dbkeys.totalblockedcustomers] + session.userCount[Dbkeys.totalpendingcustomers]}',
                                                                                iconData: Icons.people_alt)),
                                                                      ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              myinkwell(
                                                                  onTap: userAppSettingsModel ==
                                                                              null ||
                                                                          session.dashboardData[Dbkeys.totalopentickets] + session.dashboardData[Dbkeys.totalclosedtickets] ==
                                                                              0
                                                                      ? () {}
                                                                      : () {
                                                                          pageNavigator(
                                                                              context,
                                                                              AllTickets(
                                                                                userAppSettingsModel: userAppSettingsModel!,
                                                                              ));
                                                                        },
                                                                  child:
                                                                      futureLoadCollections(
                                                                          future: FirebaseFirestore
                                                                              .instance
                                                                              .collection(DbPaths
                                                                                  .collectiontickets)
                                                                              .get(),
                                                                          placeholder:
                                                                              dashboardCard(
                                                                            width:
                                                                                w / 3.6,
                                                                            iconData:
                                                                                LineAwesomeIcons.alternate_ticket,
                                                                            cardColor:
                                                                                Color(0xff67ac5b),
                                                                            label:
                                                                                getTranslatedForCurrentUser(context, 'xxtktssxx'),
                                                                            value:
                                                                                '',
                                                                          ),
                                                                          noDataWidget:
                                                                              dashboardCard(
                                                                            width:
                                                                                w / 3.6,
                                                                            iconData:
                                                                                LineAwesomeIcons.alternate_ticket,
                                                                            cardColor:
                                                                                Color(0xff67ac5b),
                                                                            label:
                                                                                getTranslatedForCurrentUser(context, 'xxtktssxx'),
                                                                            value:
                                                                                '',
                                                                          ),
                                                                          onfetchdone:
                                                                              (m) {
                                                                            return dashboardCard(
                                                                              width: w / 3.6,
                                                                              iconData: LineAwesomeIcons.alternate_ticket,
                                                                              cardColor: Color(0xff67ac5b),
                                                                              label: getTranslatedForCurrentUser(context, 'xxtktssxx'),
                                                                              value: '${m.length}',
                                                                            );
                                                                          })),
                                                              myinkwell(
                                                                onTap: () {
                                                                  pageNavigator(
                                                                      context,
                                                                      AllGroups());
                                                                },
                                                                child: dashboardCard(
                                                                    width:
                                                                        w / 3.6,
                                                                    cardColor:
                                                                        Color(
                                                                            0xff49a6ef),
                                                                    label: getTranslatedForCurrentUser(
                                                                        context,
                                                                        'xxxgroupsxxx'),
                                                                    value:
                                                                        '${session.dashboardData[Dbkeys.totalAgentGroups]}',
                                                                    iconData: Icons
                                                                        .people),
                                                              ),
                                                              myinkwell(
                                                                  onTap: () {
                                                                    pageNavigator(
                                                                        context,
                                                                        AllAgentsChat());
                                                                  },
                                                                  child:
                                                                      futureLoadCollections(
                                                                          future: FirebaseFirestore
                                                                              .instance
                                                                              .collection(DbPaths
                                                                                  .collectionAgentIndividiualmessages)
                                                                              .get(),
                                                                          placeholder: dashboardCard(
                                                                              width: w /
                                                                                  3.6,
                                                                              cardColor: Color(
                                                                                  0xff9737b3),
                                                                              label:
                                                                                  '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${getTranslatedForCurrentUser(context, 'xxchatxx')}',
                                                                              value:
                                                                                  '${session.dashboardData[Dbkeys.totalAgentChats]}',
                                                                              iconData: Icons
                                                                                  .person_add),
                                                                          noDataWidget: dashboardCard(
                                                                              width: w / 3.6,
                                                                              cardColor: Color(0xff9737b3),
                                                                              label: '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${getTranslatedForCurrentUser(context, 'xxchatxx')}',
                                                                              value: '${session.dashboardData[Dbkeys.totalAgentChats]}',
                                                                              iconData: Icons.person_add),
                                                                          onfetchdone: (m) {
                                                                            return dashboardCard(
                                                                                width: w / 3.6,
                                                                                cardColor: Color(0xff9737b3),
                                                                                label: '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${getTranslatedForCurrentUser(context, 'xxchatxx')}',
                                                                                value: '${m.length}',
                                                                                iconData: Icons.person_add);
                                                                          })
                                                                  // : dashboardCard(
                                                                  //     width:
                                                                  //         w / 3.6,
                                                                  //     cardColor:
                                                                  //         Color(
                                                                  //             0xff9737b3),
                                                                  //     label:
                                                                  //         'Agent Chat',
                                                                  //     value:
                                                                  //         '${session.dashboardData[Dbkeys.totalAgentChats]}',
                                                                  //     iconData: Icons
                                                                  //         .person_add),
                                                                  ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ];
                                            },
                                            body: SingleChildScrollView(
                                              physics: ScrollPhysics(),
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    // Padding(
                                                    //   padding: const EdgeInsets.fromLTRB(16.0, 16, 0, 16),
                                                    //   child: text(db6_lbl_top_services, fontFamily: fontBold, fontSize: textSizeNormal),
                                                    // ),
                                                    isready == false
                                                        ? lateLoad(
                                                            placeholder:
                                                                SizedBox(),
                                                            actualwidget:
                                                                isready == false
                                                                    ? Column(
                                                                        children: [
                                                                          warningTile(
                                                                              isstyledtext: true,
                                                                              title: getTranslatedForCurrentUser(context, 'xxxaskyourxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxagentsxx')}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}'),
                                                                              warningTypeIndex: WarningType.alert.index),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          warningTile(
                                                                              isstyledtext: true,
                                                                              title: getTranslatedForCurrentUser(context, 'xxxassignsecondadminxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}'),
                                                                              warningTypeIndex: WarningType.alert.index),
                                                                        ],
                                                                      )
                                                                    : SizedBox())
                                                        : myinkwell(
                                                            onTap: () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      DbPaths
                                                                          .collectionagents)
                                                                  .doc(livedata!
                                                                          .docmap[
                                                                      Dbkeys
                                                                          .secondadminID])
                                                                  .get()
                                                                  .then(
                                                                      (value) {
                                                                if (value
                                                                    .exists) {
                                                                  pageNavigator(
                                                                      context,
                                                                      AgentProfileDetails(
                                                                        agent: AgentModel.fromSnapshot(
                                                                            value),
                                                                        currentuserid:
                                                                            Optionalconstants.currentAdminID,
                                                                      ));
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .all(7),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(13),
                                                              decoration:
                                                                  boxDecoration(
                                                                      bgColor:
                                                                          Colors
                                                                              .white,
                                                                      radius:
                                                                          10),
                                                              child: Row(
                                                                children: [
                                                                  customCircleAvatar(
                                                                      radius:
                                                                          24,
                                                                      url: registry
                                                                          .getUserData(
                                                                              context,
                                                                              livedata!.docmap[Dbkeys.secondadminID])
                                                                          .photourl),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      MtCustomfontBoldSemi(
                                                                        fontsize:
                                                                            16,
                                                                        text: registry
                                                                            .getUserData(context,
                                                                                livedata.docmap[Dbkeys.secondadminID])
                                                                            .fullname,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            7,
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              MtCustomfontRegular(
                                                                                fontsize: 13,
                                                                                text: "${getTranslatedForCurrentUser(context, 'xxidxx')} " + registry.getUserData(context, livedata.docmap[Dbkeys.secondadminID]).id,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              roleBasedSticker(context, Usertype.secondadmin.index),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                w / 23,
                                                                          ),
                                                                          streamLoad(
                                                                              stream: FirebaseFirestore.instance.collection(DbPaths.collectionagents).doc(livedata.docmap[Dbkeys.secondadminID]).snapshots(),
                                                                              placeholder: SizedBox(),
                                                                              onfetchdone: (m) {
                                                                                if (m[Dbkeys.lastSeen] == true) {
                                                                                  return Container(
                                                                                      alignment: Alignment.centerRight,
                                                                                      padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                                                                                      decoration: boxDecoration(radius: 10, showShadow: false),
                                                                                      child: Row(
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.circle,
                                                                                            size: 10,
                                                                                            color: Colors.green,
                                                                                          ),
                                                                                          SizedBox(width: 3),
                                                                                          MtCustomfontMedium(
                                                                                            text: getTranslatedForCurrentUser(context, 'xxonlinexx'),
                                                                                            fontsize: 12,
                                                                                          )
                                                                                        ],
                                                                                      ));
                                                                                } else {
                                                                                  return MtCustomfontRegular(
                                                                                    fontsize: 10,
                                                                                    text: "${getTranslatedForCurrentUser(context, 'xxactivexx').toLowerCase()} " + timeAgo(DateTime.fromMillisecondsSinceEpoch(m[Dbkeys.lastSeen]), true),
                                                                                  );
                                                                                }
                                                                              }),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    userAppSettingsModel == null
                                                        ? warningTile(
                                                            title: getTranslatedForCurrentUser(
                                                                context,
                                                                'xxxuserappnotsetupxxx'),
                                                            warningTypeIndex:
                                                                WarningType
                                                                    .error
                                                                    .index)
                                                        : userAppSettingsModel!
                                                                        .departmentBasedContent ==
                                                                    true &&
                                                                userAppSettingsModel!
                                                                        .departmentList!
                                                                        .length <
                                                                    2
                                                            ? Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  warningTile(
                                                                      isstyledtext:
                                                                          true,
                                                                      title: getTranslatedForCurrentUser(
                                                                              context,
                                                                              'xxxdepartbasedcontentxxx')
                                                                          .replaceAll(
                                                                              '(####)',
                                                                              '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                                                      warningTypeIndex: WarningType
                                                                          .error
                                                                          .index),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            18.0,
                                                                        right:
                                                                            18),
                                                                    child:
                                                                        MySimpleButtonWithIcon(
                                                                      onpressed:
                                                                          () {
                                                                        pageNavigator(
                                                                            context,
                                                                            DepartmentSettings(
                                                                                currentuserid: Optionalconstants.currentAdminID,
                                                                                docRef: FirebaseFirestore.instance.collection(DbPaths.userapp).doc(DbPaths.appsettings)));
                                                                      },
                                                                      buttontext: getTranslatedForCurrentUser(
                                                                              context,
                                                                              'xxaddxx')
                                                                          .replaceAll(
                                                                              '(####)',
                                                                              '${getTranslatedForCurrentUser(context, 'xxdepartmentsxx')}'),
                                                                      buttoncolor:
                                                                          Mycolors
                                                                              .orange,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                ],
                                                              )
                                                            : SizedBox(),

                                                    customcardStatistics(
                                                      isthreecolumn: true,
                                                      onTap: () {
                                                        provider
                                                            .setcurrentIndex(2);
                                                      },
                                                      cardcolor:
                                                          Color(0xFF282A4D),
                                                      cardcolorInner:
                                                          Color(0xFF2D325A),
                                                      context: context,
                                                      l: '${session.userCount[Dbkeys.totalapprovedagents] + session.userCount[Dbkeys.totalblockedagents] + session.userCount[Dbkeys.totalpendingagents]}',
                                                      lbase:
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxagentsxx'),
                                                      r1: '${session.userCount[Dbkeys.totalapprovedagents]}',
                                                      r1base:
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxxapprovedxxx'),
                                                      r2: '${session.userCount[Dbkeys.totalblockedagents]}',
                                                      r2base:
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxxblockedxxx'),
                                                      r3: '${session.userCount[Dbkeys.totalpendingagents]}',
                                                      r3base:
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxxpendingxxx'),
                                                    ),

                                                    Container(
                                                      margin: EdgeInsets.all(5),
                                                      color: Colors.transparent,
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: GridView(
                                                        physics:
                                                            ScrollPhysics(),
                                                        shrinkWrap: true,
                                                        children: [
                                                          eachGridTile(
                                                              label: getTranslatedForCurrentUser(
                                                                  context,
                                                                  'xxxuserapplinkedxxx'),
                                                              width: w,
                                                              isallowed:
                                                                  userAppSettingsModel !=
                                                                      null),
                                                          eachGridTile(
                                                              label: getTranslatedForCurrentUser(
                                                                      context,
                                                                      'xxxbasedxxx')
                                                                  .replaceAll(
                                                                      '(####)',
                                                                      '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                                              width: w,
                                                              isallowed: userAppSettingsModel ==
                                                                      null
                                                                  ? false
                                                                  : userAppSettingsModel!
                                                                      .departmentBasedContent),
                                                          eachGridTile(
                                                              label:
                                                                  '${getTranslatedForCurrentUser(context, 'xxagentxx')}\n${getTranslatedForCurrentUser(context, 'xxloginxx')}',
                                                              width: w,
                                                              isallowed: session
                                                                              .basicuserappsettings!
                                                                              .agentRegistartionEnabled ==
                                                                          true ||
                                                                      session.basicuserappsettings!
                                                                              .agentLoginEnabled ==
                                                                          true
                                                                  ? true
                                                                  : false),
                                                          eachGridTile(
                                                              label:
                                                                  '${getTranslatedForCurrentUser(context, 'xxxonlyverfxxx')}\n${getTranslatedForCurrentUser(context, 'xxagentsxx')}',
                                                              width: w,
                                                              isallowed: session
                                                                  .basicuserappsettings!
                                                                  .agentVerificationNeeded),
                                                          eachGridTile(
                                                              label:
                                                                  '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}\n${getTranslatedForCurrentUser(context, 'xxloginxx')}',
                                                              width: w,
                                                              isallowed: session
                                                                          .basicuserappsettings!
                                                                          .customerLoginEnabled ==
                                                                      false
                                                                  ? false
                                                                  : true),
                                                          eachGridTile(
                                                              label:
                                                                  '${getTranslatedForCurrentUser(context, 'xxxonlyverfxxx')}\n${getTranslatedForCurrentUser(context, 'xxcustomersxx')}',
                                                              width: w,
                                                              isallowed: session
                                                                  .basicuserappsettings!
                                                                  .customerVerificationNeeded),
                                                          eachGridTile(
                                                              label: getTranslatedForCurrentUser(
                                                                  context,
                                                                  'xxxonlyemulatorsxxx'),
                                                              width: w,
                                                              isallowed: session
                                                                  .basicuserappsettings!
                                                                  .isemulatorallowed),
                                                          eachGridTile(
                                                              label: getTranslatedForCurrentUser(
                                                                  context,
                                                                  'xxxandroidmaintenancexxx'),
                                                              width: w,
                                                              isallowed: session
                                                                  .basicuserappsettings!
                                                                  .isappunderconstructionandroid),
                                                          eachGridTile(
                                                              label: getTranslatedForCurrentUser(
                                                                  context,
                                                                  'xxxiosmaintenancexxx'),
                                                              width: w,
                                                              isallowed: session
                                                                  .basicuserappsettings!
                                                                  .isappunderconstructionios)
                                                        ],
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    3,
                                                                childAspectRatio:
                                                                    1.1,
                                                                mainAxisSpacing:
                                                                    4,
                                                                crossAxisSpacing:
                                                                    4),
                                                        padding:
                                                            EdgeInsets.all(2),
                                                      ),
                                                    ),

                                                    registry.agents.length == 0
                                                        ? SizedBox()
                                                        : Container(
                                                            color: Colors.white,
                                                            padding: EdgeInsets
                                                                .fromLTRB(25,
                                                                    30, 0, 19),
                                                            height: 170,
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                MtCustomfontBold(
                                                                  fontsize: 16,
                                                                  text:
                                                                      "${getTranslatedForCurrentUser(context, 'xxonlinexx')} ${getTranslatedForCurrentUser(context, 'xxagentsxx')}",
                                                                ),
                                                                streamLoadCollections(
                                                                    stream: FirebaseFirestore
                                                                        .instance
                                                                        .collection(DbPaths
                                                                            .collectionagents)
                                                                        .where(
                                                                            Dbkeys
                                                                                .lastSeen,
                                                                            isEqualTo:
                                                                                true)
                                                                        // .orderBy(
                                                                        //     Dbkeys
                                                                        //         .lastOnline,
                                                                        //     descending:
                                                                        //         true)
                                                                        .snapshots(),
                                                                    placeholder:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          28.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.people,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Mycolors.greylightcolor,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                26,
                                                                          ),
                                                                          MtCustomfontLight(
                                                                            fontsize:
                                                                                14,
                                                                            isitalic:
                                                                                true,
                                                                            text:
                                                                                getTranslatedForCurrentUser(context, 'xxxnoxxcurrentlyxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                                                                            color:
                                                                                Mycolors.greytext,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    noDataWidget:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          28.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.people,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Mycolors.greylightcolor,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                26,
                                                                          ),
                                                                          MtCustomfontLight(
                                                                            fontsize:
                                                                                14,
                                                                            isitalic:
                                                                                true,
                                                                            text:
                                                                                getTranslatedForCurrentUser(context, 'xxxnoxxcurrentlyxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                                                                            color:
                                                                                Mycolors.greytext,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    onfetchdone:
                                                                        (users) {
                                                                      if (users
                                                                              .length >
                                                                          0) {
                                                                        return Container(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          height:
                                                                              105,
                                                                          child: ListView.builder(
                                                                              itemCount: users.length,
                                                                              physics: AlwaysScrollableScrollPhysics(),
                                                                              shrinkWrap: true,
                                                                              scrollDirection: Axis.horizontal,
                                                                              itemBuilder: (BuildContext context, int i) {
                                                                                return Container(
                                                                                  padding: const EdgeInsets.fromLTRB(0, 17, 17, 2),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      Stack(children: [
                                                                                        customCircleAvatar(radius: 25, url: users[i][Dbkeys.photoUrl]),
                                                                                        Positioned(
                                                                                            top: 2,
                                                                                            right: 5,
                                                                                            child: CircleAvatar(
                                                                                              radius: 6,
                                                                                              backgroundColor: Mycolors.greensqaush,
                                                                                            ))
                                                                                      ]),
                                                                                      SizedBox(
                                                                                        height: 10,
                                                                                      ),
                                                                                      MtCustomfontBoldSemi(
                                                                                        maxlines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        fontsize: 13,
                                                                                        text: registry.getUserData(context, users[i][Dbkeys.id]).shortname,
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              }),
                                                                        );
                                                                      }
                                                                    }),
                                                              ],
                                                            ),
                                                          ),

                                                    registry.agents.length == 0
                                                        ? SizedBox()
                                                        : SizedBox(
                                                            height: 24,
                                                          ),
                                                    registry.customers.length ==
                                                            0
                                                        ? SizedBox()
                                                        : Container(
                                                            color: Colors.white,
                                                            padding: EdgeInsets
                                                                .fromLTRB(25,
                                                                    30, 0, 19),
                                                            height: 170,
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                MtCustomfontBold(
                                                                  fontsize: 16,
                                                                  text:
                                                                      "${getTranslatedForCurrentUser(context, 'xxonlinexx')} ${getTranslatedForCurrentUser(context, 'xxcustomersxx')}",
                                                                ),
                                                                streamLoadCollections(
                                                                    stream: FirebaseFirestore
                                                                        .instance
                                                                        .collection(DbPaths
                                                                            .collectioncustomers)
                                                                        .where(
                                                                            Dbkeys
                                                                                .lastSeen,
                                                                            isEqualTo:
                                                                                true)
                                                                        // .orderBy(
                                                                        //     Dbkeys
                                                                        //         .lastOnline,
                                                                        //     descending:
                                                                        //         true)
                                                                        .snapshots(),
                                                                    placeholder:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          28.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.people,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Mycolors.greylightcolor,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                26,
                                                                          ),
                                                                          MtCustomfontLight(
                                                                            fontsize:
                                                                                14,
                                                                            isitalic:
                                                                                true,
                                                                            text:
                                                                                getTranslatedForCurrentUser(context, 'xxxnoxxcurrentlyxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                                                                            color:
                                                                                Mycolors.greytext,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    noDataWidget:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          28.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.people,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Mycolors.greylightcolor,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                26,
                                                                          ),
                                                                          MtCustomfontLight(
                                                                            fontsize:
                                                                                14,
                                                                            isitalic:
                                                                                true,
                                                                            text:
                                                                                getTranslatedForCurrentUser(context, 'xxxnoxxcurrentlyxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                                                                            color:
                                                                                Mycolors.greytext,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    onfetchdone:
                                                                        (users) {
                                                                      if (users
                                                                              .length >
                                                                          0) {
                                                                        return Container(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          height:
                                                                              105,
                                                                          child: ListView.builder(
                                                                              itemCount: users.length,
                                                                              physics: AlwaysScrollableScrollPhysics(),
                                                                              shrinkWrap: true,
                                                                              scrollDirection: Axis.horizontal,
                                                                              itemBuilder: (BuildContext context, int i) {
                                                                                return Container(
                                                                                  padding: const EdgeInsets.fromLTRB(0, 17, 17, 2),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      Stack(children: [
                                                                                        customCircleAvatar(radius: 25, url: users[i][Dbkeys.photoUrl]),
                                                                                        Positioned(
                                                                                            top: 2,
                                                                                            right: 5,
                                                                                            child: CircleAvatar(
                                                                                              radius: 6,
                                                                                              backgroundColor: Mycolors.greensqaush,
                                                                                            ))
                                                                                      ]),
                                                                                      SizedBox(
                                                                                        height: 10,
                                                                                      ),
                                                                                      MtCustomfontBoldSemi(
                                                                                        maxlines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        fontsize: 13,
                                                                                        text: registry.getUserData(context, users[i][Dbkeys.id]).shortname,
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              }),
                                                                        );
                                                                      }
                                                                    }),
                                                              ],
                                                            ),
                                                          ),

                                                    registry.customers.length ==
                                                            0
                                                        ? SizedBox()
                                                        : SizedBox(
                                                            height: 24,
                                                          ),
                                                    userAppSettingsModel == null
                                                        ? SizedBox()
                                                        : Container(
                                                            // color: Colors.white,
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 30,
                                                                    0, 19),
                                                            height: 250,
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              25.0),
                                                                      child:
                                                                          MtCustomfontBold(
                                                                        fontsize:
                                                                            16,
                                                                        text:
                                                                            "${getTranslatedForCurrentUser(context, 'xxxrecentxxx')} ${getTranslatedForCurrentUser(context, 'xxtktssxx')}",
                                                                      ),
                                                                    ),
                                                                    myinkwell(
                                                                      onTap: userAppSettingsModel == null ||
                                                                              session.dashboardData[Dbkeys.totalopentickets] + session.dashboardData[Dbkeys.totalclosedtickets] == 0
                                                                          ? () {}
                                                                          : () {
                                                                              pageNavigator(
                                                                                  context,
                                                                                  AllTickets(
                                                                                    userAppSettingsModel: userAppSettingsModel!,
                                                                                  ));
                                                                            },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 20),
                                                                        child:
                                                                            MtCustomfontBold(
                                                                          fontsize:
                                                                              13,
                                                                          text: getTranslatedForCurrentUser(
                                                                              context,
                                                                              'xxxseeallxxx'),
                                                                          color:
                                                                              Mycolors.secondary,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                futureLoadCollections(
                                                                    future: FirebaseFirestore
                                                                        .instance
                                                                        .collection(DbPaths
                                                                            .collectiontickets)
                                                                        .orderBy(
                                                                            Dbkeys
                                                                                .ticketlatestTimestampForAgents,
                                                                            descending:
                                                                                true)
                                                                        .limit(
                                                                            5)
                                                                        .get(),
                                                                    placeholder:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          28.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            LineAwesomeIcons.alternate_ticket,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Mycolors.greylightcolor,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                26,
                                                                          ),
                                                                          MtCustomfontLight(
                                                                            fontsize:
                                                                                14,
                                                                            isitalic:
                                                                                true,
                                                                            text:
                                                                                getTranslatedForCurrentUser(context, 'xxxrecentcreatedxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')}'),
                                                                            color:
                                                                                Mycolors.greytext,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    noDataWidget:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          28.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            LineAwesomeIcons.alternate_ticket,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Mycolors.greylightcolor,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                26,
                                                                          ),
                                                                          MtCustomfontLight(
                                                                            fontsize:
                                                                                14,
                                                                            isitalic:
                                                                                true,
                                                                            text:
                                                                                getTranslatedForCurrentUser(context, 'xxxrecentcreatedxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')}'),
                                                                            color:
                                                                                Mycolors.greytext,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    onfetchdone:
                                                                        (tickets) {
                                                                      if (tickets
                                                                              .length >
                                                                          0) {
                                                                        return Container(
                                                                          margin: EdgeInsets.only(
                                                                              top: 18,
                                                                              left: 10),
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          height:
                                                                              142,
                                                                          child: ListView.builder(
                                                                              itemCount: tickets.length,
                                                                              physics: AlwaysScrollableScrollPhysics(),
                                                                              shrinkWrap: true,
                                                                              scrollDirection: Axis.horizontal,
                                                                              itemBuilder: (BuildContext context, int i) {
                                                                                return SizedBox(
                                                                                    height: 40,
                                                                                    width: 300,
                                                                                    child: ticketWidgetForAgents(
                                                                                        isMini: true,
                                                                                        context: context,
                                                                                        ontap: (s, f) {
                                                                                          TicketModel ticket = TicketModel.fromSnapshot(tickets[i]);
                                                                                          pageNavigator(
                                                                                              context,
                                                                                              TicketChatRoom(
                                                                                                agentsListinParticularDepartment: [],
                                                                                                currentuserfullname: Optionalconstants.currentAdminID,
                                                                                                customerUID: ticket.ticketcustomerID,
                                                                                                cuurentUserCanSeeAgentNamePhoto: true,
                                                                                                cuurentUserCanSeeCustomerNamePhoto: true,
                                                                                                isSharingIntentForwarded: false,
                                                                                                ticketID: ticket.ticketID,
                                                                                                ticketTitle: ticket.ticketTitle,
                                                                                              ));
                                                                                        },
                                                                                        ticket: TicketModel.fromSnapshot(tickets[i]),
                                                                                        userAppSettingsDoc: userAppSettingsModel!));
                                                                              }),
                                                                        );
                                                                      }
                                                                    }),
                                                              ],
                                                            ),
                                                          ),

                                                    userAppSettingsModel == null
                                                        ? SizedBox()
                                                        : Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 6,
                                                                    0, 19),
                                                            height: 220,
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              25.0),
                                                                      child:
                                                                          MtCustomfontBold(
                                                                        fontsize:
                                                                            16,
                                                                        text:
                                                                            "${getTranslatedForCurrentUser(context, 'xxxrecentxxx')} ${getTranslatedForCurrentUser(context, 'xxgroupchatxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')}",
                                                                      ),
                                                                    ),
                                                                    myinkwell(
                                                                      onTap:
                                                                          () {
                                                                        pageNavigator(
                                                                            context,
                                                                            AllGroups(query: FirebaseFirestore.instance.collection(DbPaths.collectionAgentGroups).orderBy(Dbkeys.groupLATESTMESSAGETIME)));
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 20),
                                                                        child:
                                                                            MtCustomfontBold(
                                                                          fontsize:
                                                                              13,
                                                                          text: getTranslatedForCurrentUser(
                                                                              context,
                                                                              'xxxseeallxxx'),
                                                                          color:
                                                                              Mycolors.secondary,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                futureLoadCollections(
                                                                    future: FirebaseFirestore
                                                                        .instance
                                                                        .collection(DbPaths
                                                                            .collectionAgentGroups)
                                                                        .orderBy(
                                                                            Dbkeys
                                                                                .groupLATESTMESSAGETIME,
                                                                            descending:
                                                                                true)
                                                                        .limit(
                                                                            5)
                                                                        .get(),
                                                                    placeholder:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          28.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.people,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Mycolors.grey.withOpacity(0.1),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                26,
                                                                          ),
                                                                          MtCustomfontLight(
                                                                            fontsize:
                                                                                14,
                                                                            isitalic:
                                                                                true,
                                                                            text:
                                                                                getTranslatedForCurrentUser(context, 'xxxrecentcreatedxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxxgroupsxxx')}'),
                                                                            color:
                                                                                Mycolors.greytext,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    noDataWidget:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          28.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.people,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Mycolors.grey.withOpacity(0.1),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                26,
                                                                          ),
                                                                          MtCustomfontLight(
                                                                            fontsize:
                                                                                14,
                                                                            isitalic:
                                                                                true,
                                                                            text:
                                                                                getTranslatedForCurrentUser(context, 'xxxrecentcreatedxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxxgroupsxxx')}'),
                                                                            color:
                                                                                Mycolors.greytext,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    onfetchdone:
                                                                        (groups) {
                                                                      if (groups
                                                                              .length >
                                                                          0) {
                                                                        return Container(
                                                                          margin: EdgeInsets.only(
                                                                              top: 18,
                                                                              left: 10),
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          height:
                                                                              142,
                                                                          child: ListView.builder(
                                                                              itemCount: groups.length,
                                                                              physics: AlwaysScrollableScrollPhysics(),
                                                                              shrinkWrap: true,
                                                                              scrollDirection: Axis.horizontal,
                                                                              itemBuilder: (BuildContext context, int i) {
                                                                                return Stack(
                                                                                  children: [
                                                                                    Container(
                                                                                      color: Colors.white,
                                                                                      height: 120,
                                                                                      width: w / 1.3,
                                                                                      margin: EdgeInsets.all(10),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          ListTile(
                                                                                            onLongPress: () {},
                                                                                            contentPadding: EdgeInsets.fromLTRB(20, 17, 20, 7),
                                                                                            leading: groups[i][Dbkeys.groupPHOTOURL] == ""
                                                                                                ? CircleAvatar(
                                                                                                    child: Icon(
                                                                                                      Icons.people,
                                                                                                      color: Colors.white,
                                                                                                    ),
                                                                                                    radius: 26,
                                                                                                    backgroundColor: Utils.randomColorgenratorBasedOnFirstLetter(groups[i][Dbkeys.groupNAME]),
                                                                                                  )
                                                                                                : customCircleAvatarGroup(url: groups[i][Dbkeys.groupPHOTOURL], radius: 26),
                                                                                            title: MtCustomfontBold(
                                                                                              maxlines: 2,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              text: groups[i][Dbkeys.groupNAME],
                                                                                              color: Mycolors.black,
                                                                                              fontsize: 17,
                                                                                              lineheight: 1.0,
                                                                                            ),
                                                                                            subtitle: Padding(
                                                                                              padding: const EdgeInsets.only(top: 10),
                                                                                              child: Row(
                                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                children: [
                                                                                                  MtCustomfontRegular(
                                                                                                    text: '${groups[i][Dbkeys.groupMEMBERSLIST].length} ${getTranslatedForCurrentUser(context, 'xxagentsxx')}',
                                                                                                    color: Mycolors.grey,
                                                                                                    fontsize: 14.5,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            onTap: () {
                                                                                              pageNavigator(
                                                                                                  context,
                                                                                                  GroupChatPage(
                                                                                                      onDelete: () {
                                                                                                        setState(() {});
                                                                                                        setState(() {});
                                                                                                      },
                                                                                                      groupMap: groups[i].data(),
                                                                                                      groupID: groups[i][Dbkeys.groupID],
                                                                                                      isCurrentUserMuted: false));
                                                                                            },
                                                                                          ),
                                                                                          MtCustomfontBoldSemi(
                                                                                            text: "  ${getTranslatedForCurrentUser(context, 'xxxgroupidxxx')} ${groups[i][Dbkeys.groupID]}",
                                                                                            color: Utils.randomColorgenratorBasedOnFirstLetter(groups[i][Dbkeys.groupNAME]),
                                                                                            fontsize: 10.5,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 10,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Positioned(
                                                                                        top: 20,
                                                                                        right: 30,
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Icon(
                                                                                              EvaIcons.messageCircle,
                                                                                              color: Mycolors.grey.withOpacity(0.3),
                                                                                              size: 15,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 6,
                                                                                            ),
                                                                                            Text(
                                                                                              getonlyTime(context, groups[i][Dbkeys.groupLATESTMESSAGETIME]).toString(),
                                                                                              style: TextStyle(
                                                                                                fontSize: 13,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ))
                                                                                  ],
                                                                                );
                                                                              }),
                                                                        );
                                                                      }
                                                                    }),
                                                              ],
                                                            ),
                                                          ),

                                                    userAppSettingsModel == null
                                                        ? SizedBox()
                                                        : Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 6,
                                                                    0, 19),
                                                            height: 270,
                                                            width:
                                                                double.infinity,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              25.0),
                                                                      child:
                                                                          MtCustomfontBold(
                                                                        fontsize:
                                                                            16,
                                                                        text:
                                                                            "${getTranslatedForCurrentUser(context, 'xxagentsxx')} ${getTranslatedForCurrentUser(context, 'xxchatxx')}",
                                                                      ),
                                                                    ),
                                                                    myinkwell(
                                                                      onTap:
                                                                          () {
                                                                        pageNavigator(
                                                                            context,
                                                                            AllAgentsChat(query: FirebaseFirestore.instance.collection(DbPaths.collectionAgentIndividiualmessages).orderBy(Dbkeys.lastMessageTime, descending: true)));
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 20),
                                                                        child:
                                                                            MtCustomfontBold(
                                                                          fontsize:
                                                                              13,
                                                                          text: getTranslatedForCurrentUser(
                                                                              context,
                                                                              'xxxseeallxxx'),
                                                                          color:
                                                                              Mycolors.secondary,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                futureLoadCollections(
                                                                    future: FirebaseFirestore
                                                                        .instance
                                                                        .collection(DbPaths
                                                                            .collectionAgentIndividiualmessages)
                                                                        .orderBy(
                                                                            Dbkeys
                                                                                .lastMessageTime,
                                                                            descending:
                                                                                true)
                                                                        .limit(
                                                                            5)
                                                                        .get(),
                                                                    placeholder:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          28.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.message,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Mycolors.grey.withOpacity(0.1),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                26,
                                                                          ),
                                                                          MtCustomfontLight(
                                                                            fontsize:
                                                                                14,
                                                                            isitalic:
                                                                                true,
                                                                            text:
                                                                                getTranslatedForCurrentUser(context, 'xxnorecentchatsxx'),
                                                                            color:
                                                                                Mycolors.greytext,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    noDataWidget:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          28.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.message,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Mycolors.grey.withOpacity(0.1),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                26,
                                                                          ),
                                                                          MtCustomfontLight(
                                                                            fontsize:
                                                                                14,
                                                                            isitalic:
                                                                                true,
                                                                            text:
                                                                                getTranslatedForCurrentUser(context, 'xxnorecentchatsxx'),
                                                                            color:
                                                                                Mycolors.greytext,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    onfetchdone:
                                                                        (chats) {
                                                                      if (chats
                                                                              .length >
                                                                          0) {
                                                                        return Container(
                                                                          margin: EdgeInsets.only(
                                                                              top: 18,
                                                                              left: 10),
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          height:
                                                                              180,
                                                                          child: ListView.builder(
                                                                              itemCount: chats.length,
                                                                              physics: AlwaysScrollableScrollPhysics(),
                                                                              shrinkWrap: true,
                                                                              scrollDirection: Axis.horizontal,
                                                                              itemBuilder: (BuildContext context, int i) {
                                                                                String user1 = chats[i]["chatmembers"][0];
                                                                                String user2 = chats[i]["chatmembers"][1];
                                                                                return Container(
                                                                                  width: w / 1.1,
                                                                                  // height: 200,
                                                                                  margin: EdgeInsets.all(6),
                                                                                  color: Colors.white,
                                                                                  child: futureLoad(
                                                                                      future: FirebaseFirestore.instance.collection(DbPaths.collectionagents).doc(user1).get(),
                                                                                      placeholder: SizedBox(),
                                                                                      onfetchdone: (user1Map) {
                                                                                        if (user1Map != null) {
                                                                                          return futureLoad(
                                                                                              future: FirebaseFirestore.instance.collection(DbPaths.collectionagents).doc(user2).get(),
                                                                                              placeholder: SizedBox(),
                                                                                              onfetchdone: (user2Map) {
                                                                                                if (user2Map != null) {
                                                                                                  return myinkwell(
                                                                                                    onTap: () {
                                                                                                      final provider = Provider.of<FirestoreDataProviderCHATMESSAGES>(context, listen: false);
                                                                                                      provider.reset();
                                                                                                      provider.fetchNextData(Dbkeys.dataTypeMESSAGES, FirebaseFirestore.instance.collection(DbPaths.collectionAgentIndividiualmessages).doc(chats[i].reference.id).collection(chats[i].reference.id), false);
                                                                                                      pageNavigator(
                                                                                                          context,
                                                                                                          AgentToAgentChatRoom(
                                                                                                            onDelete: () async {
                                                                                                              setState(() {});
                                                                                                              setState(() {});
                                                                                                            },
                                                                                                            chatRoomDoc: chats[i],
                                                                                                            chatroomID: chats[i].reference.id,
                                                                                                            lhsUserID: user1,
                                                                                                            rhsUserID: user2,
                                                                                                            lhsUserName: user1Map[Dbkeys.nickname],
                                                                                                            rhsUserName: user2Map[Dbkeys.nickname],
                                                                                                            lhsUserPhoto: user1Map[Dbkeys.photoUrl],
                                                                                                            rhsUserPhoto: user2Map[Dbkeys.photoUrl],
                                                                                                          ));
                                                                                                    },
                                                                                                    child: Card(
                                                                                                      elevation: 0,
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsets.all(13.0),
                                                                                                        child: Column(
                                                                                                          children: [
                                                                                                            Row(
                                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                              children: [
                                                                                                                MtCustomfontBoldSemi(
                                                                                                                  text: "${getTranslatedForCurrentUser(context, 'xxxchatidxxx')}  ${chats[i].reference.id}",
                                                                                                                  fontsize: 11,
                                                                                                                  color: Mycolors.grey,
                                                                                                                ),
                                                                                                                Row(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                                                  children: [
                                                                                                                    Icon(
                                                                                                                      Icons.message,
                                                                                                                      color: Mycolors.grey.withOpacity(0.3),
                                                                                                                      size: 14,
                                                                                                                    ),
                                                                                                                    SizedBox(
                                                                                                                      width: 7,
                                                                                                                    ),
                                                                                                                    MtCustomfontBold(
                                                                                                                      text: formatTimeDateCOMLPETEString(context: context, isdateTime: true, datetimetargetTime: DateTime.fromMillisecondsSinceEpoch(chats[i][Dbkeys.lastMessageTime])),
                                                                                                                      fontsize: 11,
                                                                                                                      color: Mycolors.primary,
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                            Divider(),
                                                                                                            Row(
                                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                              children: [
                                                                                                                SizedBox(
                                                                                                                    width: MediaQuery.of(context).size.width / 3.3,
                                                                                                                    child: myinkwell(
                                                                                                                      onTap: () {
                                                                                                                        pageNavigator(context, AgentProfileDetails(agent: AgentModel.fromJson(user1Map), currentuserid: Optionalconstants.currentAdminID));
                                                                                                                      },
                                                                                                                      child: Column(
                                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                        children: [
                                                                                                                          Stack(
                                                                                                                            children: [
                                                                                                                              customCircleAvatar(
                                                                                                                                radius: 17,
                                                                                                                                url: user1Map[Dbkeys.photoUrl],
                                                                                                                              ),
                                                                                                                              user1Map[Dbkeys.lastSeen] == true
                                                                                                                                  ? Positioned(
                                                                                                                                      top: 0,
                                                                                                                                      left: 0,
                                                                                                                                      child: CircleAvatar(
                                                                                                                                        radius: 6,
                                                                                                                                        backgroundColor: Mycolors.white,
                                                                                                                                        child: CircleAvatar(
                                                                                                                                          backgroundColor: Mycolors.onlinetag,
                                                                                                                                          radius: 4,
                                                                                                                                        ),
                                                                                                                                      ))
                                                                                                                                  : SizedBox(),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                          SizedBox(
                                                                                                                            height: 15,
                                                                                                                          ),
                                                                                                                          MtCustomfontMedium(
                                                                                                                            overflow: TextOverflow.ellipsis,
                                                                                                                            maxlines: 1,
                                                                                                                            fontsize: 14,
                                                                                                                            text: user1Map[Dbkeys.nickname],
                                                                                                                          ),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    )),
                                                                                                                Icon(
                                                                                                                  Icons.connect_without_contact_outlined,
                                                                                                                  size: 44,
                                                                                                                  color: Mycolors.orange,
                                                                                                                ),
                                                                                                                SizedBox(
                                                                                                                    width: MediaQuery.of(context).size.width / 3.3,
                                                                                                                    child: myinkwell(
                                                                                                                      onTap: () {
                                                                                                                        pageNavigator(context, AgentProfileDetails(agent: AgentModel.fromJson(user2Map), currentuserid: Optionalconstants.currentAdminID));
                                                                                                                      },
                                                                                                                      child: Column(
                                                                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                                        children: [
                                                                                                                          Stack(
                                                                                                                            children: [
                                                                                                                              customCircleAvatar(
                                                                                                                                radius: 17,
                                                                                                                                url: user2Map[Dbkeys.photoUrl],
                                                                                                                              ),
                                                                                                                              user2Map[Dbkeys.lastSeen] == true
                                                                                                                                  ? Positioned(
                                                                                                                                      top: 0,
                                                                                                                                      right: 0,
                                                                                                                                      child: CircleAvatar(
                                                                                                                                        radius: 6,
                                                                                                                                        backgroundColor: Mycolors.white,
                                                                                                                                        child: CircleAvatar(
                                                                                                                                          backgroundColor: Mycolors.onlinetag,
                                                                                                                                          radius: 4,
                                                                                                                                        ),
                                                                                                                                      ))
                                                                                                                                  : SizedBox(),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                          SizedBox(
                                                                                                                            height: 15,
                                                                                                                          ),
                                                                                                                          MtCustomfontMedium(
                                                                                                                            overflow: TextOverflow.ellipsis,
                                                                                                                            maxlines: 1,
                                                                                                                            textalign: TextAlign.end,
                                                                                                                            fontsize: 14,
                                                                                                                            text: user2Map[Dbkeys.nickname],
                                                                                                                          ),
                                                                                                                        ],
                                                                                                                      ),
                                                                                                                    ))
                                                                                                              ],
                                                                                                            ),
                                                                                                            Divider(
                                                                                                              height: 27,
                                                                                                            ),
                                                                                                            MtCustomfontBold(
                                                                                                              text: getTranslatedForCurrentUser(context, 'xxxviewchatroomxxx'),
                                                                                                              letterspacing: 1.2,
                                                                                                              color: Mycolors.orange,
                                                                                                              fontsize: 13,
                                                                                                            )
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                } else {
                                                                                                  return SizedBox();
                                                                                                }
                                                                                              });
                                                                                        } else {
                                                                                          return SizedBox();
                                                                                        }
                                                                                      }),
                                                                                );
                                                                              }),
                                                                        );
                                                                      }
                                                                    }),
                                                              ],
                                                            ),
                                                          ),

                                                    userAppSettingsModel == null
                                                        ? SizedBox()
                                                        : SizedBox(
                                                            height: 17,
                                                          ),
                                                    AppConstants.isdemomode ==
                                                            true
                                                        ? SizedBox()
                                                        : Center(
                                                            child:
                                                                MySimpleButton(
                                                              buttoncolor:
                                                                  Mycolors
                                                                      .secondary,
                                                              onpressed: () {
                                                                pageNavigator(
                                                                    context,
                                                                    AllReports());
                                                              },
                                                              spacing: 0.3,
                                                              buttontext:
                                                                  getTranslatedForCurrentUser(
                                                                      context,
                                                                      'xxxseereportsxxx'),
                                                              icon: Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                color: Colors
                                                                    .white,
                                                                size: 18,
                                                              ),
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      height: AppConstants
                                                                  .isdemomode ==
                                                              true
                                                          ? 0
                                                          : 30,
                                                    ),
                                                    customcardStatistics(
                                                      isthreecolumn: true,
                                                      onTap: () {
                                                        provider
                                                            .setcurrentIndex(1);
                                                      },
                                                      cardcolor:
                                                          Color(0xFF282A4D),
                                                      cardcolorInner:
                                                          Color(0xFF2D325A),
                                                      context: context,
                                                      l: '${session.userCount[Dbkeys.totalapprovedcustomers] + session.userCount[Dbkeys.totalblockedcustomers] + session.userCount[Dbkeys.totalpendingcustomers]}',
                                                      lbase:
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxcustomersxx'),
                                                      r1: '${session.userCount[Dbkeys.totalapprovedcustomers]}',
                                                      r1base:
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxxapprovedxxx'),
                                                      r2: '${session.userCount[Dbkeys.totalblockedcustomers]}',
                                                      r2base:
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxxblockedxxx'),
                                                      r3: '${session.userCount[Dbkeys.totalpendingcustomers]}',
                                                      r3base:
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxxpendingxxx'),
                                                    ),

                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    // myinkwell(
                                                    //   onTap: () {},
                                                    //   child:
                                                    //       customcardVersionControl(
                                                    //     cardcolor:
                                                    //         Mycolors.white,
                                                    //     cardcolorInner: Mycolors
                                                    //         .greylightcolor
                                                    //         .withOpacity(0.5),
                                                    //     context: context,
                                                    //     androidUserappVersion:
                                                    //         '${session.basicuserappsettings!.latestappversionandroid}',
                                                    //     iosUserappVersion:
                                                    //         '${session.basicuserappsettings!.latestappversionios}',
                                                    //     androidAdminappVersion:
                                                    //         '${session.basicuserappsettings!.latestappversionandroid}',
                                                    //     iosAdminappVersion:
                                                    //         '${session.basicuserappsettings!.latestappversionios}',
                                                    //   ),
                                                    // ),

                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    recent5agents.length == 0
                                                        ? SizedBox()
                                                        : Container(
                                                            // color: Mycolors.white,
                                                            margin: EdgeInsets
                                                                .fromLTRB(0, 20,
                                                                    0, 10),
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 10,
                                                                    0, 10),
                                                            child: SizedBox(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            16,
                                                                            8,
                                                                            2,
                                                                            13),
                                                                    child: MtCustomfontBold(
                                                                        text:
                                                                            '${getTranslatedForCurrentUser(context, 'xxxrecetlyjoinedxxx')} ${getTranslatedForCurrentUser(context, 'xxagentsxx')} ',
                                                                        fontsize:
                                                                            16),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            6,
                                                                            0,
                                                                            6,
                                                                            0),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(2),
                                                                    // height: 110,
                                                                    child: ListView.builder(
                                                                        scrollDirection: Axis.vertical,
                                                                        itemCount: recent5agents.length,
                                                                        shrinkWrap: true,
                                                                        physics: ScrollPhysics(),
                                                                        itemBuilder: (context, index) {
                                                                          return AgentCard(
                                                                            isProfileFetchedFromProvider:
                                                                                false,
                                                                            usermodel:
                                                                                AgentModel.fromJson(recent5agents[index].data()),
                                                                            isswitchshow:
                                                                                false,
                                                                          );
                                                                        }),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        OutlinedButton(
                                                                      child:
                                                                          new Text(
                                                                        getTranslatedForCurrentUser(
                                                                            context,
                                                                            'xxxseeallxxx'),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Mycolors.black),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        provider
                                                                            .setcurrentIndex(2);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    recent5customers.length == 0
                                                        ? SizedBox()
                                                        : Container(
                                                            // color: Mycolors.white,
                                                            margin: EdgeInsets
                                                                .fromLTRB(0, 20,
                                                                    0, 10),
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 10,
                                                                    0, 10),
                                                            child: SizedBox(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            16,
                                                                            8,
                                                                            2,
                                                                            13),
                                                                    child: MtCustomfontBold(
                                                                        text:
                                                                            '${getTranslatedForCurrentUser(context, 'xxxrecetlyjoinedxxx')} ${getTranslatedForCurrentUser(context, 'xxcustomersxx')} ',
                                                                        fontsize:
                                                                            16),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            6,
                                                                            0,
                                                                            6,
                                                                            0),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(2),
                                                                    // height: 110,
                                                                    child: ListView.builder(
                                                                        scrollDirection: Axis.vertical,
                                                                        itemCount: recent5customers.length,
                                                                        shrinkWrap: true,
                                                                        physics: ScrollPhysics(),
                                                                        itemBuilder: (context, index) {
                                                                          return AgentCard(
                                                                            isProfileFetchedFromProvider:
                                                                                false,
                                                                            usermodel:
                                                                                AgentModel.fromJson(recent5customers[index].data()),
                                                                            isswitchshow:
                                                                                false,
                                                                          );
                                                                        }),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        OutlinedButton(
                                                                      child:
                                                                          new Text(
                                                                        getTranslatedForCurrentUser(
                                                                            context,
                                                                            'xxxseeallxxx'),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Mycolors.black),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        provider
                                                                            .setcurrentIndex(1);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                    SizedBox(
                                                      height: 40,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                              ),
                            ),
                          )))),
    ));
  }
}
