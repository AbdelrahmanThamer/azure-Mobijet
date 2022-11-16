import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/userapp_settings_model.dart';
import 'package:thinkcreative_technologies/Screens/settings/department/all_departments_list.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/Input_box.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Utils/delayed_function.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/FormDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/headers/sectionheaders.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Utils/custom_tiles.dart';

class TicketSettings extends StatefulWidget {
  final String currentuserid;
  final DocumentReference docRef;
  TicketSettings({required this.docRef, required this.currentuserid});
  @override
  _TicketSettingsState createState() => _TicketSettingsState();
}

class _TicketSettingsState extends State<TicketSettings> {
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

    final observer = Provider.of<Observer>(context, listen: false);
    observer.fetchUserAppSettings(context);
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
        title:
            "${getTranslatedForCurrentUser(context, 'xxsupporttktxx')} ${getTranslatedForCurrentUser(context, 'xxxsettingsxxx')}",
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
                        getTranslatedForCurrentUser(context, 'xxsupporttktxx')
                            .toUpperCase()),
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
                              value: userAppSettings!.autocreatesupportticket ??
                                  false,
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
                                              .autocreatesupportticket ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              autocreatesupportticket:
                                                  !switchvalue,
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Support Ticket Settings updated",
                                              notificationdesc:
                                                  "autoCreateSupportTicket - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxxautocreateticketxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxautocreatenewtktxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxsupporttktxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),
                    userAppSettings!.autocreatesupportticket == false
                        ? SizedBox()
                        : customTile(
                            ishighlightdesc: true,
                            margin: 5,
                            iconsize: 30,
                            trailingicondata: Icons.edit_outlined,
                            title: getTranslatedForCurrentUser(
                                    context, 'xxxxdefaulttitlexxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxsupporttktxx')}'),
                            subtitle:
                                userAppSettings!.defaultTopicsOnLoginName!,
                            leadingicondata:
                                Icons.settings_applications_rounded,
                            ontap: () {
                              _controller.text =
                                  userAppSettings!.defaultTopicsOnLoginName!;
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
                                        context, 'xxxxdefaulttitlexxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxsupporttktxx')}'),
                                onpressed: AppConstants.isdemomode == true
                                    ? () {
                                        Utils.toast(getTranslatedForCurrentUser(
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
                                                    context, 'xxvalidxxxx')
                                                .replaceAll('(####)',
                                                    '${getTranslatedForCurrentUser(context, 'xxtitlexx')}'),
                                          );
                                          delayedFunction(setstatefn: () {
                                            ShowSnackbar().close(
                                              context: context,
                                              scaffoldKey: _scaffoldKey,
                                            );
                                          });
                                        } else {
                                          await fieldupdate(
                                              context: context,
                                              updatedmodel: userAppSettings!.copyWith(
                                                  defaultTopicsOnLoginName:
                                                      _controller.text.trim(),
                                                  notifcationpostedby:
                                                      widget.currentuserid,
                                                  notificationtime: DateTime
                                                          .now()
                                                      .millisecondsSinceEpoch,
                                                  notificationtitle:
                                                      "Ticket Settings updated",
                                                  notificationdesc:
                                                      "defaultTopicsOnLoginName - is set to ${_controller.text.trim()}"));
                                        }
                                      },
                                buttontext: getTranslatedForCurrentUser(
                                    context, 'xxupdatexx'),
                              );
                            }),
                    //* -------------------------------

                    userAppSettings!.departmentBasedContent == false
                        ? SizedBox()
                        : sectionHeader(
                            '${getTranslatedForCurrentUser(context, 'xxdepartmentsxx').toUpperCase()}'),

                    userAppSettings!.departmentBasedContent == false
                        ? SizedBox()
                        : customTile(
                            margin: 5,
                            iconsize: 30,
                            trailingicondata:
                                Icons.keyboard_arrow_right_outlined,
                            title:
                                '${getTranslatedForCurrentUser(context, 'xxtktssxx')} ${getTranslatedForCurrentUser(context, 'xxdepartmentsxx')}',
                            subtitle: Optionalconstants
                                        .isEditDefaultDepartment ==
                                    false
                                ? userAppSettings!.departmentList!.length < 2
                                    ? "0 ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}"
                                    : (userAppSettings!.departmentList!.length -
                                                1)
                                            .toString() +
                                        " ${getTranslatedForCurrentUser(context, 'xxdepartmentsxx')}"
                                : userAppSettings!.departmentList!.length < 1
                                    ? "0 ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}"
                                    : userAppSettings!.departmentList!.length
                                            .toString() +
                                        " ${getTranslatedForCurrentUser(context, 'xxdepartmentsxx')}",
                            leadingicondata:
                                Icons.settings_applications_rounded,
                            ontap: () {
                              pageNavigator(
                                  context,
                                  AllDepartmentList(
                                    isShowForSignleAgent: false,
                                    filteragentid: "",
                                    onbackpressed: () {
                                      fetchdata();
                                    },
                                    currentuserid: widget.currentuserid,
                                  ));
                            }),

                    //* -------------------------------

                    sectionHeader(
                        getTranslatedForCurrentUser(context, 'xxsecondadminxx')
                            .toUpperCase()),

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
                                  userAppSettings!.secondadminCanCreateTicket ??
                                      false,
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
                                              .secondadminCanCreateTicket ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              secondadminCanCreateTicket:
                                                  !switchvalue,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Support Ticket Settings updated",
                                              notificationdesc:
                                                  "SecondAdminCanCreateTicket - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcancreatexxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxcancreateforxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')}')
                            .replaceAll('(##)',
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
                              value: userAppSettings!
                                      .secondadminCanChangeTicketStatus ??
                                  false,
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
                                              .secondadminCanChangeTicketStatus ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              secondadminCanChangeTicketStatus:
                                                  !switchvalue,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Support Ticket Settings updated",
                                              notificationdesc:
                                                  "secondAdminCanChangeTicketStatus - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcanchangexxstatusxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
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
                              value: userAppSettings!.isCallAssigningAllowed ??
                                  false,
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
                                              .isCallAssigningAllowed ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              isCallAssigningAllowed:
                                                  !switchvalue,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Support Ticket Settings updated",
                                              notificationdesc:
                                                  "isCallAssigningAllowed - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                            context, 'xxxcallassigningallowedxxx'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxcanassigncallxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),

                    userAppSettings!.isCallAssigningAllowed == false
                        ? SizedBox()
                        : Card(
                            elevation: 0.1,
                            margin: EdgeInsets.all(4),
                            child: InputGroup3small(
                              title: getTranslatedForCurrentUser(
                                  context, 'xxxallowedcalltypexxx'),
                              val1: CallType.audio.index.toString(),
                              val1String: getTranslatedForCurrentUser(
                                  context, 'xxaudioxx'),
                              val2: CallType.video.index.toString(),
                              val2String: getTranslatedForCurrentUser(
                                  context, 'xxvideoxx'),
                              val3: CallType.both.index.toString(),
                              val3String:
                                  "${getTranslatedForCurrentUser(context, 'xxaudioxx')}, ${getTranslatedForCurrentUser(context, 'xxvideoxx')}",
                              selectedvalue: userAppSettings!
                                  .callTypeForTicketChatRoom
                                  .toString(),
                              onChanged: AppConstants.isdemomode == true
                                  ? (val) {
                                      Utils.toast(getTranslatedForCurrentUser(
                                          context,
                                          'xxxnotalwddemoxxaccountxx'));
                                    }
                                  : (val) async {
                                      userAppSettings = userAppSettings!.copyWith(
                                          callTypeForTicketChatRoom:
                                              int.tryParse(val!),
                                          notifcationpostedby:
                                              widget.currentuserid,
                                          notificationtime: DateTime.now()
                                              .millisecondsSinceEpoch,
                                          notificationtitle:
                                              "Ticket Settings updated",
                                          notificationdesc:
                                              "callTypeForTicketChatRoom - is set to ${Utils.getCallValueText(int.tryParse(val)!)}");
                                      await widget.docRef
                                          .update(userAppSettings!.toMap())
                                          .then((value) {
                                        setState(() {});
                                        ShowSnackbar().open(
                                            context: context,
                                            scaffoldKey: _scaffoldKey,
                                            status: 2,
                                            time: 2,
                                            label: getTranslatedForCurrentUser(
                                                context,
                                                'xxsuccessvalueupdatedxx'));
                                      });
                                    },
                            ),
                          ),
                    //* -------------------------------

                    sectionHeader(
                        getTranslatedForCurrentUser(context, 'xxagentsxx')
                            .toUpperCase()),
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
                              value: userAppSettings!.agentCanCreateTicket ??
                                  false,
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
                                              .agentCanCreateTicket ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              agentCanCreateTicket:
                                                  !switchvalue,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Support Ticket Settings updated",
                                              notificationdesc:
                                                  "agentCancreateTicket - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcancreatexxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxtktssxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxcancreateforxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')}')
                            .replaceAll('(##)',
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
                              value:
                                  userAppSettings!.agentCanChangeTicketStatus ??
                                      false,
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
                                              .agentCanChangeTicketStatus ??
                                          false;
                                      await confirmchangeswitch(
                                        context: context,
                                        currentlbool: switchvalue,
                                        updatedmodel: userAppSettings!.copyWith(
                                            agentCanChangeTicketStatus:
                                                !switchvalue,
                                            notificationtime: DateTime.now()
                                                .millisecondsSinceEpoch,
                                            notificationtitle:
                                                "Support Ticket Settings updated",
                                            notificationdesc:
                                                "agentCanChangeTicketStatus - is set to ${Utils.getboolText(!switchvalue)}"),
                                      );
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcanchangexxstatusxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),
                    //* -------------------------------

                    sectionHeader(
                        getTranslatedForCurrentUser(context, 'xxcustomerxx')
                            .toUpperCase()),
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
                              value: userAppSettings!.customerCanCreateTicket ??
                                  false,
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
                                              .customerCanCreateTicket ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              customerCanCreateTicket:
                                                  !switchvalue,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Support Ticket Settings updated",
                                              notificationdesc:
                                                  "customerCanCreateTicket - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcancreatexxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxtktssxx')}'),
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
                              value: userAppSettings!
                                      .customerCanChangeTicketStatus ??
                                  false,
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
                                              .customerCanChangeTicketStatus ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              customerCanChangeTicketStatus:
                                                  !switchvalue,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Support Ticket Settings updated",
                                              notificationdesc:
                                                  "customerCanChangeTicketStatus - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcanchangexxstatusxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
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
                              value: userAppSettings!
                                      .customerCanSeeAgentNameInTicketCallScreen ??
                                  false,
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
                                              .customerCanSeeAgentNameInTicketCallScreen ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              customerCanSeeAgentNameInTicketCallScreen:
                                                  !switchvalue,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Support Ticket Settings updated",
                                              notificationdesc:
                                                  "customerCanSeeAgents - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcanseexxxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxcanseexinxxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                            .replaceAll('(##)',
                                '${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')}'),
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
                              value: userAppSettings!.customerCanRateTicket ??
                                  false,
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
                                              .customerCanRateTicket ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              customerCanRateTicket:
                                                  !switchvalue,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Support Ticket Settings updated",
                                              notificationdesc:
                                                  "customerCanRateTicket - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcustomercanratetktxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')
                            .replaceAll('###)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxprovidefeedbackxxx')
                            .replaceAll('####)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),

                    //* -------------------------------

                    sectionHeader(
                        getTranslatedForCurrentUser(context, 'xxxgeneralxxx')),

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
                              value: userAppSettings!
                                      .showIsTypingInTicketChatRoom ??
                                  false,
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
                                              .showIsTypingInTicketChatRoom ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              showIsTypingInTicketChatRoom:
                                                  !switchvalue,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Support Ticket Settings updated",
                                              notificationdesc:
                                                  "showWhiIstypingInticketChatroom - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                            context, 'xxxxshowistypingxxx'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxxshowoistypingdescxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),

                    customTile(
                        ishighlightdesc: true,
                        margin: 5,
                        iconsize: 30,
                        trailingicondata: Icons.edit_outlined,
                        title:
                            '${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${getTranslatedForCurrentUser(context, 'xxxxreopenxxx')} ${getTranslatedForCurrentUser(context, 'xxxdaysxxx')}',
                        subtitle: userAppSettings!.reopenTicketTillDays
                                .toString() +
                            " ${getTranslatedForCurrentUser(context, 'xxxdaysxxx')}" +
                            "  (${getTranslatedForCurrentUser(context, 'xxxxcanbereopenedafterxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxtktsxx')}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxxdaysxxx')}')}).  ${getTranslatedForCurrentUser(context, 'xxxsetzeroxxx')}",
                        leadingicondata: Icons.settings_applications_rounded,
                        ontap: () {
                          _controller.text =
                              userAppSettings!.reopenTicketTillDays.toString();
                          ShowFormDialog().open(
                              inputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]") //-- Only Number & Aplhabets
                                    )
                              ],
                              iscapital: false,
                              controller: _controller,
                              keyboardtype: TextInputType.number,
                              maxlength: 8,
                              // maxlines: 4,
                              // minlines: 2,
                              iscentrealign: true,
                              context: context,
                              title:
                                  '${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${getTranslatedForCurrentUser(context, 'xxxxreopenxxx')} ${getTranslatedForCurrentUser(context, 'xxxdaysxxx')}',
                              subtitle:
                                  "${getTranslatedForCurrentUser(context, 'xxxxcanbereopenedafterxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxtktsxx')}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxxdaysxxx')}')}",
                              onpressed: AppConstants.isdemomode == true
                                  ? () {
                                      Utils.toast(getTranslatedForCurrentUser(
                                          context,
                                          'xxxnotalwddemoxxaccountxx'));
                                    }
                                  : () async {
                                      if (_controller.text.trim().length < 1) {
                                        ShowSnackbar().open(
                                            context: context,
                                            scaffoldKey: _scaffoldKey,
                                            time: 3,
                                            label:
                                                "${getTranslatedForCurrentUser(context, 'xxxplsentervalidnumberxx')} ${getTranslatedForCurrentUser(context, 'xxxsetzeroxxx')}");
                                        delayedFunction(setstatefn: () {
                                          ShowSnackbar().close(
                                            context: context,
                                            scaffoldKey: _scaffoldKey,
                                          );
                                        });
                                      } else {
                                        await fieldupdate(
                                          context: context,
                                          updatedmodel: userAppSettings!.copyWith(
                                              reopenTicketTillDays:
                                                  int.tryParse(
                                                      _controller.text.trim()),
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Ticket Settings updated",
                                              notificationdesc:
                                                  "reopenTicketTillDays - is set to ${int.tryParse(_controller.text.trim())} Days"),
                                        );
                                      }
                                    },
                              buttontext: getTranslatedForCurrentUser(
                                  context, 'xxupdatexx'),
                              hinttext: getTranslatedForCurrentUser(
                                  context, 'xxxdaysxxx'));
                        }),
                    customTile(
                        ishighlightdesc: true,
                        margin: 5,
                        iconsize: 30,
                        trailingicondata: Icons.edit_outlined,
                        title: getTranslatedForCurrentUser(
                            context, 'xxxdefaultmssgdltingtimexxx'),
                        subtitle: userAppSettings!
                                .defaultTicketMssgsDeletingTimeAfterClosing
                                .toString() +
                            " ${getTranslatedForCurrentUser(context, 'xxxdaysxxx')} ${getTranslatedForCurrentUser(context, 'xxxsetzeroxxx')}",
                        leadingicondata: Icons.settings_applications_rounded,
                        ontap: () {
                          _controller.text = userAppSettings!
                              .defaultTicketMssgsDeletingTimeAfterClosing
                              .toString();
                          ShowFormDialog().open(
                              inputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]") //-- Only Number & Aplhabets
                                    )
                              ],
                              iscapital: false,
                              controller: _controller,
                              keyboardtype: TextInputType.number,
                              maxlength: 8,
                              // maxlines: 4,
                              // minlines: 2,
                              iscentrealign: true,
                              context: context,
                              title: getTranslatedForCurrentUser(
                                  context, 'xxxdaysxxx'),
                              subtitle: getTranslatedForCurrentUser(
                                      context, 'xxxxforclosedtktxxxx')
                                  .replaceAll('(####)',
                                      '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                              onpressed: AppConstants.isdemomode == true
                                  ? () {
                                      Utils.toast(getTranslatedForCurrentUser(
                                          context,
                                          'xxxnotalwddemoxxaccountxx'));
                                    }
                                  : () async {
                                      if (_controller.text.trim().length < 1) {
                                        ShowSnackbar().open(
                                            context: context,
                                            scaffoldKey: _scaffoldKey,
                                            time: 3,
                                            label:
                                                "${getTranslatedForCurrentUser(context, 'xxxplsentervalidnumberxx')} ${getTranslatedForCurrentUser(context, 'xxxsetzeroxxx')}");
                                        delayedFunction(setstatefn: () {
                                          ShowSnackbar().close(
                                            context: context,
                                            scaffoldKey: _scaffoldKey,
                                          );
                                        });
                                      } else {
                                        await fieldupdate(
                                          context: context,
                                          updatedmodel: userAppSettings!.copyWith(
                                              defaultTicketMssgsDeletingTimeAfterClosing:
                                                  int.tryParse(
                                                      _controller.text.trim()),
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Ticket Settings updated",
                                              notificationdesc:
                                                  "defaultTicketMssgsDeletingTimeAfterClosing - is set to ${int.tryParse(_controller.text.trim())} Days"),
                                        );
                                      }
                                    },
                              buttontext: getTranslatedForCurrentUser(
                                  context, 'xxupdatexx'),
                              hinttext: getTranslatedForCurrentUser(
                                  context, 'xxxdaysxxx'));
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
                              value: userAppSettings!
                                      .isMediaSendingAllowedInTicketChatRoom ??
                                  false,
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
                                              .isMediaSendingAllowedInTicketChatRoom ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              isMediaSendingAllowedInTicketChatRoom:
                                                  !switchvalue,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Support Ticket Settings updated",
                                              notificationdesc:
                                                  "MediaSendingInTicketChatRoomAllowed - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                            context, 'xxxmediasendingxxx'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxcanuploadmediaxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                            .replaceAll('(##)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
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
                              value: userAppSettings!.showIsCustomerOnline ??
                                  false,
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
                                              .showIsCustomerOnline ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              showIsCustomerOnline:
                                                  !switchvalue,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Support Ticket Settings updated",
                                              notificationdesc:
                                                  "showCustomerIsOnlineInTicketChatRomm - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(context, 'xxxonlinestatusxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxchnagexxxstatusxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}')
                            .replaceAll('(##)',
                                '${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')}'),
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
                                  userAppSettings!.showIsAgentOnline ?? false,
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
                                      bool switchvalue =
                                          userAppSettings!.showIsAgentOnline ??
                                              false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              showIsAgentOnline: !switchvalue,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Support Ticket Settings updated",
                                              notificationdesc:
                                                  "CustomerCanSeeAgentIsOnlineinTicketChatroom - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(context, 'xxxonlinestatusxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxchnagexxxstatusxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxxx')}')
                            .replaceAll('(##)',
                                '${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),
                  ]));
  }
}
