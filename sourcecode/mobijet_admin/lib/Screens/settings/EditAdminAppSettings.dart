import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/basic_settings_model_adminapp.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Utils/delayed_function.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/FormDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Utils/custom_tiles.dart';
import 'dart:convert';
import 'package:thinkcreative_technologies/Widgets/headers/sectionheaders.dart';

class AdminAppSettings extends StatefulWidget {
  final DocumentReference docRef;
  AdminAppSettings({required this.docRef});
  @override
  _AdminAppSettingsState createState() => _AdminAppSettingsState();
}

class _AdminAppSettingsState extends State<AdminAppSettings> {
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
  BasicSettingModelAdminApp? adminAppSettings;
  fetchdata() async {
    await widget.docRef.get().then((dc) async {
      if (dc.exists) {
        //           Codec<String, String> stringToBase64 = utf8.fuse(base64);
        // String v = stringToBase64.decode(dc["f9846v"]).toString();

        String decoded = utf8.decode(base64.decode(dc["f9846v"]));
        // try parse the http json response
        var jsonobject = json.decode(decoded) as Map<String, dynamic>;

        adminAppSettings = BasicSettingModelAdminApp.fromJson(jsonobject);
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

  Future setEncoded(BasicSettingModelAdminApp settingsmodel) async {
    String str = json.encode(settingsmodel.toMap());
    String encoded = base64.encode(utf8.encode("$str"));
    await widget.docRef.set({"f9846v": encoded}, SetOptions(merge: true));
    adminAppSettings = settingsmodel;
  }

  confirmchangeswitch({
    required BuildContext context,
    bool? currentlbool,
    String? toONmessage,
    String? toOFFmessage,
    required BasicSettingModelAdminApp updatedmodel,
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
                    adminAppSettings = updatedmodel;
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
      required BasicSettingModelAdminApp updatedmodel,
      p}) async {
    final session = Provider.of<CommonSession>(context, listen: false);
    Navigator.pop(context);
    ShowLoading().open(context: context, key: _keyLoader);
    await setEncoded(updatedmodel).then((value) async {
      ShowLoading().close(context: context, key: _keyLoader);
      setState(() {
        adminAppSettings = updatedmodel;
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
                        subtitle: adminAppSettings!.latestappversionandroid,
                        ontap: () {
                          _controller.text =
                              adminAppSettings!.latestappversionandroid!;
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
                                            updatedmodel: adminAppSettings!
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
                        subtitle: adminAppSettings!.newapplinkandroid,
                        leadingicondata: Icons.settings_applications_rounded,
                        ontap: () {
                          _controller.text =
                              adminAppSettings!.newapplinkandroid!;
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
                                            updatedmodel: adminAppSettings!
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
                              value: adminAppSettings!
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
                                      bool switchvalue = adminAppSettings!
                                              .isappunderconstructionandroid ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel:
                                              adminAppSettings!.copyWith(
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
                        subtitle: adminAppSettings!.maintainancemessage,
                        leadingicondata: Icons.settings_applications_rounded,
                        ontap: () {
                          _controller.text =
                              adminAppSettings!.maintainancemessage!;
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
                                            updatedmodel: adminAppSettings!
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
                        subtitle: adminAppSettings!.latestappversionios,
                        ontap: () {
                          _controller.text =
                              adminAppSettings!.latestappversionios!;
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
                                            updatedmodel: adminAppSettings!
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
                        subtitle: adminAppSettings!.newapplinkios,
                        leadingicondata: Icons.settings_applications_rounded,
                        ontap: () {
                          _controller.text = adminAppSettings!.newapplinkios!;
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
                                            updatedmodel: adminAppSettings!
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
                                  adminAppSettings!.isappunderconstructionios!,
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
                                      bool switchvalue = adminAppSettings!
                                              .isappunderconstructionios ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: adminAppSettings!
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
