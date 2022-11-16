import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Models/basic_settings_model_adminapp.dart';
import 'package:thinkcreative_technologies/Models/basic_settings_model_userapp.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseApi.dart';

class CommonSession with ChangeNotifier {
  String uid = 'admin';
  String fullname = 'Admin';
  String? photourl;
  String role = 'RoleValue1234';

  var userSettings;
  BasicSettingModelAdminApp? basicadminappsettings;
  var userCount;
  var dashboardData;
  BasicSettingModelUserApp? basicuserappsettings;
  setData(
      {String? newuid,
      newfullname,
      newphotourl,
      newrole,
      var newuserSettings,
      var newuserCount,
      BasicSettingModelAdminApp? newbasicadminappsettings,
      BasicSettingModelUserApp? newbasicuserappsettings,
      var newDashboardData}) {
    basicuserappsettings = newbasicuserappsettings ?? this.basicuserappsettings;
    uid = newuid != null ? newuid + 'admin' : uid;
    fullname = newfullname ?? fullname;
    photourl = newphotourl ?? photourl;
    role = newrole ?? role;
    userSettings = newuserSettings ?? userSettings;
    basicuserappsettings = basicuserappsettings ?? basicuserappsettings;
    userCount = newuserCount ?? userCount;
    dashboardData = newDashboardData ?? dashboardData;
    uid = newuid ?? uid;
    notifyListeners();
  }

  setUserAppSettingFromFirestore() async {
    await FirebaseFirestore.instance
        .collection(Dbkeys.appsettings)
        .doc(Dbkeys.userapp)
        .get()
        .then((doc) {
      userSettings = doc.data();
    });
    notifyListeners();
  }

  String? alertmsg;

  clearalert() {
    alertmsg = null;
    notifyListeners();
  }

  createalert(
      {BuildContext? context,
      int? alerttime,
      String? alerttitle,
      String? alertdesc,
      String? alertuid,
      String? alertmsgforuser,
      String? alertcollection}) async {
    alertmsg = alertmsgforuser;
    notifyListeners();
    await FirebaseApi.runTransactionRecordActivity(
      context: context,
      onErrorFn: (e) {},
      onSuccessFn: () {},
      isshowloader: false,
      title: alerttitle ?? "",
      plainDesc: alertdesc ?? "",
      parentid: "ALERT",
      postedbyID: "sys",
    );
  }
}
