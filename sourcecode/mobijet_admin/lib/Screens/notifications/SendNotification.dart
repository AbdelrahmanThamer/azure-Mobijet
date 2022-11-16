import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/number_limits.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseApi.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseUploader.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Utils/delayed_function.dart';
import 'package:thinkcreative_technologies/Widgets/Input_box.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Utils/hide_keyboard.dart';

class SendNotification extends StatefulWidget {
  final String currentuserid;
  final String? userphone;
  final bool issendtosingleuser;
  final DocumentReference refdata;
  final String notificationid;
  final Function? optionalOnUpdateCallback;
  final String storagefoldername;
  SendNotification(
      {required this.issendtosingleuser,
      required this.currentuserid,
      required this.refdata,
      this.optionalOnUpdateCallback,
      required this.notificationid,
      required this.storagefoldername,
      this.userphone});
  @override
  _SendNotificationState createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  // DateTime todayDate;
  // TimeOfDay todayTime;
  // DateTime todaydatetimeoverall;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController tcmessage = new TextEditingController();
  GlobalKey<State> _keyLoader1 =
      new GlobalKey<State>(debugLabel: '48757577575');
  GlobalKey<State> _keyLoader2 =
      new GlobalKey<State>(debugLabel: '7474748488484');
  GlobalKey<State> _keyLoader3 =
      new GlobalKey<State>(debugLabel: '848848484884');
  GlobalKey<State> _keyLoader4 = new GlobalKey<State>(debugLabel: 'rjrjrjrrr');
  GlobalKey<State> _keyLoader5 =
      new GlobalKey<State>(debugLabel: 'nffjfjjfjjgg');

  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: '_hhh');
  bool isautovalidatemode = false;

