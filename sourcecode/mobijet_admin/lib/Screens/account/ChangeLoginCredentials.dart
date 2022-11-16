import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/number_limits.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:flutter/services.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseUploader.dart';
import 'package:thinkcreative_technologies/Widgets/Input_box.dart';
import 'package:thinkcreative_technologies/Widgets/double_tap_back.dart';
import 'package:thinkcreative_technologies/Utils/hide_keyboard.dart';

class ChangeLoginCredentials extends StatefulWidget {
  final Function? callbackOnUpdate;
  final String? currentdeviceid;
  final bool isFirstTime;

  ChangeLoginCredentials(
      {this.callbackOnUpdate, this.currentdeviceid, required this.isFirstTime});
  @override
  _ChangeLoginCredentialsState createState() => _ChangeLoginCredentialsState();
}

class _ChangeLoginCredentialsState extends State<ChangeLoginCredentials> {
  String? fullname;

  String? pin;
  String? mobile;
  String? email;
  String? photourl;
  String? phonecode;
  String? phonenumber;
  String? country;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController tcmessage = new TextEditingController();
  TextEditingController tcfullname = new TextEditingController();
  TextEditingController tcpin = new TextEditingController();

  GlobalKey<State> _keyLoader = new GlobalKey<State>(debugLabel: '733ss883833');

