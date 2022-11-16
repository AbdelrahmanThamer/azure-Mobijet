import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Screens/activity/activity_history.dart';
import 'package:thinkcreative_technologies/Screens/agents/all_agents.dart';
import 'package:thinkcreative_technologies/Screens/customers/all_customers.dart';
import 'package:thinkcreative_technologies/Screens/dashboard/AdminDashboard.dart';
import 'package:thinkcreative_technologies/Screens/account/AdminAccount.dart';
import 'package:thinkcreative_technologies/Screens/account/ChangeLoginCredentials.dart';
import 'package:thinkcreative_technologies/Screens/notifications/AllNotifications.dart';
import 'package:thinkcreative_technologies/Screens/settings/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Services/my_providers/bottom_nav_bar.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Utils/my_shared_prefs.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Widgets/double_tap_back.dart';

GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');

class MyBottomNavBarAdminApp extends StatefulWidget {
  final bool isFirstTimeSetup;
  final String currentdeviceid;
  final SharedPreferences prefs;

  MyBottomNavBarAdminApp(
      {required this.isFirstTimeSetup,
      required this.currentdeviceid,
      required this.prefs});
  @override
  _MyBottomNavBarAdminAppState createState() => _MyBottomNavBarAdminAppState();
}

class _MyBottomNavBarAdminAppState extends State<MyBottomNavBarAdminApp> {
// List<BottomNavigationBarProvider> bottomtabs=[];
  var currentTab = [];
  bool setupdone = true;
// bool isreday=false;
  @override
  void initState() {
    super.initState();
    currentTab = [
      Admindashboard(
        prefs: widget.prefs,
      ),
      AllCustomers(
        currentuserid: Optionalconstants.currentAdminID,
      ),

      AllAgents(
        currentuserid: Optionalconstants.currentAdminID,
      ),
      SettingsPage(
        currentuserid: Optionalconstants.currentAdminID,
        isforcehideleading: true,
      ),
      // NotificationCentre(),
      AdminAccount(
        prefs: widget.prefs,
      ),
    ];
    MySharedPrefs().setmybool('isLoggedIn', true);

    if (widget.isFirstTimeSetup == true) {
      setState(() {
        setupdone = false;
      });
    }
    FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true);

    registerToNotifications();
    configurePushNotification();
  }

  makeReady() {}

  registerToNotifications() async {
    var registry = Provider.of<UserRegistry>(context, listen: false);
    registry.fetchUserRegistry(context);
    await FirebaseMessaging.instance.subscribeToTopic(Dbkeys.topicADMIN);
  }

