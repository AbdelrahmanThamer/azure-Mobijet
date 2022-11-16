//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/number_limits.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/department_model.dart';
import 'package:thinkcreative_technologies/Models/user_registry_model.dart';
import 'package:thinkcreative_technologies/Models/userapp_settings_model.dart';
import 'package:thinkcreative_technologies/Screens/settings/department/add_agents_to_department.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseApi.dart';
import 'package:thinkcreative_technologies/Services/my_providers/liveListener.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Utils/custom_tiles.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/Input_box.dart';
import 'package:thinkcreative_technologies/Widgets/WarningWidgets/warning_tile.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/Avatar.dart';
import 'package:thinkcreative_technologies/Widgets/custom_buttons.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/others/userrole_based_sticker.dart';

class DefaultAgents extends StatefulWidget {
  final String departmentID;
  final String currentuserid;
  final Function onrefreshPreviousPage;

  const DefaultAgents(
      {Key? key,
      required this.departmentID,
      required this.currentuserid,
      required this.onrefreshPreviousPage})
      : super(key: key);

  @override
  _DefaultAgentsState createState() => _DefaultAgentsState();
}

class _DefaultAgentsState extends State<DefaultAgents> {
  File? imageFile;
  String error = "";
  bool isloading = true;
  final GlobalKey<State> _keyLoader223 =
      new GlobalKey<State>(debugLabel: '272husd1');
  UserAppSettingsModel? userAppSettings;
  DepartmentModel? department;
  List<dynamic> departments = [];
  final TextEditingController _textEditingController =
      new TextEditingController();
  DocumentReference docRef = FirebaseFirestore.instance
      .collection(DbPaths.userapp)
      .doc(DbPaths.appsettings);
  bool issecondaryloaderon = false;
  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  fetchdata() async {
    await docRef.get().then((dc) async {
      if (dc.exists) {
        userAppSettings = UserAppSettingsModel.fromSnapshot(dc);
        departments = userAppSettings!.departmentList!;
        // departments.removeAt(0);
        department = DepartmentModel.fromJson(userAppSettings!.departmentList!
            .lastWhere((department) =>
                department[Dbkeys.departmentTitle].toString() ==
                widget.departmentID));
        setState(() {
          isloading = false;
          issecondaryloaderon = false;
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
            "${getTranslatedForCurrentUser(context, 'xxuserappsetupincompletexx')}. $onError";

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
                Navigator.pop(context);
                ShowLoading().open(context: context, key: _keyLoader223);
                await docRef.update(updatedmodel.toMap()).then((value) async {
                  ShowLoading().close(context: context, key: _keyLoader223);
                  setState(() {
                    userAppSettings = updatedmodel;
                  });
                }).catchError((error) {
                  ShowLoading().close(context: context, key: _keyLoader223);

                  Utils.toast("ERROR: $error");
                });
              });
  }

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
    return Scaffold(
      backgroundColor: Mycolors.backgroundcolor,
      appBar: AppBar(
        elevation: 0.4,
        titleSpacing: -5,
        leading: Container(
          margin: EdgeInsets.only(right: 0),
          width: 10,
          child: IconButton(
            icon: Icon(LineAwesomeIcons.arrow_left,
                size: 24, color: Mycolors.primary),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: Mycolors.white,
        title: InkWell(
          onTap: () {
            // Navigator.push(
            //     context,
            //     PageRouteBuilder(
            //         opaque: false,
            //         pageBuilder: (context, a1, a2) => ProfileView(peer)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MtCustomfontBoldSemi(
                text: getTranslatedForCurrentUser(context, 'xxxdefaultxxxxx')
                    .replaceAll('(####)',
                        '${getTranslatedForCurrentUser(context, 'xxsupporttktxx')} ${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                fontsize: 19,
                color: Mycolors.black,
              ),
            ],
          ),
        ),
      ),
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
              : Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: Stack(
                    children: [
                      ListView(
                        children: [
                          customTile(
                              isheading: true,
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
                                    activeColor:
                                        Mycolors.green.withOpacity(0.85),
                                    inactiveColor: Mycolors.red,
                                    height: 19.0,
                                    valueFontSize: 12.0,
                                    toggleSize: 15.0,
                                    value: userAppSettings!
                                            .secondAdminCanCreateDepartmentGlobally ??
                                        false,
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
                                            bool switchvalue = userAppSettings!
                                                    .secondAdminCanCreateDepartmentGlobally ??
                                                false;
                                            await confirmchangeswitch(
                                                context: context,
                                                currentlbool: switchvalue,
                                                updatedmodel: userAppSettings!.copyWith(
                                                    secondAdminCanCreateDepartmentGlobally:
                                                        !switchvalue,
                                                    notifcationpostedby:
                                                        widget.currentuserid,
                                                    notificationtime: DateTime
                                                            .now()
                                                        .millisecondsSinceEpoch,
                                                    notificationtitle:
                                                        "Default Support Agents settings updated",
                                                    notificationdesc:
                                                        "secondAdminCanManageDefaultAgent - is set to ${Utils.getboolText(!switchvalue)}"));
                                          }),
                              ),
                              title: getTranslatedForCurrentUser(
                                      context, 'xxxxcanmanagexxx')
                                  .replaceAll('(####)',
                                      '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}'),
                              subtitle: getTranslatedForCurrentUser(
                                      context, 'xxxcanmanagelongxxx')
                                  .replaceAll('(####)',
                                      '${getTranslatedForCurrentUser(context, 'xxsecondadminxx')}')
                                  .replaceAll('(###)',
                                      '${getTranslatedForCurrentUser(context, 'xxagentsxxx')}'),
                              leadingicondata:
                                  Icons.settings_applications_rounded),
                          SizedBox(
                            height: 20,
                          ),
                          // sec
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      department!.departmentAgentsUIDList
                                                  .length <
                                              1
                                          ? getTranslatedForCurrentUser(
                                              context, 'xxagentxx')
                                          : department!.departmentAgentsUIDList
                                                  .length
                                                  .toString() +
                                              " ${getTranslatedForCurrentUser(context, 'xxagentsxx')}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Mycolors.secondary,
                                          fontSize: 15),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          addNewAgentsToDepartment(
                                              context,
                                              department!
                                                  .departmentAgentsUIDList,
                                              registry);
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          size: 25,
                                          color: Mycolors.primary,
                                        ))
                                  ],
                                ),
                                Divider(),
                                department!.departmentAgentsUIDList.length == 0
                                    ? MtCustomfontRegular(
                                        fontsize: 14,
                                        isitalic: true,
                                        text: getTranslatedForCurrentUser(
                                                context, 'xxnoxxisassignedinxx')
                                            .replaceAll('(####)',
                                                '${getTranslatedForCurrentUser(context, 'xxagentxx')}')
                                            .replaceAll('(###)',
                                                '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.all(3),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: department!
                                            .departmentAgentsUIDList.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          var agentid = department!
                                              .departmentAgentsUIDList[i];
                                          return Column(
                                            children: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.only(left: 7),
                                                leading: avatar(
                                                    imageUrl: registry
                                                        .getUserData(
                                                            context, agentid)
                                                        .photourl),
                                                title: MtCustomfontRegular(
                                                    fontsize: 16,
                                                    color: Mycolors.black,
                                                    text: registry
                                                        .getUserData(
                                                            context, agentid)
                                                        .fullname),
                                                subtitle: Row(
                                                  children: [
                                                    MtCustomfontRegular(
                                                      fontsize: 13,
                                                      text:
                                                          "${getTranslatedForCurrentUser(context, 'xxidxx')} " +
                                                              registry
                                                                  .getUserData(
                                                                      context,
                                                                      agentid)
                                                                  .id,
                                                    ),
                                                    SizedBox(
                                                      width: 1,
                                                    ),
                                                    isready == true
                                                        ? livedata!.docmap[Dbkeys
                                                                    .secondadminID] ==
                                                                agentid
                                                            ? roleBasedSticker(context,
                                                                Usertype
                                                                    .secondadmin
                                                                    .index)
                                                            : SizedBox()
                                                        : SizedBox(),
                                                    agentid ==
                                                            department!
                                                                .departmentManagerID
                                                        ? Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: roleBasedSticker(context,
                                                                Usertype
                                                                    .departmentmanager
                                                                    .index),
                                                          )
                                                        : SizedBox()
                                                  ],
                                                ),
                                                trailing: department!
                                                            .departmentAgentsUIDList
                                                            .length <
                                                        2
                                                    ? SizedBox()
                                                    : IconButton(
                                                        onPressed: () async {
                                                          await removeAgentFromDepartment(
                                                              context,
                                                              registry
                                                                  .getUserData(
                                                                      context,
                                                                      agentid)
                                                                  .id,
                                                              registry
                                                                  .getUserData(
                                                                      context,
                                                                      agentid)
                                                                  .fullname,
                                                              department!
                                                                  .departmentAgentsUIDList);
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .remove_circle_outline_rounded,
                                                          color: Mycolors.red,
                                                        ),
                                                      ),
                                              ),
                                              department!.departmentAgentsUIDList
                                                          .last ==
                                                      department!
                                                          .departmentAgentsUIDList[i]
                                                  ? SizedBox()
                                                  : Divider(
                                                      height: 1,
                                                    ),
                                            ],
                                          );
                                        }),
                                SizedBox(
                                  height: 7,
                                ),
                                userAppSettings!.autoJoinNewAgentsToDefaultList == false
                                    ? SizedBox()
                                    : warningTile(
                                        isstyledtext: true,
                                        title: registry.agents.length !=
                                                    department!
                                                        .departmentAgentsUIDList
                                                        .length &&
                                                userAppSettings!
                                                        .autoJoinNewAgentsToDefaultList ==
                                                    true
                                            ? "${getTranslatedForCurrentUser(context, 'xxxautoaddnewagentsxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')} ${getTranslatedForCurrentUser(context, 'xxxxturnofftodisablexxx')}"
                                            : getTranslatedForCurrentUser(
                                                    context,
                                                    'xxxautoaddnewagentsxxx')
                                                .replaceAll('(####)',
                                                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                                        warningTypeIndex: registry.agents.length !=
                                                    department!
                                                        .departmentAgentsUIDList
                                                        .length &&
                                                userAppSettings!.autoJoinNewAgentsToDefaultList == true
                                            ? WarningType.alert.index
                                            : WarningType.success.index),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          customTile(
                              isheading: true,
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
                                    activeColor:
                                        Mycolors.green.withOpacity(0.85),
                                    inactiveColor: Mycolors.red,
                                    height: 19.0,
                                    valueFontSize: 12.0,
                                    toggleSize: 15.0,
                                    value: userAppSettings!
                                            .autoJoinNewAgentsToDefaultList ??
                                        false,
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
                                            bool switchvalue = userAppSettings!
                                                    .autoJoinNewAgentsToDefaultList ??
                                                false;
                                            await confirmchangeswitch(
                                                context: context,
                                                currentlbool: switchvalue,
                                                updatedmodel: userAppSettings!.copyWith(
                                                    autoJoinNewAgentsToDefaultList:
                                                        !switchvalue,
                                                    notifcationpostedby:
                                                        widget.currentuserid,
                                                    notificationtime: DateTime
                                                            .now()
                                                        .millisecondsSinceEpoch,
                                                    notificationtitle:
                                                        "Default Support Agents settings updated",
                                                    notificationdesc:
                                                        "autoJoinNewAgentsToDefaultList - is set to ${Utils.getboolText(!switchvalue)}"));
                                          }),
                              ),
                              title: getTranslatedForCurrentUser(
                                      context, 'xxxxautoaddnewxxxxx')
                                  .replaceAll('(####)',
                                      '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                              subtitle: getTranslatedForCurrentUser(
                                      context, 'xxxautoaddnewagentsxxx')
                                  .replaceAll('(####)',
                                      '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                              leadingicondata:
                                  Icons.settings_applications_rounded),
                          SizedBox(
                            height: 18,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  addNewAgentsToDepartment(BuildContext context, List<dynamic> alreadyaddedlist,
      UserRegistry registry) async {
    List<UserRegistryModel> availableAgents = registry.agents;

    availableAgents = availableAgents
        .where((agent) => !alreadyaddedlist.contains(agent.id))
        .toList();

    await pageOpenOnTop(
        context,
        AddAgentsToDepartment(
          title: getTranslatedForCurrentUser(context, 'xxaddxx').replaceAll(
              '(####)',
              '${getTranslatedForCurrentUser(context, 'xxsupporttktxx')} ${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
          isdepartmentalreadycreated: true,
          agents: availableAgents,
          onselectagents: (agentids, agentmodels) {
            ShowConfirmDialog().open(
                context: context,
                subtitle: getTranslatedForCurrentUser(context, 'xxaddtocdeptxx')
                    .replaceAll('(####)',
                        '${agentids.length} ${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                    .replaceAll('(###)',
                        '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                    .replaceAll('(##)',
                        '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                title: getTranslatedForCurrentUser(context, 'xxconfirmquesxx'),
                rightbtnonpress: AppConstants.isdemomode == true
                    ? () {
                        Utils.toast(getTranslatedForCurrentUser(
                            context, 'xxxnotalwddemoxxaccountxx'));
                      }
                    : () async {
                        Navigator.pop(context);
                        ShowLoading()
                            .open(context: context, key: _keyLoader223);
                        List<dynamic> agents = alreadyaddedlist;
                        agentids.forEach((userid) {
                          agents.add(userid);
                        });

                        await FirebaseApi.runUPDATEmapobjectinListField(
                            docrefdata: docRef,
                            compareKey: Dbkeys.departmentTitle,
                            context: context,
                            isshowloader: false,
                            listkeyname: Dbkeys.departmentList,
                            keyloader: _keyLoader223,
                            compareVal: department!.departmentTitle,
                            replaceableMapObjectWithOnlyFieldsRequired: {
                              Dbkeys.departmentAgentsUIDList: agents,
                              Dbkeys.departmentLastEditedOn:
                                  DateTime.now().millisecondsSinceEpoch
                            },
                            onErrorFn: (e) {
                              ShowLoading()
                                  .close(context: context, key: _keyLoader223);
                              Utils.toast(
                                  "Error occured while updating. Please contact developer. ERROR: " +
                                      e.toString());
                            },
                            onSuccessFn: () async {
                              await FirebaseApi.runTransactionRecordActivity(
                                  parentid: "DEPT--${widget.departmentID}",
                                  title: getTranslatedForCurrentUser(
                                          context, 'xxxassignedtothexxx')
                                      .replaceAll('(####)',
                                          '${agentids.length} ${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                      .replaceAll('(###)',
                                          '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                  plainDesc: getTranslatedForCurrentUser(
                                          context,
                                          '')
                                      .replaceAll('(####)',
                                          '${getTranslatedForCurrentUser(context, 'xxagentsxx')}: [$agentids]')
                                      .replaceAll('(###)',
                                          '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${department!.departmentTitle}')
                                      .replaceAll(
                                          '(##)', '${widget.currentuserid}'),
                                  postedbyID: widget.currentuserid,
                                  context: context,
                                  onSuccessFn: () async {
                                    agentids.forEach((id) async {
                                      await Utils.sendDirectNotification(
                                          title: getTranslatedForCurrentUser(
                                                  context, 'xxxaddedtothisdeptxxx')
                                              .replaceAll(
                                                  '(####)', '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                          parentID:
                                              "DEPT--${widget.departmentID}",
                                          plaindesc: getTranslatedForCurrentUser(
                                                  context,
                                                  'xxxhasaddedutothexxxx')
                                              .replaceAll('(####)',
                                                  '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                              .replaceAll('(###)',
                                                  '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} - ${department!.departmentTitle}'),
                                          docRef: FirebaseFirestore.instance
                                              .collection(DbPaths.collectionagents)
                                              .doc(id)
                                              .collection(DbPaths.agentnotifications)
                                              .doc(DbPaths.agentnotifications),
                                          postedbyID: widget.currentuserid);
                                    });
                                    ShowLoading().close(
                                        context: context, key: _keyLoader223);
                                    await fetchdata();
                                    widget.onrefreshPreviousPage();
                                  },
                                  onErrorFn: (e) {
                                    print(e.toString());
                                    ShowLoading().close(
                                        context: context, key: _keyLoader223);
                                    Utils.toast(
                                        "Error occured while runTransactionRecordActivity(). Please contact developer. ERROR: " +
                                            e.toString());
                                  });
                            });
                      });
          },
        ));
  }

  removeAgentFromDepartment(
    BuildContext context,
    String agentid,
    String agentname,
    List<dynamic> alreadyaddedlist,
  ) {
    ShowConfirmDialog().open(
        context: context,
        subtitle: getTranslatedForCurrentUser(
                context, 'xxareyousureremovefromdeptxx')
            .replaceAll('(####)',
                '$agentname (${getTranslatedForCurrentUser(context, 'xxidxx')} $agentid)')
            .replaceAll('(###)',
                '${getTranslatedForCurrentUser(context, 'xxxxdefaultagentlistxxx')}'),
        title: getTranslatedForCurrentUser(context, 'xxconfirmquesxx'),
        rightbtnonpress: AppConstants.isdemomode == true
            ? () {
                Utils.toast(getTranslatedForCurrentUser(
                    context, 'xxxnotalwddemoxxaccountxx'));
              }
            : () async {
                Navigator.of(context).pop();

                ShowLoading().open(context: context, key: _keyLoader223);
                List<dynamic> agents = alreadyaddedlist;
                agents.remove(agentid);

                await FirebaseApi.runUPDATEmapobjectinListField(
                    docrefdata: docRef,
                    compareKey: Dbkeys.departmentTitle,
                    context: context,
                    isshowloader: false,
                    listkeyname: Dbkeys.departmentList,
                    keyloader: _keyLoader223,
                    compareVal: department!.departmentTitle,
                    replaceableMapObjectWithOnlyFieldsRequired:
                        agents.length < 2
                            ? {
                                Dbkeys.departmentIsShow: false,
                                Dbkeys.departmentAgentsUIDList: agents,
                                Dbkeys.departmentLastEditedOn:
                                    DateTime.now().millisecondsSinceEpoch
                              }
                            : {
                                Dbkeys.departmentAgentsUIDList: agents,
                                Dbkeys.departmentLastEditedOn:
                                    DateTime.now().millisecondsSinceEpoch
                              },
                    onErrorFn: (e) {
                      ShowLoading().close(context: context, key: _keyLoader223);
                      Utils.toast(
                          "Error occured while updating. Please contact developer. ERROR: " +
                              e.toString());
                    },
                    onSuccessFn: () async {
                      await FirebaseApi.runTransactionRecordActivity(
                          parentid: "DEFAULTAGENTSLIST--${widget.departmentID}",
                          title: getTranslatedForCurrentUser(
                                  context, 'xxxremovedfromxxx')
                              .replaceAll('(####)',
                                  '1 ${getTranslatedForCurrentUser(context, 'xxagentxx')}')
                              .replaceAll('(###)',
                                  '${getTranslatedForCurrentUser(context, 'xxxxdefaultagentlistxxx')}'),
                          plainDesc: getTranslatedForCurrentUser(
                                  context, 'xxxremovedfromxxx')
                              .replaceAll('(####)',
                                  '${getTranslatedForCurrentUser(context, 'xxagentxx')} $agentname (${getTranslatedForCurrentUser(context, 'xxidxx')} $agentid)')
                              .replaceAll('(###)',
                                  '${getTranslatedForCurrentUser(context, 'xxxxdefaultagentlistxxx')}. ${getTranslatedForCurrentUser(context, 'xxxbyxxx')} ${widget.currentuserid}'),
                          postedbyID: widget.currentuserid,
                          context: context,
                          onSuccessFn: () async {
                            // await Utils.sendDirectNotification(
                            //     title: getTranslatedForCurrentUser(
                            //             context, 'xxxuareremovedfromxxx')
                            //         .replaceAll('(####)',
                            //             '${getTranslatedForCurrentUser(context, 'xxxxdefaultagentlistxxx')}'),
                            //     parentID:
                            //         "DEFAULTAGENTSLIST--${widget.departmentID}",
                            //     plaindesc:
                            //         "${widget.currentuserid} has removed you from the Default Agent List. You can now only manage the tasks which are individually assigned to you by Admin OR Second admin",
                            //     docRef: FirebaseFirestore.instance
                            //         .collection(DbPaths.collectionagents)
                            //         .doc(agentid)
                            //         .collection(DbPaths.agentnotifications)
                            //         .doc(DbPaths.agentnotifications),
                            //     postedbyID: widget.currentuserid);

                            ShowLoading()
                                .close(context: context, key: _keyLoader223);
                            await fetchdata();
                            widget.onrefreshPreviousPage();
                          },
                          onErrorFn: (e) {
                            print(e.toString());
                            ShowLoading()
                                .close(context: context, key: _keyLoader223);
                            Utils.toast(
                                "Error occured while runTransactionRecordActivity(). Please contact developer. ERROR: " +
                                    e.toString());
                          });
                    });
              });
  }

  setAsManager(
    BuildContext context,
    String agentid,
    String agentname,
  ) {
    ShowConfirmDialog().open(
        context: context,
        subtitle: getTranslatedForCurrentUser(context, 'xxareusurexx')
            .replaceAll('(####)',
                '$agentname (${getTranslatedForCurrentUser(context, 'xxidxx')} $agentid)')
            .replaceAll('(###)',
                '${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}')
            .replaceAll('(##)',
                '${department!.departmentTitle} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
        title: getTranslatedForCurrentUser(context, 'xxconfirmquesxx'),
        rightbtnonpress: AppConstants.isdemomode == true
            ? () {
                Utils.toast(getTranslatedForCurrentUser(
                    context, 'xxxnotalwddemoxxaccountxx'));
              }
            : () async {
                Navigator.of(context).pop();

                ShowLoading().open(context: context, key: _keyLoader223);

                await FirebaseApi.runUPDATEmapobjectinListField(
                    docrefdata: docRef,
                    compareKey: Dbkeys.departmentTitle,
                    context: context,
                    isshowloader: false,
                    listkeyname: Dbkeys.departmentList,
                    keyloader: _keyLoader223,
                    compareVal: department!.departmentTitle,
                    replaceableMapObjectWithOnlyFieldsRequired: {
                      Dbkeys.departmentManagerID: agentid,
                      Dbkeys.departmentLastEditedOn:
                          DateTime.now().millisecondsSinceEpoch
                    },
                    onErrorFn: (e) {
                      ShowLoading().close(context: context, key: _keyLoader223);
                      Utils.toast(
                          "${getTranslatedForCurrentUser(context, 'xxfailedxx')} Please contact developer. ERROR: " +
                              e.toString());
                    },
                    onSuccessFn: () async {
                      await FirebaseApi.runTransactionRecordActivity(
                          parentid: "DEPT--${widget.departmentID}",
                          title: getTranslatedForCurrentUser(
                                  context, 'xxchangedxxx')
                              .replaceAll('(####)',
                                  '${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}'),
                          plainDesc: getTranslatedForCurrentUser(
                                  context, 'xxxnewoldmanagerxxx')
                              .replaceAll('(######)',
                                  '${getTranslatedForCurrentUser(context, 'xxagentxx')} $agentname (${getTranslatedForCurrentUser(context, 'xxidxx')} $agentid)')
                              .replaceAll('(#####)',
                                  '${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}')
                              .replaceAll('(####)',
                                  '${department!.departmentTitle} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                              .replaceAll('(###)', '${widget.currentuserid}')
                              .replaceAll('(##)',
                                  '${getTranslatedForCurrentUser(context, 'xxagentidxx')} ${department!.departmentManagerID}'),
                          postedbyID: widget.currentuserid,
                          context: context,
                          onSuccessFn: () async {
                            await Utils.sendDirectNotification(
                                title: getTranslatedForCurrentUser(
                                        context, 'xxxxyourssignedasxxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}'),
                                parentID: "DEPT--${widget.departmentID}",
                                plaindesc: getTranslatedForCurrentUser(
                                        context, 'xxxxhasaasigneduasthexxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                    .replaceAll('(###)',
                                        '${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}')
                                    .replaceAll('(##)',
                                        '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} - ${department!.departmentTitle}'),
                                docRef: FirebaseFirestore.instance
                                    .collection(DbPaths.collectionagents)
                                    .doc(agentid)
                                    .collection(DbPaths.agentnotifications)
                                    .doc(DbPaths.agentnotifications),
                                postedbyID: widget.currentuserid);
                            await Utils.sendDirectNotification(
                                title: getTranslatedForCurrentUser(
                                        context, 'xxxxyourremovedfromrolexxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}'),
                                parentID: "DEPT--${widget.departmentID}",
                                plaindesc: getTranslatedForCurrentUser(
                                        context, 'xxxxhasremoveduuasthexxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                    .replaceAll('(###)',
                                        '${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}')
                                    .replaceAll(
                                        '(##)', '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} - ${department!.departmentTitle}'),
                                docRef: FirebaseFirestore.instance
                                    .collection(DbPaths.collectionagents)
                                    .doc(department!.departmentManagerID)
                                    .collection(DbPaths.agentnotifications)
                                    .doc(DbPaths.agentnotifications),
                                postedbyID: widget.currentuserid);

                            ShowLoading()
                                .close(context: context, key: _keyLoader223);
                            await fetchdata();
                            widget.onrefreshPreviousPage();
                          },
                          onErrorFn: (e) {
                            print(e.toString());
                            ShowLoading()
                                .close(context: context, key: _keyLoader223);
                            Utils.toast(
                                "Error occured while runTransactionRecordActivity(). Please contact developer. ERROR: " +
                                    e.toString());
                          });
                    });
              });
  }

  editDescription(BuildContext context, String existingdesc) {
    _textEditingController.text = existingdesc;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          // return your layout
          var w = MediaQuery.of(context).size.width;
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                padding: EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        height: 219,
                        width: w / 1.24,
                        child: InpuTextBox(
                          controller: _textEditingController,
                          leftrightmargin: 0,
                          minLines: 8,
                          maxLines: 10,
                          showIconboundary: false,
                          maxcharacters: Numberlimits.maxdepartmentdescchar,
                          boxcornerradius: 5.5,
                          // boxheight: 70,
                          hinttext:
                              "${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(context, 'xxdescxx')}",
                        ),
                      ),
                      SizedBox(height: 20),
                      MySimpleButton(
                        buttontext:
                            getTranslatedForCurrentUser(context, 'xxupdatexx'),
                        onpressed: AppConstants.isdemomode == true
                            ? () {
                                Utils.toast(getTranslatedForCurrentUser(
                                    context, 'xxxnotalwddemoxxaccountxx'));
                              }
                            : () async {
                                if (_textEditingController.text.trim().length >
                                    Numberlimits.maxdepartmentdescchar) {
                                  Utils.toast(getTranslatedForCurrentUser(
                                          context, 'xxmaxxxcharxx')
                                      .replaceAll('(####)',
                                          '${Numberlimits.maxdepartmentdescchar}'));
                                } else {
                                  Navigator.of(context).pop();
                                  ShowLoading().open(
                                      context: context, key: _keyLoader223);

                                  await FirebaseApi.runUPDATEmapobjectinListField(
                                      docrefdata: docRef,
                                      compareKey: Dbkeys.departmentTitle,
                                      context: context,
                                      isshowloader: false,
                                      listkeyname: Dbkeys.departmentList,
                                      keyloader: _keyLoader223,
                                      compareVal: department!.departmentTitle,
                                      replaceableMapObjectWithOnlyFieldsRequired: {
                                        Dbkeys.departmentDesc:
                                            _textEditingController.text.trim(),
                                        Dbkeys.departmentLastEditedOn:
                                            DateTime.now()
                                                .millisecondsSinceEpoch
                                      },
                                      onErrorFn: (e) {
                                        ShowLoading().close(
                                            context: context,
                                            key: _keyLoader223);
                                        Utils.toast(
                                            "${getTranslatedForCurrentUser(context, 'xxfailedxx')} ERROR: " +
                                                e.toString());
                                      },
                                      onSuccessFn: () async {
                                        await FirebaseApi
                                            .runTransactionRecordActivity(
                                                parentid:
                                                    "DEPT--${widget.departmentID}",
                                                title: _textEditingController.text.trim().length < 1
                                                    ? getTranslatedForCurrentUser(
                                                            context, 'xxxxxremovedxxx')
                                                        .replaceAll(
                                                            '(####)', '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(context, 'xxdescxx')}')
                                                    : getTranslatedForCurrentUser(
                                                            context, 'xxxxxxupdatedxx')
                                                        .replaceAll(
                                                            '(####)', '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(context, 'xxdescxx')}'),
                                                plainDesc: _textEditingController.text.isEmpty
                                                    ? getTranslatedForCurrentUser(context, 'xxxxxremovedxxx')
                                                            .replaceAll(
                                                                '(####)', '${department!.departmentTitle}  ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(context, 'xxdescxx')}') +
                                                        ". ${getTranslatedForCurrentUser(context, 'xxxbyxxx')} ${getTranslatedForCurrentUser(context, 'xxadminxx')}"
                                                    : getTranslatedForCurrentUser(
                                                                context, 'xxxxxxupdatedxx')
                                                            .replaceAll('(####)', '${department!.departmentTitle} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(context, 'xxdescxx')}') +
                                                        ". ${getTranslatedForCurrentUser(context, 'xxxbyxxx')} ${getTranslatedForCurrentUser(context, 'xxadminxx')}",
                                                postedbyID: widget.currentuserid,
                                                context: context,
                                                onSuccessFn: () async {
                                                  ShowLoading().close(
                                                      context: context,
                                                      key: _keyLoader223);
                                                  await fetchdata();
                                                  widget
                                                      .onrefreshPreviousPage();
                                                },
                                                onErrorFn: (e) {
                                                  print(e.toString());
                                                  ShowLoading().close(
                                                      context: context,
                                                      key: _keyLoader223);
                                                  Utils.errortoast(
                                                      "E_5001: Error occured while runTransactionRecordActivity(). Please contact developer. ERROR: " +
                                                          e.toString());
                                                });
                                      });
                                }
                              },
                      ),
                    ])),
          );
        });
  }
}

formatDate(DateTime timeToFormat) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final String formatted = formatter.format(timeToFormat);
  return formatted;
}
