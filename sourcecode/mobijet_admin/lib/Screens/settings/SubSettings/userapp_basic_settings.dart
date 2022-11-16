import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/basic_settings_model_userapp.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Utils/delayed_function.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/FormDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/headers/sectionheaders.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Utils/custom_tiles.dart';

class UserBasicSettings extends StatefulWidget {
  final String currentuserid;
  final DocumentReference docRef;
  UserBasicSettings({required this.docRef, required this.currentuserid});
  @override
  _UserBasicSettingsState createState() => _UserBasicSettingsState();
}

class _UserBasicSettingsState extends State<UserBasicSettings> {
  bool isloading = true;

  TextEditingController _controller = new TextEditingController();
  final GlobalKey<State> _keyLoader =
      new GlobalKey<State>(debugLabel: '272hu1');

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  String error = "";
  BasicSettingModelUserApp? userAppSettings;
  fetchdata() async {
    await widget.docRef.get().then((dc) async {
      if (dc.exists) {
        //           Codec<String, String> stringToBase64 = utf8.fuse(base64);
        // String v = stringToBase64.decode(dc["f9846v"]).toString();

        String decoded = utf8.decode(base64.decode(dc["f9846v"]));
        // try parse the http json response
        var jsonobject = json.decode(decoded) as Map<String, dynamic>;

        userAppSettings = BasicSettingModelUserApp.fromJson(jsonobject);
        setState(() {
          isloading = false;
        });
      } else {
        setState(() {
          error = getTranslatedForCurrentUser(
              context, 'xxuserappsetupincompletexx');
        });
      }
    }).catchError((onError) {
      setState(() {
        error =
            "${getTranslatedForCurrentUser(context, 'xxuserappsetupincompletexx')}. ${onError.toString()} ";

        isloading = false;
      });
    });
  }

  Future setEncoded(BasicSettingModelUserApp settingsmodel) async {
    String str = json.encode(settingsmodel.toMap());
    String encoded = base64.encode(utf8.encode("$str"));
    await widget.docRef.set({"f9846v": encoded}, SetOptions(merge: true));
    userAppSettings = settingsmodel;
  }

  confirmchangeswitch({
    required BuildContext context,
    bool? currentlbool,
    String? toONmessage,
    String? toOFFmessage,
    required BasicSettingModelUserApp updatedmodel,
  }) {
    ShowConfirmDialog().open(
        context: context,
        subtitle: currentlbool == false
            ? toONmessage ??
                getTranslatedForCurrentUser(context, 'xxxxturnonxxx')
            : toOFFmessage ??
                getTranslatedForCurrentUser(context, 'xxxxturnoffxxx'),
        title: getTranslatedForCurrentUser(context, 'xxxxalertxxx'),
        rightbtnonpress: AppConstants.isdemomode == true
            ? () {
                Utils.toast(getTranslatedForCurrentUser(
                    context, 'xxxnotalwddemoxxaccountxx'));
              }
            : () async {
                final session =
                    Provider.of<CommonSession>(context, listen: false);
                Navigator.pop(context);
                ShowLoading().open(context: context, key: _keyLoader);
                await setEncoded(updatedmodel).then((value) async {
                  ShowLoading().close(context: context, key: _keyLoader);
                  setState(() {
                    userAppSettings = updatedmodel;
                  });

                  ShowSnackbar().open(
                      context: context,
                      scaffoldKey: _scaffoldKey,
                      status: 2,
                      time: 2,
                      label: getTranslatedForCurrentUser(
                          context, 'xxsuccessvalueupdatedxx'));
                  session.setUserAppSettingFromFirestore();
                }).catchError((error) {
                  ShowLoading().close(context: context, key: _keyLoader);
                  print('Error: $error');
                  ShowSnackbar().open(
                      context: context,
                      scaffoldKey: _scaffoldKey,
                      status: 1,
                      time: 3,
                      label:
                          '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}\n $error');
                });
              });
  }