// 22 page variables-------
  String? notificationtitle;
  String? notificationdesc;
  String? notificationbnrurl;
  @override
  void initState() {
    super.initState();
    widget.refdata.update({
      Dbkeys.nOTIFICATIONxxaction: Dbkeys.nOTIFICATIONactionNOPUSH,
      Dbkeys.nOTIFICATIONxxdesc: notificationdesc,
      Dbkeys.nOTIFICATIONxxtitle: notificationtitle,
      Dbkeys.nOTIFICATIONxxpageID: Dbkeys.pageIDAllNotifications,
      Dbkeys.nOTIFICATIONxxlastupdateepoch:
          DateTime.now().millisecondsSinceEpoch,
      Dbkeys.list: FieldValue.arrayUnion([
        {
          Dbkeys.nOTIFICATIONxxlastupdateepoch: widget.notificationid,
        }
      ])
    });
  }

  // ignore: missing_return
  Future<bool> _willPopCallback(BuildContext context) async {
    ShowConfirmDialog().open(
        context: context,
        rightbtnonpress: () async {
          Navigator.of(context).pop();
          await deleteIfPresent(context, widget.notificationid);
        });
    return false;
  }

  deleteIfPresent(BuildContext context, String docid) async {
    if (this.notificationbnrurl != null) {
      await FirebaseUploader()
          .deleteFile(
              context: context,
              scaffoldkey: _scaffoldKey,
              mykeyLoader: _keyLoader1,
              isDeleteUsingUrl: true,
              fileType: 'image',
              filename: widget.notificationid + '.png',
              url: notificationbnrurl,
              folder: widget.storagefoldername,
              collection: widget.storagefoldername)
          .then((isDeleted) {
        if (isDeleted == true) {
          setState(() {
            notificationbnrurl = null;
          });
        }
      });
    }

    await delayedFunction(
        setstatefn: () async {
          await FirebaseApi().runDELETEtransaction(
              isshowmsg: false,
              keyloader: _keyLoader5,
              isshowloader: true,
              scaffoldkey: _scaffoldKey,
              context: context,
              refdata: widget.refdata,
              compareKey: Dbkeys.nOTIFICATIONxxlastupdateepoch,
              isusesecondfn: true,
              compareVal: widget.notificationid,
              secondfn: () {
                Navigator.of(context).pop();
              });
        },
        durationmilliseconds: 100);
  }

  save(
    BuildContext context,
  ) {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      AppConstants.isdemomode == true
          ? Utils.toast(
              getTranslatedForCurrentUser(context, 'xxxnotalwddemoxxaccountxx'))
          : createInDatabase(context);
    } else {
      setState(() {
        isautovalidatemode = true;
      });
      ShowSnackbar().open(
        label:
            getTranslatedForCurrentUser(context, 'xxpleasefillrequiredinfoxx'),
        context: context,
        scaffoldKey: _scaffoldKey,
      );
    }
  }

  createInDatabase(context) async {
    hidekeyboard(context);
    ShowLoading().open(context: context, key: _keyLoader5);
    await FirebaseApi().runDELETEtransaction(
      isshowmsg: false,
      keyloader: _keyLoader5,
      scaffoldkey: _scaffoldKey,
      isshowloader: false,
      context: context,
      refdata: widget.refdata,
      compareKey: Dbkeys.nOTIFICATIONxxlastupdateepoch,
      isusesecondfn: false,
      compareVal: widget.notificationid,
    );

    await FirebaseApi.runTransactionSendNotification(
        docRef: widget.refdata,
        postedbyID: widget.currentuserid,
        context: context,
        isshowloader: false,
        title: notificationtitle!,
        imageurl: this.notificationbnrurl ?? "",
        plainDesc: notificationdesc!,
        parentid: Optionalconstants.currentAdminID,
        onErrorFn: (e) {
          ShowLoading().close(context: context, key: _keyLoader5);
          Utils.toast(
              "${getTranslatedForCurrentUser(context, 'xxfailedxx')} $e");
        },
        onSuccessFn: () {
          ShowLoading().close(context: context, key: _keyLoader5);
          Navigator.of(context).pop();
          widget.optionalOnUpdateCallback!();
        });
  }

  late BuildContext context;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return WillPopScope(
        // ignore: missing_return
        onWillPop: () => _willPopCallback(context),
        child: MyScaffold(
          scaffoldkey: _scaffoldKey,
          title: getTranslatedForCurrentUser(context, 'xxsendnewnotixx'),
          subtitle: '${getTranslatedForCurrentUser(context, 'xxidxx')} ' +
              widget.notificationid,
          leadingIconData: Icons.chevron_left,
          leadingIconPress: () {
            _willPopCallback(context);
          },
          icon1press: () {
            save(context);
          },
          icondata1: Icons.done,
          icondata2: Icons.close,
          icon2press: () {
            _willPopCallback(context);
          },
          body: ListView(children: [
            Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: InputBanner(
                        // iseditvisible: false,
                        boxwidth: w - 20,
                        placeholder: '900x465',
                        title: getTranslatedForCurrentUser(
                            context, 'xxxnotificationbnrxxx'),
                        photourl: notificationbnrurl,
                        uploadfn: AppConstants.isdemomode == true
                            ? (file, filetype, basename) {
                                Utils.toast(getTranslatedForCurrentUser(
                                    context, 'xxxnotalwddemoxxaccountxx'));
                              }
                            : (file, filetype, basename) async {
                                FirebaseUploader()
                                    .uploadFile(
                                        context: context,
                                        scaffoldkey: _scaffoldKey,
                                        keyLoader: _keyLoader1,
                                        file: file,
                                        fileType: 'image',
                                        filename:
                                            widget.notificationid + '.png',
                                        folder:
                                            widget.issendtosingleuser == true
                                                ? widget.userphone
                                                : widget.notificationid,
                                        collection: widget.storagefoldername)
                                    .then((value) {
                                  setState(() {
                                    notificationbnrurl = value;
                                  });
                                  hidekeyboard(context);
                                }).then((value) async {
                                  await FirebaseApi().runUPDATEtransaction(
                                      listreplaceablekey: Dbkeys.list,
                                      keyloader: _keyLoader2,
                                      scaffoldkey: _scaffoldKey,
                                      context: context,
                                      refdata: widget.refdata,
                                      isusesecondfn: false,
                                      compareKey:
                                          Dbkeys.nOTIFICATIONxxlastupdateepoch,
                                      compareVal: widget.notificationid,
                                      updatemap: {
                                        Dbkeys.nOTIFICATIONxximageurl:
                                            notificationbnrurl ?? ""
                                      });
                                });

                                //  upload(context,);
                              },
                        deletefn: () async {
                          await FirebaseUploader()
                              .deleteFile(
                                  context: context,
                                  scaffoldkey: _scaffoldKey,
                                  mykeyLoader: _keyLoader3,
                                  isDeleteUsingUrl: true,
                                  fileType: 'image',
                                  filename: widget.notificationid + '.png',
                                  url: notificationbnrurl,
                                  folder: widget.issendtosingleuser == true
                                      ? widget.userphone
                                      : widget.notificationid,
                                  collection: widget.storagefoldername)
                              .then((isDeleted) {
                            if (isDeleted == true) {
                              setState(() {
                                notificationbnrurl = null;
                              });
                            }
                            hidekeyboard(context);
                          }).then((value) async {
                            await FirebaseApi().runUPDATEtransaction(
                                listreplaceablekey: Dbkeys.list,
                                keyloader: _keyLoader4,
                                scaffoldkey: _scaffoldKey,
                                context: context,
                                refdata: widget.refdata,
                                isusesecondfn: false,
                                compareKey:
                                    Dbkeys.nOTIFICATIONxxlastupdateepoch,
                                compareVal: widget.notificationid,
                                updatemap: {
                                  Dbkeys.nOTIFICATIONxximageurl: "",
                                });
                          });
                        },
                      ),
                    ),
                    InpuTextBox(
                      title:
                          '${getTranslatedForCurrentUser(context, 'xxxnotificationxxx')} ${getTranslatedForCurrentUser(context, 'xxtitlexx')}',
                      hinttext:
                          getTranslatedForCurrentUser(context, 'xxmaxxxcharxx')
                              .replaceAll(
                                  '(####)', '${Numberlimits.maxtitledigits}'),
                      minLines: 3,
                      maxLines: 4,
                      autovalidate: isautovalidatemode,
                      keyboardtype: TextInputType.name,
                      inputFormatter: [],
                      onSaved: (val) {
                        notificationtitle = val;
                      },
                      isboldinput: true,
                      validator: (val) {
                        if (val!.trim().length < 1) {
                          return getTranslatedForCurrentUser(
                                  context, 'xxvalidxxxx')
                              .replaceAll('(####)',
                                  '${getTranslatedForCurrentUser(context, 'xxxnotificationxxx')} ${getTranslatedForCurrentUser(context, 'xxtitlexx')}');
                        } else if (val.trim().length >
                            Numberlimits.maxtitledigits) {
                          return getTranslatedForCurrentUser(
                                  context, 'xxmaxxxcharxx')
                              .replaceAll(
                                  '(####)', '${Numberlimits.maxtitledigits}');
                        }
                        return null;
                      },
                    ),
                    InpuTextBox(
                      title:
                          '${getTranslatedForCurrentUser(context, 'xxxnotificationxxx')} ${getTranslatedForCurrentUser(context, 'xxdescxx')}',
                      hinttext:
                          getTranslatedForCurrentUser(context, 'xxmaxxxcharxx')
                              .replaceAll(
                                  '(####)', '${Numberlimits.maxdescdigits}'),
                      minLines: 13,
                      maxLines: 22,
                      autovalidate: isautovalidatemode,
                      keyboardtype: TextInputType.name,
                      inputFormatter: [],
                      onSaved: (val) {
                        notificationdesc = val;
                      },
                      isboldinput: true,
                      validator: (val) {
                        if (val!.trim().length < 1) {
                          return getTranslatedForCurrentUser(
                                  context, 'xxvalidxxxx')
                              .replaceAll('(####)',
                                  '${getTranslatedForCurrentUser(context, 'xxxnotificationxxx')} ${getTranslatedForCurrentUser(context, 'xxdescxx')}');
                        } else if (val.trim().length >
                            Numberlimits.maxdescdigits) {
                          return getTranslatedForCurrentUser(
                                  context, 'xxmaxxxcharxx')
                              .replaceAll(
                                  '(####)', '${Numberlimits.maxdescdigits}');
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                )),
          ]),
        ));
  }
}