  GlobalKey<State> _keyLoader5 =
      new GlobalKey<State>(debugLabel: 'nffjfjjfjssjgg');
  GlobalKey<State> _keyLoader6 =
      new GlobalKey<State>(debugLabel: 'ffjfjfjfssjfnn');
  GlobalKey<State> _keyLoader7 =
      new GlobalKey<State>(debugLabel: 'jud8dissrrr');
  GlobalKey<State> _keyLoader8 =
      new GlobalKey<State>(debugLabel: 'jjjdjjssdjjd8d');

  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: '_hhh');

  late BuildContext context;
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    if (widget.isFirstTime == true) {
      setState(() {
        isloading = false;
      });
    } else {
      fetchfromdatabase();
    }
  }

  String deviceid = "";
  fetchfromdatabase() async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    await FirebaseFirestore.instance
        .collection(DbPaths.adminapp)
        .doc(DbPaths.admincred)
        .get()
        .then((doc) {
      deviceid = doc[Dbkeys.admindeviceid];
      fullname = doc[Dbkeys.adminfullname];
      pin = doc[Dbkeys.adminpin] == ""
          ? ""
          : stringToBase64.decode(doc[Dbkeys.adminpin]).toString();
      photourl = doc[Dbkeys.adminphotourl];
      tcfullname.text = doc[Dbkeys.adminfullname];
      tcpin.text = doc[Dbkeys.adminpin] == ""
          ? ""
          : stringToBase64.decode(doc[Dbkeys.adminpin]).toString();

      setState(() {
        isloading = false;
      });
    });
  }

  save(BuildContext context) {
    final session = Provider.of<CommonSession>(context, listen: false);
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      if (pin == "123456" || pin == "654321" || pin == "000000") {
        ShowSnackbar().open(
            context: context,
            scaffoldKey: _scaffoldKey,
            label:
                getTranslatedForCurrentUser(context, 'xxxpleaseusediffpinxxx'),
            status: 0,
            time: 2);
      } else {
        ShowLoading().open(context: context, key: _keyLoader);
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String encoded = stringToBase64.encode(pin!).toString();
        FirebaseFirestore.instance
            .collection(DbPaths.adminapp)
            .doc(DbPaths.admincred)
            .update({
          Dbkeys.admindeviceid: widget.currentdeviceid ?? deviceid,
          Dbkeys.adminpin: encoded,
          Dbkeys.adminfullname: fullname,
          Dbkeys.adminloginhistory: FieldValue.arrayUnion([
            {
              Dbkeys.adminlogineventsTIME:
                  DateTime.now().millisecondsSinceEpoch,
              Dbkeys.adminlogineventsTITLE:
                  Dbkeys.adminlogineventsTITLEcredchange,
              Dbkeys.adminlogineventsDESC:
                  'Admin login credentials changed by admin',
              Dbkeys.admindeviceid: widget.currentdeviceid ?? deviceid,
            }
          ]),
        }).then((value) async {
          ShowLoading().close(context: context, key: _keyLoader);
          session.setData(
            newfullname: fullname,
            newphotourl: photourl,
          );
          if (widget.callbackOnUpdate == null) {
            Navigator.of(context).pop();
          } else if (widget.callbackOnUpdate != null) {
            widget.callbackOnUpdate!();
          }
        }).catchError((err) async {
          final session = Provider.of<CommonSession>(context, listen: false);
          final observer = Provider.of<Observer>(context, listen: false);
          ShowLoading().close(context: context, key: _keyLoader);

          ShowCustomAlertDialog().open(
            context: context,
            errorlog: err.toString(),
            isshowerrorlog: observer.isshowerrorlog,
            dialogtype: 'error',
          );
          await session.createalert(
              alertmsgforuser: null,
              context: context,
              alertcollection: DbPaths.collectionALLNORMALalerts,
              alerttime: DateTime.now().millisecondsSinceEpoch,
              alerttitle: 'Admin credentials Change failed',
              alertdesc:
                  'Admin Login credentials cannot be changed. Check the admin credentials and help verify securily.\n[CAPTURED ERROR:$err]');
        });
      }
    } else {
      ShowSnackbar().open(
          context: context,
          scaffoldKey: _scaffoldKey,
          label: getTranslatedForCurrentUser(
              context, 'xxpleasefillrequiredinfoxx'),
          status: 0,
          time: 2);
    }
  }

  Future<bool> back() {
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return WillPopScope(
        // ignore: missing_return
        onWillPop: widget.isFirstTime == true ? doubleTapTrigger : back,
        child: MyScaffold(
          isforcehideback: true,
          scaffoldkey: _scaffoldKey,
          title: getTranslatedForCurrentUser(context, 'xxxchangelogincredxxx'),
          icon1press: isloading == true
              ? null
              : () {
                  save(context);
                },
          icondata1: Icons.done,
          body: isloading == true
              ? circularProgress()
              : ListView(children: [
                  Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          widget.isFirstTime == true
                              ? SizedBox()
                              : Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 0, 12, 0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InputSquarePicture(
                                          iscontain: true,
                                          placeholder: '200x200',
                                          boxwidth: w / 2,
                                          title: getTranslatedForCurrentUser(
                                              context, 'xxxadminprofilepicxxx'),
                                          photourl:
                                              photourl == "" ? null : photourl,
                                          uploadfn:
                                              (file, filetype, basename) async {
                                            FirebaseUploader()
                                                .uploadFile(
                                                    context: context,
                                                    scaffoldkey: _scaffoldKey,
                                                    keyLoader: _keyLoader5,
                                                    file: file,
                                                    fileType: 'image',
                                                    filename:
                                                        'admin_cover' + '.png',
                                                    folder: DbStoragePaths
                                                        .adminFolder,
                                                    collection: DbStoragePaths
                                                        .adminCollection)
                                                .then((value) {
                                              setState(() {
                                                photourl = value;
                                              });
                                            }).then((value) async {
                                              await firestoreupdatedoc(
                                                  context: context,
                                                  scaffoldkey: _scaffoldKey,
                                                  keyloader: _keyLoader6,
                                                  collection: DbPaths.adminapp,
                                                  document: DbPaths.admincred,
                                                  updatemap: {
                                                    Dbkeys.adminphotourl:
                                                        photourl ?? "",
                                                  });
                                              hidekeyboard(context);
                                            });
                                          },
                                          deletefn: () {
                                            FirebaseUploader()
                                                .deleteFile(
                                                    context: context,
                                                    scaffoldkey: _scaffoldKey,
                                                    isDeleteUsingUrl: true,
                                                    mykeyLoader: _keyLoader7,
                                                    fileType: 'image',
                                                    filename:
                                                        'admin_cover' + '.png',
                                                    folder: DbStoragePaths
                                                        .adminFolder,
                                                    collection: DbStoragePaths
                                                        .adminCollection)
                                                .then((isDeleted) {
                                              if (isDeleted == true) {
                                                setState(() {
                                                  photourl = null;
                                                });
                                              }
                                            }).then((value) async {
                                              await firestoreupdatedoc(
                                                  context: context,
                                                  scaffoldkey: _scaffoldKey,
                                                  keyloader: _keyLoader8,
                                                  collection: DbPaths.adminapp,
                                                  document: DbPaths.admincred,
                                                  updatemap: {
                                                    Dbkeys.adminphotourl: "",
                                                  });
                                              hidekeyboard(context);
                                            });
                                          },
                                        ),
                                      ]),
                                ),
                          InpuTextBox(
                            title: getTranslatedForCurrentUser(
                                context, 'xxxadminfullnamecxxx'),
                            hinttext: getTranslatedForCurrentUser(
                                context, 'xxenterfullnamexx'),
                            autovalidate: true,
                            controller: tcfullname,
                            keyboardtype: TextInputType.name,
                            inputFormatter: [
                              LengthLimitingTextInputFormatter(
                                  Numberlimits.adminfullname),
                            ],
                            onSaved: (val) {
                              fullname = val;
                            },
                            isboldinput: true,
                            validator: (val) {
                              if (val!.trim().length < 1) {
                                return getTranslatedForCurrentUser(
                                    context, 'xxenterfullnamexx');
                              } else if (val.trim().length >
                                  Numberlimits.adminfullname) {
                                return getTranslatedForCurrentUser(
                                        context, 'xxmaxxxcharxx')
                                    .replaceAll('(####)',
                                        '${Numberlimits.adminfullname}');
                              } else {
                                return null;
                              }
                            },
                          ),
                          InpuTextBox(
                            obscuretext: true,
                            title: getTranslatedForCurrentUser(
                                context, 'xxxsecuritypinxxx'),
                            hinttext: getTranslatedForCurrentUser(
                                context, 'xxxenter6dpinxxx'),
                            autovalidate: true,
                            keyboardtype: TextInputType.number,
                            controller: tcpin,
                            inputFormatter: [
                              LengthLimitingTextInputFormatter(
                                  Numberlimits.adminpin),
                              FilteringTextInputFormatter.allow(
                                RegExp("[0-9]"),
                              ),
                            ],
                            onSaved: (val) {
                              pin = val;
                            },
                            isboldinput: true,
                            validator: (val) {
                              if (val!.trim().length < 1) {
                                return getTranslatedForCurrentUser(
                                    context, 'xxxkeeppinxxx');
                              } else if (val.trim().length !=
                                  Numberlimits.adminpin) {
                                return getTranslatedForCurrentUser(
                                    context, 'xxxenter6dpinxxx');
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      )),
                ]),
        ));
  }
}
