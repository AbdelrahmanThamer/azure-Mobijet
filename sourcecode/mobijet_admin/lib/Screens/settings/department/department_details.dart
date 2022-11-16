//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/department_model.dart';
import 'package:thinkcreative_technologies/Models/ticket_model.dart';
import 'package:thinkcreative_technologies/Models/user_registry_model.dart';
import 'package:thinkcreative_technologies/Models/userapp_settings_model.dart';
import 'package:thinkcreative_technologies/Screens/activity/filtered_activity_history.dart';
import 'package:thinkcreative_technologies/Screens/settings/department/add_agents_to_department.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/ticket_chat_room.dart';
import 'package:thinkcreative_technologies/Screens/tickets/ticketWidget.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseApi.dart';
import 'package:thinkcreative_technologies/Services/my_providers/liveListener.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Utils/custom_time_formatter.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/Input_box.dart';
import 'package:thinkcreative_technologies/Widgets/WarningWidgets/warning_tile.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/Avatar.dart';
import 'package:thinkcreative_technologies/Widgets/custom_buttons.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/late_load.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Widgets/nodata_widget.dart';
import 'package:thinkcreative_technologies/Widgets/others/userrole_based_sticker.dart';
import 'package:thinkcreative_technologies/Widgets/pickers/ImagePicker/image_picker.dart';

class DepartmentDetails extends StatefulWidget {
  final String departmentID;
  final String currentuserid;
  final Function onrefreshPreviousPage;

  const DepartmentDetails(
      {Key? key,
      required this.departmentID,
      required this.currentuserid,
      required this.onrefreshPreviousPage})
      : super(key: key);

  @override
  _DepartmentDetailsState createState() => _DepartmentDetailsState();
}

class _DepartmentDetailsState extends State<DepartmentDetails> {
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

  getImage(File image) {
    // ignore: unnecessary_null_comparison
    if (image != null) {
      setState(() {
        imageFile = image;
      });
    }
    return uploadFile(false);
  }

