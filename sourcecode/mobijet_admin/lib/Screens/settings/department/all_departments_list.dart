import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/number_limits.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/department_model.dart';
import 'package:thinkcreative_technologies/Models/userapp_settings_model.dart';
import 'package:thinkcreative_technologies/Screens/settings/department/add_agents_to_department.dart';
import 'package:thinkcreative_technologies/Screens/settings/department/department_details.dart';
import 'package:thinkcreative_technologies/Screens/settings/department/set_department_manager.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseApi.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/Input_box.dart';
import 'package:thinkcreative_technologies/Widgets/custom_buttons.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Widgets/nodata_widget.dart';

class AllDepartmentList extends StatefulWidget {
  final String currentuserid;
  final Function onbackpressed;
  final bool isShowForSignleAgent;
  final String filteragentid;
  const AllDepartmentList(
      {Key? key,
      required this.currentuserid,
      required this.filteragentid,
      required this.onbackpressed,
      required this.isShowForSignleAgent})
      : super(key: key);

  @override
  _AllDepartmentListState createState() => _AllDepartmentListState();
}

class _AllDepartmentListState extends State<AllDepartmentList> {
  DocumentReference docRef = FirebaseFirestore.instance
      .collection(DbPaths.userapp)
      .doc(DbPaths.appsettings);

  String error = "";
  bool isloading = true;
  UserAppSettingsModel? userAppSettings;
  List<dynamic> departments = [];
  final TextEditingController _textEditingController =
      new TextEditingController();
  @override
  void initState() {
    super.initState();
    ctx = ctx ?? this.context;
    fetchdata();
  }

  BuildContext? ctx;

  fetchdata() async {
    await docRef.get().then((dc) async {
      if (dc.exists) {
        userAppSettings = UserAppSettingsModel.fromSnapshot(dc);
        departments = userAppSettings!.departmentList!.reversed.toList();
        if (widget.isShowForSignleAgent == true) {
          departments = departments
              .where((element) => element[Dbkeys.departmentAgentsUIDList]
                  .contains(widget.filteragentid))
              .toList();
        }
        if (Optionalconstants.isEditDefaultDepartment == false) {
          departments.removeLast();
        }

        setState(() {
          isloading = false;
        });
      } else {
        setState(() {
          error = getTranslatedForCurrentUser(
              ctx ?? this.context, 'xxuserappsetupincompletexx');
        });
      }
    }).catchError((onError) {
      setState(() {
        error =
            "${getTranslatedForCurrentUser(ctx ?? this.context, 'xxuserappsetupincompletexx')}. $onError";

        isloading = false;
      });
    });

    final observer = Provider.of<Observer>(ctx ?? this.context, listen: false);
    observer.fetchUserAppSettings(context);
  }

