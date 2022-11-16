import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/userapp_settings_model.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Widgets/Input_box.dart';
import 'package:thinkcreative_technologies/Widgets/custom_buttons.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Widgets/nodata_widget.dart';

class DemoUserIDs extends StatefulWidget {
  final String currentuserid;
  final DocumentReference docRef;
  DemoUserIDs({required this.docRef, required this.currentuserid});
  @override
  _DemoUserIDsState createState() => _DemoUserIDsState();
}

class _DemoUserIDsState extends State<DemoUserIDs> {
  bool isloading = true;

  TextEditingController _controller = new TextEditingController();
  final GlobalKey<State> _keyLoader =
      new GlobalKey<State>(debugLabel: '272dddhu1');

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  String error = "";
  UserAppSettingsModel? userAppSettings;

  fetchdata() async {
    await widget.docRef.get().then((dc) async {
      if (dc.exists) {
        userAppSettings = UserAppSettingsModel.fromSnapshot(dc);

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

  confirmchangeswitch({
    required BuildContext context,
    bool? currentlbool,
    String? toONmessage,
    String? toOFFmessage,
    required UserAppSettingsModel updatedmodel,
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
                await widget.docRef
                    .update(updatedmodel.toMap())
                    .then((value) async {
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

  String selectval = "Agent";
  fieldupdate(
      {required BuildContext context,
      required UserAppSettingsModel updatedmodel,
      p}) async {
    final session = Provider.of<CommonSession>(context, listen: false);
    Navigator.pop(context);
    ShowLoading().open(context: context, key: _keyLoader);
    await widget.docRef.update(updatedmodel.toMap()).then((value) async {
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
        title: "Demo User IDs",
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
                : ListView(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 15.0),
                          child: MtCustomfontRegular(
                            fontsize: 13,
                            text:
                                "Add already registered User ID of Agents / Customers for those who will be using the demo account with only Viewing rights from the User app.\n\nMulti- device login & Demo functionalities will be turned ON for these users.",
                          )),
                      Card(
                        elevation: 0.1,
                        margin: EdgeInsets.all(4),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              InpuTextBox(
                                controller: _controller,
                                title: "Agent / Customer ID",
                                hinttext: "Enter User ID",
                              ),
                              InputGroup4Large(
                                val4: 'Second Admin',
                                val3: 'Dept. manager',
                                title: 'User type',
                                val1: 'Agent',
                                val2: 'Customer',
                                selectedvalue: selectval,
                                onChanged: (val) async {
                                  setState(() {
                                    selectval = val.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MySimpleButton(
                          buttontext: "ADD TEST USER",
                          onpressed: () {
                            if (_controller.text.trim().length < 2) {
                              Utils.toast("Please enter user ID");
                            } else {
                              String userid = _controller.text.trim();
                              if (userAppSettings!.demoIDsList!.lastIndexWhere(
                                      (element) =>
                                          element['userid'] == userid) >=
                                  0) {
                                Utils.toast('Already exists !');
                              } else {
                                widget.docRef.update({
                                  Dbkeys.demoIDsList: FieldValue.arrayUnion([
                                    {'userid': userid, 'value': selectval}
                                  ]),
                                }).then((value) {
                                  Utils.toast("Added successfully !");
                                  fetchdata();
                                  setState(() {});
                                });
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: MtCustomfontBoldSemi(
                          text: "Demo Users List :",
                          fontsize: 16,
                        ),
                      ),
                      new Expanded(
                        child: userAppSettings!.demoIDsList!.length == 0
                            ? noDataWidget(
                                context: context, title: "No Demo users added")
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: userAppSettings!.demoIDsList!.length,
                                itemBuilder: (BuildContext context, int i) {
                                  var userMap = userAppSettings!
                                      .demoIDsList!.reversed
                                      .toList()[i];
                                  return Card(
                                    margin: EdgeInsets.all(7),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          MtCustomfontBoldSemi(
                                            text: "ID: " + userMap['userid'],
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          MtCustomfontBoldSemi(
                                            text: userMap['value'],
                                            color: userMap['value'] == "Agent"
                                                ? Mycolors.purple
                                                : userMap['value'] ==
                                                        "Dept. manager"
                                                    ? Mycolors.cyan
                                                    : userMap['value'] ==
                                                            "Second Admin"
                                                        ? Mycolors.green
                                                        : Mycolors.pink,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                widget.docRef.update({
                                                  Dbkeys.demoIDsList:
                                                      FieldValue.arrayRemove([
                                                    {
                                                      'userid':
                                                          userMap['userid'],
                                                      'value': userMap['value']
                                                    }
                                                  ]),
                                                }).then((value) {
                                                  Utils.toast(
                                                      "Removed successfully !");
                                                  fetchdata();
                                                  setState(() {});
                                                });
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.blueGrey,
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                      )
                    ],
                  ));
  }
}