  int? uploadTimestamp;
  int? thumnailtimestamp;
  Future uploadFile(bool isthumbnail) async {
    uploadTimestamp = DateTime.now().millisecondsSinceEpoch;
    String fileName = 'DEPARTMENT_ICON';
    Reference reference = FirebaseStorage.instance
        .ref("+00_DEPARTMENT_MEDIA/${widget.departmentID}/")
        .child(fileName);
    TaskSnapshot uploading = await reference.putFile(imageFile!);
    if (isthumbnail == false) {
      setState(() {
        thumnailtimestamp = uploadTimestamp;
      });
    }

    return uploading.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

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
        actions: <Widget>[
          isloading == true
              ? SizedBox()
              : department!.departmentIsShow == true
                  ? Chip(
                      backgroundColor: Mycolors.green.withOpacity(0.1),
                      label: Text(
                        getTranslatedForCurrentUser(context, 'xxlivexx'),
                        style: TextStyle(color: Mycolors.green),
                      ))
                  : Chip(
                      backgroundColor: Mycolors.greytext.withOpacity(0.1),
                      label: Text(
                        getTranslatedForCurrentUser(context, 'xxhiddenxx'),
                        style: TextStyle(color: Mycolors.grey),
                      )),
          SizedBox(
            width: 10,
          ),
        ],
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
                text: getTranslatedForCurrentUser(context, 'xxdepartmentxx'),
                fontsize: 17,
                color: Mycolors.black,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "${getTranslatedForCurrentUser(context, 'xxidxx')} ${widget.departmentID}",
                style: TextStyle(
                    color: Mycolors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
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
                          Stack(
                            children: [
                              CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl: department!.departmentLogoURL,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: w,
                                  height: w / 1.2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Mycolors.white),
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(0.0),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: w,
                                  height: w / 1.2,
                                  decoration: BoxDecoration(
                                    color: Utils
                                        .randomColorgenratorBasedOnFirstLetter(
                                            department!.departmentTitle),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Icon(Icons.location_city,
                                      color: Mycolors.white.withOpacity(0.7),
                                      size: 75),
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                width: w,
                                height: w / 1.2,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(
                                      department!.departmentLogoURL == ""
                                          ? 0.0
                                          : 0.4),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      department!.departmentLogoURL == ""
                                          ? IconButton(
                                              onPressed:
                                                  AppConstants.isdemomode ==
                                                          true
                                                      ? () {
                                                          Utils.toast(
                                                              getTranslatedForCurrentUser(
                                                                  context,
                                                                  'xxxnotalwddemoxxaccountxx'));
                                                        }
                                                      : () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      SingleImagePicker(
                                                                        recommendedsize:
                                                                            "200 X 200 px (.jpg or .png)",
                                                                        title: getTranslatedForCurrentUser(
                                                                            context,
                                                                            'xxpickimagexx'),
                                                                        callback:
                                                                            getImage,
                                                                      ))).then(
                                                              (url) async {
                                                            if (url != null) {
                                                              Utils.toast(
                                                                  getTranslatedForCurrentUser(
                                                                      context,
                                                                      'xxplswaitxx'));
                                                              ShowLoading().open(
                                                                  context:
                                                                      context,
                                                                  key:
                                                                      _keyLoader223);
                                                              await FirebaseApi
                                                                  .runUPDATEmapobjectinListField(
                                                                      compareKey:
                                                                          Dbkeys
                                                                              .departmentTitle,
                                                                      compareVal:
                                                                          department!
                                                                              .departmentTitle,
                                                                      docrefdata:
                                                                          docRef,
                                                                      replaceableMapObjectWithOnlyFieldsRequired: {
                                                                        Dbkeys.departmentLogoURL:
                                                                            url,
                                                                        Dbkeys
                                                                            .departmentLastEditedOn: DateTime
                                                                                .now()
                                                                            .millisecondsSinceEpoch
                                                                      },
                                                                      context:
                                                                          context,
                                                                      listkeyname:
                                                                          Dbkeys
                                                                              .departmentList,
                                                                      onSuccessFn:
                                                                          () async {
                                                                        await FirebaseApi.runTransactionRecordActivity(
                                                                            isOnlyAlertNotSave: false,
                                                                            parentid: "DEPT--${widget.departmentID}",
                                                                            title: getTranslatedForCurrentUser(context, 'xxxlogoupdatedshortxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(context, 'xxidxx')}${department!.departmentCreatedby}'),
                                                                            plainDesc: getTranslatedForCurrentUser(context, 'xxxlogoupdatedxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(context, 'xxidxx')}${department!.departmentCreatedby}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
                                                                            imageurl: url,
                                                                            onErrorFn: (e) {
                                                                              ShowLoading().close(context: context, key: _keyLoader223);
                                                                              _textEditingController.clear();
                                                                              fetchdata();
                                                                              widget.onrefreshPreviousPage();
                                                                              Utils.toast("${getTranslatedForCurrentUser(context, 'xxfailedxx')} ERROR: $e");
                                                                            },
                                                                            postedbyID: widget.currentuserid,
                                                                            onSuccessFn: () {
                                                                              ShowLoading().close(context: context, key: _keyLoader223);
                                                                              _textEditingController.clear();
                                                                              fetchdata();
                                                                              widget.onrefreshPreviousPage();
                                                                            });
                                                                      },
                                                                      onErrorFn:
                                                                          (String
                                                                              s) {
                                                                        ShowLoading().close(
                                                                            context:
                                                                                context,
                                                                            key:
                                                                                _keyLoader223);
                                                                        setState(
                                                                            () {
                                                                          isloading =
                                                                              false;
                                                                        });
                                                                        Utils.toast(
                                                                            "${getTranslatedForCurrentUser(context, 'xxfailedxx')}. Error log: $s");
                                                                      });
                                                            }
                                                          });
                                                        },
                                              icon: Icon(
                                                  Icons.camera_alt_rounded,
                                                  color: Mycolors.white,
                                                  size: 35),
                                            )
                                          : IconButton(
                                              onPressed: () async {
                                                ShowConfirmDialog().open(
                                                    context: context,
                                                    subtitle:
                                                        getTranslatedForCurrentUser(
                                                            context,
                                                            'xxremovesurexx'),
                                                    title:
                                                        getTranslatedForCurrentUser(
                                                            context,
                                                            'xxconfirmquesxx'),
                                                    rightbtnonpress: AppConstants
                                                                .isdemomode ==
                                                            true
                                                        ? () {
                                                            Utils.toast(
                                                                getTranslatedForCurrentUser(
                                                                    context,
                                                                    'xxxnotalwddemoxxaccountxx'));
                                                          }
                                                        : () async {
                                                            Navigator.pop(
                                                                context);
                                                            ShowLoading().open(
                                                                context:
                                                                    context,
                                                                key:
                                                                    _keyLoader223);
                                                            await FirebaseApi
                                                                    .deleteFirebaseMediaUsingURL(
                                                                        department!
                                                                            .departmentLogoURL)
                                                                .then(
                                                                    (status) async {
                                                              if (status
                                                                      is bool ||
                                                                  status ==
                                                                      null) {
                                                                if (status ==
                                                                        true ||
                                                                    status ==
                                                                        null) {
                                                                  await FirebaseApi.runUPDATEmapobjectinListField(
                                                                      compareKey: Dbkeys.departmentTitle,
                                                                      compareVal: department!.departmentTitle,
                                                                      docrefdata: docRef,
                                                                      replaceableMapObjectWithOnlyFieldsRequired: {
                                                                        Dbkeys.departmentLogoURL:
                                                                            "",
                                                                        Dbkeys
                                                                            .departmentLastEditedOn: DateTime
                                                                                .now()
                                                                            .millisecondsSinceEpoch
                                                                      },
                                                                      context: context,
                                                                      listkeyname: Dbkeys.departmentList,
                                                                      onSuccessFn: () async {
                                                                        await FirebaseApi.runTransactionRecordActivity(
                                                                            isOnlyAlertNotSave: false,
                                                                            parentid: "DEPT--${widget.departmentID}",
                                                                            title: getTranslatedForCurrentUser(context, 'xxxlogoremovedshortxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${department!.departmentTitle}'),
                                                                            plainDesc: getTranslatedForCurrentUser(context, 'xxxlogoremovedxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${department!.departmentTitle}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
                                                                            imageurl: "",
                                                                            onErrorFn: (e) {
                                                                              ShowLoading().close(context: context, key: _keyLoader223);
                                                                              _textEditingController.clear();
                                                                              fetchdata();
                                                                              widget.onrefreshPreviousPage();
                                                                              Utils.toast("${getTranslatedForCurrentUser(context, 'xxfailedxx')} ERROR: $e");
                                                                            },
                                                                            postedbyID: widget.currentuserid,
                                                                            onSuccessFn: () {
                                                                              ShowLoading().close(context: context, key: _keyLoader223);
                                                                              _textEditingController.clear();
                                                                              fetchdata();
                                                                              widget.onrefreshPreviousPage();
                                                                            });
                                                                      },
                                                                      onErrorFn: (String s) {
                                                                        ShowLoading().close(
                                                                            context:
                                                                                context,
                                                                            key:
                                                                                _keyLoader223);
                                                                        setState(
                                                                            () {
                                                                          isloading =
                                                                              false;
                                                                        });
                                                                        Utils.toast(
                                                                            "Error occured!. Error log: $s");
                                                                      });
                                                                } else {
                                                                  ShowLoading().close(
                                                                      context:
                                                                          context,
                                                                      key:
                                                                          _keyLoader223);
                                                                  Utils.toast(
                                                                      '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}');
                                                                }
                                                              } else {
                                                                ShowLoading().close(
                                                                    context:
                                                                        context,
                                                                    key:
                                                                        _keyLoader223);
                                                                Utils.toast(
                                                                    status);
                                                              }
                                                            });
                                                          });
                                              },
                                              icon: Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: Mycolors.white,
                                                  size: 35),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 25,
                                  left: 18,
                                  child: Container(
                                    width: w / 1.5,
                                    child: Text(
                                      department!.departmentTitle,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ],
                          ),
                          Container(
                            color: Colors.white,
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.fromLTRB(
                                10,
                                15,
                                15,
                                department!.departmentIsShow == false &&
                                        issecondaryloaderon == false
                                    ? 3
                                    : 18),
                            // decoration: boxDecoration(
                            //     bgColor: Colors.white, radius: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MtCustomfontBoldSemi(
                                      text: getTranslatedForCurrentUser(
                                          context, 'xxstatusxx'),
                                      fontsize: 16,
                                    ),
                                    Container(
                                      width:
                                          issecondaryloaderon == true ? 25 : 55,
                                      child: issecondaryloaderon == true
                                          ? minicircularProgress()
                                          : FlutterSwitch(
                                              activeColor: Mycolors.green,
                                              inactiveColor: Mycolors.red,
                                              toggleSize: 17,
                                              width: 47,
                                              height: 20,
                                              value:
                                                  department!.departmentIsShow,
                                              onToggle: (cv) async {
                                                ShowConfirmDialog().open(
                                                    context: context,
                                                    subtitle: department!.departmentIsShow == true
                                                        ? getTranslatedForCurrentUser(
                                                                context, 'xxareusurehidexx')
                                                            .replaceAll(
                                                                '(####)',
                                                                getTranslatedForCurrentUser(
                                                                    context, 'xxagentsxx'))
                                                            .replaceAll(
                                                                '(###)',
                                                                getTranslatedForCurrentUser(
                                                                    context, 'xxcustomersxx'))
                                                        : getTranslatedForCurrentUser(
                                                                context, 'xxareusurelivexx')
                                                            .replaceAll(
                                                                '(####)',
                                                                getTranslatedForCurrentUser(
                                                                    context, 'xxagentsxx'))
                                                            .replaceAll(
                                                                '(###)',
                                                                getTranslatedForCurrentUser(
                                                                    context, 'xxcustomersxx')),
                                                    title: getTranslatedForCurrentUser(
                                                        context, 'xxconfirmquesxx'),
                                                    rightbtnonpress:
                                                        AppConstants.isdemomode ==
                                                                true
                                                            ? () {
                                                                Utils.toast(
                                                                    getTranslatedForCurrentUser(
                                                                        context,
                                                                        'xxxnotalwddemoxxaccountxx'));
                                                              }
                                                            : () async {
                                                                Navigator.pop(
                                                                    context);

                                                                if (department!
                                                                            .departmentIsShow ==
                                                                        false &&
                                                                    department!
                                                                            .departmentAgentsUIDList
                                                                            .length <
                                                                        1) {
                                                                  Utils.toast(getTranslatedForCurrentUser(
                                                                          context,
                                                                          'xxaddxxtoxxtobexx')
                                                                      .replaceAll(
                                                                          '(####)',
                                                                          getTranslatedForCurrentUser(
                                                                              context,
                                                                              'xxagentsxx'))
                                                                      .replaceAll(
                                                                          '(###)',
                                                                          getTranslatedForCurrentUser(
                                                                              context,
                                                                              'xxdepartmentxx'))
                                                                      .replaceAll(
                                                                          '(##)',
                                                                          getTranslatedForCurrentUser(
                                                                              context,
                                                                              'xxcustomersxx')));
                                                                } else {
                                                                  setState(() {
                                                                    issecondaryloaderon =
                                                                        true;
                                                                  });
                                                                  await FirebaseApi.runUPDATEmapobjectinListField(
                                                                      compareKey: Dbkeys.departmentTitle,
                                                                      compareVal: department!.departmentTitle,
                                                                      docrefdata: docRef,
                                                                      replaceableMapObjectWithOnlyFieldsRequired: {
                                                                        Dbkeys.departmentIsShow:
                                                                            !department!.departmentIsShow,
                                                                        Dbkeys
                                                                            .departmentLastEditedOn: DateTime
                                                                                .now()
                                                                            .millisecondsSinceEpoch
                                                                      },
                                                                      context: context,
                                                                      listkeyname: Dbkeys.departmentList,
                                                                      onSuccessFn: () async {
                                                                        await FirebaseApi.runTransactionRecordActivity(
                                                                            isOnlyAlertNotSave: false,
                                                                            parentid: "DEPT--${widget.departmentID}",
                                                                            title: getTranslatedForCurrentUser(context, 'xxxstatusupdatedxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                                                            plainDesc: department!.departmentIsShow == true ? getTranslatedForCurrentUser(context, 'xxxstatusupdatedlongxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${department!.departmentTitle}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxhiddenxx')} ${getTranslatedForCurrentUser(context, 'xxxbyxxx')} ${getTranslatedForCurrentUser(context, 'xxadminxx')}') : getTranslatedForCurrentUser(context, 'xxxstatusupdatedlongxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${department!.departmentTitle}').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxlivexx')}  ${getTranslatedForCurrentUser(context, 'xxxbyxxx')} ${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
                                                                            onErrorFn: (e) {
                                                                              _textEditingController.clear();
                                                                              fetchdata();
                                                                              widget.onrefreshPreviousPage();
                                                                              Utils.toast("${getTranslatedForCurrentUser(context, 'xxfailedxx')} ERROR: $e");
                                                                            },
                                                                            postedbyID: widget.currentuserid,
                                                                            onSuccessFn: () {
                                                                              _textEditingController.clear();
                                                                              fetchdata();
                                                                              widget.onrefreshPreviousPage();
                                                                            });
                                                                      },
                                                                      onErrorFn: (String s) {
                                                                        setState(
                                                                            () {
                                                                          isloading =
                                                                              false;
                                                                        });
                                                                        Utils.toast(
                                                                            "Error occured!. Error log: $s");
                                                                      });
                                                                }
                                                              });
                                              }),
                                    )
                                  ],
                                ),
                                department!.departmentIsShow == false &&
                                        issecondaryloaderon == false
                                    ? warningTile(
                                        title: getTranslatedForCurrentUser(
                                                context, 'xxdeptnotvisiblexx')
                                            .replaceAll('(####)',
                                                '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                                            .replaceAll('(###)',
                                                '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')
                                            .replaceAll('(##)',
                                                '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                            .replaceAll('(#)',
                                                '${getTranslatedForCurrentUser(context, 'xxtktssxx')}'),
                                        warningTypeIndex:
                                            WarningType.error.index)
                                    : SizedBox(
                                        width: 0,
                                      ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslatedForCurrentUser(
                                          context, 'xxdescxx'),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Mycolors.secondary,
                                          fontSize: 15),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          editDescription(context,
                                              department!.departmentDesc);
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          size: 21,
                                          color: Mycolors.primary,
                                        ))
                                  ],
                                ),
                                Divider(),
                                SizedBox(
                                  height: 7,
                                ),
                                MtCustomfontRegular(
                                  text: department!.departmentDesc == ""
                                      ? getTranslatedForCurrentUser(
                                          context, 'xxnodescxx')
                                      : department!.departmentDesc,
                                  fontsize: 14,
                                  isitalic: department!.departmentDesc == "",
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          myinkwell(
                            onTap: () {
                              pageNavigator(
                                  context,
                                  FilteredActivityHistory(
                                    subtitle:
                                        "${getTranslatedForCurrentUser(context, 'xxdepartmentxx').toUpperCase()} ${getTranslatedForCurrentUser(context, 'xxidxx').toUpperCase()} " +
                                            widget.departmentID,
                                    isShowDesc: true,
                                    extrafieldid:
                                        "DEPT--" + widget.departmentID,
                                  ));
                            },
                            child: Chip(
                                backgroundColor: Mycolors.cyan,
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      EvaIcons.activity,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    MtCustomfontBoldSemi(
                                      fontsize: 13,
                                      text: getTranslatedForCurrentUser(
                                              context, 'xxtrackxxactivityxx')
                                          .replaceAll('(####)',
                                              '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                      color: Colors.white,
                                    )
                                  ],
                                )),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(context, 'xxxcreatedbyxx')}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Mycolors.secondary,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Divider(),
                                SizedBox(
                                  height: 7,
                                ),
                                department!.departmentCreatedby == "Admin"
                                    ? Text("Admin")
                                    : department!.departmentCreatedby ==
                                                "auto" ||
                                            department!.departmentCreatedby ==
                                                "sys"
                                        ? Text(getTranslatedForCurrentUser(
                                            context, 'xxsystemxx'))
                                        : ListTile(
                                            leading: avatar(
                                                imageUrl: registry
                                                    .getUserData(
                                                        context,
                                                        department!
                                                            .departmentCreatedby)
                                                    .photourl),
                                            title: Text(registry
                                                .getUserData(
                                                    context,
                                                    department!
                                                        .departmentCreatedby)
                                                .fullname),
                                            subtitle: Row(
                                              children: [
                                                MtCustomfontRegular(
                                                  fontsize: 13,
                                                  text: "${getTranslatedForCurrentUser(context, 'xxidxx')} " +
                                                      registry
                                                          .getUserData(
                                                              context,
                                                              department!
                                                                  .departmentCreatedby)
                                                          .id,
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                // isready == true
                                                //     ? roleBasedSticker(
                                                //         Usertype.manager.index)
                                                //     : SizedBox(),
                                              ],
                                            ),
                                          ),
                                SizedBox(
                                  height: 7,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(12),
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
                                          ? "${getTranslatedForCurrentUser(context, 'xxagentsxx')}"
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
                                                context, 'xxnoxxisassignedxx')
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
                                                    EdgeInsets.all(0),
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
                                                            ? roleBasedSticker(
                                                                context,
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
                                                            child: roleBasedSticker(
                                                                context,
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
                                                    : SizedBox(
                                                        width: 30,
                                                        child: PopupMenuButton<
                                                                String>(
                                                            color: agentid ==
                                                                    department!
                                                                        .departmentManagerID
                                                                ? Mycolors.grey
                                                                : Mycolors
                                                                    .primary,
                                                            itemBuilder: (BuildContext
                                                                    context) =>
                                                                agentid ==
                                                                        department!
                                                                            .departmentManagerID
                                                                    ? <
                                                                        PopupMenuEntry<
                                                                            String>>[
                                                                        PopupMenuItem<
                                                                            String>(
                                                                          value:
                                                                              'removemanager',
                                                                          child:
                                                                              Text(
                                                                            getTranslatedForCurrentUser(context, 'xxremovefromxxxxx').replaceAll('(####)',
                                                                                '${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}'),
                                                                            style:
                                                                                TextStyle(fontSize: 13, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ]
                                                                    : <
                                                                        PopupMenuEntry<
                                                                            String>>[
                                                                        PopupMenuItem<
                                                                            String>(
                                                                          value:
                                                                              'remove',
                                                                          child:
                                                                              Text(
                                                                            getTranslatedForCurrentUser(context, 'xxremovefromxxxxx').replaceAll('(####)',
                                                                                '${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}'),
                                                                            style:
                                                                                TextStyle(fontSize: 13, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                        PopupMenuItem<
                                                                            String>(
                                                                          value:
                                                                              "setmanager",
                                                                          child:
                                                                              Text(
                                                                            getTranslatedForCurrentUser(context, 'xxsetasxx').replaceAll('(####)',
                                                                                '${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}'),
                                                                            style:
                                                                                TextStyle(fontSize: 13, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ],
                                                            onSelected: (String
                                                                value) async {
                                                              if (value ==
                                                                  "removemanager") {
                                                                Utils.toast(
                                                                  getTranslatedForCurrentUser(
                                                                          context,
                                                                          'xxfirstasssignasanyxxx')
                                                                      .replaceAll(
                                                                          '(####)',
                                                                          '${getTranslatedForCurrentUser(context, 'xxagentxx')}')
                                                                      .replaceAll(
                                                                          '(###)',
                                                                          '${getTranslatedForCurrentUser(context, 'xxdepartmentmanagerxx')}')
                                                                      .replaceAll(
                                                                          '(##)',
                                                                          '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${registry.getUserData(context, agentid).fullname}'),
                                                                );
                                                              } else if (value ==
                                                                  "setmanager") {
                                                                await setAsManager(
                                                                  context,
                                                                  agentid,
                                                                  registry
                                                                      .getUserData(
                                                                          context,
                                                                          agentid)
                                                                      .fullname,
                                                                );
                                                              } else if (value ==
                                                                  "remove") {
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
                                                              }
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .more_vert_outlined,
                                                              size: 20,
                                                              color:
                                                                  Mycolors.grey,
                                                            ))),
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
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Container(
                              color: Colors.white,
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: MtCustomfontBoldSemi(
                                    color: Mycolors.black,
                                    text: getTranslatedForCurrentUser(
                                        context, 'xxlasteditedbyxx'),
                                    fontsize: 15.6,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: department!.departmentLastEditedby ==
                                          "Admin"
                                      ? MtCustomfontRegular(
                                          text: getTranslatedForCurrentUser(
                                              context, 'xxadminxx'),
                                          fontsize: 12.8,
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MtCustomfontRegular(
                                              color: Mycolors.grey,
                                              text: registry
                                                      .getUserData(
                                                          context,
                                                          department!
                                                              .departmentLastEditedby)
                                                      .fullname +
                                                  " (${getTranslatedForCurrentUser(context, 'xxidxx')} ${registry.getUserData(context, department!.departmentLastEditedby).id})",
                                              fontsize: 12.8,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            isready == true
                                                ? livedata!.docmap[Dbkeys
                                                            .secondadminID] ==
                                                        department!
                                                            .departmentLastEditedby
                                                    ? roleBasedSticker(
                                                        context,
                                                        Usertype
                                                            .secondadmin.index)
                                                    : SizedBox()
                                                : SizedBox(),
                                          ],
                                        ),
                                ),
                                leading: Icon(
                                  Icons.person,
                                  color: Mycolors.secondary,
                                ),
                                isThreeLine: false,
                                onTap: () {},
                              )),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                              color: Colors.white,
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: MtCustomfontBoldSemi(
                                    color: Mycolors.black,
                                    text: getTranslatedForCurrentUser(
                                        context, 'xxlasteditedonxx'),
                                    fontsize: 15.6,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: MtCustomfontRegular(
                                    color: Mycolors.grey,
                                    text: formatTimeDateCOMLPETEString(
                                        isdateTime: true,
                                        isshowutc: false,
                                        context: context,
                                        datetimetargetTime:
                                            DateTime.fromMillisecondsSinceEpoch(
                                          department!.departmentLastEditedOn,
                                        )),
                                    fontsize: 12.8,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.access_time_rounded,
                                  color: Mycolors.secondary,
                                ),
                                isThreeLine: false,
                                onTap: () {},
                              )),
                          SizedBox(
                            height: 18,
                          ),
                          Container(
                              color: Colors.white,
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: MtCustomfontBoldSemi(
                                    color: Mycolors.black,
                                    text:
                                        "${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} " +
                                            getTranslatedForCurrentUser(
                                                context, 'xxxcreatedbyxx'),
                                    fontsize: 15.6,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: department!.departmentLastEditedby ==
                                          "Admin"
                                      ? MtCustomfontRegular(
                                          text: getTranslatedForCurrentUser(
                                              context, 'xxadminxx'),
                                          fontsize: 12.8,
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MtCustomfontRegular(
                                              color: Mycolors.grey,
                                              text: registry
                                                      .getUserData(
                                                          context,
                                                          department!
                                                              .departmentLastEditedby)
                                                      .fullname +
                                                  " (${getTranslatedForCurrentUser(context, 'xxidxx')} ${registry.getUserData(context, department!.departmentLastEditedby).id})",
                                              fontsize: 12.8,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            isready == true
                                                ? livedata!.docmap[Dbkeys
                                                            .secondadminID] ==
                                                        department!
                                                            .departmentLastEditedby
                                                    ? roleBasedSticker(
                                                        context,
                                                        Usertype
                                                            .secondadmin.index)
                                                    : SizedBox()
                                                : SizedBox(),
                                          ],
                                        ),
                                ),
                                leading: Icon(
                                  Icons.person,
                                  color: Mycolors.secondary,
                                ),
                                isThreeLine: false,
                                onTap: () {},
                              )),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                              color: Colors.white,
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: MtCustomfontBoldSemi(
                                    color: Mycolors.black,
                                    text: getTranslatedForCurrentUser(
                                            context, 'xxcreatedonxx')
                                        .replaceAll('(####)',
                                            '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                    fontsize: 15.6,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: MtCustomfontRegular(
                                    color: Mycolors.grey,
                                    text: formatTimeDateCOMLPETEString(
                                        isdateTime: true,
                                        isshowutc: false,
                                        context: context,
                                        datetimetargetTime:
                                            DateTime.fromMillisecondsSinceEpoch(
                                          department!.departmentCreatedTime,
                                        )),
                                    fontsize: 12.8,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.access_time_rounded,
                                  color: Mycolors.secondary,
                                ),
                                isThreeLine: false,
                                onTap: () {},
                              )),
                          SizedBox(
                            height: 18,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: myinkwell(
                                onTap: AppConstants.isdemomode == true
                                    ? () {
                                        Utils.toast(getTranslatedForCurrentUser(
                                            context,
                                            'xxxnotalwddemoxxaccountxx'));
                                      }
                                    : () {
                                        ShowConfirmDialog().open(
                                            context: context,
                                            subtitle: getTranslatedForCurrentUser(
                                                    context, 'xxxareusuredltdeptxxx')
                                                .replaceAll('(####)',
                                                    '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                                                .replaceAll('(###)',
                                                    '${getTranslatedForCurrentUser(context, 'xxtktsxx')}, ${getTranslatedForCurrentUser(context, 'xxagenstxx')}, ${getTranslatedForCurrentUser(context, 'xxagentchatsxx')}'),
                                            title: getTranslatedForCurrentUser(
                                                context, 'xxconfirmquesxx'),
                                            rightbtnonpress: AppConstants
                                                        .isdemomode ==
                                                    true
                                                ? () {
                                                    Utils.toast(
                                                        getTranslatedForCurrentUser(
                                                            context,
                                                            'xxxnotalwddemoxxaccountxx'));
                                                  }
                                                : () async {
                                                    Navigator.pop(context);
                                                    ShowLoading().open(
                                                        context: context,
                                                        key: _keyLoader223);

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(DbPaths
                                                            .collectiontickets)
                                                        .where(
                                                            Dbkeys
                                                                .tktdepartmentNameList,
                                                            arrayContains: widget
                                                                .departmentID)
                                                        .get()
                                                        .then((tickets) async {
                                                      if (tickets.docs.length >
                                                          0) {
                                                        tickets.docs.forEach(
                                                            (tkt) async {
                                                          await tkt.reference
                                                              .update({
                                                            Dbkeys.tktMEMBERSactiveList:
                                                                [],
                                                            Dbkeys.ticketDepartmentID:
                                                                "",
                                                            Dbkeys.tktdepartmentNameList:
                                                                [],
                                                          });
                                                        });
                                                      }
                                                    });

                                                    await FirebaseApi
                                                        .runDELETEmapobjectinListField(
                                                            context: context,
                                                            listkeyname: Dbkeys
                                                                .departmentList,
                                                            docrefdata: docRef,
                                                            compareKey: Dbkeys
                                                                .departmentTitle,
                                                            compareVal: department!
                                                                .departmentTitle,
                                                            onErrorFn: (e) {
                                                              ShowLoading().close(
                                                                  context:
                                                                      context,
                                                                  key:
                                                                      _keyLoader223);
                                                              Utils.errortoast(
                                                                  '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}\n $e');
                                                            },
                                                            onSuccessFn:
                                                                () async {
                                                              await Utils.sendDirectNotification(
                                                                  title: getTranslatedForCurrentUser(context, 'xxxshasdeletedbyxxxxx')
                                                                      .replaceAll(
                                                                          '(####)', '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                                                                      .replaceAll(
                                                                          '(###)',
                                                                          '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
                                                                  parentID:
                                                                      "DEPT--${widget.departmentID}",
                                                                  plaindesc: getTranslatedForCurrentUser(
                                                                          context,
                                                                          'xxxshasdeletedbyxxxxx')
                                                                      .replaceAll(
                                                                          '(####)',
                                                                          '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}- ${department!.departmentTitle}')
                                                                      .replaceAll(
                                                                          '(###)',
                                                                          '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
                                                                  docRef: FirebaseFirestore
                                                                      .instance
                                                                      .collection(DbPaths.adminapp)
                                                                      .doc(DbPaths.collectionhistory),
                                                                  postedbyID: widget.currentuserid);
                                                              await Utils.sendDirectNotification(
                                                                  title: getTranslatedForCurrentUser(context, 'xxxshasdeletedbyxxxxx')
                                                                      .replaceAll(
                                                                          '(####)', '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                                                                      .replaceAll(
                                                                          '(###)',
                                                                          '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
                                                                  parentID:
                                                                      "DEPT--${widget.departmentID}",
                                                                  plaindesc: getTranslatedForCurrentUser(
                                                                          context,
                                                                          'xxxshasdeletedbyxxxxx')
                                                                      .replaceAll(
                                                                          '(####)',
                                                                          '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}- ${department!.departmentTitle}')
                                                                      .replaceAll(
                                                                          '(###)',
                                                                          '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
                                                                  docRef: FirebaseFirestore
                                                                      .instance
                                                                      .collection(DbPaths.adminapp)
                                                                      .doc(DbPaths.adminnotifications),
                                                                  postedbyID: widget.currentuserid);
                                                              ShowLoading().close(
                                                                  context:
                                                                      context,
                                                                  key:
                                                                      _keyLoader223);
                                                              widget
                                                                  .onrefreshPreviousPage();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                  });
                                      },
                                child: Chip(
                                    backgroundColor:
                                        Mycolors.red.withOpacity(0.2),
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.remove_circle_outline,
                                            size: 17, color: Mycolors.red),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${getTranslatedForCurrentUser(context, 'xxdeletexx').toUpperCase()} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx').toUpperCase()}",
                                          style: TextStyle(color: Mycolors.red),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            // height: 130,
                            width: double.infinity,
                            child: futureLoadCollections(
                                future: FirebaseFirestore.instance
                                    .collection(DbPaths.collectiontickets)
                                    .where(Dbkeys.tktdepartmentNameList,
                                        arrayContainsAny: [department!.departmentTitle])
                                    .orderBy(
                                        Dbkeys.ticketlatestTimestampForAgents,
                                        descending: true)
                                    .get(),
                                placeholder: minicircularProgress(),
                                noDataWidget: noDataWidget(
                                    context: context,
                                    title: getTranslatedForCurrentUser(
                                            context, 'xxnoxxavailabletoaddxx')
                                        .replaceAll('(####)',
                                            '${getTranslatedForCurrentUser(context, 'xxtktssxx')}'),
                                    subtitle: getTranslatedForCurrentUser(
                                            context, 'xxnoxxavailabletoaddforxxxx')
                                        .replaceAll('(####)',
                                            '${getTranslatedForCurrentUser(context, 'xxtktssxx')}')
                                        .replaceAll('(###)', '${department!.departmentTitle} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                    iconData: LineAwesomeIcons.alternate_ticket,
                                    iconColor: Utils.randomColorgenratorBasedOnFirstLetter(department!.departmentTitle)),
                                onfetchdone: (ticketDocList) {
                                  return ticketDocList.length == 0
                                      ? noDataWidget(
                                          context: context,
                                          title: getTranslatedForCurrentUser(
                                                  context, 'xxnoxxavailabletoaddxx')
                                              .replaceAll('(####)',
                                                  '${getTranslatedForCurrentUser(context, 'xxtktssxx')}'),
                                          subtitle: getTranslatedForCurrentUser(
                                                  context,
                                                  'xxnoxxavailabletoaddforxxxx')
                                              .replaceAll('(####)',
                                                  '${getTranslatedForCurrentUser(context, 'xxtktssxx')}')
                                              .replaceAll('(###)',
                                                  '${department!.departmentTitle} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                          iconData:
                                              LineAwesomeIcons.alternate_ticket,
                                          iconColor: Utils
                                              .randomColorgenratorBasedOnFirstLetter(
                                                  department!.departmentTitle))
                                      : Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            MtCustomfontBoldSemi(
                                              textalign: TextAlign.left,
                                              text: ticketDocList.length
                                                      .toString() +
                                                  " ${getTranslatedForCurrentUser(context, 'xxtktssxx')}",
                                              color: Mycolors.secondary,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: ticketDocList.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int i) {
                                                  return ticketWidgetForAgents(
                                                    isMini: false,
                                                    context: context,
                                                    userAppSettingsDoc:
                                                        userAppSettings!,
                                                    ontap: (ticketid,
                                                        customerUID) {
                                                      TicketModel ticket =
                                                          TicketModel
                                                              .fromSnapshot(
                                                                  ticketDocList[
                                                                      i]);
                                                      pageNavigator(
                                                          context,
                                                          TicketChatRoom(
                                                            agentsListinParticularDepartment: [],
                                                            currentuserfullname:
                                                                Optionalconstants
                                                                    .currentAdminID,
                                                            customerUID: ticket
                                                                .ticketcustomerID,
                                                            cuurentUserCanSeeAgentNamePhoto:
                                                                true,
                                                            cuurentUserCanSeeCustomerNamePhoto:
                                                                true,
                                                            isSharingIntentForwarded:
                                                                false,
                                                            ticketID:
                                                                ticket.ticketID,
                                                            ticketTitle: ticket
                                                                .ticketTitle,
                                                          ));
                                                    },
                                                    ticket: TicketModel
                                                        .fromSnapshot(
                                                            ticketDocList[i]),
                                                  );
                                                }),
                                            SizedBox(
                                              height: 50,
                                            ),
                                          ],
                                        );
                                }),
                          ),
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

                        await FirebaseFirestore.instance
                            .collection(DbPaths.collectiontickets)
                            .where(Dbkeys.tktdepartmentNameList,
                                arrayContains: widget.departmentID)
                            .get()
                            .then((tickets) async {
                          if (tickets.docs.length > 0) {
                            tickets.docs.forEach((tkt) async {
                              await tkt.reference.update(
                                  {Dbkeys.tktMEMBERSactiveList: agents});
                            });
                          }
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
                                  "${getTranslatedForCurrentUser(context, 'xxfailedxx')} ERROR: " +
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
                List<dynamic> agents = alreadyaddedlist;
                agents.remove(agentid);
                await FirebaseFirestore.instance
                    .collection(DbPaths.collectiontickets)
                    .where(Dbkeys.tktdepartmentNameList,
                        arrayContains: widget.departmentID)
                    .get()
                    .then((tickets) async {
                  if (tickets.docs.length > 0) {
                    tickets.docs.forEach((tkt) async {
                      await tkt.reference
                          .update({Dbkeys.tktMEMBERSactiveList: agents});
                    });
                  }
                });
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
                          "${getTranslatedForCurrentUser(context, 'xxfailedxx')} ERROR: " +
                              e.toString());
                    },
                    onSuccessFn: () async {
                      await FirebaseApi.runTransactionRecordActivity(
                          parentid: "DEPT--${widget.departmentID}",
                          title: getTranslatedForCurrentUser(
                                  context, 'xxxremovedfromxxx')
                              .replaceAll('(####)',
                                  '1 ${getTranslatedForCurrentUser(context, 'xxagentxx')}')
                              .replaceAll('(###)',
                                  '${department!.departmentTitle} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                          plainDesc: getTranslatedForCurrentUser(
                                  context, 'xxxremovedfromxxx')
                              .replaceAll('(####)',
                                  '${getTranslatedForCurrentUser(context, 'xxagentxx')} $agentname (${getTranslatedForCurrentUser(context, 'xxidxx')} $agentid)')
                              .replaceAll('(###)',
                                  '${department!.departmentTitle} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}. ${getTranslatedForCurrentUser(context, 'xxxbyxxx')} ${widget.currentuserid}'),
                          postedbyID: widget.currentuserid,
                          context: context,
                          onSuccessFn: () async {
                            await Utils.sendDirectNotification(
                                title: getTranslatedForCurrentUser(
                                        context, 'xxxuareremovedfromxxx')
                                    .replaceAll('(###)',
                                        '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${department!.departmentTitle}'),
                                parentID: "DEPT--${widget.departmentID}",
                                plaindesc: getTranslatedForCurrentUser(
                                        context, 'xxxhasremovedufromxxxx')
                                    .replaceAll('(####)',
                                        '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                                    .replaceAll('(###)',
                                        '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${department!.departmentTitle}'),
                                docRef: FirebaseFirestore.instance
                                    .collection(DbPaths.collectionagents)
                                    .doc(agentid)
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

  setAsManager(
    BuildContext context,
    String agentid,
    String agentname,
  ) {
    ShowConfirmDialog().open(
        context: context,
        subtitle: getTranslatedForCurrentUser(context, 'xxareusurexx')
            .replaceAll('(####)',
                '$agentname (${getTranslatedForCurrentUser(context, 'xxagentidxx')} $agentid)')
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
                          "Error occured while changing manager. Please contact developer. ERROR: " +
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
                                            "Error occured while updating description. Please contact developer. ERROR: " +
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
                                                                '(####)', '${department!.departmentTitle} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(context, 'xxdescxx')}') +
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
