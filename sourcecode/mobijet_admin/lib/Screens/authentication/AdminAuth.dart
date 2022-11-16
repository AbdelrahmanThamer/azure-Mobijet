import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Localization/language.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/basic_settings_model_adminapp.dart';
import 'package:thinkcreative_technologies/Screens/dashboard/BottomNavBarAdminApp.dart';
import 'package:thinkcreative_technologies/Screens/authentication/PasscodeScreen.dart';
import 'package:thinkcreative_technologies/Screens/splashScreen/SplashScreen.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/custom_buttons.dart';
import 'package:thinkcreative_technologies/Widgets/Input_box.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Utils/hide_keyboard.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dynamic_modal_bottomsheet.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/main.dart';

class AdminAauth extends StatefulWidget {
  AdminAauth({
    Key? key,
    required this.prefs,
    required this.basicsettings,
    required this.currentdeviceID,
    required this.deviceInfoMap,
  }) : super(key: key);

  final SharedPreferences prefs;
  final BasicSettingModelAdminApp basicsettings;
  final String currentdeviceID;
  final deviceInfoMap;

  @override
  _AdminAauthState createState() => new _AdminAauthState();
}

class _AdminAauthState extends State<AdminAauth> {
  bool isloggedin = false;

  String? errormsg = '';
  int attempt = 0;
  TextEditingController _enteredemailcontroller = new TextEditingController();
  TextEditingController _enteredpasswordcontroller =
      new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: '_hhddbh');
  GlobalKey<State> _keyLoader =
      new GlobalKey<State>(debugLabel: '7338dshh83833');
  @override
  void initState() {
    super.initState();
    checkLoginStatus(false);

    if (AppConstants.isdemomode == true) {
      _enteredemailcontroller.text = 'abcdef@example.com';
      _enteredpasswordcontroller.text = 'abcdef';
    }
  }

  // firsttimeWriteDatabase() async {
  //   final session = Provider.of<CommonSession>(context, listen: false);
  //   //-------Below Firestore Document creation for Admin app Settings ---------
  //   await FirebaseFirestore.instance
  //       .collection(DbPaths.adminapp)
  //       .doc(DbPaths.admincred)
  //       .set(adminappsettingsmap, SetOptions(merge: true))
  //       .then((value) async {
  //     await batchwrite().then((value) async {
  //       if (value == false) {
  //         setState(() {
  //           errormsg =
  //               'Error occured while setting up admin app.\n\nPlease inform the below captured error to developer: BATCH_WRITE FAILED AT ADMIN LOGIN PAGE';
  //         });

  //         await session.createalert(
  //             alertmsgforuser: '',
  //             context: context,
  //             alerttime: DateTime.now().millisecondsSinceEpoch,
  //             alerttitle: 'Database setup failed',
  //             alertdesc:
  //                 'First time database write failed by admin (${AppConstants.apptype}). \n[CAPTURED ERROR: Batched Write failed at admin login page]');
  //       } else if (value == true) {
  //         checkLoginStatus();
  //       }
  //     });
  //   }).catchError((err) async {
  //     if (mounted)
  //       setState(() {
  //         errormsg =
  //             'Error occured while setting up admin app.\n\nPlease inform the below captured error to developer: $err';
  //       });

  //     await session.createalert(
  //         alertmsgforuser: '',
  //         context: context,
  //         alerttime: DateTime.now().millisecondsSinceEpoch,
  //         alerttitle: 'Database setup failed',
  //         alertdesc:
  //             'First time database write failed by admin (${AppConstants.apptype}). \n[CAPTURED ERROR:$err]');
  //   });
  // }

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocaleForUsers(language.languageCode);
    AppWrapper.setLocale(this.context, _locale);

    await widget.prefs.setBool('islanguageselected', true);
  }

  checkLoginStatus(bool isfreshlogin) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('User is currently signed out!');

      setState(() {
        isLoading = false;
        isloggedin = false;
        errormsg = null;
      });
    } else {
      print('User is signed in!');
      await FirebaseFirestore.instance
          .collection(DbPaths.adminapp)
          .doc(DbPaths.admincred)
          .get()
          .then((doc) {
        if (doc.exists) {
          if (doc.data()!.containsKey(Dbkeys.admindeviceid)) {
            if (doc[Dbkeys.admindeviceid] == widget.currentdeviceID ||
                (doc[Dbkeys.admindeviceid] == "")) {
              if (doc[Dbkeys.admindeviceid] == "" && isfreshlogin == true) {
                if (doc[Dbkeys.setupNotdoneyet] == true) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyBottomNavBarAdminApp(
                        prefs: widget.prefs,
                        isFirstTimeSetup: true,
                        currentdeviceid: widget.currentdeviceID,
                      ),
                    ),
                    (route) => false,
                  );
                } else {
                  pageNavigator(
                      context,
                      PasscodeScreen(
                        prefs: widget.prefs,
                        currentdeviceID: widget.currentdeviceID,
                        deviceInfoMap: widget.deviceInfoMap,
                        docmap: doc.data(),
                        basicsettings: widget.basicsettings,
                        isfirsttime: false,
                      ));
                }
              } else if (doc[Dbkeys.admindeviceid] == "" &&
                  isfreshlogin == false) {
                setState(() {
                  isLoading = false;
                  isloggedin = false;
                  errormsg = null;
                });
                FirebaseAuth.instance.signOut();
              } else {
                pageNavigator(
                    context,
                    PasscodeScreen(
                      prefs: widget.prefs,
                      currentdeviceID: widget.currentdeviceID,
                      deviceInfoMap: widget.deviceInfoMap,
                      docmap: doc.data(),
                      basicsettings: widget.basicsettings,
                      isfirsttime: false,
                    ));
              }
            } else {
              if (isfreshlogin == true ||
                  AppConstants.isMultiDeviceLoginEnabled == true) {
                pageNavigator(
                    context,
                    PasscodeScreen(
                      prefs: widget.prefs,
                      currentdeviceID: widget.currentdeviceID,
                      deviceInfoMap: widget.deviceInfoMap,
                      docmap: doc.data(),
                      basicsettings: widget.basicsettings,
                      isfirsttime: false,
                    ));
              } else {
                isLoading = false;
                setState(() {});
                // Restart.restartApp();
                FirebaseAuth.instance.signOut();
                Fluttertoast.showToast(
                    msg: getTranslatedForCurrentUser(
                        context, 'xxxsessionexpiredxxx'));
              }
            }
          } else {
            isLoading = false;
            setState(() {});
            FirebaseAuth.instance.signOut();
            Fluttertoast.showToast(
                msg:
                    "${getTranslatedForCurrentUser(context, 'xxxsessionexpiredxxx')}.\n\n Not ready yet");
          }
        } else {
          setState(() {
            isLoading = false;
            errormsg = 'Error occured while setting up admin app. ERR_487';
          });
          FirebaseAuth.instance.signOut();
          Fluttertoast.showToast(msg: errormsg!);
        }
      }).catchError((e) {
        setState(() {
          isLoading = false;
          errormsg =
              "ERR_423:  Error loadin admin data. Please try again . If it continues Please report it to developer.";
        });
        Fluttertoast.showToast(msg: errormsg!);
      });
    }
  }

  bool istask1done = false;
  bool isLoading = true;
  loginWdget(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(28, 45, 28, 17),
                    child: Image.asset(
                      AppConstants.logopath,
                      height: 90,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(28, h / 47, 28, 10),
                    child: MtCustomfontBoldSemi(
                      text: getTranslatedForCurrentUser(context, 'xxwelcomexx')
                          .replaceAll('(####)', ''),
                      color: Colors.white54,
                      fontsize: 23,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(28, 5, 13, 17),
                    child: MtCustomfontBoldExtra(
                      text: AppConstants.title,
                      color: Colors.white,
                      fontsize: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3.0,
                      color: Colors.white.withOpacity(0.3),
                      spreadRadius: 1.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                margin: EdgeInsets.fromLTRB(15, h / 30.3, 16, 0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 13,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(28, 10, 28, 10),
                      child: MtCustomfontBold(
                        text: AppConstants.isdemomode == true
                            ? getTranslatedForCurrentUser(
                                context, 'xxxlogintoadmindemoxxx')
                            : getTranslatedForCurrentUser(
                                context, 'xxxlogintoadminxxx'),
                        color: Mycolors.secondary,
                        fontsize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: InpuTextBox(
                        boxbordercolor: Colors.white,
                        boxbcgcolor: Mycolors.greylightcolor,
                        hinttext:
                            getTranslatedForCurrentUser(context, 'xxemailxx'),
                        boxcornerradius: 6,
                        boxheight: 50,
                        controller: _enteredemailcontroller,
                        forcedmargin: EdgeInsets.only(bottom: 0),
                        autovalidate: false,
                        contentpadding: EdgeInsets.only(
                            top: 15, bottom: 15, left: 20, right: 20),
                        keyboardtype: TextInputType.emailAddress,
                        inputFormatter: [],
                        onSaved: (val) {},
                        isboldinput: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                      child: InpuTextBox(
                        boxbordercolor: Colors.white,
                        boxbcgcolor: Mycolors.greylightcolor,
                        hinttext: getTranslatedForCurrentUser(
                            context, 'xxpasswordxx'),
                        boxcornerradius: 6,
                        boxheight: 50,
                        autovalidate: false,
                        contentpadding: EdgeInsets.only(
                            top: 15, bottom: 15, left: 20, right: 20),
                        keyboardtype: TextInputType.text,
                        inputFormatter: [],
                        obscuretext: true,
                        controller: _enteredpasswordcontroller,
                        isboldinput: true,
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(17),
                    //   child: Text(
                    //     'Send a SMS Code to Verify your number.',
                    //     // 'Send a SMS Code to verify your number',
                    //     textAlign: TextAlign.center,
                    //     // style: TextStyle(color: Mycolors.black),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 12, 15, 0),
                      child: isLoading == true
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : MySimpleButton(
                              buttoncolor: Mycolors.black,
                              buttontext: getTranslatedForCurrentUser(
                                      context, 'xxloginxx')
                                  .toUpperCase(),
                              onpressed: AppConstants.isdemomode == true
                                  ? () async {
                                      // ignore: unused_local_variable
                                      UserCredential userCredential =
                                          await FirebaseAuth
                                              .instance
                                              .signInWithEmailAndPassword(
                                                  email: AppConstants.isdemomode ==
                                                          true
                                                      ? AppConstants
                                                          .demoadminemail
                                                      : _enteredemailcontroller
                                                          .text
                                                          .trim(),
                                                  password: AppConstants
                                                              .isdemomode ==
                                                          true
                                                      ? AppConstants
                                                          .demoadminpassword
                                                      : _enteredpasswordcontroller
                                                          .text
                                                          .trim());
                                      pageNavigator(
                                          context,
                                          PasscodeScreen(
                                            prefs: widget.prefs,
                                            currentdeviceID:
                                                widget.currentdeviceID,
                                            deviceInfoMap: widget.deviceInfoMap,
                                            basicsettings: widget.basicsettings,
                                            docmap: "",
                                            isfirsttime: false,
                                          ));
                                    }
                                  : widget.basicsettings.isEmailLoginEnabled ==
                                          true
                                      ? () async {
                                          ShowSnackbar().open(
                                              label: getTranslatedForCurrentUser(
                                                  context,
                                                  'xxxlogintempdisbaledxxx'),
                                              context: context,
                                              scaffoldKey: _scaffoldKey,
                                              time: 2,
                                              status: 0);
                                        }
                                      : () async {
                                          if (_enteredemailcontroller.text
                                                      .trim()
                                                      .length <
                                                  2 ||
                                              _enteredpasswordcontroller.text
                                                      .trim()
                                                      .length <
                                                  2) {
                                            ShowSnackbar().open(
                                                label: getTranslatedForCurrentUser(
                                                    context,
                                                    'xxxplsenterlogincredxxx'),
                                                context: context,
                                                scaffoldKey: _scaffoldKey,
                                                time: 2,
                                                status: 0);
                                          } else {
                                            hidekeyboard(context);
                                            await loginCredentialsCheck(
                                                context);
                                          }
                                        }),
                    ),

                    SizedBox(
                      height: 11,
                    ),
                    AppConstants.isdemomode == true
                        ? MtCustomfontRegular(
                            text: getTranslatedForCurrentUser(
                                context, 'xxxtaploginxxx'),
                            fontsize: 12,
                            color: Mycolors.green,
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 11,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Center(
          child: Language.languageList().length < 2
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(10, 27, 7, 10),
                  child: myinkwell(
                      onTap: Language.languageList().length < 2
                          ? () {}
                          : () {
                              showDynamicModalBottomSheet(
                                title: "",
                                context: context,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                e.flag +
                                                    ' ' +
                                                    '    ' +
                                                    e.languageNameInEnglish,
                                                style: TextStyle(
                                                    color: Mycolors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                              Language.languageList().length < 2
                                                  ? SizedBox()
                                                  : Icon(
                                                      Icons.done,
                                                      color: e.languageCode ==
                                                              widget.prefs
                                                                  .getString(
                                                                      LAGUAGE_CODE)
                                                          ? Mycolors.green
                                                          : Colors.transparent,
                                                    )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                      child: Container(
                        alignment: Alignment.center,
                        width: 130,
                        child: Row(
                          children: [
                            Container(
                              // radius: 40,
                              child: Row(
                                children: [
                                  MtCustomfontBoldSemi(
                                    color: Mycolors.black,
                                    textalign: TextAlign.center,
                                    text: widget.prefs.getString(LAGUAGE_CODE) == null
                                        ? Language.languageList()[
                                                Language.languageList()
                                                    .indexWhere((element) =>
                                                        element.languageCode ==
                                                        DefaulLANGUAGEfileCodeForCURRENTuser)]
                                            .flag
                                            .toString()
                                        : Language.languageList()[
                                                Language.languageList()
                                                    .indexWhere((element) =>
                                                        element.languageCode ==
                                                        widget.prefs.getString(
                                                            LAGUAGE_CODE))]
                                            .flag
                                            .toString(),
                                    fontsize: 16,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  MtCustomfontBoldSemi(
                                    color: Mycolors.white,
                                    textalign: TextAlign.center,
                                    text: widget.prefs.getString(LAGUAGE_CODE) == null
                                        ? Language.languageList()[
                                                Language.languageList()
                                                    .indexWhere((element) =>
                                                        element.languageCode ==
                                                        DefaulLANGUAGEfileCodeForCURRENTuser)]
                                            .languageNameInEnglish
                                            .toString()
                                        : Language.languageList()[
                                                Language.languageList()
                                                    .indexWhere((element) =>
                                                        element.languageCode ==
                                                        widget.prefs.getString(
                                                            LAGUAGE_CODE))]
                                            .languageNameInEnglish
                                            .toString(),
                                    fontsize: 16,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 27,
                                    color: Mycolors.secondary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
        )
      ],
    );
  }

  loginCredentialsCheck(BuildContext context) async {
    final session = Provider.of<CommonSession>(context, listen: false);
    hidekeyboard(context);

    ShowLoading().open(
      context: context,
      key: _keyLoader,
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: AppConstants.isdemomode == true
                  ? AppConstants.demoadminemail
                  : _enteredemailcontroller.text.trim(),
              password: AppConstants.isdemomode == true
                  ? AppConstants.demoadminpassword
                  : _enteredpasswordcontroller.text.trim());
      if (userCredential.user != null) {
        await FirebaseMessaging.instance
            .subscribeToTopic('Admin')
            .then((value) async {
          await FirebaseMessaging.instance
              .subscribeToTopic('Activities')
              .then((value) async {
            ShowLoading().close(
              context: context,
              key: _keyLoader,
            );
            await checkLoginStatus(true);
          }).catchError((err) {
            ShowLoading().close(
              context: context,
              key: _keyLoader,
            );

            Utils.toast(
                'ERROR SUBSCRIBING NOTIFICATION ACTIVITIES' + err.toString());
            print('ERROR SUBSCRIBING NOTIFICATION ACTIVITIES' + err.toString());
          });
        }).catchError((err) {
          ShowLoading().close(
            context: context,
            key: _keyLoader,
          );
          Utils.toast('ERROR SUBSCRIBING NOTIFICATION ADMIN' + err.toString());
          print('ERROR SUBSCRIBING NOTIFICATION ADMIN' + err.toString());
        });
      } else {
        setState(() {
          attempt = attempt + 1;
        });
        ShowLoading().close(
          context: context,
          key: _keyLoader,
        );
        ShowSnackbar().open(
            label:
                getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx'),
            context: context,
            scaffoldKey: _scaffoldKey,
            time: 3,
            status: 1);
        if (attempt > 2) {
          await session.createalert(
              alertmsgforuser: null,
              context: context,
              alertcollection: DbPaths.collectionALLNORMALalerts,
              alerttime: DateTime.now().millisecondsSinceEpoch,
              alerttitle: 'Admin Credentials match failed',
              alertdesc:
                  'Error occured while matching admin entered login credentials in admin app ERR_456 ');
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        attempt = attempt + 1;
      });
      ShowLoading().close(
        context: context,
        key: _keyLoader,
      );
      ShowSnackbar().open(
          label: getTranslatedForCurrentUser(context, 'xxauthfailedxx'),
          context: context,
          scaffoldKey: _scaffoldKey,
          time: 3,
          status: 1);
      if (attempt > 2) {
        await session.createalert(
            alertmsgforuser: null,
            context: context,
            alertcollection: DbPaths.collectionALLNORMALalerts,
            alerttime: DateTime.now().millisecondsSinceEpoch,
            alerttitle: 'Admin Credentials match failed',
            alertdesc:
                'Error occured while matching admin entered login credentials in admin app \n[CAPTURED ERROR: $e ] ERR_457');
      }
    } catch (e) {
      setState(() {
        attempt = attempt + 1;
      });
      ShowLoading().close(
        context: context,
        key: _keyLoader,
      );
      ShowSnackbar().open(
          label: getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx'),
          context: context,
          scaffoldKey: _scaffoldKey,
          time: 3,
          status: 1);
      if (attempt > 2) {
        await session.createalert(
            alertmsgforuser: null,
            context: context,
            alertcollection: DbPaths.collectionALLNORMALalerts,
            alerttime: DateTime.now().millisecondsSinceEpoch,
            alerttitle: 'Admin Credentials match failed',
            alertdesc:
                'Error occured while matching admin entered login credentials in admin app \n[CAPTURED ERROR: $e ] ERR_457');
      }
    }
    // await FirebaseFirestore.instance
    //     .collection(Dbkeys.admincredentials)
    //     .doc(Dbkeys.admincredentials)
    //     .get()
    //     .then((doc) async {
    //   if (doc.exists) {
    //     if (doc[Dbkeys.adminusername] == _enteredemailcontroller.text &&
    //         doc[Dbkeys.adminpassword] == _enteredpasswordcontroller.text) {
    //       //--- entered credentials are correct
    //       ShowLoading().close(
    //         context: context,
    //         key: _keyLoader,
    //       );
    //       pageNavigator(context, PasscodeScreen());
    //     } else {
    //       //--- entered credentials are incorrect
    //       ShowLoading().close(
    //         context: context,
    //         key: _keyLoader,
    //       );
    //       ShowSnackbar().open(
    //           label: 'Invalid Credentials. Please try again !',
    //           context: context,
    //           scaffoldKey: _scaffoldKey,
    //           time: 3,
    //           status: 1);
    //       await session.createalert(
    //           alertmsgforuser: null,
    //           context: context,
    //           alertcollection: DbPaths.collectionALLNORMALalerts,
    //           alerttime: DateTime.now().millisecondsSinceEpoch,
    //           alerttitle: 'Admin Credentials incorrect',
    //           alertdesc:
    //               'Error occured while matching admin entered login credentials in admin app \n[CAPTURED ERROR: Firestore document does not exists. This message is showing ]');
    //     }
    //   } else {
    //
    //     ShowLoading().close(
    //       context: context,
    //       key: _keyLoader,
    //     );
    //     ShowSnackbar().open(
    //         label: 'Login Failed ! Please enter correct credentials',
    //         context: context,
    //         scaffoldKey: _scaffoldKey,
    //         time: 3,
    //         status: 1);
    //     if (attempt > 3) {
    //       await session.createalert(
    //           alertmsgforuser: null,
    //           context: context,
    //           alertcollection: DbPaths.collectionTXNHIGHalerts,
    //           alerttime: DateTime.now().millisecondsSinceEpoch,
    //           alerttitle: 'Admin Credentials Incorrect',
    //           alertdesc:
    //               'More than 3 attempts to login admin app has been made \n[CAPTURED ERROR: Incorrect admin credentials]');
    //     }
    //   }
    // }).catchError((err) async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Splashscreen()
        : Scaffold(
            key: _scaffoldKey,
            backgroundColor: Mycolors.primary,
            body: Platform.isAndroid &&
                        widget.basicsettings.isappunderconstructionandroid! ||
                    Platform.isIOS &&
                        widget.basicsettings.isappunderconstructionios!
                ? Center(
                    child: Padding(
                    padding: EdgeInsets.all(68.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.settings_applications,
                              size: 88, color: Colors.cyanAccent[400]),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            getTranslatedForCurrentUser(
                                context, 'xxappundercxx'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                height: 1.4,
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            errormsg!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                height: 1.4,
                                fontSize: 17,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ))
                : errormsg != null
                    ? Center(
                        child: Padding(
                        padding: EdgeInsets.all(68.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline,
                                  size: 88, color: Colors.pinkAccent[400]),
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                getTranslatedForCurrentUser(
                                    context, 'xxxsessionlongxxx'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    height: 1.4,
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                getTranslatedForCurrentUser(
                                    context, 'xxxifitsnotuxxx'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    height: 1.4,
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                errormsg!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    height: 1.4,
                                    fontSize: 17,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              MySimpleButton(
                                buttoncolor: Mycolors.black,
                                buttontext: getTranslatedForCurrentUser(
                                        context, 'xxloginxx')
                                    .toUpperCase(),
                                onpressed: () {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                  Restart.restartApp();
                                },
                              )
                            ],
                          ),
                        ),
                      ))
                    : loginWdget(context));
  }
}