  fieldupdate(
      {required BuildContext context,
      required BasicSettingModelUserApp updatedmodel,
      p}) async {
    final session = Provider.of<CommonSession>(context, listen: false);
    Navigator.pop(context);
    ShowLoading().open(context: context, key: _keyLoader);
    await setEncoded(updatedmodel).then((value) async {
      ShowLoading().close(context: context, key: _keyLoader);
      setState(() {
        userAppSettings = updatedmodel;
      });
      _controller.clear();
      ShowSnackbar().open(
          context: context,
          scaffoldKey: _scaffoldKey,
          status: 2,
          time: 2,
          label:
              getTranslatedForCurrentUser(context, 'xxsuccessvalueupdatedxx'));
      session.setUserAppSettingFromFirestore();
    }).catchError((error) {
      ShowLoading().close(context: context, key: _keyLoader);
      print('Error: $error');
      ShowSnackbar().open(
          context: context,
          scaffoldKey: _scaffoldKey,
          status: 1,
          time: 3,
          label:
              '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}\n $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        scaffoldkey: _scaffoldKey,
        titlespacing: 0,
        title: getTranslatedForCurrentUser(context, 'xxxbasicsetupuserappxxx'),
        body: error != ""
            ? Center(
                child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      error,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Mycolors.red),
                    )),
              )
            : isloading == true
                ? circularProgress()
                : ListView(padding: EdgeInsets.only(top: 4), children: [
                    //* -------------------------------

                    sectionHeader(getTranslatedForCurrentUser(
                        context, 'xxxandroidappxxx')),

                    customTile(
                        ishighlightdesc: true,
                        margin: 5,
                        iconsize: 30,
                        trailingicondata: Icons.edit_outlined,
                        leadingicondata: Icons.settings_applications_rounded,
                        title: getTranslatedForCurrentUser(
                            context, 'xxxandroidlatestversionxxx'),
                        subtitle: userAppSettings!.latestappversionandroid,
                        ontap: () {
                          _controller.text =
                              userAppSettings!.latestappversionandroid!;
                          ShowFormDialog().open(
                              keyboardtype: TextInputType.number,
                              inputFormatter: [
                                // LengthLimitingTextInputFormatter(AppSettings.maxcoupondigits),
                                FilteringTextInputFormatter.allow(
                                    // RegExp("[0-9a-zA-Z,.-_]")),

                                    RegExp(r"[\d.]")) //-- Only Number &dot
                                // RegExp("[0-9A-Z]")//-- Only Number & Aplhabets
                                // ), //-- Only Number & Aplhabets
                              ],
                              iscapital: false,
                              controller: _controller,
                              maxlength: 8,
                              // maxlines: 4,
                              // minlines: 2,
                              iscentrealign: true,
                              context: context,
                              title: getTranslatedForCurrentUser(
                                  context, 'xxxandroidlatestversionxxx'),
                              subtitle: 'Format - X.X.X',
                              onpressed: AppConstants.isdemomode == true
                                  ? () {
                                      Utils.toast(getTranslatedForCurrentUser(
                                          context,
                                          'xxxnotalwddemoxxaccountxx'));
                                    }
                                  : () async {
                                      if (_controller.text.trim().length < 5) {
                                        ShowSnackbar().open(
                                            context: context,
                                            scaffoldKey: _scaffoldKey,
                                            time: 3,
                                            label:
                                                '${getTranslatedForCurrentUser(context, 'xxxpllsentervalidversionxxx')} (X.X.X)');
                                        delayedFunction(setstatefn: () {
                                          ShowSnackbar().close(
                                            context: context,
                                            scaffoldKey: _scaffoldKey,
                                          );
                                        });
                                      } else {
                                        await fieldupdate(
                                            context: context,
                                            updatedmodel: userAppSettings!
                                                .copyWith(
                                                    latestappversionandroid:
                                                        _controller.text
                                                            .trim()));
                                      }
                                    },
                              buttontext: getTranslatedForCurrentUser(
                                  context, 'xxupdatexx'),
                              hinttext:
                                  '${getTranslatedForCurrentUser(context, 'xxxenterappversionxxx')} (X.X.X)');
                        }),

                    customTile(
                        ishighlightdesc: true,
                        margin: 5,
                        iconsize: 30,
                        trailingicondata: Icons.edit_outlined,
                        title: getTranslatedForCurrentUser(
                            context, 'xxxandroidupdatelinkxxx'),
                        subtitle: userAppSettings!.newapplinkandroid,
                        leadingicondata: Icons.settings_applications_rounded,
                        ontap: () {
                          _controller.text =
                              userAppSettings!.newapplinkandroid!;
                          ShowFormDialog().open(
                              inputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9a-zA-Z,.-_]")),
                              ],
                              iscapital: false,
                              controller: _controller,
                              maxlength: 500,
                              maxlines: 4,
                              minlines: 2,
                              iscentrealign: true,
                              context: context,
                              title: getTranslatedForCurrentUser(
                                  context, 'xxxappupdatelinkxxx'),
                              onpressed: AppConstants.isdemomode == true
                                  ? () {
                                      Utils.toast(getTranslatedForCurrentUser(
                                          context,
                                          'xxxnotalwddemoxxaccountxx'));
                                    }
                                  : () async {
                                      if (_controller.text.trim().length < 2) {
                                        ShowSnackbar().open(
                                            context: context,
                                            scaffoldKey: _scaffoldKey,
                                            time: 3,
                                            label: getTranslatedForCurrentUser(
                                                context,
                                                'xxxplssenteravalidurlxxx'));
                                        delayedFunction(setstatefn: () {
                                          ShowSnackbar().close(
                                            context: context,
                                            scaffoldKey: _scaffoldKey,
                                          );
                                        });
                                      } else {
                                        await fieldupdate(
                                            context: context,
                                            updatedmodel: userAppSettings!
                                                .copyWith(
                                                    newapplinkandroid:
                                                        _controller.text
                                                            .trim()));
                                      }
                                    },
                              buttontext: getTranslatedForCurrentUser(
                                  context, 'xxupdatexx'),
                              hinttext: getTranslatedForCurrentUser(
                                  context, 'xxxenterurlxxx'));
                        }),
                    customTile(
                        ishighlightdesc: false,
                        margin: 5,
                        iconsize: 30,
                        trailingWidget: Container(
                          margin: EdgeInsets.only(right: 3, top: 5),
                          width: 50,
                          height: 19,
                          child: FlutterSwitch(
                              activeText: '',
                              inactiveText: '',
                              width: 46.0,
                              activeColor: Mycolors.green.withOpacity(0.85),
                              inactiveColor: Mycolors.grey,
                              height: 19.0,
                              valueFontSize: 12.0,
                              toggleSize: 15.0,
                              value: userAppSettings!
                                  .isappunderconstructionandroid!,
                              borderRadius: 25.0,
                              padding: 3.0,
                              showOnOff: true,
                              onToggle: AppConstants.isdemomode == true
                                  ? (val) {
                                      Utils.toast(getTranslatedForCurrentUser(
                                          context,
                                          'xxxnotalwddemoxxaccountxx'));
                                    }
                                  : (val) async {
                                      bool switchvalue = userAppSettings!
                                              .isappunderconstructionandroid ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel:
                                              userAppSettings!.copyWith(
                                            isappunderconstructionandroid:
                                                !switchvalue,
                                          ));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                            context, 'xxxxandroidappmaintencexxx'),
                        subtitle: getTranslatedForCurrentUser(
                            context, 'xxxxappmaintencedescxxx'),
                        leadingicondata: Icons.settings_applications_rounded),
                    customTile(
                        ishighlightdesc: true,
                        margin: 5,
                        iconsize: 30,
                        trailingicondata: Icons.edit_outlined,
                        title: getTranslatedForCurrentUser(
                            context, 'xxxmainteancecustomssgxx'),
                        subtitle: userAppSettings!.maintainancemessage,
                        leadingicondata: Icons.settings_applications_rounded,
                        ontap: () {
                          _controller.text =
                              userAppSettings!.maintainancemessage!;
                          ShowFormDialog().open(
                              inputFormatter: [],
                              iscapital: false,
                              controller: _controller,
                              maxlength: 500,
                              maxlines: 4,
                              minlines: 2,
                              iscentrealign: true,
                              context: context,
                              title: getTranslatedForCurrentUser(
                                  context, 'xxmssgxx'),
                              onpressed: AppConstants.isdemomode == true
                                  ? () {
                                      Utils.toast(getTranslatedForCurrentUser(
                                          context,
                                          'xxxnotalwddemoxxaccountxx'));
                                    }
                                  : () async {
                                      if (_controller.text.trim().length < 2) {
                                      } else {
                                        await fieldupdate(
                                            context: context,
                                            updatedmodel: userAppSettings!
                                                .copyWith(
                                                    maintainancemessage:
                                                        _controller.text
                                                            .trim()));
                                      }
                                    },
                              buttontext: getTranslatedForCurrentUser(
                                  context, 'xxupdatexx'),
                              hinttext: getTranslatedForCurrentUser(
                                  context, 'xxmssgxx'));
                        }),
                    //* -------------------------------

                    sectionHeader(
                        getTranslatedForCurrentUser(context, 'xxxiosappxxx')),

                    customTile(
                        ishighlightdesc: true,
                        margin: 5,
                        iconsize: 30,
                        trailingicondata: Icons.edit_outlined,
                        leadingicondata: Icons.settings_applications_rounded,
                        title: getTranslatedForCurrentUser(
                            context, 'xxxioslatestversionxxx'),
                        subtitle: userAppSettings!.latestappversionios,
                        ontap: () {
                          _controller.text =
                              userAppSettings!.latestappversionios!;
                          ShowFormDialog().open(
                              keyboardtype: TextInputType.number,
                              inputFormatter: [
                                // LengthLimitingTextInputFormatter(AppSettings.maxcoupondigits),
                                FilteringTextInputFormatter.allow(
                                    // RegExp("[0-9a-zA-Z,.-_]")),

                                    RegExp(r"[\d.]")) //-- Only Number &dot
                                // RegExp("[0-9A-Z]")//-- Only Number & Aplhabets
                                // ), //-- Only Number & Aplhabets
                              ],
                              iscapital: false,
                              controller: _controller,
                              maxlength: 8,
                              // maxlines: 4,
                              // minlines: 2,
                              iscentrealign: true,
                              context: context,
                              title: getTranslatedForCurrentUser(
                                  context, 'xxxioslatestversionxxx'),
                              subtitle: 'Format - X.X.X',
                              onpressed: AppConstants.isdemomode == true
                                  ? () {
                                      Utils.toast(getTranslatedForCurrentUser(
                                          context,
                                          'xxxnotalwddemoxxaccountxx'));
                                    }
                                  : () async {
                                      if (_controller.text.trim().length < 5) {
                                        ShowSnackbar().open(
                                            context: context,
                                            scaffoldKey: _scaffoldKey,
                                            time: 3,
                                            label:
                                                '${getTranslatedForCurrentUser(context, 'xxxpllsentervalidversionxxx')} (X.X.X)');
                                        delayedFunction(setstatefn: () {
                                          ShowSnackbar().close(
                                            context: context,
                                            scaffoldKey: _scaffoldKey,
                                          );
                                        });
                                      } else {
                                        await fieldupdate(
                                            context: context,
                                            updatedmodel: userAppSettings!
                                                .copyWith(
                                                    latestappversionios:
                                                        _controller.text
                                                            .trim()));
                                      }
                                    },
                              buttontext: getTranslatedForCurrentUser(
                                  context, 'xxupdatexx'),
                              hinttext:
                                  '${getTranslatedForCurrentUser(context, 'xxxenterappversionxxx')} (X.X.X)');
                        }),

                    customTile(
                        ishighlightdesc: true,
                        margin: 5,
                        iconsize: 30,
                        trailingicondata: Icons.edit_outlined,
                        title: getTranslatedForCurrentUser(
                            context, 'xxxiosupdatelinkxxx'),
                        subtitle: userAppSettings!.newapplinkios,
                        leadingicondata: Icons.settings_applications_rounded,
                        ontap: () {
                          _controller.text = userAppSettings!.newapplinkios!;
                          ShowFormDialog().open(
                              inputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9a-zA-Z,.-_]")),
                              ],
                              iscapital: false,
                              controller: _controller,
                              maxlength: 500,
                              maxlines: 4,
                              minlines: 2,
                              iscentrealign: true,
                              context: context,
                              title: getTranslatedForCurrentUser(
                                  context, 'xxxappupdatelinkxxx'),
                              onpressed: AppConstants.isdemomode == true
                                  ? () {
                                      Utils.toast(getTranslatedForCurrentUser(
                                          context,
                                          'xxxnotalwddemoxxaccountxx'));
                                    }
                                  : () async {
                                      if (_controller.text.trim().length < 2) {
                                        ShowSnackbar().open(
                                            context: context,
                                            scaffoldKey: _scaffoldKey,
                                            time: 3,
                                            label: getTranslatedForCurrentUser(
                                                context,
                                                'xxxplssenteravalidurlxxx'));
                                        delayedFunction(setstatefn: () {
                                          ShowSnackbar().close(
                                            context: context,
                                            scaffoldKey: _scaffoldKey,
                                          );
                                        });
                                      } else {
                                        await fieldupdate(
                                            context: context,
                                            updatedmodel: userAppSettings!
                                                .copyWith(
                                                    newapplinkios: _controller
                                                        .text
                                                        .trim()));
                                      }
                                    },
                              buttontext: getTranslatedForCurrentUser(
                                  context, 'xxupdatexx'),
                              hinttext: getTranslatedForCurrentUser(
                                  context, 'xxxenterurlxxx'));
                        }),
                    customTile(
                        margin: 5,
                        iconsize: 30,
                        trailingWidget: Container(
                          margin: EdgeInsets.only(right: 3, top: 5),
                          width: 50,
                          height: 19,
                          child: FlutterSwitch(
                              activeText: '',
                              inactiveText: '',
                              width: 46.0,
                              activeColor: Mycolors.green.withOpacity(0.85),
                              inactiveColor: Mycolors.grey,
                              height: 19.0,
                              valueFontSize: 12.0,
                              toggleSize: 15.0,
                              value:
                                  userAppSettings!.isappunderconstructionios!,
                              borderRadius: 25.0,
                              padding: 3.0,
                              showOnOff: true,
                              onToggle: AppConstants.isdemomode == true
                                  ? (val) {
                                      Utils.toast(getTranslatedForCurrentUser(
                                          context,
                                          'xxxnotalwddemoxxaccountxx'));
                                    }
                                  : (val) async {
                                      bool switchvalue = userAppSettings!
                                              .isappunderconstructionios ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!
                                              .copyWith(
                                                  isappunderconstructionios:
                                                      !switchvalue));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                            context, 'xxxxiosappmaintencexxx'),
                        subtitle: getTranslatedForCurrentUser(
                            context, 'xxxxappmaintencedescxxx'),
                        leadingicondata: Icons.settings_applications_rounded),

                    SizedBox(
                      height: 20,
                    ),
                  ]));
  }
}
