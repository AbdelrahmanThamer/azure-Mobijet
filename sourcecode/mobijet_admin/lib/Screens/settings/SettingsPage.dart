import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Screens/initialization/initialization_constant.dart';
import 'package:thinkcreative_technologies/Screens/role_manager/role_manager.dart';
import 'package:thinkcreative_technologies/Screens/settings/EditAdminAppSettings.dart';
import 'package:thinkcreative_technologies/Screens/settings/SubSettings/sub-userapp-controls.dart';
import 'package:thinkcreative_technologies/Screens/settings/department/department_settings.dart';
import 'package:thinkcreative_technologies/Screens/users/select_second_admin.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseApi.dart';
import 'package:thinkcreative_technologies/Services/my_providers/liveListener.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/WarningWidgets/warning_tile.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/Avatar.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Widgets/boxdecoration.dart';
import 'package:thinkcreative_technologies/Utils/custom_tiles.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';

class SettingsPage extends StatefulWidget {
  final String currentuserid;
  final bool isforcehideleading;
  SettingsPage({required this.isforcehideleading, required this.currentuserid});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<State> _keyLoader =
      new GlobalKey<State>(debugLabel: '272hu1');

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SpecialLiveConfigData? livedata =
        Provider.of<SpecialLiveConfigData?>(context, listen: true);