//----- -------------------- -----

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavigationBarProvider>(context);
    return WillPopScope(
        onWillPop: doubleTapTrigger,
        child: WillPopScope(
            onWillPop: doubleTapTrigger,
            child: setupdone == false
                ? ChangeLoginCredentials(
                    currentdeviceid: widget.currentdeviceid,
                    isFirstTime: true,
                    callbackOnUpdate: () async {
                      await FirebaseFirestore.instance
                          .collection(DbPaths.adminapp)
                          .doc(DbPaths.admincred)
                          .update({Dbkeys.setupNotdoneyet: false});
                      await widget.prefs.setBool('isLoggedIn', true);

                      setState(() {
                        setupdone = true;
                      });
                    },
                  )
                : Scaffold(
                    body: currentTab[provider.currentInd],
                    bottomNavigationBar: BottomNavigationBar(
                      selectedItemColor: Mycolors.bottomappbaricontext,
                      backgroundColor: Colors.white,
                      type: BottomNavigationBarType.fixed,
                      selectedFontSize: 11.0,
                      unselectedFontSize: 11,
                      unselectedItemColor: Mycolors.grey,
                      key: navBarGlobalKey,
                      currentIndex: provider.currentInd,
                      onTap: (index) {
                        provider.setcurrentIndex(index);
                        var registry =
                            Provider.of<UserRegistry>(context, listen: false);
                        final observer =
                            Provider.of<Observer>(context, listen: false);
                        registry.fetchUserRegistry(context);
                        observer.fetchUserAppSettings(context);
                      },
                      items: [
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3),
                            child: Icon(
                              LineAwesomeIcons.dashcube,
                              size: 25,
                              color: Mycolors.grey,
                            ),
                          ),
                          label: getTranslatedForCurrentUser(
                              context, 'xxxdashboardxxx'),
                          activeIcon: Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3),
                            child: Icon(
                              LineAwesomeIcons.dashcube,
                              size: 25,
                              color: Mycolors.bottomappbaricontext,
                            ),
                          ),
                        ),
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3),
                            child: Icon(
                              LineAwesomeIcons.users,
                              size: 25,
                              color: Mycolors.grey,
                            ),
                          ),
                          label: getTranslatedForCurrentUser(
                              context, 'xxcustomersxx'),
                          activeIcon: Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3),
                            child: Icon(
                              LineAwesomeIcons.users,
                              size: 25,
                              color: Mycolors.bottomappbaricontext,
                            ),
                          ),
                        ),
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3),
                            child: Icon(
                              LineAwesomeIcons.user_friends,
                              size: 25,
                              color: Mycolors.grey,
                            ),
                          ),
                          label: getTranslatedForCurrentUser(
                              context, 'xxagentsxx'),
                          activeIcon: Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3),
                            child: Icon(
                              LineAwesomeIcons.user_friends,
                              size: 25,
                              color: Mycolors.bottomappbaricontext,
                            ),
                          ),
                        ),
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3),
                            child: Icon(
                              LineAwesomeIcons.discord,
                              size: 25,
                              color: Mycolors.grey,
                            ),
                          ),
                          label: getTranslatedForCurrentUser(
                              context, 'xxxsettingsxxx'),
                          activeIcon: Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3),
                            child: Icon(
                              LineAwesomeIcons.discord,
                              size: 25,
                              color: Mycolors.bottomappbaricontext,
                            ),
                          ),
                        ),
                        // BottomNavigationBarItem(
                        //   icon: Padding(
                        //     padding: const EdgeInsets.only(top: 3, bottom: 3),
                        //     child: Icon(
                        //       LineAwesomeIcons.bell,
                        //       size: 25,
                        //       color: Mycolors.grey,
                        //     ),
                        //   ),
                        //   label: 'Notifications',
                        //   activeIcon: Padding(
                        //     padding: const EdgeInsets.only(top: 3, bottom: 3),
                        //     child: Icon(
                        //       LineAwesomeIcons.bell,
                        //       size: 25,
                        //       color: Mycolors.bottomappbaricontext,
                        //     ),
                        //   ),
                        // ),
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3),
                            child: Icon(
                              LineAwesomeIcons.user,
                              size: 25,
                              color: Mycolors.grey,
                            ),
                          ),
                          label: getTranslatedForCurrentUser(
                              context, 'xxaccountxx'),
                          activeIcon: Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3),
                            child: Icon(
                              LineAwesomeIcons.user,
                              size: 25,
                              color: Mycolors.bottomappbaricontext,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )));
  }

  configurePushNotification() async {
    //ANDROID & iOS  OnMessage callback
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message.data);
      // ignore: unnecessary_null_comparison
      if (message.data != null) {
        // ShowCustomAlertDialog().open(
        //     context: context,
        //     dialogtype: 'notification',
        //     title: 'New Notification',
        //     leftbuttontext: 'SEE NOTIFICATION',
        //     leftbuttoncolor: Mycolors.primary,
        //     leftbuttononpress: () {
        //       provider.setcurrentIndex(3);
        //     },
        //     description: message.data['body']);
      }
    });
    //ANDROID & iOS  onMessageOpenedApp callback
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // ignore: unnecessary_null_comparison
      if (message != null) {
        // provider.setcurrentIndex(1);
        pageNavigator(
            context,
            message.data["eventid"] == "1"
                ? ActivityHistory()
                : NotificationCentre());
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // provider.setcurrentIndex(1);
        pageNavigator(
            context,
            message.data["eventid"] == "1"
                ? ActivityHistory()
                : NotificationCentre());
      }
    });
  }
}
