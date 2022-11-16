import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/basic_settings_model_adminapp.dart';
import 'package:thinkcreative_technologies/Models/basic_settings_model_userapp.dart';
import 'package:thinkcreative_technologies/Models/userapp_settings_model.dart';
import 'package:thinkcreative_technologies/Screens/initialization/initialization_constant.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';

class Observer with ChangeNotifier {
  bool? isgeolocationprefered = false;
  bool? islocationeditallowed = false;
  bool? isgeolocationmandatory = false;
  bool? isshowerrorlog = false;
  String? privacypolicy;
  String? tnc;
  BasicSettingModelAdminApp? basicSettingDoc;
  BasicSettingModelUserApp? basicSettingUserApp;
  UserAppSettingsModel? userAppSettingsDoc;

  setbasicsettings({
    BasicSettingModelAdminApp? basicModel,
  }) {
    this.basicSettingDoc = basicModel ?? this.basicSettingDoc;
    notifyListeners();
  }

  fetchUserAppSettings(BuildContext context) async {
    // Utils.toast("FETCHING SETTINGS !");
    await InitializationConstant.k12.get().then((doc) {
      if (doc.exists) {
        userAppSettingsDoc = UserAppSettingsModel.fromSnapshot(doc);
        notifyListeners();
      } else {
        Utils.toast(
            "INSTALLATION PENDING ! ${getTranslatedForCurrentUser(context, 'xxuserappsetupincompletexx')}");
      }
    });

    await FirebaseFirestore.instance
        .collection(InitializationConstant.k9)
        .doc(InitializationConstant.k14)
        .get()
        .then((dc) async {
      if (dc.exists) {
        String decoded = utf8.decode(base64.decode(dc["f9846v"]));
        // try parse the http json response
        var jsonobject = json.decode(decoded) as Map<String, dynamic>;
        basicSettingUserApp = BasicSettingModelUserApp.fromJson(jsonobject);
        notifyListeners();
      } else {
        Utils.toast(
            "INSTALLATION PENDING ! Unable to fetch Basic Settings userapp in Observer");
      }
    }).catchError((onError) {
      Utils.toast(
          "INSTALLATION PENDING ! Unable to fetch Basic Settings userapp in Observer, ERROR: $onError");
    });
  }

  setObserver({
    bool? isgeolocationpreferedforuser,
    bool? islocationeditforuser,
    bool? isgeolocationmandatoryforuser,
    bool? isshowerrorloguser,
    String? ncoversionrate,
    String? nprivacypolicy,
    String? ntnc,
  }) {
    this.islocationeditallowed = islocationeditforuser;
    this.isgeolocationprefered = isgeolocationpreferedforuser;
    this.isgeolocationmandatory = isgeolocationmandatoryforuser;
    this.isshowerrorlog = isshowerrorloguser;
    this.privacypolicy = nprivacypolicy;
    this.tnc = ntnc;
    notifyListeners();
  }
}
