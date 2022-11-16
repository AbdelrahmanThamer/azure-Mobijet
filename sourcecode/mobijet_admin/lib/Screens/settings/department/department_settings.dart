import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/userapp_settings_model.dart';
import 'package:thinkcreative_technologies/Screens/settings/department/all_departments_list.dart';
import 'package:thinkcreative_technologies/Screens/settings/department/default_agents.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Utils/color_light_dark.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Widgets/WarningWidgets/warning_tile.dart';
import 'package:thinkcreative_technologies/Widgets/custom_buttons.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/headers/sectionheaders.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Utils/custom_tiles.dart';

class DepartmentSettings extends StatefulWidget {
  final String currentuserid;
  final DocumentReference docRef;
  DepartmentSettings({required this.docRef, required this.currentuserid});
  @override
  _DepartmentSettingsState createState() => _DepartmentSettingsState();
}

class _DepartmentSettingsState extends State<DepartmentSettings> {
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
            getTranslatedForCurrentUser(context, 'xxuserappsetupincompletexx') +
                ". ${onError.toString()}";

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
            "${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(context, 'xxxsettingsxxx')}",
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

                    customTile(
                        isheading: true,
                        color: lighten(
                            userAppSettings!.departmentBasedContent == false
                                ? Colors.red
                                : Colors.yellow,
                            0.3),
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
                              inactiveColor: Mycolors.red,
                              height: 19.0,
                              valueFontSize: 12.0,
                              toggleSize: 15.0,
                              value: userAppSettings!.departmentBasedContent ??
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
                                              .departmentBasedContent ??
                                          false;
                                      await confirmchangeswitch(
                                          context: context,
                                          currentlbool: switchvalue,
                                          updatedmodel: userAppSettings!.copyWith(
                                              departmentBasedContent:
                                                  !switchvalue,
                                              notifcationpostedby:
                                                  widget.currentuserid,
                                              notificationtime: DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              notificationtitle:
                                                  getTranslatedForCurrentUser(
                                                          context,
                                                          'xxxsettingsupdatedxxx')
                                                      .replaceAll('(####)',
                                                          '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                              notificationdesc: getTranslatedForCurrentUser(
                                                      context, 'xxissettobyxx')
                                                  .replaceAll('(####)',
                                                      'departmentBasedContent')
                                                  .replaceAll('(###)',
                                                      '${Utils.getboolText(!switchvalue)}')
                                                  .replaceAll(
                                                      '(##)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}')));
                                    }),
                        ),
                        title: getTranslatedForCurrentUser(context, 'xxxdeptcontentxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                        subtitle: userAppSettings!.departmentBasedContent == true
                            ? getTranslatedForCurrentUser(context, 'xxwillbelimitedtoxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                .replaceAll(
                                    '(###)', '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')
                                .replaceAll(
                                    '(##)', '${getTranslatedForCurrentUser(context, 'xxdepartmentsxx')}')
                            : getTranslatedForCurrentUser(context, 'xxwillbelimitedtolongxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                .replaceAll('(###)',
                                    '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')
                                .replaceAll('(##)', '${getTranslatedForCurrentUser(context, 'xxxxdefaultagentlistxxx')}')
                                .replaceAll('(#)', '${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')}'),
                        leadingicondata: Icons.settings_applications_rounded),
                    // sectionHeader('TICKET DEPARTEMENTS'),

                    userAppSettings!.departmentBasedContent!
                        ? SizedBox()
                        : customTile(
                            isheading: true,
                            margin: 5,
                            iconsize: 30,
                            trailingicondata:
                                Icons.keyboard_arrow_right_outlined,
                            title:
                                '${getTranslatedForCurrentUser(context, 'xxxxdefaultagentlistxxx')}',
                            subtitle: userAppSettings!
                                    .departmentList![0]
                                        [Dbkeys.departmentAgentsUIDList]
                                    .length
                                    .toString() +
                                " ${getTranslatedForCurrentUser(context, 'xxagentsxx')}\n\n" +
                                getTranslatedForCurrentUser(
                                        context, 'xxautoaddintktsxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                    .replaceAll('(###)',
                                        '${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')}')
                                    .replaceAll('(##)',
                                        '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                            leadingicondata:
                                Icons.settings_applications_rounded,
                            ontap: () {
                              pageNavigator(
                                  context,
                                  DefaultAgents(
                                    departmentID: userAppSettings!
                                        .departmentList![0]
                                            [Dbkeys.departmentTitle]
                                        .toString(),
                                    onrefreshPreviousPage: () {
                                      fetchdata();
                                    },
                                    currentuserid: widget.currentuserid,
                                  ));
                            }),
                    userAppSettings!.departmentBasedContent == true &&
                            userAppSettings!.departmentList!.length < 2
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              warningTile(
                                  isstyledtext: true,
                                  title: getTranslatedForCurrentUser(
                                          context, 'xxxdepartbasedcontentxxx')
                                      .replaceAll('(####)',
                                          '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                  warningTypeIndex: WarningType.error.index),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18),
                                child: MySimpleButtonWithIcon(
                                  onpressed: () {
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
                                  },
                                  buttontext: getTranslatedForCurrentUser(
                                          context, 'xxaddnewxxxx')
                                      .replaceAll('(####)',
                                          '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                  buttoncolor: Mycolors.orange,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          )
                        : SizedBox(),
                    userAppSettings!.departmentBasedContent == true
                        ? Column(
                            children: [
                              customTile(
                                  isheading: true,
                                  margin: 5,
                                  iconsize: 30,
                                  trailingicondata: Icons
                                      .keyboard_arrow_right_outlined,
                                  title: getTranslatedForCurrentUser(
                                          context, 'xxallxxxx')
                                      .replaceAll('(####)',
                                          '${getTranslatedForCurrentUser(context, 'xxdepartmentsxx')}'),
                                  subtitle: Optionalconstants
                                              .isEditDefaultDepartment ==
                                          false
                                      ? userAppSettings!
                                                  .departmentList!.length <
                                              2
                                          ? "0 ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}"
                                          : (userAppSettings!.departmentList!
                                                          .length -
                                                      1)
                                                  .toString() +
                                              " ${getTranslatedForCurrentUser(context, 'xxdepartmentsxx')}"
                                      : userAppSettings!
                                                  .departmentList!.length <
                                              1
                                          ? "0 ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}"
                                          : userAppSettings!
                                                  .departmentList!.length
                                                  .toString() +
                                              " ${getTranslatedForCurrentUser(context, 'xxdepartmentsxx')}",
                                  leadingicondata:
                                      Icons.settings_applications_rounded,
                                  ontap: () {
                                    pageNavigator(
                                        context,
                                        AllDepartmentList(
                                          filteragentid: "",
                                          isShowForSignleAgent: false,
                                          onbackpressed: () {
                                            fetchdata();
                                          },
                                          currentuserid: widget.currentuserid,
                                        ));
                                  }),
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
                              //           activeColor:
                              //               Mycolors.green.withOpacity(0.85),
                              //           inactiveColor: Mycolors.grey,
                              //           height: 19.0,
                              //           valueFontSize: 12.0,
                              //           toggleSize: 15.0,
                              //           value: userAppSettings!
                              //                   .secondAdminCanCreateDepartmentGlobally ??
                              //               false,
                              //           borderRadius: 25.0,
                              //           padding: 3.0,
                              //           showOnOff: true,
                              //           onToggle:
                              //               AppConstants.isdemomode == true
                              //                   ? (val) {
                              //                       Utils.toast(
                              //                           getTranslatedForCurrentUser(context, 'xxxnotalwddemoxxaccountxx'));
                              //                     }
                              //                   : (val) async {
                              //                       bool switchvalue =
                              //                           userAppSettings!
                              //                                   .secondAdminCanCreateDepartmentGlobally ??
                              //                               false;
                              //                       await confirmchangeswitch(
                              //                           context: context,
                              //                           currentlbool:
                              //                               switchvalue,
                              //                           updatedmodel: userAppSettings!.copyWith(
                              //                               secondAdminCanCreateDepartmentGlobally:
                              //                                   !switchvalue,
                              //                               notifcationpostedby:
                              //                                   widget
                              //                                       .currentuserid,
                              //                               notificationtime:
                              //                                   DateTime.now()
                              //                                       .millisecondsSinceEpoch,
                              //                               notificationtitle:
                              //                                   "Department Settings updated",
                              //                               notificationdesc:
                              //                                   "secondAdminCanManageAllDepartment - is set to ${Utils.getboolText(!switchvalue)}"));
                              //                     }),
                              //     ),
                              //     title:
                              //         'Second Admin can Create / Delete Department',
                              //     subtitle:
                              //         'If Enabled, Second admin can manager & monitor all the Department contents from the User App',
                              //     leadingicondata:
                              //         Icons.settings_applications_rounded),
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
                              //           activeColor:
                              //               Mycolors.green.withOpacity(0.85),
                              //           inactiveColor: Mycolors.grey,
                              //           height: 19.0,
                              //           valueFontSize: 12.0,
                              //           toggleSize: 15.0,
                              //           value: userAppSettings!
                              //                   .secondAdminCanEditDepartment ??
                              //               false,
                              //           borderRadius: 25.0,
                              //           padding: 3.0,
                              //           showOnOff: true,
                              //           onToggle:
                              //               AppConstants.isdemomode == true
                              //                   ? (val) {
                              //                       Utils.toast(
                              //                           getTranslatedForCurrentUser(context, 'xxxnotalwddemoxxaccountxx'));
                              //                     }
                              //                   : (val) async {
                              //                       bool switchvalue =
                              //                           userAppSettings!
                              //                                   .secondAdminCanEditDepartment ??
                              //                               false;
                              //                       await confirmchangeswitch(
                              //                           context: context,
                              //                           currentlbool:
                              //                               switchvalue,
                              //                           updatedmodel: userAppSettings!.copyWith(
                              //                               secondAdminCanEditDepartment:
                              //                                   !switchvalue,
                              //                               notifcationpostedby:
                              //                                   widget
                              //                                       .currentuserid,
                              //                               notificationtime:
                              //                                   DateTime.now()
                              //                                       .millisecondsSinceEpoch,
                              //                               notificationtitle:
                              //                                   "Department Settings updated",
                              //                               notificationdesc:
                              //                                   "secondAdminCanEditDepartment - is set to ${Utils.getboolText(!switchvalue)}"));
                              //                     }),
                              //     ),
                              //     title: 'Departent Manager can edit',
                              //     subtitle:
                              //         'Each department manager can edit their department details & add or remove agents from their departments',
                              //     leadingicondata:
                              //         Icons.settings_applications_rounded),
                              sectionHeader(getTranslatedForCurrentUser(
                                  context, 'xxhowitwillworknow')),
                              warningTile(
                                  isbold: false,
                                  isstyledtext: true,
                                  title: getTranslatedForCurrentUser(
                                          context, 'xxxxhwl1xx')
                                      .replaceAll('(######)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxadminxx')}</bold>')
                                      .replaceAll('(#####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}</bold>')
                                      .replaceAll('(####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxdepartmentsxx')}</bold>')
                                      .replaceAll('(###)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxagentsxx')}</bold>')
                                      .replaceAll('(##)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}</bold>'),
                                  warningTypeIndex: WarningType.success.index),
                              warningTile(
                                  isstyledtext: true,
                                  title: getTranslatedForCurrentUser(
                                          context, 'xxxxhwl2xx')
                                      .replaceAll('(######)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}</bold>')
                                      .replaceAll('(#####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxagentsxx')}</bold>')
                                      .replaceAll('(####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxcustomersxx')}</bold>')
                                      .replaceAll('(###)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')}</bold>')
                                      .replaceAll('(##)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxagentchatsxx')}</bold>')
                                      .replaceAll('(#)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}</bold>'),
                                  warningTypeIndex: WarningType.success.index),
                              warningTile(
                                  isstyledtext: true,
                                  title: getTranslatedForCurrentUser(
                                          context, 'xxxxhwl3xx')
                                      .replaceAll('(####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}</bold>'),
                                  warningTypeIndex: WarningType.success.index),
                              warningTile(
                                  isstyledtext: true,
                                  title: getTranslatedForCurrentUser(
                                          context, 'xxxxhwl4xx')
                                      .replaceAll('(######)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxagentsxx')}</bold>')
                                      .replaceAll('(#####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}</bold>')
                                      .replaceAll('(####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}</bold>')
                                      .replaceAll('(###)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxadminxx')}</bold>')
                                      .replaceAll('(##)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}</bold>'),
                                  warningTypeIndex: WarningType.success.index),
                              warningTile(
                                  isstyledtext: true,
                                  title: getTranslatedForCurrentUser(
                                          context, 'xxxxhwl5xx')
                                      .replaceAll('(######)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxagentsxx')}</bold>')
                                      .replaceAll('(#####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}</bold>'),
                                  warningTypeIndex: WarningType.alert.index),
                              warningTile(
                                  isstyledtext: true,
                                  title: getTranslatedForCurrentUser(
                                          context, 'xxxxhwl6xx')
                                      .replaceAll('(######)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}</bold>')
                                      .replaceAll('(#####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}</bold>')
                                      .replaceAll('(####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxadminxx')}</bold>')
                                      .replaceAll('(###)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}</bold>'),
                                  warningTypeIndex: WarningType.alert.index),
                            ],
                          )
                        : Column(
                            children: [
                              sectionHeader(getTranslatedForCurrentUser(
                                  context, 'xxhowitwillworknow')),
                              warningTile(
                                  isstyledtext: true,
                                  title: getTranslatedForCurrentUser(
                                          context, 'xxxxhwl7xx')
                                      .replaceAll('(######)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}</bold>')
                                      .replaceAll('(#####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxagentsxx')}</bold>')
                                      .replaceAll('(####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxcustomersxx')}</bold>')
                                      .replaceAll('(###)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')}</bold>')
                                      .replaceAll('(##)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxagentchatsxx')}</bold>'),
                                  warningTypeIndex: WarningType.success.index),
                              warningTile(
                                  isstyledtext: true,
                                  title: getTranslatedForCurrentUser(
                                          context, 'xxxxhwl8xx')
                                      .replaceAll('(######)',
                                          '${getTranslatedForCurrentUser(context, 'xxdepartmentsxx')}'),
                                  warningTypeIndex: WarningType.error.index),
                              warningTile(
                                  isstyledtext: true,
                                  title: getTranslatedForCurrentUser(
                                          context, 'xxxxhwl9xx')
                                      .replaceAll('(######)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxagentsxx')}</bold>')
                                      .replaceAll('(#####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxagentxx')}</bold>'),
                                  warningTypeIndex: WarningType.alert.index),
                              warningTile(
                                  isstyledtext: true,
                                  isbold: false,
                                  title: getTranslatedForCurrentUser(
                                          context, 'xxxxhwl10xx')
                                      .replaceAll('(######)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}</bold>')
                                      .replaceAll('(#####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxagentxx')}</bold>')
                                      .replaceAll('(####)',
                                          '<bold>${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')}</bold>'),
                                  warningTypeIndex: WarningType.alert.index),
                            ],
                          ),
                  ]));
  }
}
