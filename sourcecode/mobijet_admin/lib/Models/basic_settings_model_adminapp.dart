import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:thinkcreative_technologies/Configs/db_keys.dart';

class BasicSettingModelAdminApp {
  bool? isemulatorallowed = true;
  bool? isEmailLoginEnabled = false;
  String? latestappversionandroid = '1.0.0';
  String? newapplinkandroid = 'Google Playstore link not available yet';
  String? latestappversionios = '1.0.0';
  String? newapplinkios = 'Apple AppStore link not available yet';
  bool? isappunderconstructionandroid = false;
  bool? isappunderconstructionios = false;
  String? accountapprovalmessage =
      'Your account is created successfully ! You can start using the account once the admin approves it.';
  bool? isshowerrorlog = false;
  String? maintainancemessage = 'App Under Maintenance. Please visit later';

  List<dynamic>? exList1 = [];
  List<dynamic>? exList2 = [];
  List<dynamic>? exList3 = [];

  bool? exBool7 = false;
  bool? exBool8 = false;
  bool? exBool9 = true;
  int? exInt1 = 0;
  int? exInt2 = 0;
  double? exDouble4 = 0.001;
  double? exDouble5 = 0.001;
  Map? exMap1 = {};
  Map? exMap2 = {};
  String? exString1 = '';
  String? exString2 = '';
  String? exString3 = '';
  String? exString4 = '';
  String? exString5 = '';

  BasicSettingModelAdminApp({
    this.isemulatorallowed = true,
    this.latestappversionandroid = '1.0.0',
    this.newapplinkandroid = 'Google Playstore link not available yet',
    this.latestappversionios = '1.0.0',
    this.newapplinkios = 'Apple AppStore link not available yet',
    this.isappunderconstructionandroid = false,
    this.isappunderconstructionios = false,
    this.accountapprovalmessage =
        'Your account is created successfully ! You can start using the account once the admin approves it.',
    this.isshowerrorlog = false,
    this.maintainancemessage = 'App Under Maintenance. Please visit later',
    this.exList1 = const [],
    this.exList2 = const [],
    this.exList3 = const [],
    this.isEmailLoginEnabled = false,
    this.exBool7 = false,
    this.exBool8 = false,
    this.exBool9 = true,
    this.exInt1 = 0,
    this.exInt2 = 0,
    this.exDouble4 = 0.001,
    this.exDouble5 = 0.001,
    this.exMap1 = const {},
    this.exMap2 = const {},
    this.exString1 = '',
    this.exString2 = '',
    this.exString3 = '',
    this.exString4 = '',
    this.exString5 = '',
  });

  BasicSettingModelAdminApp copyWith({
    final bool? isemulatorallowed,
    final String? latestappversionandroid,
    final String? newapplinkandroid,
    final String? latestappversionios,
    final String? newapplinkios,
    final bool? isappunderconstructionandroid,
    final bool? isappunderconstructionios,
    final String? accountapprovalmessage,
    final bool? isshowerrorlog,
    final String? maintainancemessage,

    //---Extra fields for future scalabality
    final List<dynamic>? exList1,
    final List<dynamic>? exList2,
    final List<dynamic>? exList3,
    final bool? isEmailLoginEnabled,
    final bool? exBool7,
    final bool? exBool8,
    final bool? exBool9,
    final int? exInt1,
    final int? exInt2,
    final double? exDouble4,
    final double? exDouble5,
    final Map? exMap1,
    final Map? exMap2,
    final String? exString1,
    final String? exString2,
    final String? exString3,
    final String? exString4,
    final String? exString5,
  }) {
    return BasicSettingModelAdminApp(
      isemulatorallowed: isemulatorallowed ?? this.isemulatorallowed,
      latestappversionandroid:
          latestappversionandroid ?? this.latestappversionandroid,
      latestappversionios: latestappversionios ?? this.latestappversionios,
      newapplinkandroid: newapplinkandroid ?? this.newapplinkandroid,
      newapplinkios: newapplinkios ?? this.newapplinkios,
      isappunderconstructionandroid:
          isappunderconstructionandroid ?? this.isappunderconstructionandroid,
      isappunderconstructionios:
          isappunderconstructionios ?? this.isappunderconstructionios,
      accountapprovalmessage:
          accountapprovalmessage ?? this.accountapprovalmessage,
      isshowerrorlog: isshowerrorlog ?? this.isshowerrorlog,
      maintainancemessage: maintainancemessage ?? this.maintainancemessage,
      exList1: exList1 ?? this.exList1,
      exList2: exList2 ?? this.exList2,
      exList3: exList3 ?? this.exList3,
      isEmailLoginEnabled: isEmailLoginEnabled ?? this.isEmailLoginEnabled,
      exBool7: exBool7 ?? this.exBool7,
      exBool8: exBool8 ?? this.exBool8,
      exBool9: exBool9 ?? this.exBool9,
      exInt1: exInt1 ?? this.exInt1,
      exInt2: exInt2 ?? this.exInt2,
      exDouble4: exDouble4 ?? this.exDouble4,
      exDouble5: exDouble5 ?? this.exDouble5,
      exMap1: exMap1 ?? this.exMap1,
      exMap2: exMap2 ?? this.exMap2,
      exString1: exString1 ?? this.exString1,
      exString2: exString2 ?? this.exString2,
      exString3: exString3 ?? this.exString3,
      exString4: exString4 ?? this.exString4,
      exString5: exString5 ?? this.exString5,
    );
  }

