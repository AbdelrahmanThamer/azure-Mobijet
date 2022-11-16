import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/userapp_settings_model.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/Input_box.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Utils/delayed_function.dart';
import 'package:thinkcreative_technologies/Widgets/WarningWidgets/warning_tile.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/FormDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/headers/sectionheaders.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Utils/custom_tiles.dart';

class AgentChatGroupChatSettings extends StatefulWidget {
  final String currentuserid;
  final DocumentReference docRef;
  AgentChatGroupChatSettings(
      {required this.docRef, required this.currentuserid});
  @override
  _AgentChatGroupChatSettingsState createState() =>
      _AgentChatGroupChatSettingsState();
}

class _AgentChatGroupChatSettingsState
    extends State<AgentChatGroupChatSettings> {
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
    bool isdepartmentbased =
        isloading == true ? false : userAppSettings!.departmentBasedContent!;
    return MyScaffold(
        scaffoldkey: _scaffoldKey,
        titlespacing: 0,
        title: getTranslatedForCurrentUser(context, 'xxxchatsettingsxxx'),
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
                    isdepartmentbased
                        ? warningTile(
                            isstyledtext: true,
                            title: getTranslatedForCurrentUser(
                                    context, 'xxxdepartmentbasedonxxx')
                                .replaceAll('(######)',
                                    '<bold>${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}</bold>')
                                .replaceAll('(#####)',
                                    '<bold>${getTranslatedForCurrentUser(context, 'xxdepartmentsxx')}</bold>')
                                .replaceAll('(####)',
                                    '<bold>${getTranslatedForCurrentUser(context, 'xxagentsxx')}</bold>'),
                            warningTypeIndex: WarningType.alert.index,
                          )
                        : warningTile(
                            isstyledtext: true,
                            title: getTranslatedForCurrentUser(
                                    context, 'xxxdepartmentbasedoffxxx')
                                .replaceAll('(######)',
                                    '<bold>${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}</bold>')
                                .replaceAll('(#####)',
                                    '<bold>${getTranslatedForCurrentUser(context, 'xxagentsxx')}</bold>'),
                            warningTypeIndex: WarningType.success.index,
                          ),
                    //* -------------------------------
                    sectionHeader(
                        getTranslatedForCurrentUser(context, 'xxagentchatsxx')
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
                              value: userAppSettings!
                                      .agentCancreateandViewNewIndividualChat ??
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
                                              .agentCancreateandViewNewIndividualChat ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              agentCancreateandViewNewIndividualChat:
                                                  !switchvalue,
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Chat Settings updated",
                                              notificationdesc:
                                                  "agentCancreateandViewNewIndividualChat - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                            context, 'xxagentchatsxx'),
                        subtitle: isdepartmentbased
                            ? getTranslatedForCurrentUser(
                                    context, 'xxxindividualchatdeptxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                .replaceAll('(###)',
                                    '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                                .replaceAll(
                                    '(##)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                            : getTranslatedForCurrentUser(
                                    context, 'xxxindividualchatgloballytxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                .replaceAll('(###)',
                                    '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
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
                                  userAppSettings!.agentCanCallAgents ?? false,
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
                                          userAppSettings!.agentCanCallAgents ??
                                              false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              agentCanCallAgents: !switchvalue,
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Chat Settings updated",
                                              notificationdesc:
                                                  "agentCanCallAgents - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(context, 'xxxcancallxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                        subtitle: isdepartmentbased
                            ? getTranslatedForCurrentUser(
                                    context, 'xxxindividualcalldeptxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                .replaceAll('(###)',
                                    '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                                .replaceAll('(##)',
                                    '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                            : getTranslatedForCurrentUser(
                                    context, 'xxxindividualcallgloballytxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                .replaceAll(
                                    '(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
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
                                      .secondadminCancreateandViewNewIndividualChat ??
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
                                              .secondadminCancreateandViewNewIndividualChat ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              secondadminCancreateandViewNewIndividualChat:
                                                  !switchvalue,
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Chat Settings updated",
                                              notificationdesc:
                                                  "SecondAdminCanChatWithAgents - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcanchatwithxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxcanchatwithdescxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')
                            .replaceAll('(###)',
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
                                  userAppSettings!.secondadminCanCallAgents ??
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
                                              .secondadminCanCallAgents ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              secondadminCanCallAgents:
                                                  !switchvalue,
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Chat Settings updated",
                                              notificationdesc:
                                                  "SecondAdminCanCallAgents - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcancallxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxindividualcallgloballytxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}, ${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),
                    userAppSettings!.secondadminCanCallAgents == true ||
                            userAppSettings!.agentCanCallAgents == true
                        ? Card(
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
                              val3String: getTranslatedForCurrentUser(
                                      context, 'xxaudioxx') +
                                  ", " +
                                  getTranslatedForCurrentUser(
                                      context, 'xxvideoxx'),
                              selectedvalue: userAppSettings!
                                  .personalcalltypeagents
                                  .toString(),
                              onChanged: AppConstants.isdemomode == true
                                  ? (val) {
                                      Utils.toast(getTranslatedForCurrentUser(
                                          context,
                                          'xxxnotalwddemoxxaccountxx'));
                                    }
                                  : (val) async {
                                      userAppSettings = userAppSettings!.copyWith(
                                          personalcalltypeagents:
                                              int.tryParse(val!),
                                          notifcationpostedby:
                                              widget.currentuserid,
                                          notificationtime: DateTime.now()
                                              .millisecondsSinceEpoch,
                                          notificationtitle:
                                              "Chat Settings updated",
                                          notificationdesc:
                                              "personalcalltypeagents - is set to ${Utils.getCallValueText(int.tryParse(val)!)}");
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
                          )
                        : SizedBox(),
                    customTile(
                        ishighlightdesc: true,
                        margin: 5,
                        iconsize: 30,
                        trailingicondata: Icons.edit_outlined,
                        title: getTranslatedForCurrentUser(
                            context, 'xxxdefaultmssgdltingtimexxx'),
                        subtitle: userAppSettings!
                                .defaultMessageDeletingTimeForOneToOneChat
                                .toString() +
                            " ${getTranslatedForCurrentUser(context, 'xxxdaysxxx')}    ${getTranslatedForCurrentUser(context, 'xxxsetzeroxxx')}",
                        leadingicondata: Icons.settings_applications_rounded,
                        ontap: () {
                          _controller.text = userAppSettings!
                              .defaultMessageDeletingTimeForOneToOneChat
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
                                  context, 'xxxdeleteafterxxx'),
                              subtitle: getTranslatedForCurrentUser(
                                  context, 'xxxdeleteafterdescxxx'),
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
                                            label: getTranslatedForCurrentUser(
                                                context,
                                                'xxxplsentervalidnumberxx'));
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
                                              defaultMessageDeletingTimeForOneToOneChat:
                                                  int.tryParse(
                                                      _controller.text.trim()),
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Chat Deleting Time updated",
                                              notificationdesc:
                                                  "defaultMessageDeletingTimeForOneToOneChat - is set to ${_controller.text.trim()}"),
                                        );
                                      }
                                    },
                              buttontext: getTranslatedForCurrentUser(
                                  context, 'xxupdatexx'),
                              hinttext: getTranslatedForCurrentUser(
                                  context, 'xxxdaysxxx'));
                        }),
                    //* -------------------------------
                    SizedBox(
                      height: 26,
                    ),
                    sectionHeader(
                      (getTranslatedForCurrentUser(context, 'xxgroupchatxx')
                              .replaceAll('(####)',
                                  '${getTranslatedForCurrentUser(context, 'xxagents')}'))
                          .toUpperCase(),
                    ),

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
                                  userAppSettings!.agentsCanCreateAgentsGroup ??
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
                                              .agentsCanCreateAgentsGroup ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              agentsCanCreateAgentsGroup:
                                                  !switchvalue,
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Chat Settings updated",
                                              notificationdesc:
                                                  "agentsCanCreateGroupChat - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(context, 'xxxcancreatexxx')
                            .replaceAll(
                                '(####)', '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                            .replaceAll(
                                '(###)', '${getTranslatedForCurrentUser(context, 'xxgroupchatonlyxx')}'),
                        subtitle: isdepartmentbased
                            ? getTranslatedForCurrentUser(context, 'xxxcreategroupwithdeptxxx')
                                .replaceAll('(######)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                .replaceAll('(#####)',
                                    '${getTranslatedForCurrentUser(context, 'xxgroupchatonlyxx')}')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                                .replaceAll(
                                    '(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                .replaceAll(
                                    '(##)', '${getTranslatedForCurrentUser(context, 'xxgroupchatonlyxx')}')
                            : getTranslatedForCurrentUser(context, 'xxxcreategroupgloballyxxx')
                                .replaceAll('(######)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                .replaceAll('(#####)', '${getTranslatedForCurrentUser(context, 'xxgroupchatonlyxx')}')
                                .replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                .replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                .replaceAll('(##)', '${getTranslatedForCurrentUser(context, 'xxgroupchatonlyxx')}'),
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
                                      .secondadminCanCreateAgentsGroup ??
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
                                              .secondadminCanCreateAgentsGroup ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              secondadminCanCreateAgentsGroup:
                                                  !switchvalue,
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Chat Settings updated",
                                              notificationdesc:
                                                  "SecondAdminCancreateGroupChat - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcancreatexxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')
                            .replaceAll(
                                '(###)', '${getTranslatedForCurrentUser(context, 'xxgroupchatonlyxx')}'),
                        subtitle: getTranslatedForCurrentUser(context,
                                'xxxcreategroupgloballyxxx')
                            .replaceAll('(######)',
                                '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')
                            .replaceAll('(#####)',
                                '${getTranslatedForCurrentUser(context, 'xxgroupchatonlyxx')}')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                            .replaceAll('(##)',
                                '${getTranslatedForCurrentUser(context, 'xxgroupchatonlyxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),
                    customTile(
                        ishighlightdesc: true,
                        margin: 5,
                        iconsize: 30,
                        trailingicondata: Icons.edit_outlined,
                        title: getTranslatedForCurrentUser(
                            context, 'xxgroupmembersxx'),
                        subtitle: userAppSettings!.groupMemberslimit
                                .toString() +
                            " ${getTranslatedForCurrentUser(context, 'xxagentsxx')}",
                        leadingicondata: Icons.settings_applications_rounded,
                        ontap: () {
                          _controller.text =
                              userAppSettings!.groupMemberslimit.toString();
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
                                  context, 'xxgroupmembersxx'),
                              subtitle: getTranslatedForCurrentUser(
                                  context, 'xxxtotlagroupmemberxxx'),
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
                                            label: getTranslatedForCurrentUser(
                                                context,
                                                'xxxplsentervalidnumberxx'));
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
                                              groupMemberslimit: int.tryParse(
                                                  _controller.text.trim()),
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Chat Settings updated",
                                              notificationdesc:
                                                  "groupmemberLimit - is set to ${int.tryParse(_controller.text.trim())} Members"),
                                        );
                                      }
                                    },
                              buttontext: getTranslatedForCurrentUser(
                                  context, 'xxupdatexx'),
                              hinttext: '');
                        }),

                    customTile(
                        ishighlightdesc: true,
                        margin: 5,
                        iconsize: 30,
                        trailingicondata: Icons.edit_outlined,
                        title: getTranslatedForCurrentUser(
                            context, 'xxxdefaultmssgdltingtimexxx'),
                        subtitle: userAppSettings!
                                .defaultMessageDeletingTimeForGroup
                                .toString() +
                            " ${getTranslatedForCurrentUser(context, 'xxxdaysxxx')}    ${getTranslatedForCurrentUser(context, 'xxxsetzeroxxx')}",
                        leadingicondata: Icons.settings_applications_rounded,
                        ontap: () {
                          _controller.text = userAppSettings!
                              .defaultMessageDeletingTimeForGroup
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
                                  context, 'xxxdeleteafterxxx'),
                              subtitle: getTranslatedForCurrentUser(
                                  context, 'xxxdeleteafterdescxxx'),
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
                                            label: getTranslatedForCurrentUser(
                                                context,
                                                'xxxplsentervalidnumberxx'));
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
                                              defaultMessageDeletingTimeForGroup:
                                                  int.tryParse(
                                                      _controller.text.trim()),
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Chat Settings updated",
                                              notificationdesc:
                                                  "defaultMessageDeletingTimeForGroup - is set to ${int.tryParse(_controller.text.trim())} Days"),
                                        );
                                      }
                                    },
                              buttontext: getTranslatedForCurrentUser(
                                  context, 'xxupdatexx'),
                              hinttext: getTranslatedForCurrentUser(
                                  context, 'xxxdaysxxx'));
                        }),
                    //* -------------------------------
                    // SizedBox(
                    //   height: 26,
                    // ),
                    // sectionHeader('BROADCAST LIST MESSAGING'),
                    // customTile(
                    //     margin: 5,
                    //     iconsize: 30,
                    //     trailingWidget: Container(
                    //       margin: EdgeInsets.only(right: 3, top: 5),
                    //       width: 50,
                    //       height: 19,
                    //       child: FlutterSwitch(
                    //           activeText: '',
                    //           inactiveText: '',
                    //           width: 46.0,
                    //           activeColor: Mycolors.green.withOpacity(0.85),
                    //           inactiveColor: Mycolors.grey,
                    //           height: 19.0,
                    //           valueFontSize: 12.0,
                    //           toggleSize: 15.0,
                    //           value: userAppSettings!
                    //                   .agentCanCreateBroadcastToAgents ??
                    //               false,
                    //           borderRadius: 25.0,
                    //           padding: 3.0,
                    //           showOnOff: true,
                    //           onToggle: AppConstants.isdemomode == true
                    //               ? (val) {
                    //                   Utils.toast(getTranslatedForCurrentUser(context, 'xxxnotalwddemoxxaccountxx'));
                    //                 }
                    //               : (val) async {
                    //                   bool switchvalue = userAppSettings!
                    //                           .agentCanCreateBroadcastToAgents ??
                    //                       false;
                    //                   await confirmchangeswitch(
                    //                       context: context,
                    //                       currentlbool: switchvalue,
                    //                       updatedmodel: userAppSettings!.copyWith(
                    //                           agentCanCreateBroadcastToAgents:
                    //                               !switchvalue,
                    //                           notifcationpostedby:
                    //                               widget.currentuserid,
                    //                           notificationtime: DateTime.now()
                    //                               .millisecondsSinceEpoch,
                    //                           notificationtitle:
                    //                               "Chat Settings updated",
                    //                           notificationdesc:
                    //                               "agentCanCreateBroadcastList - is set to ${Utils.getboolText(!switchvalue)}"));
                    //                 }),
                    //     ),
                    //     title: 'Agents can create Broadcast List',
                    //     subtitle: isdepartmentbased
                    //         ? 'Agents can create agents list within the department memebers only & send a broadcast message to that list recepients'
                    //         : 'Agents can create agents list of any agents globally & send a broadcast message to that list recepients',
                    //     leadingicondata: Icons.settings_applications_rounded),
                    // customTile(
                    //     margin: 5,
                    //     iconsize: 30,
                    //     trailingWidget: Container(
                    //       margin: EdgeInsets.only(right: 3, top: 5),
                    //       width: 50,
                    //       height: 19,
                    //       child: FlutterSwitch(
                    //           activeText: '',
                    //           inactiveText: '',
                    //           width: 46.0,
                    //           activeColor: Mycolors.green.withOpacity(0.85),
                    //           inactiveColor: Mycolors.grey,
                    //           height: 19.0,
                    //           valueFontSize: 12.0,
                    //           toggleSize: 15.0,
                    //           value: userAppSettings!
                    //                   .secondadminCanCreateBroadcastToAgents ??
                    //               false,
                    //           borderRadius: 25.0,
                    //           padding: 3.0,
                    //           showOnOff: true,
                    //           onToggle: AppConstants.isdemomode == true
                    //               ? (val) {
                    //                   Utils.toast(getTranslatedForCurrentUser(context, 'xxxnotalwddemoxxaccountxx'));
                    //                 }
                    //               : (val) async {
                    //                   bool switchvalue = userAppSettings!
                    //                           .secondadminCanCreateBroadcastToAgents ??
                    //                       false;
                    //                   await confirmchangeswitch(
                    //                       context: context,
                    //                       currentlbool: switchvalue,
                    //                       updatedmodel: userAppSettings!.copyWith(
                    //                           secondadminCanCreateBroadcastToAgents:
                    //                               !switchvalue,
                    //                           notifcationpostedby:
                    //                               widget.currentuserid,
                    //                           notificationtime: DateTime.now()
                    //                               .millisecondsSinceEpoch,
                    //                           notificationtitle:
                    //                               "Chat Settings updated",
                    //                           notificationdesc:
                    //                               "SecondAdminCanCreateBroadcastList - is set to ${Utils.getboolText(!switchvalue)}"));
                    //                 }),
                    //     ),
                    //     title: 'Second Admin can create Broadcast List',
                    //     subtitle: isdepartmentbased
                    //         ? 'Second Admin can create agents list within the department memebers only & send a broadcast message to that list recepients'
                    //         : 'Second Admin can create agents list of any agents globally & send a broadcast message to that list recepients',
                    //     leadingicondata: Icons.settings_applications_rounded),
                    // customTile(
                    //     ishighlightdesc: true,
                    //     margin: 5,
                    //     iconsize: 30,
                    //     trailingicondata: Icons.edit_outlined,
                    //     title: 'Broadcast Member Limit',
                    //     subtitle:
                    //         userAppSettings!.broadcastMemberslimit.toString() +
                    //             " Members",
                    //     leadingicondata: Icons.settings_applications_rounded,
                    //     ontap: () {
                    //       _controller.text =
                    //           userAppSettings!.broadcastMemberslimit.toString();
                    //       ShowFormDialog().open(
                    //           inputFormatter: [
                    //             FilteringTextInputFormatter.allow(
                    //                 RegExp("[0-9]") //-- Only Number & Aplhabets
                    //                 )
                    //           ],
                    //           iscapital: false,
                    //           controller: _controller,
                    //           keyboardtype: TextInputType.number,
                    //           maxlength: 8,
                    //           // maxlines: 4,
                    //           // minlines: 2,
                    //           iscentrealign: true,
                    //           context: context,
                    //           title: 'Broadcast Members',
                    //           subtitle:
                    //               "Total broadcast memebers can be in a List ?",
                    //           onpressed: AppConstants.isdemomode == true
                    //               ? () {
                    //                   Utils.toast(getTranslatedForCurrentUser(context, 'xxxnotalwddemoxxaccountxx'));
                    //                 }
                    //               : () async {
                    //                   if (_controller.text.trim().length < 1) {
                    //                     ShowSnackbar().open(
                    //                         context: context,
                    //                         scaffoldKey: _scaffoldKey,
                    //                         time: 3,
                    //                         label:
                    //                             'Please enter a valid number');
                    //                     delayedFunction(setstatefn: () {
                    //                       ShowSnackbar().close(
                    //                         context: context,
                    //                         scaffoldKey: _scaffoldKey,
                    //                       );
                    //                     });
                    //                   } else {
                    //                     await fieldupdate(
                    //                       context: context,
                    //                       updatedmodel: userAppSettings!.copyWith(
                    //                           broadcastMemberslimit:
                    //                               int.tryParse(
                    //                                   _controller.text.trim()),
                    //                           notifcationpostedby:
                    //                               widget.currentuserid,
                    //                           notificationtime: DateTime.now()
                    //                               .millisecondsSinceEpoch,
                    //                           notificationtitle:
                    //                               "Chat Settings updated",
                    //                           notificationdesc:
                    //                               "broadcastMemberslimit - is set to ${int.tryParse(_controller.text.trim())} Members"),
                    //                     );
                    //                   }
                    //                 },
                    //           buttontext: getTranslatedForCurrentUser(context, 'xxupdatexx'),
                    //           hinttext: 'Enter no.');
                    //     }),
                    //* -------------------------------
                    SizedBox(
                      height: 26,
                    ),
                    sectionHeader(getTranslatedForCurrentUser(
                        context, 'xxxpersonalinfoviewxx')),
                    warningTile(
                        isstyledtext: true,
                        title: getTranslatedForCurrentUser(
                                context, 'xxxifbelowtuirnedoffxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                        warningTypeIndex: WarningType.alert.index),
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
                                      .agentCanSeeAgentStatisticsProfile ??
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
                                              .agentCanSeeAgentStatisticsProfile ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              agentCanSeeAgentStatisticsProfile:
                                                  !switchvalue,
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Chat Settings updated",
                                              notificationdesc:
                                                  "agentCanSeeAgentStatisticsProfile - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcanseexxprofilexxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                        subtitle: isdepartmentbased
                            ? getTranslatedForCurrentUser(
                                    context, 'xxxcanseedeptxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentxx')}')
                                .replaceAll('(###)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                .replaceAll('(##)',
                                    '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                            : getTranslatedForCurrentUser(context,
                                    'xxxcanseeallxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentxx')}')
                                .replaceAll('(###)',
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
                              value: userAppSettings!
                                      .agentsCanSeeCustomerStatisticsProfile ??
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
                                              .agentsCanSeeCustomerStatisticsProfile ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              agentsCanSeeCustomerStatisticsProfile:
                                                  !switchvalue,
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Chat Settings updated",
                                              notificationdesc:
                                                  "agentsCanSeeCustomerStatisticsProfile - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcanseexxprofilexxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                        subtitle: isdepartmentbased
                            ? getTranslatedForCurrentUser(
                                    context, 'xxxcanseedeptxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentxx')}')
                                .replaceAll('(###)',
                                    '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')
                                .replaceAll('(##)',
                                    '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                            : getTranslatedForCurrentUser(context,
                                    'xxxcanseeallxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentxx')}')
                                .replaceAll('(###)',
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
                                      .secondadminCanSeeAgentStatisticsProfile ??
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
                                              .secondadminCanSeeAgentStatisticsProfile ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              secondadminCanSeeAgentStatisticsProfile:
                                                  !switchvalue,
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Chat Settings updated",
                                              notificationdesc:
                                                  "SecondAdminCanSeeManagerProfile - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcanseexxprofilexxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxcanseeallxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')
                            .replaceAll('(###)',
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
                              value: userAppSettings!
                                      .secondadminCanSeeCustomerStatisticsProfile ??
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
                                              .secondadminCanSeeCustomerStatisticsProfile ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              secondadminCanSeeCustomerStatisticsProfile:
                                                  !switchvalue,
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  "Chat Settings updated",
                                              notificationdesc:
                                                  "SecondAdminCanSeeCustomerProfile - is set to ${Utils.getboolText(!switchvalue)}"));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(
                                context, 'xxxcanseexxprofilexxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                context, 'xxxcanseeallxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),

                    SizedBox(
                      height: 30,
                    ),
                  ]));
  }
}
