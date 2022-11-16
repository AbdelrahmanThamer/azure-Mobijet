import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/basic_settings_model_userapp.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseUploader.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Utils/delayed_function.dart';
import 'package:thinkcreative_technologies/Utils/hide_keyboard.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Widgets/Input_box.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/FormDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/headers/sectionheaders.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Utils/custom_tiles.dart';
import 'package:thinkcreative_technologies/Widgets/pdf_view_cached.dart';

class TermsPrivacySettings extends StatefulWidget {
  final String currentuserid;
  final DocumentReference docRef;
  TermsPrivacySettings({required this.docRef, required this.currentuserid});
  @override
  _TermsPrivacySettingsState createState() => _TermsPrivacySettingsState();
}

class _TermsPrivacySettingsState extends State<TermsPrivacySettings> {
  bool isloading = true;

  TextEditingController _controller = new TextEditingController();
  final GlobalKey<State> _keyLoader =
      new GlobalKey<State>(debugLabel: '272hu1');
  final GlobalKey<State> _keyLoader2 =
      new GlobalKey<State>(debugLabel: '272hu2');
  final GlobalKey<State> _keyLoader4 =
      new GlobalKey<State>(debugLabel: '272hu4');

  String tncFileName = "terms_conditions.pdf";
  String ppFileName = "privacy_policy.pdf";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  String error = "";
  BasicSettingModelUserApp? userAppSettings;

  Future setEncoded(BasicSettingModelUserApp settingsmodel) async {
    String str = json.encode(settingsmodel.toMap());
    String encoded = base64.encode(utf8.encode("$str"));
    await widget.docRef.set({"f9846v": encoded}, SetOptions(merge: true));
    userAppSettings = settingsmodel;
    setState(() {});

    ShowSnackbar().open(
        context: context,
        scaffoldKey: _scaffoldKey,
        time: 4,
        label: getTranslatedForCurrentUser(context, 'xxsuccessvalueupdatedxx'),
        status: 2);
  }

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
            "${getTranslatedForCurrentUser(context, 'xxuserappsetupincompletexx')}. ${onError.toString()}";

