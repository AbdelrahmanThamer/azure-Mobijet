import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/userapp_settings_model.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseApi.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/headers/sectionheaders.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Widgets/role_column.dart';

class RoleManager extends StatefulWidget {
  final String currentuserid;
  final DocumentReference docRef;
  RoleManager({required this.docRef, required this.currentuserid});
  @override
  _RoleManagerState createState() => _RoleManagerState();
}

class _RoleManagerState extends State<RoleManager> {
  bool isloading = true;

  TextEditingController _controller = new TextEditingController();
  final GlobalKey<State> _keyLoader =
      new GlobalKey<State>(debugLabel: '272hu1');
  final GlobalKey<State> _keyLoader2 =
      new GlobalKey<State>(debugLabel: '272hu2');

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
            getTranslatedForCurrentUser(context, 'xxuserappsetupincompletexx');

        isloading = false;
      });
    });
  }

  updateInFirestore(m, k, v) async {
    ShowLoading().open(context: context, key: _keyLoader2);
    await FirebaseApi.runUPDATEtransactionInFirestoreDocument(
        context: context,
        refdata: widget.docRef,
        updatemap: {
          k: !v,
          Dbkeys.notificationtitle:
              getTranslatedForCurrentUser(context, 'xxrolesupdatedxx'),
          Dbkeys.notificationdesc:
              getTranslatedForCurrentUser(context, 'xxissettoxx')
                  .replaceAll('(####)', '$k')
                  .replaceAll('(###)', '${Utils.getboolText(!v)}')
                  .replaceAll('(##)', '${widget.currentuserid}'),
          Dbkeys.notificationtime: DateTime.now().millisecondsSinceEpoch,
          Dbkeys.notifcationpostedby: widget.currentuserid,
        },
        onerror: (e) {
          setState(() {
            error =
                "${getTranslatedForCurrentUser(context, 'xxerroroccuredxx')}\n\nERROR: " +
                    e.toString();
          });
          ShowLoading().close(context: context, key: _keyLoader2);
        },
        onsuccess: () async {
          await fetchdata();
          ShowLoading().close(context: context, key: _keyLoader2);
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
              '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')} \n\n$error');
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    bool isdepartmentbased =
        isloading == true ? false : userAppSettings!.departmentBasedContent!;
    return MyScaffold(
        scaffoldkey: _scaffoldKey,
        titlespacing: 0,
        title: getTranslatedForCurrentUser(context, 'xxrolemanagerxx'),
        appbarbottom: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0, color: Mycolors.greylightcolor),
              // bottom: BorderSide(width: 16.0, color: Colors.lightBlue.shade900),
            ),
            color: Colors.white,
          ),
          child: isloading == true
              ? SizedBox()
              : Row(
                  children: userAppSettings!.departmentBasedContent == true
                      ? [
                          Center(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Mycolors.greylightcolor),
                                ),
                                color: Colors.white,
                              ),
                              width: 0.4 * w,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Text(
                                  "  ${getTranslatedForCurrentUser(context, 'xxtasksxx')}",
                                  style: TextStyle(
                                      color: Mycolors.black,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Mycolors.greylightcolor),
                                ),
                                color: Colors.white,
                              ),
                              width: 0.15 * w,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Text(
                                  getTranslatedForCurrentUser(
                                      context, 'xxsecondadminxx'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Mycolors.greylightcolor),
                                ),
                                color: Colors.white,
                              ),
                              width: 0.15 * w,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Text(
                                  getTranslatedForCurrentUser(
                                      context, 'xxdepartmentmanagerxx'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Mycolors.greylightcolor),
                                ),
                                color: Colors.white,
                              ),
                              width: 0.15 * w,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Text(
                                  getTranslatedForCurrentUser(
                                      context, 'xxagentxx'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              width: 0.15 * w,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Text(
                                  getTranslatedForCurrentUser(
                                      context, 'xxcustomerxx'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ]
                      : [
                          Center(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Mycolors.greylightcolor),
                                ),
                                color: Colors.white,
                              ),
                              width: w / 2,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Text(
                                  "  ${getTranslatedForCurrentUser(context, 'xxtasksxx')}",
                                  style: TextStyle(
                                      color: Mycolors.black,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Mycolors.greylightcolor),
                                ),
                                color: Colors.white,
                              ),
                              width: w / 6,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Text(
                                  getTranslatedForCurrentUser(
                                      context, 'xxsecondadminxx'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Mycolors.greylightcolor),
                                ),
                                color: Colors.white,
                              ),
                              width: w / 6,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Text(
                                  getTranslatedForCurrentUser(
                                      context, 'xxagentxx'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              width: w / 6,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Text(
                                  getTranslatedForCurrentUser(
                                      context, 'xxcustomerxx'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
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
            : isloading == true || userAppSettings == null
                ? circularProgress()
                : ListView(padding: EdgeInsets.only(top: 0), children: [
                    //* -------------------------------
                    Column(
                      children: [
                        sectionHeader(getTranslatedForCurrentUser(
                                context, 'xxuserslistxx')
                            .toUpperCase()),
                        RoleColumn(
                          taskname: getTranslatedForCurrentUser(
                                  context, 'xxviewallxxx')
                              .replaceAll('(####)',
                                  '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}'),

                          tasksubtitle: getTranslatedForCurrentUser(
                              context, 'xxglobalxx'),
                          key1secondadmin:
                              Dbkeys.secondadminCanViewAllCustomerGlobally,
                          key4departemtmanager: Dbkeys
                              .departmentmanagerCanViewAllCustomerGlobally,
                          key2agent: Dbkeys.agentsCanViewAllCustomerGlobally,
                          // key3customer: Dbkeys.agentCanCreateBroadcastToAgents,
                          onSelect: (m, k, v) async {
                            await updateInFirestore(m, k, v);
                          },
                          isDepartmentBased:
                              userAppSettings!.departmentBasedContent!,
                          latestsettings: userAppSettings!.toMap(),
                        ),
                        isdepartmentbased == true
                            ? RoleColumn(
                                taskname: getTranslatedForCurrentUser(
                                        context, 'xxviewxxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}'),
                                tasksubtitle: isdepartmentbased == true
                                    ? getTranslatedForCurrentUser(
                                        context, 'xxonlywithindeptxx')
                                    : getTranslatedForCurrentUser(
                                        context, 'xxassignedtomexx'),
                                key1secondadmin: Dbkeys
                                    .secondadminCanViewAllCustomerGlobally,
                                key4departemtmanager: Dbkeys
                                    .departmentManagerCanSeeOwnDepartmentCustomers,
                                key2agent:
                                    Dbkeys.agentsCanSeeOwnDepartmentACustomer,
                                // key3customer: Dbkeys.agentCanCreateBroadcastToAgents,
                                onSelect: (m, k, v) async {
                                  await updateInFirestore(m, k, v);
                                },
                                isDepartmentBased:
                                    userAppSettings!.departmentBasedContent!,
                                latestsettings: userAppSettings!.toMap(),
                              )
                            : SizedBox(),
                        RoleColumn(
                          taskname: getTranslatedForCurrentUser(
                                  context, 'xxviewallxxx')
                              .replaceAll('(####)',
                                  '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                          tasksubtitle: getTranslatedForCurrentUser(
                              context, 'xxglobalxx'),
                          key1secondadmin:
                              Dbkeys.secondadminCanViewAllAgentsGlobally,
                          key4departemtmanager:
                              Dbkeys.departmentmanagerCanViewAllAgentsGlobally,
                          key2agent: Dbkeys.agentsCanViewAllAgentsGlobally,
                          // key3customer: Dbkeys.agentCanCreateBroadcastToAgents,
                          onSelect: (m, k, v) async {
                            await updateInFirestore(m, k, v);
                          },
                          isDepartmentBased:
                              userAppSettings!.departmentBasedContent!,
                          latestsettings: userAppSettings!.toMap(),
                        ),
                        isdepartmentbased == true
                            ? RoleColumn(
                                taskname: getTranslatedForCurrentUser(
                                        context, 'xxvixxviewonlyxxxewxxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                                tasksubtitle: getTranslatedForCurrentUser(
                                    context, 'xxonlywithindeptxx'),
                                key1secondadmin:
                                    Dbkeys.secondadminCanViewAllAgentsGlobally,
                                key4departemtmanager: Dbkeys
                                    .departmentManagerCanSeeOwnDepartmentAgents,
                                key2agent:
                                    Dbkeys.agentsCanSeeOwnDepartmentAgents,
                                // key3customer:
                                //     Dbkeys.agentCanCreateBroadcastToAgents,
                                onSelect: (m, k, v) async {
                                  await updateInFirestore(m, k, v);
                                },
                                isDepartmentBased:
                                    userAppSettings!.departmentBasedContent!,
                                latestsettings: userAppSettings!.toMap(),
                              )
                            : SizedBox(),
                      ],
                    ),
                    //* -------------------------------
                    sectionHeader(
                        getTranslatedForCurrentUser(context, 'xxprofilexxx')
                            .toUpperCase()),
                    RoleColumn(
                      taskname: getTranslatedForCurrentUser(
                              context, 'xxviewxxnamexxx')
                          .replaceAll('(####)',
                              '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                      key1secondadmin:
                          Dbkeys.secondadmincanseecustomernameandphoto,
                      key4departemtmanager:
                          Dbkeys.departmentmanagercanseecustomernameandphoto,
                      key2agent: Dbkeys.agentcanseecustomernameandphoto,
                      // key3customer: Dbkeys.agentCanCreateBroadcastToAgents,
                      onSelect: (m, k, v) async {
                        await updateInFirestore(m, k, v);
                      },
                      isDepartmentBased:
                          userAppSettings!.departmentBasedContent!,
                      latestsettings: userAppSettings!.toMap(),
                    ),
                    RoleColumn(
                      taskname: getTranslatedForCurrentUser(
                              context, 'xxviewxxnstatsxxx')
                          .replaceAll('(####)',
                              '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                      key1secondadmin:
                          Dbkeys.secondadminCanSeeCustomerStatisticsProfile,
                      key4departemtmanager: Dbkeys
                          .departmentmanagerCanSeeCustomerStatisticsProfile,
                      key2agent: Dbkeys.agentsCanSeeCustomerStatisticsProfile,
                      // key3customer: Dbkeys.customerCanSeeAgentStatisticsProfile,
                      onSelect: (m, k, v) async {
                        await updateInFirestore(m, k, v);
                      },
                      isDepartmentBased:
                          userAppSettings!.departmentBasedContent!,
                      latestsettings: userAppSettings!.toMap(),
                    ),
                    RoleColumn(
                      taskname: getTranslatedForCurrentUser(
                              context, 'xxviewxxcontactdetails')
                          .replaceAll('(####)',
                              '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),

                      key1secondadmin:
                          Dbkeys.secondadminCanSeeCustomerContactInfo,
                      key4departemtmanager:
                          Dbkeys.departmentmanagerCanSeeCustomerContactinfo,
                      key2agent: Dbkeys.agentCanSeeCustomerContactInfo,
                      // key3customer: Dbkeys.agentCanCreateBroadcastToAgents,
                      onSelect: (m, k, v) async {
                        await updateInFirestore(m, k, v);
                      },
                      isDepartmentBased:
                          userAppSettings!.departmentBasedContent!,
                      latestsettings: userAppSettings!.toMap(),
                    ),

                    RoleColumn(
                      taskname: getTranslatedForCurrentUser(
                              context, 'xxviewxxnamexxx')
                          .replaceAll('(####)',
                              '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                      key1secondadmin:
                          Dbkeys.secondadmincanseeagentnameandphoto,
                      key4departemtmanager:
                          Dbkeys.departmentmanagercanseeagentnameandphoto,
                      key2agent: Dbkeys.agentcanseeagentnameandphoto,
                      key3customer: Dbkeys.customercanseeagentnameandphoto,
                      onSelect: (m, k, v) async {
                        await updateInFirestore(m, k, v);
                      },
                      isDepartmentBased:
                          userAppSettings!.departmentBasedContent!,
                      latestsettings: userAppSettings!.toMap(),
                    ),
                    RoleColumn(
                      taskname: getTranslatedForCurrentUser(
                              context, 'xxviewxxnstatsxxx')
                          .replaceAll('(####)',
                              '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                      key1secondadmin:
                          Dbkeys.secondadminCanSeeAgentStatisticsProfile,
                      key4departemtmanager:
                          Dbkeys.departmentmanagerCanSeeAgentStatisticsProfile,
                      key2agent: Dbkeys.agentCanSeeAgentStatisticsProfile,
                      key3customer: Dbkeys.customerCanSeeAgentStatisticsProfile,
                      onSelect: (m, k, v) async {
                        await updateInFirestore(m, k, v);
                      },
                      isDepartmentBased:
                          userAppSettings!.departmentBasedContent!,
                      latestsettings: userAppSettings!.toMap(),
                    ),
                    RoleColumn(
                      taskname: getTranslatedForCurrentUser(
                              context, 'xxviewxxcontactdetails')
                          .replaceAll('(####)',
                              '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                      key1secondadmin: Dbkeys.secondadminCanSeeAgentContactinfo,
                      key4departemtmanager:
                          Dbkeys.departmentmanagerCanSeeAgentContactinfo,
                      key2agent: Dbkeys.agentCanSeeAgentContactinfo,
                      key3customer: Dbkeys.customerCanSeeAgentContactinfo,
                      onSelect: (m, k, v) async {
                        await updateInFirestore(m, k, v);
                      },
                      isDepartmentBased:
                          userAppSettings!.departmentBasedContent!,
                      latestsettings: userAppSettings!.toMap(),
                    ),

                    // isdepartmentbased
                    //     ? warningTile(
                    //         isstyledtext: true,
                    //         title:
                    //             "<bold>Department based content is turned ON.</bold>  Below settings will be applicable to <bold>individual departments only</bold> where agents are assigned. Agents can see & communicate with other agent in <bold>their department only.</bold> ",
                    //         warningTypeIndex: WarningType.alert.index,
                    //       )
                    //     : warningTile(
                    //         isstyledtext: true,
                    //         title:
                    //             "<bold>Department based content is turned OFF.</bold>  Below settings will be applicable <bold>globally</bold>. Agents can see & communicate with all agents registed in <bold>App</bold> if permitted in below settings ",
                    //         warningTypeIndex: WarningType.success.index,
                    //       ),
                    //* -------------------------------
                    // bool?  = true;
                    // bool?  = false;
                    // bool?  = true;
                    // bool?  = true;
                    // bool?  = true;
                    // bool?  = true;
                    // bool?  = false;
                    // bool?  = false;
                    // bool? departmentmanagerCanDeleteDepartment = false;
                    // bool? secondadminCanDeleteDepartment = true;

                    isdepartmentbased == true
                        ? Column(
                            children: [
                              sectionHeader(getTranslatedForCurrentUser(
                                      context, 'xxdepartmentxx')
                                  .toUpperCase()),
                              RoleColumn(
                                taskname: getTranslatedForCurrentUser(
                                        context, 'xxviewallxxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxdepartmentsxx')}'),
                                tasksubtitle: getTranslatedForCurrentUser(
                                        context, 'xxnamelogoxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                key1secondadmin:
                                    Dbkeys.secondadminCanViewGlobalDepartments,
                                key4departemtmanager: Dbkeys
                                    .departmentmanagerCanViewGlobalDepartments,
                                key2agent:
                                    Dbkeys.agentsCanViewGlobalDepartments,
                                key3customer:
                                    Dbkeys.customerCanViewGlobalDepartments,
                                onSelect: (m, k, v) async {
                                  await updateInFirestore(m, k, v);
                                },
                                isDepartmentBased:
                                    userAppSettings!.departmentBasedContent!,
                                latestsettings: userAppSettings!.toMap(),
                              ),
                              RoleColumn(
                                taskname: getTranslatedForCurrentUser(
                                        context, 'xxviewxxnstatsxxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                tasksubtitle: getTranslatedForCurrentUser(
                                    context, 'xxglobalxx'),
                                key1secondadmin: Dbkeys
                                    .secondAdminCanviewDepartmentStatistics,
                                key4departemtmanager: Dbkeys
                                    .departmentmanagerCanviewDepartmentStatistics,
                                onSelect: (m, k, v) async {
                                  await updateInFirestore(m, k, v);
                                },
                                isDepartmentBased:
                                    userAppSettings!.departmentBasedContent!,
                                latestsettings: userAppSettings!.toMap(),
                              ),
                              RoleColumn(
                                taskname: getTranslatedForCurrentUser(
                                        context, 'xxcreatexx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                key1secondadmin: Dbkeys
                                    .secondAdminCanCreateDepartmentGlobally,
                                key4departemtmanager: Dbkeys
                                    .departmentManagerCanCreateDepartmentGlobally,
                                onSelect: (m, k, v) async {
                                  await updateInFirestore(m, k, v);
                                },
                                isDepartmentBased:
                                    userAppSettings!.departmentBasedContent!,
                                latestsettings: userAppSettings!.toMap(),
                              ),
                              RoleColumn(
                                taskname: getTranslatedForCurrentUser(
                                        context, 'xxxeditxxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                tasksubtitle: getTranslatedForCurrentUser(
                                        context, 'xxxaddremovexxxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                                key1secondadmin:
                                    Dbkeys.secondAdminCanEditDepartment,
                                key4departemtmanager: Dbkeys
                                    .departmentManagerCanEditAddAgentstodepartment,
                                onSelect: (m, k, v) async {
                                  await updateInFirestore(m, k, v);
                                },
                                isDepartmentBased:
                                    userAppSettings!.departmentBasedContent!,
                                latestsettings: userAppSettings!.toMap(),
                              ),
                              RoleColumn(
                                taskname:
                                    "${getTranslatedForCurrentUser(context, 'xxdeletexx')} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}",
                                key1secondadmin:
                                    Dbkeys.secondadminCanDeleteDepartment,
                                // key4departemtmanager:
                                //     Dbkeys.departmentmanagerCanDeleteDepartment,
                                onSelect: (m, k, v) async {
                                  await updateInFirestore(m, k, v);
                                },
                                isDepartmentBased:
                                    userAppSettings!.departmentBasedContent!,
                                latestsettings: userAppSettings!.toMap(),
                              ),
                            ],
                          )
                        : SizedBox(),
                    // //* -------------------------------
                    //                   Column(
                    //                     children: [
                    //                       sectionHeader('USERS LIST'),
                    //                       RoleColumn(
                    //                         taskname: "See All Customers",
                    //                         tasksubtitle: getTranslatedForCurrentUser( context, 'xxglobalxx'),
                    //                         key1secondadmin:
                    //                             Dbkeys.secondadmincanseecustomernameandphoto,
                    //                         key4departemtmanager: Dbkeys
                    //                             .departmentmanagercanseecustomernameandphoto,
                    //                         key2agent: Dbkeys.agentcanseecustomernameandphoto,
                    //                         // key3customer: Dbkeys.agentCanCreateBroadcastToAgents,
                    //                         onSelect: (m) {
                    //                           userAppSettings = m;
                    //                           setState(() {});
                    //                         },
                    //                         isDepartmentBased:
                    //                             userAppSettings!.departmentBasedContent!,
                    //                         latestsettings: userAppSettings!.toMap(),
                    //                       ),]),

                    // //* -------------------------------
                    Column(children: [
                      sectionHeader(
                          '${getTranslatedForCurrentUser(context, 'xxcustomerxx').toUpperCase()} ${getTranslatedForCurrentUser(context, 'xxsupporttktsxx')}'),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                                context, 'xxviewallxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxtktssxx')}'),
                        tasksubtitle:
                            getTranslatedForCurrentUser(context, 'xxglobalxx'),
                        key1secondadmin:
                            Dbkeys.secondadminCanViewAllTicketGlobally,
                        key4departemtmanager:
                            Dbkeys.departmentmanagerCanViewAllTicketGlobally,
                        key2agent: Dbkeys.agentCanViewAllTicketGlobally,
                        // key3customer: Dbkeys.agentCanCreateBroadcastToAgents,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                                context, 'xxviewxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxtktssxx')}'),
                        tasksubtitle: getTranslatedForCurrentUser(
                            context, 'xxassignedtomexx'),
                        iskey2agentdisabled: true,
                        iskey1secondadmindisabled: true,
                        iskey3customerdisabled: true,
                        iskey4departmentmanagerdisabled: true,
                        key1secondadmin: Dbkeys.viewowntickets,
                        key4departemtmanager: Dbkeys.viewowntickets,
                        key2agent: Dbkeys.viewowntickets,
                        key3customer: Dbkeys.viewowntickets,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                                context, 'xxcreatexx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                        key1secondadmin: Dbkeys.secondadminCanCreateTicket,
                        key4departemtmanager:
                            Dbkeys.departmentManagerCanCreateTicket,
                        key2agent: Dbkeys.agentCanCreateTicket,
                        key3customer: Dbkeys.customerCanCreateTicket,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                                context, 'xxchatwithxxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}'),
                        key1secondadmin:
                            Dbkeys.secondadminCanChatWithCustomerInTicket,
                        key4departemtmanager:
                            Dbkeys.departmentmanagerCanChatWithCustomerInTicket,
                        key2agent: Dbkeys.agentcanChatWithCustomerInTicket,
                        // key3customer: Dbkeys.agentCanCreateBroadcastToAgents,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                                context, 'xxviewxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                        tasksubtitle: getTranslatedForCurrentUser(
                                context, 'xxxassignedinxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                        key1secondadmin:
                            Dbkeys.secondadminCanViewAgentsListJoinedTicket,
                        key4departemtmanager: Dbkeys
                            .departmentmanagerCanViewAgentsListJoinedTicket,
                        key2agent: Dbkeys.agentCanViewAgentsListJoinedTicket,
                        key3customer:
                            Dbkeys.customerCanViewAgentsListJoinedTicket,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                            context, 'xxxassigncallsxx'),
                        tasksubtitle: getTranslatedForCurrentUser(
                                context, 'xxxabilitytoassignxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}'),
                        key1secondadmin: Dbkeys.secondadminCanScheduleCalls,
                        key4departemtmanager:
                            Dbkeys.departmentManagerCanScheduleCalls,
                        key2agent: Dbkeys.agentCanScheduleCalls,
                        // key3customer:
                        //     Dbkeys.customerCanDialCallsInTicketChatroom,
                        iskey3customerdisabled: true,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                                context, 'xxchangexxstatusxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                        key1secondadmin:
                            Dbkeys.secondadminCanChangeTicketStatus,
                        key4departemtmanager:
                            Dbkeys.departmentmanagerCanChangeTicketStatus,
                        key2agent: Dbkeys.agentCanChangeTicketStatus,
                        key3customer: Dbkeys.customerCanChangeTicketStatus,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                                context, 'xxclosexxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                        key1secondadmin: Dbkeys.secondAdminCanCloseTicket,
                        key4departemtmanager:
                            Dbkeys.departmentmanagerCanCloseTicket,
                        key2agent: Dbkeys.agentCanCloseTicket,
                        key3customer: Dbkeys.customerCanCloseTicket,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                                context, 'xxreopenxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                        tasksubtitle: userAppSettings!.reopenTicketTillDays == 0
                            ? getTranslatedForCurrentUser(
                                context, 'xxdisabledxx')
                            : getTranslatedForCurrentUser(
                                    context, 'xxxwithinxxdaysxxx')
                                .replaceAll('(####)',
                                    '${userAppSettings!.reopenTicketTillDays}'),
                        key1secondadmin: Dbkeys.secondadminCanReopenTicket,
                        key4departemtmanager:
                            Dbkeys.departmentManagerCanReopenTicket,
                        key2agent: Dbkeys.agentCanReopenTicket,
                        key3customer: Dbkeys.customerCanReopenTicket,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                    ]),
                    // //* -------------------------------

                    //                     bool?  = true;
                    // bool?  = true;
                    // bool?  = true;
                    // bool?  = true;
                    // bool?  = true;

                    Column(children: [
                      sectionHeader(
                        getTranslatedForCurrentUser(context, 'xxgroupchatxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')} '),
                      ),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                                context, 'xxviewallxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxxgroupsxxx')} '),
                        tasksubtitle:
                            getTranslatedForCurrentUser(context, 'xxglobalxx'),
                        key1secondadmin:
                            Dbkeys.secondadminCanViewAllGlobalgroups,
                        key4departemtmanager:
                            Dbkeys.departmentManagerCanViewAllGlobalgroups,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                                context, 'xxviewonlyxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxxgroupsxxx')} '),
                        tasksubtitle: isdepartmentbased
                            ? getTranslatedForCurrentUser(
                                context, 'xxonlywithindeptxx')
                            : getTranslatedForCurrentUser(context, 'xxiamxxxx')
                                .replaceAll('(####)',
                                    '${getTranslatedForCurrentUser(context, 'xxagentxx')} '),

                        key1secondadmin:
                            Dbkeys.secondadminCanViewDepartmentGroups,
                        key4departemtmanager:
                            Dbkeys.departmentManagerCanViewDepartmentGroups,

                        // key3customer: Dbkeys.agentCanCreateBroadcastToAgents,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                                context, 'xxcreatexx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxxgroupsxxx')} '),
                        key1secondadmin: Dbkeys.secondadminCanCreateAgentsGroup,
                        key4departemtmanager:
                            Dbkeys.departmentManagerCanCreateAgentsGroup,
                        key2agent: Dbkeys.agentsCanCreateAgentsGroup,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                    ]),

                    // //* -------------------------------

                    Column(children: [
                      sectionHeader(
                          getTranslatedForCurrentUser(context, 'xxagentchatsxx')
                              .toUpperCase()),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                                context, 'xxviewallxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(context, 'xxagentchatsxx')}'),
                        tasksubtitle:
                            getTranslatedForCurrentUser(context, 'xxglobalxx'),
                        key1secondadmin:
                            Dbkeys.secondadminCanViewAllGlobalChats,
                        key4departemtmanager:
                            Dbkeys.departmentManagerCanViewAllGlobalChats,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                      RoleColumn(
                        taskname: getTranslatedForCurrentUser(
                            context, 'xxxstartnewchatxxx'),
                        tasksubtitle: getTranslatedForCurrentUser(
                            context, 'xxxviewmychatxxx'),

                        key1secondadmin:
                            Dbkeys.secondadminCancreateandViewNewIndividualChat,
                        key4departemtmanager: Dbkeys
                            .departmentmanagerCancreateandViewNewIndividualChat,
                        key2agent:
                            Dbkeys.agentCancreateandViewNewIndividualChat,
                        // key3customer: Dbkeys.agentCanCreateBroadcastToAgents,
                        onSelect: (m, k, v) async {
                          await updateInFirestore(m, k, v);
                        },
                        isDepartmentBased:
                            userAppSettings!.departmentBasedContent!,
                        latestsettings: userAppSettings!.toMap(),
                      ),
                    ]),
                    // //* -------------------------------
                    // Column(children: [
                    //   sectionHeader('BROADCAST LIST'),
                    //   RoleColumn(
                    //     taskname: "View All Broadcast List",
                    //     tasksubtitle:
                    //         getTranslatedForCurrentUser(context, 'xxglobalxx'),
                    //     key1secondadmin:
                    //         Dbkeys.secondadminCanViewGloabalBroadcast,
                    //     key4departemtmanager:
                    //         Dbkeys.departmentmanagerCanViewGloabalBroadcast,
                    //     // key2agent: Dbkeys.agentcanseecustomernameandphoto,
                    //     // key3customer: Dbkeys.agentCanCreateBroadcastToAgents,
                    //     onSelect: (m, k, v) async {
                    //       await updateInFirestore(m, k, v);
                    //     },
                    //     isDepartmentBased:
                    //         userAppSettings!.departmentBasedContent!,
                    //     latestsettings: userAppSettings!.toMap(),
                    //   ),
                    //   RoleColumn(
                    //     taskname: "Create / View\nBroadcast List",
                    //     tasksubtitle: "Own Created",
                    //     key1secondadmin:
                    //         Dbkeys.secondadminCanCreateBroadcastToAgents,
                    //     key4departemtmanager:
                    //         Dbkeys.departmentmanagerCanCreateBroadcastToAgents,
                    //     key2agent: Dbkeys.agentCanCreateBroadcastToAgents,
                    //     // key3customer: Dbkeys.agentCanCreateBroadcastToAgents,
                    //     onSelect: (m, k, v) async {
                    //       await updateInFirestore(m, k, v);
                    //     },
                    //     isDepartmentBased:
                    //         userAppSettings!.departmentBasedContent!,
                    //     latestsettings: userAppSettings!.toMap(),
                    //   ),
                    //   RoleColumn(
                    //     taskname: "Delete Broadcast List",
                    //     tasksubtitle: "Own",
                    //     key1secondadmin: Dbkeys.secondadminCanDeleteBroadcast,
                    //     key4departemtmanager:
                    //         Dbkeys.departmentmanagerCanDeleteBroadcast,
                    //     key2agent: Dbkeys.agentCanDeleteBroadcast,
                    //     // key3customer: Dbkeys.agentCanCreateBroadcastToAgents,
                    //     onSelect: (m, k, v) async {
                    //       await updateInFirestore(m, k, v);
                    //     },
                    //     isDepartmentBased:
                    //         userAppSettings!.departmentBasedContent!,
                    //     latestsettings: userAppSettings!.toMap(),
                    //   ),
                    // ]),

                    SizedBox(
                      height: 30,
                    ),
                  ]));
  }
}