  addNewDepartment(BuildContext context) async {
    var registry =
        Provider.of<UserRegistry>(ctx ?? this.context, listen: false);

    await pageOpenOnTop(
        ctx ?? this.context,
        AddAgentsToDepartment(
          isdepartmentalreadycreated: false,
          agents: registry.agents,
          onselectagents: (agentids, agentmodels) async {
            await pageOpenOnTop(
                ctx ?? this.context,
                SetDepartmentManager(
                  selecteduser: (manager) {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: ctx ?? this.context,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25.0)),
                        ),
                        builder: (BuildContext context) {
                          // return your layout
                          var w = MediaQuery.of(context).size.width;
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                                padding: EdgeInsets.all(16),
                                height: MediaQuery.of(context).size.height >
                                        MediaQuery.of(context).size.width
                                    ? MediaQuery.of(context).size.height / 2
                                    : MediaQuery.of(context).size.height / 1.6,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                        height: 12,
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 7),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslatedForCurrentUser(
                                                      ctx ?? this.context,
                                                      'xxaddnewxxxx')
                                                  .replaceAll('(####)',
                                                      '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')}'),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.5),
                                            ),
                                            SizedBox(
                                              height: 18,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  EvaIcons.person,
                                                  color: Mycolors.secondary,
                                                ),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  (agentids.length).toString() +
                                                      " ${getTranslatedForCurrentUser(ctx ?? this.context, 'xxagentsxx')} ${getTranslatedForCurrentUser(ctx ?? this.context, 'xxselectedxx')}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13.5),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentmanagerxx')} ",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Mycolors.secondary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13.5),
                                                ),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  manager.fullname,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13.5),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        // height: 63,
                                        height: 93,
                                        width: w / 1.24,
                                        child: InpuTextBox(
                                          controller: _textEditingController,
                                          leftrightmargin: 0,
                                          showIconboundary: false,
                                          maxcharacters: Numberlimits
                                              .maxdepartmenttitlechar,
                                          boxcornerradius: 5.5,
                                          boxheight: 70,
                                          hinttext:
                                              "${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(ctx ?? this.context, 'xxtitlexx')}",
                                          prefixIconbutton: Icon(
                                            Icons.location_city,
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      MySimpleButton(
                                        buttontext: getTranslatedForCurrentUser(
                                                ctx ?? this.context,
                                                'xxaddnewxxxx')
                                            .replaceAll('(####)',
                                                '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')}'),
                                        onpressed:
                                            AppConstants.isdemomode == true
                                                ? () {
                                                    Utils.toast(
                                                        getTranslatedForCurrentUser(
                                                            ctx ?? this.context,
                                                            'xxxnotalwddemoxxaccountxx'));
                                                  }
                                                : () async {
                                                    if (_textEditingController
                                                            .text
                                                            .trim()
                                                            .length <
                                                        2) {
                                                      Utils.toast(
                                                        getTranslatedForCurrentUser(
                                                               ctx?? this.context,
                                                                'xxvalidxxxx')
                                                            .replaceAll(
                                                                '(####)',
                                                                '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxtitlexx')}'),
                                                      );
                                                    } else if (_textEditingController
                                                                .text
                                                                .trim() ==
                                                            "Default" ||
                                                        _textEditingController
                                                                .text
                                                                .trim() ==
                                                            "default") {
                                                      Utils.toast(
                                                          getTranslatedForCurrentUser(
                                                              ctx ??
                                                                  this.context,
                                                              'xxxthisdefaulttitlexxx'));
                                                    } else if (_textEditingController
                                                            .text
                                                            .trim()
                                                            .length >
                                                        Numberlimits
                                                            .maxdepartmenttitlechar) {
                                                      Utils.toast(
                                                        getTranslatedForCurrentUser(
                                                                ctx ??
                                                                    this
                                                                        .context,
                                                                'xxmaxxxcharxx')
                                                            .replaceAll(
                                                                '(####)',
                                                                '${Numberlimits.maxdepartmenttitlechar}'),
                                                      );
                                                    } else {
                                                      Navigator.of(ctx ??
                                                              this.context)
                                                          .pop();
                                                      setState(() {
                                                        isloading = true;
                                                      });
                                                      int epoch = DateTime.now()
                                                          .millisecondsSinceEpoch;
                                                      await docRef
                                                          .get()
                                                          .then((value) async {
                                                        if (value.exists) {
                                                          UserAppSettingsModel
                                                              userAppSettingsModel =
                                                              UserAppSettingsModel
                                                                  .fromSnapshot(
                                                                      value);
                                                          if (userAppSettingsModel.departmentList!.indexWhere((element) =>
                                                                      element[Dbkeys
                                                                              .departmentTitle]
                                                                          .toString()
                                                                          .toLowerCase()
                                                                          .trim() ==
                                                                      _textEditingController
                                                                          .text
                                                                          .trim()
                                                                          .toLowerCase()) >=
                                                                  0 ||
                                                              _textEditingController
                                                                      .text
                                                                      .trim() ==
                                                                  "Default" ||
                                                              _textEditingController
                                                                      .text
                                                                      .trim() ==
                                                                  "default") {
                                                            setState(() {
                                                              isloading = false;
                                                            });
                                                            Utils.toast(
                                                              getTranslatedForCurrentUser(
                                                                      this
                                                                          .context,
                                                                      'xxxfailedtocreatexxxx')
                                                                  .replaceAll(
                                                                      '(####)',
                                                                      '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')}'),
                                                            );
                                                          } else {
                                                            await docRef.update({
                                                              Dbkeys.departmentList:
                                                                  FieldValue
                                                                      .arrayUnion([
                                                                DepartmentModel(
                                                                        departmentManagerID: manager
                                                                            .id,
                                                                        departmentExtraMap1: {},
                                                                        departmentExtraMap2: {},
                                                                        departmentLogoURL:
                                                                            "",
                                                                        departmentLastEditedby: widget
                                                                            .currentuserid,
                                                                        departmentTitle: _textEditingController
                                                                            .text
                                                                            .trim(),
                                                                        departmentDesc:
                                                                            "",
                                                                        departmentAgentsUIDList:
                                                                            agentids,
                                                                        departmentIsShow:
                                                                            true,
                                                                        departmentCreatedby: widget
                                                                            .currentuserid,
                                                                        departmentLastEditedOn:
                                                                            epoch,
                                                                        departmentCreatedTime:
                                                                            epoch)
                                                                    .toMap()
                                                              ])
                                                            }).then(
                                                                (value) async {
                                                              await FirebaseApi
                                                                  .runTransactionRecordActivity(
                                                                      parentid:
                                                                          "DEPT--$epoch",
                                                                      isOnlyAlertNotSave:
                                                                          false,
                                                                      title: getTranslatedForCurrentUser(ctx ?? this.context, 'xxnewxxcreatedxx').replaceAll(
                                                                          '(####)',
                                                                          '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')}'),
                                                                      plainDesc: getTranslatedForCurrentUser(
                                                                              this
                                                                                  .context,
                                                                              'xxcreatedbyxx')
                                                                          .replaceAll(
                                                                              '(####)',
                                                                              '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')} ${_textEditingController.text.trim()}')
                                                                          .replaceAll(
                                                                              '(###)',
                                                                              '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxadminxx')}'),
                                                                      onErrorFn:
                                                                          (e) {
                                                                        _textEditingController
                                                                            .clear();
                                                                        setState(
                                                                            () {
                                                                          isloading =
                                                                              false;
                                                                        });

                                                                        Utils.toast(
                                                                            "${getTranslatedForCurrentUser(ctx ?? this.context, 'xxfailedxx')}. $e");
                                                                      },
                                                                      postedbyID:
                                                                          widget
                                                                              .currentuserid,
                                                                      onSuccessFn:
                                                                          () {
                                                                        _textEditingController
                                                                            .clear();
                                                                        fetchdata();
                                                                        agentids
                                                                            .forEach((element) {
                                                                          Utils.sendDirectNotification(
                                                                              title: getTranslatedForCurrentUser(ctx ?? this.context, 'xxxaddedtothisdeptxxx'.replaceAll('(####)', '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')}')),
                                                                              parentID: "DEPT--$epoch",
                                                                              plaindesc: getTranslatedForCurrentUser(ctx ?? this.context, 'xxxyouareaddeddeptxx').replaceAll('(####)', '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')} ${_textEditingController.text.trim()} '),
                                                                              docRef: FirebaseFirestore.instance.collection(DbPaths.collectionagents).doc(element).collection(DbPaths.agentnotifications).doc(DbPaths.agentnotifications),
                                                                              postedbyID: widget.currentuserid);
                                                                        });
                                                                      });
                                                            });
                                                          }
                                                        } else {
                                                          setState(() {
                                                            isloading = false;
                                                            error =
                                                                "User app settings does not exists";
                                                          });
                                                        }
                                                      });
                                                    }
                                                  },
                                      ),
                                    ])),
                          );
                        });
                  },
                  agents: agentmodels,
                  alreadyselecteduserid: "",
                ));
          },
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      leadingIconData: LineAwesomeIcons.arrow_left,
      leadingIconPress: () {
        Navigator.of(context).pop();
        widget.onbackpressed();
      },
      icondata1: Icons.add,
      icon1press: () async {
        await addNewDepartment(context);
      },
      title: departments.length.toString() == "0"
          ? "${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentsxx')}"
          : departments.length == 1
              ? "1 ${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')}"
              : "${departments.length.toString()} ${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentsxx')}",
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
              : departments.length == 0
                  ? Center(
                      child: noDataWidget(
                        context: ctx ?? this.context,
                        iconData: Icons.location_city_rounded,
                        title: getTranslatedForCurrentUser(
                                ctx ?? this.context, 'xxnoxxavailabletoaddxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')}'),
                        subtitle: getTranslatedForCurrentUser(
                                ctx ?? this.context, 'xxaddxxandxxxx')
                            .replaceAll('(####)',
                                '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')}')
                            .replaceAll('(###)',
                                '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxmanagerxx')}')
                            .replaceAll('(##)',
                                '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxagentxx')}'),
                      ),
                    )
                  : ListView.builder(
                      itemCount: departments.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Card(
                          elevation: 0.2,
                          color:
                              departments[i][Dbkeys.departmentIsShow] == false
                                  ? Colors.red[50]
                                  : Colors.white,
                          margin: EdgeInsets.fromLTRB(4, 8, 4, 2),
                          child: ListTile(
                              onTap: () {
                                pageNavigator(
                                    ctx ?? this.context,
                                    DepartmentDetails(
                                        currentuserid: widget.currentuserid,
                                        onrefreshPreviousPage: () {
                                          fetchdata();
                                        },
                                        departmentID: departments[i]
                                                [Dbkeys.departmentTitle]
                                            .toString()));
                              },
                              trailing: IconButton(
                                  onPressed: () {
                                    pageNavigator(
                                        ctx ?? this.context,
                                        DepartmentDetails(
                                            currentuserid: widget.currentuserid,
                                            onrefreshPreviousPage: () {
                                              fetchdata();
                                            },
                                            departmentID: departments[i]
                                                    [Dbkeys.departmentTitle]
                                                .toString()));
                                  },
                                  icon:
                                      Icon(Icons.keyboard_arrow_right_rounded)),
                              contentPadding: EdgeInsets.fromLTRB(5, 8, 2, 8),
                              title: MtCustomfontRegular(
                                fontsize: 16,
                                color: Mycolors.black,
                                lineheight: 1.3,
                                text: departments[i][Dbkeys.departmentTitle],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MtCustomfontRegular(
                                        fontsize: 13,
                                        text: departments[i][Dbkeys
                                                        .departmentAgentsUIDList]
                                                    .length ==
                                                1
                                            ? "1 ${getTranslatedForCurrentUser(ctx ?? this.context, 'xxagentxx')}"
                                            : departments[i][Dbkeys
                                                        .departmentAgentsUIDList]
                                                    .length
                                                    .toString() +
                                                " ${getTranslatedForCurrentUser(ctx ?? this.context, 'xxagentsxx')} "),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        departments[i]
                                                    [Dbkeys.departmentIsShow] ==
                                                true
                                            ? SizedBox()
                                            : Icon(
                                                Icons.visibility_off,
                                                size: 13,
                                                color: Mycolors.red,
                                              ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        FlutterSwitch(
                                            activeColor: Mycolors.green,
                                            inactiveColor: Mycolors.red,
                                            width: 36,
                                            toggleSize: 10,
                                            height: 17,
                                            value: departments[i]
                                                [Dbkeys.departmentIsShow],
                                            onToggle: (cv) async {
                                              ShowConfirmDialog().open(
                                                  context: ctx ?? this.context,
                                                  subtitle: departments[i][Dbkeys
                                                              .departmentIsShow] ==
                                                          true
                                                      ? getTranslatedForCurrentUser(
                                                              ctx ??
                                                                  this.context,
                                                              'xxareusurehidexx')
                                                          .replaceAll(
                                                              '(####)',
                                                              getTranslatedForCurrentUser(
                                                                  ctx ??
                                                                      this
                                                                          .context,
                                                                  'xxagentsxx'))
                                                          .replaceAll(
                                                              '(###)',
                                                              getTranslatedForCurrentUser(
                                                                  ctx ??
                                                                      this
                                                                          .context,
                                                                  'xxcustomersxx'))
                                                      : getTranslatedForCurrentUser(
                                                              ctx ??
                                                                  this.context,
                                                              'xxareusurelivexx')
                                                          .replaceAll(
                                                              '(####)',
                                                              getTranslatedForCurrentUser(
                                                                  ctx ??
                                                                      this
                                                                          .context,
                                                                  'xxagentsxx'))
                                                          .replaceAll(
                                                              '(###)',
                                                              getTranslatedForCurrentUser(
                                                                  ctx ??
                                                                      this
                                                                          .context,
                                                                  'xxcustomersxx')),
                                                  title:
                                                      getTranslatedForCurrentUser(
                                                          ctx ?? this.context,
                                                          'xxconfirmquesxx'),
                                                  rightbtnonpress:
                                                      AppConstants.isdemomode ==
                                                              true
                                                          ? () {
                                                              Utils.toast(getTranslatedForCurrentUser(
                                                                  ctx ??
                                                                      this.context,
                                                                  'xxxnotalwddemoxxaccountxx'));
                                                            }
                                                          : () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              if (departments[i]
                                                                          [
                                                                          Dbkeys
                                                                              .departmentIsShow] ==
                                                                      false &&
                                                                  departments[i]
                                                                              [
                                                                              Dbkeys.departmentAgentsUIDList]
                                                                          .length <
                                                                      1) {
                                                                Utils.toast(getTranslatedForCurrentUser(
                                                                        this
                                                                            .context,
                                                                        'xxaddxxtoxxtobexx')
                                                                    .replaceAll(
                                                                        '(####)',
                                                                        getTranslatedForCurrentUser(
                                                                            this
                                                                                .context,
                                                                            'xxagentsxx'))
                                                                    .replaceAll(
                                                                        '(###)',
                                                                        getTranslatedForCurrentUser(
                                                                            this
                                                                                .context,
                                                                            'xxdepartmentxx'))
                                                                    .replaceAll(
                                                                        '(##)',
                                                                        getTranslatedForCurrentUser(
                                                                            ctx ??
                                                                                this.context,
                                                                            'xxcustomersxx')));
                                                              } else {
                                                                setState(() {
                                                                  isloading =
                                                                      true;
                                                                });
                                                                await FirebaseApi
                                                                    .runUPDATEmapobjectinListField(
                                                                        compareKey:
                                                                            Dbkeys
                                                                                .departmentTitle,
                                                                        compareVal:
                                                                            departments[i][Dbkeys
                                                                                .departmentTitle],
                                                                        docrefdata:
                                                                            docRef,
                                                                        replaceableMapObjectWithOnlyFieldsRequired: {
                                                                          Dbkeys.departmentIsShow:
                                                                              !departments[i][Dbkeys.departmentIsShow],
                                                                          Dbkeys.departmentLastEditedOn:
                                                                              DateTime.now().millisecondsSinceEpoch
                                                                        },
                                                                        context:
                                                                            this
                                                                                .context,
                                                                        listkeyname:
                                                                            Dbkeys
                                                                                .departmentList,
                                                                        onSuccessFn:
                                                                            () async {
                                                                          await FirebaseApi.runTransactionRecordActivity(
                                                                              isOnlyAlertNotSave: false,
                                                                              parentid: "DEPT--${departments[i][Dbkeys.departmentTitle]}",
                                                                              title: getTranslatedForCurrentUser(ctx ?? this.context, 'xxxstatusupdatedxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')}'),
                                                                              plainDesc: departments[i][Dbkeys.departmentIsShow] == true ? getTranslatedForCurrentUser(ctx ?? this.context, 'xxxstatusupdatedlongxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')} ${departments[i][Dbkeys.departmentTitle]}').replaceAll('(###)', '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxhiddenxx')} ${getTranslatedForCurrentUser(ctx ?? this.context, 'xxxbyxxx')} ${getTranslatedForCurrentUser(ctx ?? this.context, 'xxadminxx')}') : getTranslatedForCurrentUser(ctx ?? this.context, 'xxxstatusupdatedlongxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxdepartmentxx')} ${departments[i][Dbkeys.departmentTitle]}').replaceAll('(###)', '${getTranslatedForCurrentUser(ctx ?? this.context, 'xxlivexx')}  ${getTranslatedForCurrentUser(ctx ?? this.context, 'xxxbyxxx')} ${getTranslatedForCurrentUser(ctx ?? this.context, 'xxadminxx')}'),
                                                                              onErrorFn: (e) {
                                                                                _textEditingController.clear();
                                                                                fetchdata();

                                                                                Utils.toast("${getTranslatedForCurrentUser(ctx ?? this.context, 'xxfailedxx')} $e");
                                                                              },
                                                                              postedbyID: widget.currentuserid,
                                                                              onSuccessFn: () {
                                                                                _textEditingController.clear();
                                                                                fetchdata();
                                                                              });
                                                                        },
                                                                        onErrorFn:
                                                                            (String
                                                                                s) {
                                                                          setState(
                                                                              () {
                                                                            isloading =
                                                                                false;
                                                                          });
                                                                          Utils.toast(
                                                                              "${getTranslatedForCurrentUser(ctx ?? this.context, 'xxfailedxx')} $s");
                                                                        });
                                                              }
                                                            });
                                            }),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              leading: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: departments[i]
                                            [Dbkeys.departmentLogoURL] ==
                                        ""
                                    ? Utils.squareAvatarIcon(
                                        backgroundColor: Utils
                                            .randomColorgenratorBasedOnFirstLetter(
                                                departments[i]
                                                    [Dbkeys.departmentTitle]),
                                        iconData: Icons.location_city,
                                        size: 55)
                                    : Utils.squareAvatarImage(
                                        url: departments[i]
                                            [Dbkeys.departmentLogoURL],
                                        size: 55),
                              )),
                        );
                      }),
    );
  }
}