        isloading = false;
      });
    });
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
    var w = MediaQuery.of(context).size.width;
    return MyScaffold(
        scaffoldkey: _scaffoldKey,
        titlespacing: 0,
        title: getTranslatedForCurrentUser(context, 'xxxtermsandpolicy'),
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
//**---  TnC  controls
                    sectionHeader(
                        getTranslatedForCurrentUser(context, 'xxtncxx')
                            .toUpperCase()),
                    InputGroup2large(
                      title: getTranslatedForCurrentUser(
                          context, 'xxxcontenttypexxx'),
                      val1: Dbkeys.file,
                      val2: Dbkeys.url,
                      selectedvalue: userAppSettings!.tncTYPE,
                      onChanged: AppConstants.isdemomode == true
                          ? (val) {
                              Utils.toast(getTranslatedForCurrentUser(
                                  context, 'xxxnotalwddemoxxaccountxx'));
                            }
                          : (val) async {
                              if (userAppSettings!.tncTYPE == Dbkeys.file &&
                                  userAppSettings!.tnc != "") {
                                ShowSnackbar().open(
                                    context: context,
                                    scaffoldKey: _scaffoldKey,
                                    time: 4,
                                    label: getTranslatedForCurrentUser(
                                        context, 'xxxplsdltfilexxx'),
                                    status: 0);
                              } else if (userAppSettings!.tncTYPE ==
                                  Dbkeys.url) {
                                setState(() {
                                  userAppSettings = userAppSettings!.copyWith(
                                    tncTYPE: val,
                                    tnc: "",
                                  );
                                });
                                await setEncoded(userAppSettings!);
                              } else {
                                setState(() {
                                  userAppSettings = userAppSettings!
                                      .copyWith(tncTYPE: val, tnc: "");
                                });
                                await setEncoded(userAppSettings!);
                              }
                            },
                    ),

                    userAppSettings!.tncTYPE == Dbkeys.file
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InputPDFFile(
                                // iseditvisible: false,
                                boxwidth: w,
                                iseditvisible: false,
                                // placeholder: '1024x465',
                                title: ' File',
                                filename: tncFileName,
                                fileurl: userAppSettings!.tnc!,
                                uploadfn: AppConstants.isdemomode == true
                                    ? (file, filetype, basename) {
                                        Utils.toast(getTranslatedForCurrentUser(
                                            context,
                                            'xxxnotalwddemoxxaccountxx'));
                                      }
                                    : (file, filetype, basename) async {
                                        FirebaseUploader()
                                            .uploadFile(
                                          context: context,
                                          scaffoldkey: _scaffoldKey,
                                          keyLoader: _keyLoader2,
                                          file: file,
                                          fileType: 'pdf',
                                          filename: file.path
                                              .split('/')
                                              .last
                                              .toString(),
                                          folder: "TNC",
                                          collection:
                                              DbStoragePaths.appDATACommon,
                                        )
                                            .then((value) {
                                          userAppSettings = userAppSettings!
                                              .copyWith(tnc: value);
                                        }).then((value) async {
                                          await setEncoded(userAppSettings!);
                                          setState(() {});
                                          hidekeyboard(context);
                                        });
                                      },
                                deletefn: AppConstants.isdemomode == true
                                    ? () {
                                        Utils.toast(getTranslatedForCurrentUser(
                                            context,
                                            'xxxnotalwddemoxxaccountxx'));
                                      }
                                    : () async {
                                        await FirebaseUploader()
                                            .deleteFile(
                                          context: context,
                                          scaffoldkey: _scaffoldKey,
                                          mykeyLoader: _keyLoader4,
                                          isDeleteUsingUrl: true,
                                          fileType: 'pdf',
                                          filename: this.tncFileName,
                                          url: userAppSettings!.tnc,
                                        )
                                            .then((isDeleted) {
                                          if (isDeleted == true) {
                                            userAppSettings =
                                                userAppSettings!.copyWith(
                                              tnc: "",
                                            );
                                          }
                                        }).then((value) async {
                                          userAppSettings = userAppSettings!
                                              .copyWith(
                                                  tnc: "", tncTYPE: Dbkeys.url);

                                          await setEncoded(userAppSettings!);

                                          hidekeyboard(context);
                                        });
                                      },
                              ),
                              userAppSettings!.tnc! != "" &&
                                      userAppSettings!.tncTYPE == Dbkeys.file
                                  ? InkWell(
                                      onTap: () {
                                        pageNavigator(
                                            context,
                                            PDFViewerCachedFromUrl(
                                                url: userAppSettings!.tnc!,
                                                title: tncFileName));
                                      },
                                      child: Chip(
                                        label: Text(
                                          getTranslatedForCurrentUser(
                                              context, 'xxpreviewxx'),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Mycolors.green,
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          )
                        : userAppSettings!.tncTYPE == Dbkeys.url
                            ? customTile(
                                margin: 5,
                                iconsize: 30,
                                trailingicondata: Icons.edit_outlined,
                                title:
                                    '${getTranslatedForCurrentUser(context, 'xxtncxx')} URL',
                                subtitle: userAppSettings!.tnc == ""
                                    ? getTranslatedForCurrentUser(
                                        context, 'xxxpasteurlherexxx')
                                    : userAppSettings!.tnc,
                                leadingicondata:
                                    Icons.settings_applications_rounded,
                                ontap: () {
                                  _controller.text = userAppSettings!.tnc!;
                                  ShowFormDialog().open(
                                      iscapital: false,
                                      controller: _controller,
                                      maxlength: 500,
                                      maxlines: 5,
                                      minlines: 4,
                                      iscentrealign: true,
                                      context: context,
                                      title:
                                          '${getTranslatedForCurrentUser(context, 'xxtncxx')} URL',
                                      onpressed: AppConstants.isdemomode == true
                                          ? () {
                                              Utils.toast(
                                                  getTranslatedForCurrentUser(
                                                      context,
                                                      'xxxnotalwddemoxxaccountxx'));
                                            }
                                          : () async {
                                              if (_controller.text
                                                      .trim()
                                                      .length <
                                                  5) {
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
                                                Navigator.of(context).pop();
                                                userAppSettings =
                                                    userAppSettings!.copyWith(
                                                        tnc: _controller.text
                                                            .trim(),
                                                        tncTYPE: Dbkeys.url);
                                                await setEncoded(
                                                    userAppSettings!);
                                                setState(() {});
                                              }
                                            },
                                      buttontext: getTranslatedForCurrentUser(
                                          context, 'xxupdatexx'),
                                      hinttext: getTranslatedForCurrentUser(
                                          context, 'xxxenterurlxxx'));
                                })
                            : SizedBox(),
                    SizedBox(
                      height: 40,
                    ),
//**---  PP  controls
                    sectionHeader(getTranslatedForCurrentUser(context, 'xxppxx')
                        .toUpperCase()),
                    InputGroup2large(
                      title: getTranslatedForCurrentUser(
                          context, 'xxxcontenttypexxx'),
                      val1: Dbkeys.file,
                      val2: Dbkeys.url,
                      selectedvalue: userAppSettings!.privacypolicyTYPE,
                      onChanged: AppConstants.isdemomode == true
                          ? (val) {
                              Utils.toast(getTranslatedForCurrentUser(
                                  context, 'xxxnotalwddemoxxaccountxx'));
                            }
                          : (val) async {
                              if (userAppSettings!.privacypolicyTYPE ==
                                      Dbkeys.file &&
                                  userAppSettings!.privacypolicy != "") {
                                ShowSnackbar().open(
                                    context: context,
                                    scaffoldKey: _scaffoldKey,
                                    time: 4,
                                    label: getTranslatedForCurrentUser(
                                        context, 'xxxplsdltfilexxx'),
                                    status: 0);
                              } else if (userAppSettings!.privacypolicyTYPE ==
                                  Dbkeys.url) {
                                setState(() {
                                  userAppSettings = userAppSettings!.copyWith(
                                      privacypolicyTYPE: val,
                                      privacypolicy: "");
                                });
                                await setEncoded(userAppSettings!);
                              } else {
                                setState(() {
                                  userAppSettings = userAppSettings!.copyWith(
                                      privacypolicyTYPE: val,
                                      privacypolicy: "");
                                });
                                await setEncoded(userAppSettings!);
                              }
                            },
                    ),

                    userAppSettings!.privacypolicyTYPE == Dbkeys.file
                        ? Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InputPDFFile(
                                // iseditvisible: false,
                                boxwidth: w,
                                iseditvisible: false,
                                // placeholder: '1024x465',
                                title: ' File',
                                filename: ppFileName,
                                fileurl: userAppSettings!.privacypolicy!,
                                uploadfn: AppConstants.isdemomode == true
                                    ? (file, filetype, basename) {
                                        Utils.toast(getTranslatedForCurrentUser(
                                            context,
                                            'xxxnotalwddemoxxaccountxx'));
                                      }
                                    : (file, filetype, basename) async {
                                        FirebaseUploader()
                                            .uploadFile(
                                          context: context,
                                          scaffoldkey: _scaffoldKey,
                                          keyLoader: _keyLoader2,
                                          file: file,
                                          fileType: 'pdf',
                                          filename: file.path
                                              .split('/')
                                              .last
                                              .toString(),
                                          folder: "PP",
                                          collection:
                                              DbStoragePaths.appDATACommon,
                                        )
                                            .then((value) {
                                          userAppSettings = userAppSettings!
                                              .copyWith(privacypolicy: value);
                                        }).then((value) async {
                                          await setEncoded(userAppSettings!);
                                          setState(() {});
                                          hidekeyboard(context);
                                        });
                                      },
                                deletefn: AppConstants.isdemomode == true
                                    ? () {
                                        Utils.toast(getTranslatedForCurrentUser(
                                            context,
                                            'xxxnotalwddemoxxaccountxx'));
                                      }
                                    : () async {
                                        await FirebaseUploader()
                                            .deleteFile(
                                                context: context,
                                                scaffoldkey: _scaffoldKey,
                                                mykeyLoader: _keyLoader4,
                                                isDeleteUsingUrl: true,
                                                fileType: 'pdf',
                                                filename: this.ppFileName,
                                                url: userAppSettings!
                                                    .privacypolicy)
                                            .then((isDeleted) {
                                          if (isDeleted == true) {
                                            userAppSettings =
                                                userAppSettings!.copyWith(
                                              privacypolicy: "",
                                            );
                                          }
                                        }).then((value) async {
                                          userAppSettings = userAppSettings!
                                              .copyWith(
                                                  privacypolicy: "",
                                                  privacypolicyTYPE:
                                                      Dbkeys.url);

                                          await setEncoded(userAppSettings!);

                                          hidekeyboard(context);
                                        });
                                      },
                              ),
                              userAppSettings!.privacypolicy! != "" &&
                                      userAppSettings!.privacypolicyTYPE ==
                                          Dbkeys.file
                                  ? InkWell(
                                      onTap: () {
                                        pageNavigator(
                                            context,
                                            PDFViewerCachedFromUrl(
                                                url: userAppSettings!
                                                    .privacypolicy!,
                                                title: ppFileName));
                                      },
                                      child: Chip(
                                        label: Text(
                                          getTranslatedForCurrentUser(
                                              context, 'xxpreviewxx'),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Mycolors.green,
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          )
                        : userAppSettings!.privacypolicyTYPE == Dbkeys.url
                            ? customTile(
                                margin: 5,
                                iconsize: 30,
                                trailingicondata: Icons.edit_outlined,
                                title:
                                    '${getTranslatedForCurrentUser(context, 'xxppxx')} URL',
                                subtitle: userAppSettings!.privacypolicy == ""
                                    ? getTranslatedForCurrentUser(
                                        context, 'xxxpasteurlherexxx')
                                    : userAppSettings!.privacypolicy,
                                leadingicondata:
                                    Icons.settings_applications_rounded,
                                ontap: () {
                                  _controller.text =
                                      userAppSettings!.privacypolicy!;
                                  ShowFormDialog().open(
                                      iscapital: false,
                                      controller: _controller,
                                      maxlength: 500,
                                      maxlines: 5,
                                      minlines: 4,
                                      iscentrealign: true,
                                      context: context,
                                      title:
                                          '${getTranslatedForCurrentUser(context, 'xxppxx')} URL',
                                      onpressed: AppConstants.isdemomode == true
                                          ? () {
                                              Utils.toast(
                                                  getTranslatedForCurrentUser(
                                                      context,
                                                      'xxxnotalwddemoxxaccountxx'));
                                            }
                                          : () async {
                                              if (_controller.text
                                                      .trim()
                                                      .length <
                                                  5) {
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
                                                Navigator.of(context).pop();
                                                userAppSettings =
                                                    userAppSettings!.copyWith(
                                                        privacypolicy:
                                                            _controller.text
                                                                .trim(),
                                                        privacypolicyTYPE:
                                                            Dbkeys.url);
                                                await setEncoded(
                                                    userAppSettings!);
                                                setState(() {});
                                              }
                                            },
                                      buttontext: getTranslatedForCurrentUser(
                                          context, 'xxupdatexx'),
                                      hinttext: getTranslatedForCurrentUser(
                                          context, 'xxxenterurlxxx'));
                                })
                            : SizedBox(),

                    SizedBox(
                      height: 60,
                    ),
                  ]));
  }
}