  factory BasicSettingModelAdminApp.fromJson(Map<String, dynamic> doc) {
    return BasicSettingModelAdminApp(
      isemulatorallowed: doc[Dbkeys.isemulatorallowed],

      latestappversionandroid: doc[Dbkeys.latestappversionandroid],
      latestappversionios: doc[Dbkeys.latestappversionios],
      newapplinkandroid: doc[Dbkeys.newapplinkandroid],
      newapplinkios: doc[Dbkeys.newapplinkios],
      isappunderconstructionandroid: doc[Dbkeys.isappunderconstructionandroid],
      isappunderconstructionios: doc[Dbkeys.isappunderconstructionios],
      accountapprovalmessage: doc[Dbkeys.accountapprovalmessage],
      isshowerrorlog: doc[Dbkeys.isshowerrorlog],
      maintainancemessage: doc[Dbkeys.maintainancemessage],

//-------
      exList1: doc[Dbkeys.exList1],
      exList2: doc[Dbkeys.exList2],
      exList3: doc[Dbkeys.exList3],

      isEmailLoginEnabled: doc[Dbkeys.isEmailLoginEnabled],
      exBool7: doc[Dbkeys.exBool7],
      exBool8: doc[Dbkeys.exBool8],
      exBool9: doc[Dbkeys.exBool9],

      exInt2: doc[Dbkeys.exInt2],

      exDouble4: doc[Dbkeys.exDouble4],
      exDouble5: doc[Dbkeys.exDouble5],
      exMap1: doc[Dbkeys.exMap1],
      exMap2: doc[Dbkeys.exMap2],

      exString1: doc[Dbkeys.exString1],
      exString2: doc[Dbkeys.exString2],
      exString3: doc[Dbkeys.exString3],
      exString4: doc[Dbkeys.exString4],
      exString5: doc[Dbkeys.exString5],
    );
  }
  factory BasicSettingModelAdminApp.fromSnapshot(DocumentSnapshot doc) {
    return BasicSettingModelAdminApp(
      isemulatorallowed: doc[Dbkeys.isemulatorallowed],

      latestappversionandroid: doc[Dbkeys.latestappversionandroid],
      latestappversionios: doc[Dbkeys.latestappversionios],
      newapplinkandroid: doc[Dbkeys.newapplinkandroid],
      newapplinkios: doc[Dbkeys.newapplinkios],
      isappunderconstructionandroid: doc[Dbkeys.isappunderconstructionandroid],
      isappunderconstructionios: doc[Dbkeys.isappunderconstructionios],
      accountapprovalmessage: doc[Dbkeys.accountapprovalmessage],
      isshowerrorlog: doc[Dbkeys.isshowerrorlog],
      maintainancemessage: doc[Dbkeys.maintainancemessage],

//-------
      exList1: doc[Dbkeys.exList1],
      exList2: doc[Dbkeys.exList2],
      exList3: doc[Dbkeys.exList3],

      isEmailLoginEnabled: doc[Dbkeys.isEmailLoginEnabled],
      exBool7: doc[Dbkeys.exBool7],
      exBool8: doc[Dbkeys.exBool8],
      exBool9: doc[Dbkeys.exBool9],

      exInt2: doc[Dbkeys.exInt2],

      exDouble4: doc[Dbkeys.exDouble4],
      exDouble5: doc[Dbkeys.exDouble5],
      exMap1: doc[Dbkeys.exMap1],
      exMap2: doc[Dbkeys.exMap2],

      exString1: doc[Dbkeys.exString1],
      exString2: doc[Dbkeys.exString2],
      exString3: doc[Dbkeys.exString3],
      exString4: doc[Dbkeys.exString4],
      exString5: doc[Dbkeys.exString5],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Dbkeys.isemulatorallowed: this.isemulatorallowed,

      Dbkeys.latestappversionandroid: this.latestappversionandroid,
      Dbkeys.latestappversionios: this.latestappversionios,
      Dbkeys.newapplinkandroid: this.newapplinkandroid,
      Dbkeys.newapplinkios: this.newapplinkios,
      Dbkeys.isappunderconstructionandroid: this.isappunderconstructionandroid,
      Dbkeys.isappunderconstructionios: this.isappunderconstructionios,
      Dbkeys.accountapprovalmessage: this.accountapprovalmessage,
      Dbkeys.isshowerrorlog: this.isshowerrorlog,
      Dbkeys.maintainancemessage: this.maintainancemessage,

//-------
      Dbkeys.exList1: this.exList1,
      Dbkeys.exList2: this.exList2,
      Dbkeys.exList3: this.exList3,

      Dbkeys.isEmailLoginEnabled: this.isEmailLoginEnabled,
      Dbkeys.exBool7: this.exBool7,
      Dbkeys.exBool8: this.exBool8,
      Dbkeys.exBool9: this.exBool9,

      Dbkeys.exInt2: this.exInt2,
      Dbkeys.exInt1: this.exInt1,

      Dbkeys.exDouble4: this.exDouble4,
      Dbkeys.exDouble5: this.exDouble5,
      Dbkeys.exMap1: this.exMap1,
      Dbkeys.exMap2: this.exMap2,

      Dbkeys.exString1: this.exString1,
      Dbkeys.exString2: this.exString2,
      Dbkeys.exString3: this.exString3,
      Dbkeys.exString4: this.exString4,
      Dbkeys.exString5: this.exString5,
    };
  }
}
