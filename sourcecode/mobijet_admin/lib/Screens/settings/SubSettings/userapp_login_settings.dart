import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/basic_settings_model_userapp.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Utils/delayed_function.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Widgets/Input_box.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/FormDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/headers/sectionheaders.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Utils/custom_tiles.dart';

class UserLoginSettings extends StatefulWidget {
  final String currentuserid;
  final DocumentReference docRef;
  UserLoginSettings({required this.docRef, required this.currentuserid});
  @override
  _UserLoginSettingsState createState() => _UserLoginSettingsState();
}

class _UserLoginSettingsState extends State<UserLoginSettings> {
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
  BasicSettingModelUserApp? basicrAppSettings;
  fetchdata() async {
    await widget.docRef.get().then((dc) async {
      if (dc.exists) {
        //           Codec<String, String> stringToBase64 = utf8.fuse(base64);
        // String v = stringToBase64.decode(dc["f9846v"]).toString();

        String decoded = utf8.decode(base64.decode(dc["f9846v"]));
        // try parse the http json response
        var jsonobject = json.decode(decoded) as Map<String, dynamic>;

        basicrAppSettings = BasicSettingModelUserApp.fromJson(jsonobject);
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
    basicrAppSettings = settingsmodel;
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
                    basicrAppSettings = updatedmodel;
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
        basicrAppSettings = updatedmodel;
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
        title: getTranslatedForCurrentUser(context, 'xxxloginrulesxxx'),
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

                    sectionHeader(
                        getTranslatedForCurrentUser(context, 'xxxauthxxx')),

                    Card(
                      elevation: 0.1,
                      margin: EdgeInsets.all(4),
                      child: InputGroup2large(
                        title: getTranslatedForCurrentUser(
                            context, 'xxxauthtypexxx'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxsigninproviderforxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxxx')}'),
                        val1: 'Phone',
                        val2: 'Email/Password',
                        selectedvalue: basicrAppSettings!.loginTypeUserApp
                                        .toString() ==
                                    "" ||
                                basicrAppSettings!.loginTypeUserApp
                                        .toString() ==
                                    "Phone"
                            ? 'Phone'
                            : basicrAppSettings!.loginTypeUserApp.toString(),
                        onChanged: AppConstants.isdemomode == true
                            ? (val) {
                                Utils.toast(getTranslatedForCurrentUser(
                                    context, 'xxxnotalwddemoxxaccountxx'));
                              }
                            : (val) async {
                                basicrAppSettings = basicrAppSettings!.copyWith(
                                  loginTypeUserApp: val,
                                );
                                final session = Provider.of<CommonSession>(
                                    context,
                                    listen: false);

                                ShowLoading()
                                    .open(context: context, key: _keyLoader);
                                await setEncoded(basicrAppSettings!)
                                    .then((value) async {
                                  ShowLoading()
                                      .close(context: context, key: _keyLoader);
                                  setState(() {
                                    basicrAppSettings = basicrAppSettings;
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
                                  ShowLoading()
                                      .close(context: context, key: _keyLoader);
                                  print('Error: $error');
                                  ShowSnackbar().open(
                                      context: context,
                                      scaffoldKey: _scaffoldKey,
                                      status: 1,
                                      time: 3,
                                      label:
                                          '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}\n $error');
                                });
                              },
                      ),
                    ),

                    //* -------------------------------

                    sectionHeader(
                        '${getTranslatedForCurrentUser(context, 'xxagentxx').toUpperCase()} ${getTranslatedForCurrentUser(context, 'xxloginxx').toUpperCase()}'),
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
                              value: basicrAppSettings!.agentLoginEnabled!,
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
                                      bool switchvalue = basicrAppSettings!
                                              .agentLoginEnabled ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: basicrAppSettings!
                                              .copyWith(
                                                  agentLoginEnabled:
                                                      !switchvalue));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxxloginenabledxxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxxexistingwhohavecanloginxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),
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
                                  basicrAppSettings!.agentRegistartionEnabled!,
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
                                      bool switchvalue = basicrAppSettings!
                                              .agentRegistartionEnabled ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: basicrAppSettings!
                                              .copyWith(
                                                  agentRegistartionEnabled:
                                                      !switchvalue));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxxregenabledxxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxnewcancreateaccountxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),

                    basicrAppSettings!.agentRegistartionEnabled == false ||
                            basicrAppSettings!.loginTypeUserApp.toString() ==
                                "Phone"
                        ? SizedBox()
                        : customTile(
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
                                      basicrAppSettings!.isCustomDomainsOnly!,
                                  borderRadius: 25.0,
                                  padding: 3.0,
                                  showOnOff: true,
                                  onToggle: AppConstants.isdemomode == true
                                      ? (val) {
                                          Utils.toast(
                                              getTranslatedForCurrentUser(
                                                  context,
                                                  'xxxnotalwddemoxxaccountxx'));
                                        }
                                      : (val) async {
                                          bool switchvalue = basicrAppSettings!
                                                  .isCustomDomainsOnly ??
                                              false;
                                          await confirmchangeswitch(
                                              context: context,
                                              currentlbool: switchvalue,
                                              updatedmodel: basicrAppSettings!
                                                  .copyWith(
                                                      isCustomDomainsOnly:
                                                          !switchvalue));
                                        }),
                            ),
                            title: getTranslatedForCurrentUser(
                                context, 'xxxcustomdomainisallowxxx'),
                            subtitle: getTranslatedForCurrentUser(
                                    context, 'xxxcustomdomainxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                            leadingicondata:
                                Icons.settings_applications_rounded),
                    basicrAppSettings!.agentRegistartionEnabled == false ||
                            basicrAppSettings!.loginTypeUserApp.toString() ==
                                "Phone"
                        ? SizedBox()
                        : basicrAppSettings!.isCustomDomainsOnly == false
                            ? SizedBox()
                            : customTile(
                                ishighlightdesc: true,
                                margin: 5,
                                iconsize: 30,
                                trailingicondata: Icons.edit_outlined,
                                title: getTranslatedForCurrentUser(
                                    context, 'xxxcustomdomainsxxx'),
                                subtitle:
                                    basicrAppSettings!.customDomainslist == ""
                                        ? getTranslatedForCurrentUser(
                                            context, 'xxxpredeflistxxx')
                                        : basicrAppSettings!.customDomainslist!,
                                leadingicondata:
                                    Icons.settings_applications_rounded,
                                ontap: () {
                                  _controller.text =
                                      basicrAppSettings!.customDomainslist!;
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
                                          context, 'xxxcustomdomainsxxx'),
                                      onpressed: AppConstants.isdemomode == true
                                          ? () {
                                              Utils.toast(
                                                  getTranslatedForCurrentUser(
                                                      context,
                                                      'xxxnotalwddemoxxaccountxx'));
                                            }
                                          : () async {
                                              await fieldupdate(
                                                  context: context,
                                                  updatedmodel:
                                                      basicrAppSettings!
                                                          .copyWith(
                                                              customDomainslist:
                                                                  _controller
                                                                      .text
                                                                      .trim()));
                                            },
                                      buttontext: getTranslatedForCurrentUser(
                                          context, 'xxupdatexx'),
                                      hinttext: getTranslatedForCurrentUser(
                                          context, 'xxxpredeflistxxx'));
                                }),
                    basicrAppSettings!.agentRegistartionEnabled == false
                        ? SizedBox()
                        : customTile(
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
                                  value: basicrAppSettings!
                                      .agentVerificationNeeded!,
                                  borderRadius: 25.0,
                                  padding: 3.0,
                                  showOnOff: true,
                                  onToggle: AppConstants.isdemomode == true
                                      ? (val) {
                                          Utils.toast(
                                              getTranslatedForCurrentUser(
                                                  context,
                                                  'xxxnotalwddemoxxaccountxx'));
                                        }
                                      : (val) async {
                                          bool switchvalue = basicrAppSettings!
                                                  .agentVerificationNeeded ??
                                              false;
                                          await confirmchangeswitch(
                                              context: context,
                                              currentlbool: switchvalue,
                                              updatedmodel: basicrAppSettings!
                                                  .copyWith(
                                                      agentVerificationNeeded:
                                                          !switchvalue));
                                        }),
                            ),
                            title: getTranslatedForCurrentUser(
                                    context, 'xxxxverfrequiredxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                            subtitle: getTranslatedForCurrentUser(
                                    context, 'xxxxeverynewagentapprovalxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                            leadingicondata:
                                Icons.settings_applications_rounded),
                    basicrAppSettings!.agentRegistartionEnabled == false
                        ? SizedBox()
                        : customTile(
                            ishighlightdesc: true,
                            margin: 5,
                            iconsize: 30,
                            trailingicondata: Icons.edit_outlined,
                            title: getTranslatedForCurrentUser(
                                context, 'xxxaccountapprovalmessagexx'),
                            subtitle: basicrAppSettings!.accountapprovalmessage,
                            leadingicondata:
                                Icons.settings_applications_rounded,
                            ontap: () {
                              _controller.text =
                                  basicrAppSettings!.accountapprovalmessage!;
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
                                          Utils.toast(
                                              getTranslatedForCurrentUser(
                                                  context,
                                                  'xxxnotalwddemoxxaccountxx'));
                                        }
                                      : () async {
                                          if (_controller.text.trim().length <
                                              2) {
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
                                                updatedmodel: basicrAppSettings!
                                                    .copyWith(
                                                        accountapprovalmessage:
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
                        '${getTranslatedForCurrentUser(context, 'xxcustomerxx').toUpperCase()} ${getTranslatedForCurrentUser(context, 'xxloginxx').toUpperCase()}'),
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
                              value: basicrAppSettings!.customerLoginEnabled!,
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
                                      bool switchvalue = basicrAppSettings!
                                              .customerLoginEnabled ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: basicrAppSettings!
                                              .copyWith(
                                                  customerLoginEnabled:
                                                      !switchvalue));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxxloginenabledxxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxxexistingwhohavecanloginxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),
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
                              value: basicrAppSettings!
                                  .customerRegistationEnabled!,
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
                                      bool switchvalue = basicrAppSettings!
                                              .customerRegistationEnabled ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: basicrAppSettings!
                                              .copyWith(
                                                  customerRegistationEnabled:
                                                      !switchvalue));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxxregenabledxxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxnewcancreateaccountxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),

                    basicrAppSettings!.agentRegistartionEnabled == false
                        ? SizedBox()
                        : customTile(
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
                                  value: basicrAppSettings!
                                      .customerVerificationNeeded!,
                                  borderRadius: 25.0,
                                  padding: 3.0,
                                  showOnOff: true,
                                  onToggle: AppConstants.isdemomode == true
                                      ? (val) {
                                          Utils.toast(
                                              getTranslatedForCurrentUser(
                                                  context,
                                                  'xxxnotalwddemoxxaccountxx'));
                                        }
                                      : (val) async {
                                          bool switchvalue = basicrAppSettings!
                                                  .customerVerificationNeeded ??
                                              false;
                                          await confirmchangeswitch(
                                              context: context,
                                              currentlbool: switchvalue,
                                              updatedmodel: basicrAppSettings!
                                                  .copyWith(
                                                      customerVerificationNeeded:
                                                          !switchvalue));
                                        }),
                            ),
                            title: getTranslatedForCurrentUser(
                                    context, 'xxxxverfrequiredxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                            subtitle: getTranslatedForCurrentUser(
                                    context, 'xxxxeverynewagentapprovalxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                            leadingicondata:
                                Icons.settings_applications_rounded),

                    SizedBox(
                      height: 20,
                    ),
                  ]));
  }
}