    var registry = Provider.of<UserRegistry>(context, listen: true);
    bool isready = livedata == null
        ? false
        : !livedata.docmap.containsKey(Dbkeys.secondadminID) ||
                livedata.docmap[Dbkeys.secondadminID] == '' ||
                livedata.docmap[Dbkeys.secondadminID] == null
            ? false
            : true;
    return MyScaffold(
      scaffoldkey: _scaffoldKey,
      isforcehideback: widget.isforcehideleading,
      titlespacing: 15,
      title: getTranslatedForCurrentUser(context, 'xxxsettingsxxx'),
      body: ListView(padding: EdgeInsets.only(top: 4), children: [
        customTile(
          margin: 8,
          iconsize: 35,
          leadingWidget: avatar(
            imageUrl: isready == true
                ? registry
                    .getUserData(
                        context, livedata!.docmap[Dbkeys.secondadminID])
                    .photourl
                : null,
          ),
          title: getTranslatedForCurrentUser(context, 'xxsecondadminxx'),
          trailingWidget: IconButton(
              onPressed: () {
                pageNavigator(
                    context,
                    SelectSecondAdmin(
                        alreadyselecteduserid:
                            livedata!.docmap[Dbkeys.secondadminID],
                        agents: registry.agents,
                        selecteduser: (agent) {
                          ShowConfirmDialog().open(
                              context: context,
                              subtitle: getTranslatedForCurrentUser(
                                      context, 'xxxassignxxrolesofxxx')
                                  .replaceAll('(####)',
                                      '${agent.fullname} (${getTranslatedForCurrentUser(context, 'xxidxx')} ${agent.id})')
                                  .replaceAll('(###)',
                                      '${getTranslatedForCurrentUser(context, 'xxsecondadminxx').toUpperCase()}'),
                              title: getTranslatedForCurrentUser(
                                      context, 'xxsetasxx')
                                  .replaceAll('(####)',
                                      '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}'),
                              rightbtnonpress: AppConstants.isdemomode == true
                                  ? () {
                                      Utils.toast(getTranslatedForCurrentUser(
                                          context,
                                          'xxxnotalwddemoxxaccountxx'));
                                    }
                                  : () async {
                                      Navigator.pop(context);
                                      ShowLoading().open(
                                          context: context, key: _keyLoader);
                                      await FirebaseFirestore.instance
                                          .collection(DbPaths.userapp)
                                          .doc(DbPaths.collectionconfigs)
                                          .update({
                                        Dbkeys.secondadminID:
                                            agent.id.toString()
                                      }).then((value) async {
                                        await FirebaseApi
                                            .runTransactionSendNotification(
                                                isOnlyAlertNotSave: false,
                                                parentid: "sys",
                                                docRef: FirebaseFirestore.instance
                                                    .collection(DbPaths
                                                        .collectionagents)
                                                    .doc(agent.id.toString())
                                                    .collection(
                                                        DbPaths
                                                            .agentnotifications)
                                                    .doc(DbPaths
                                                        .agentnotifications),
                                                title: getTranslatedForCurrentUser(
                                                        context, 'xxxurassignedasxxx')
                                                    .replaceAll('(####)',
                                                        '${getTranslatedForCurrentUser(context, 'xxsecondadminxx').toUpperCase()}'),
                                                plainDesc: getTranslatedForCurrentUser(
                                                        context,
                                                        'xxxcongratssecondadminxxx')
                                                    .replaceAll('(####)',
                                                        '${getTranslatedForCurrentUser(context, 'xxsecondadminxx').toUpperCase()}')
                                                    .replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                                    .replaceAll('(##)', '${getTranslatedForCurrentUser(context, 'xxagentsxx')}, ${getTranslatedForCurrentUser(context, 'xxcustomersxx')}, ${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')} '),
                                                onErrorFn: (e) {
                                                  ShowLoading().close(
                                                      context: context,
                                                      key: _keyLoader);
                                                  ShowSnackbar().open(
                                                      context: context,
                                                      scaffoldKey: _scaffoldKey,
                                                      status: 0,
                                                      time: 2,
                                                      label:
                                                          'Error Occured ! Error: $e');
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          DbPaths.userapp)
                                                      .doc(DbPaths
                                                          .collectionconfigs)
                                                      .update({
                                                    Dbkeys.secondadminID: ""
                                                  });
                                                },
                                                postedbyID: widget.currentuserid,
                                                onSuccessFn: () async {
                                                  await FirebaseApi
                                                      .runTransactionRecordActivity(
                                                          isOnlyAlertNotSave:
                                                              false,
                                                          parentid:
                                                              "SECONDADMIN--${agent.id}",
                                                          title: getTranslatedForCurrentUser(
                                                                  context, 'xxnewxxassignedxx')
                                                              .replaceAll(
                                                                  '(####)',
                                                                  '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}'),
                                                          plainDesc: (livedata.docmap[Dbkeys.secondadminID] != "" && livedata.docmap[Dbkeys.secondadminID] != null) == true
                                                              ? getTranslatedForCurrentUser(context, 'xxxsecondadminassignedxx')
                                                                      .replaceAll(
                                                                          '(####)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                                                      .replaceAll(
                                                                          '(###)', '${agent.fullname}, ${getTranslatedForCurrentUser(context, 'xxidxx')} ${agent.id}')
                                                                      .replaceAll(
                                                                          '(##)', '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}') +
                                                                  " (${getTranslatedForCurrentUser(context, 'xxxxcondadminremovedxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxagentidxx')} ${livedata.docmap[Dbkeys.secondadminID]}').replaceAll('(##)', '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')}) "
                                                              : getTranslatedForCurrentUser(context, 'xxxsecondadminassignedxx')
                                                                  .replaceAll(
                                                                      '(####)',
                                                                      '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                                                  .replaceAll('(###)', '${agent.fullname}, ${getTranslatedForCurrentUser(context, 'xxidxx')} ${agent.id}')
                                                                  .replaceAll('(##)', '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}'),
                                                          onErrorFn: (e) {
                                                            ShowLoading().close(
                                                                context:
                                                                    context,
                                                                key:
                                                                    _keyLoader);
                                                            ShowSnackbar().open(
                                                                context:
                                                                    context,
                                                                scaffoldKey:
                                                                    _scaffoldKey,
                                                                status: 0,
                                                                time: 2,
                                                                label:
                                                                    '${getTranslatedForCurrentUser(context, 'xxfailedxx')} Error: $e');
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    DbPaths
                                                                        .userapp)
                                                                .doc(DbPaths
                                                                    .collectionconfigs)
                                                                .update({
                                                              Dbkeys.secondadminID:
                                                                  ""
                                                            });
                                                          },
                                                          postedbyID: widget.currentuserid,
                                                          onSuccessFn: () async {
                                                            if (livedata.docmap[
                                                                        Dbkeys
                                                                            .secondadminID] !=
                                                                    "" &&
                                                                livedata.docmap[
                                                                        Dbkeys
                                                                            .secondadminID] !=
                                                                    null) {
                                                              await Utils.sendDirectNotification(
                                                                  docRef: FirebaseFirestore.instance
                                                                      .collection(
                                                                          DbPaths
                                                                              .collectionagents)
                                                                      .doc(livedata.docmap[Dbkeys.secondadminID]
                                                                          .toString())
                                                                      .collection(
                                                                          DbPaths
                                                                              .agentnotifications)
                                                                      .doc(
                                                                          DbPaths
                                                                              .agentnotifications),
                                                                  title: getTranslatedForCurrentUser(context, 'xxxuareremovedfromxxx').replaceAll(
                                                                      '(####)',
                                                                      '${getTranslatedForCurrentUser(context, 'xxsecondadminxx').toUpperCase()}'),
                                                                  plaindesc: getTranslatedForCurrentUser(context, 'xxxremovedfromxxx')
                                                                      .replaceAll(
                                                                          '(####)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                                                      .replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxsecondadminxx').toUpperCase()}'),
                                                                  postedbyID: widget.currentuserid,
                                                                  parentID: "SECONDADMIN--${livedata.docmap[Dbkeys.secondadminID]}");
                                                            }

                                                            ShowLoading().close(
                                                                context:
                                                                    context,
                                                                key:
                                                                    _keyLoader);

                                                            ShowSnackbar().open(
                                                              context: context,
                                                              scaffoldKey:
                                                                  _scaffoldKey,
                                                              status: 2,
                                                              time: 2,
                                                              label: getTranslatedForCurrentUser(
                                                                      context,
                                                                      'xxxsuccessassignxxx')
                                                                  .replaceAll(
                                                                      '(####)',
                                                                      '${agent.fullname}')
                                                                  .replaceAll(
                                                                      '(###)',
                                                                      '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}'),
                                                            );
                                                          });
                                                });
                                      }).catchError((error) {
                                        ShowLoading().close(
                                            context: context, key: _keyLoader);
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
                        }));
              },
              icon: Icon(isready == true ? Icons.edit : Icons.add)),
          subtitle: isready == false
              ? getTranslatedForCurrentUser(context, 'xxxassignxxasxxxxx')
                  .replaceAll('(####)',
                      '${getTranslatedForCurrentUser(context, 'xxagentxx')}')
                  .replaceAll('(###)',
                      '${getTranslatedForCurrentUser(context, 'xxsecondadminxx').toUpperCase()}')
              : registry
                      .getUserData(
                          context, livedata!.docmap[Dbkeys.secondadminID])
                      .fullname +
                  " (${getTranslatedForCurrentUser(context, 'xxidxx')}${livedata.docmap[Dbkeys.secondadminID]})",
          leadingicondata: Icons.settings_applications_rounded,
          leadingiconcolor: Mycolors.red,
        ),
        isready == false
            ? warningTile(
                isstyledtext: true,
                title: getTranslatedForCurrentUser(
                        context, 'xxxnosecondadminxxx')
                    .replaceAll('(####)',
                        '<bold>${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}</bold>')
                    .replaceAll('(###)',
                        '<bold>${getTranslatedForCurrentUser(context, 'xxcustomerxx')}</bold>'),
                warningTypeIndex: WarningType.alert.index)
            : warningTile(
                isbold: true,
                isstyledtext: true,
                title: getTranslatedForCurrentUser(context, 'xxxcanusexxx')
                    .replaceAll('(####)',
                        '<bold>${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}</bold>'),
                warningTypeIndex: WarningType.success.index),
        customTile(
            margin: 8,
            iconsize: 35,
            leadingWidget: Container(
              decoration: boxDecoration(
                radius: 9,
                color: Mycolors.orange,
                showShadow: false,
                bgColor: Mycolors.orange,
              ),
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.list,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            title: getTranslatedForCurrentUser(context, 'xxdepartmentsxx'),
            subtitle: getTranslatedForCurrentUser(
                    context, 'xxxuserappwillworkdeptxxx')
                .replaceAll('(####)',
                    '${getTranslatedForCurrentUser(context, 'xxdepartmentsxx')}'),
            leadingicondata: Icons.settings_applications_rounded,
            leadingiconcolor: Mycolors.red,
            ontap: () {
              pageNavigator(
                  context,
                  DepartmentSettings(
                    docRef: FirebaseFirestore.instance
                        .collection(DbPaths.userapp)
                        .doc(DbPaths.appsettings),
                    currentuserid: widget.currentuserid,
                  ));
            }),
        customTile(
            margin: 8,
            iconsize: 35,
            leadingWidget: Container(
              decoration: boxDecoration(
                radius: 9,
                color: Mycolors.red,
                showShadow: false,
                bgColor: Mycolors.red,
              ),
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            title:
                getTranslatedForCurrentUser(context, 'xxxuserappcontrolsxxx'),
            subtitle: getTranslatedForCurrentUser(
                    context, 'xxxuserappsettingsdescxxx')
                .replaceAll('(####)',
                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                .replaceAll('(###)',
                    '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}'),
            ontap: () {
              pageNavigator(
                  context,
                  SubUserAppControls(
                    currentuserid: widget.currentuserid,
                    isforcehideleading: false,
                    docref: FirebaseFirestore.instance
                        .collection(DbPaths.userapp)
                        .doc(DbPaths.appsettings),
                    iconcolor: Mycolors.red,
                  ));
            },
            leadingicondata: Icons.settings_applications_rounded),
        customTile(
            color: Color(0xffe0f5ff),
            margin: 8,
            iconsize: 35,
            leadingWidget: Container(
              decoration: boxDecoration(
                radius: 9,
                color: Mycolors.cyan,
                showShadow: false,
                bgColor: Mycolors.cyan,
              ),
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.person_pin_circle_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            title: getTranslatedForCurrentUser(context, 'xxrolemanagerxx'),
            subtitle:
                '${getTranslatedForCurrentUser(context, 'xxxquicksettingsxxx')}. ${getTranslatedForCurrentUser(context, 'xxxassignrolesxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxagentsxx')}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}').replaceAll('(##)', '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')}',
            ontap: () {
              pageNavigator(
                  context,
                  RoleManager(
                    currentuserid: widget.currentuserid,
                    docRef: FirebaseFirestore.instance
                        .collection(DbPaths.userapp)
                        .doc(DbPaths.appsettings),
                  ));
            },
            leadingicondata: Icons.settings_applications_rounded),
        customTile(
            margin: 8,
            iconsize: 35,
            leadingWidget: Container(
              decoration: boxDecoration(
                radius: 9,
                color: Mycolors.green,
                showShadow: false,
                bgColor: Mycolors.green,
              ),
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.app_settings_alt,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            title:
                getTranslatedForCurrentUser(context, 'xxxadminappsettingsxxx'),
            subtitle:
                getTranslatedForCurrentUser(context, 'xxxsettingsforadminxxx'),
            leadingicondata: Icons.settings_applications_rounded,
            leadingiconcolor: Mycolors.red,
            ontap: () {
              pageNavigator(context, AdminAppSettings(
                docRef: FirebaseFirestore.instance
                        .collection(InitializationConstant.k9)
                        .doc(InitializationConstant.k11),
              ));
            }),
      ]),
    );
  }
}
