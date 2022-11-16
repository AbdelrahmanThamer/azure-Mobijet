import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';

class BasicSettingModelUserApp {
  bool? agentVerificationNeeded = false;
  bool? agentLoginEnabled = true;
  bool? agentRegistartionEnabled = false;
  bool? customerVerificationNeeded = false;
  bool? customerLoginEnabled = true;
  bool? isemulatorallowed = true;
  String? privacypolicyTYPE = Dbkeys.url;
  String? tncTYPE = Dbkeys.url;
  String? privacypolicy = '';
  String? tnc = '';
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
  bool? isPhoneAuthenticationMandatory = true;
  bool? isEmailLoginEnabled = true;
  bool? exBool4 = true;
  bool? exbool453 = true;
  bool? isFbLoginEnabled = true;
  bool? isGoogleLoginEnabled = true;
  List<dynamic>? exList1 = [];
  List<dynamic>? exList2 = [];
  List<dynamic>? exList3 = [];
  bool? customerRegistationEnabled = true;
  bool? isCustomDomainsOnly = false;
  bool? exBool8 = false;
  bool? exBool9 = true;
  int? exInt1 = 0;
  int? exInt2 = 0;
  double? exDouble4 = 0.001;
  double? exDouble5 = 0.001;
  Map? exMap1 = {};
  Map? exMap2 = {};
  String? loginTypeUserApp = '';
  String? customDomainslist = '';
  String? exString3 = '';
  String? exString4 = '';
  String? exString5 = '';

  BasicSettingModelUserApp({
    this.agentVerificationNeeded = false,
    this.agentLoginEnabled = false,
    this.agentRegistartionEnabled = false,
    this.customerVerificationNeeded = false,
    this.customerLoginEnabled = false,
    this.isemulatorallowed = true,
    this.privacypolicyTYPE = 'url',
    this.tncTYPE = 'url',
    this.privacypolicy = '',
    this.tnc = '',
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
    this.isPhoneAuthenticationMandatory = true,
    this.isEmailLoginEnabled = true,
    this.exBool4 = true,
    this.exbool453 = true,
    this.isFbLoginEnabled = true,
    this.isGoogleLoginEnabled = true,
    this.exList1 = const [],
    this.exList2 = const [],
    this.exList3 = const [],
    this.customerRegistationEnabled = false,
    this.isCustomDomainsOnly = false,
    this.exBool8 = false,
    this.exBool9 = true,
    this.exInt1 = 0,
    this.exInt2 = 0,
    this.exDouble4 = 0.001,
    this.exDouble5 = 0.001,
    this.exMap1 = const {},
    this.exMap2 = const {},
    this.loginTypeUserApp = '',
    this.customDomainslist = '',
    this.exString3 = '',
    this.exString4 = '',
    this.exString5 = '',
  });

  BasicSettingModelUserApp copyWith({
    final bool? agentVerificationNeeded,
    final bool? agentLoginEnabled,
    final bool? agentRegistartionEnabled,
    final bool? customerVerificationNeeded,
    final bool? customerLoginEnabled,
    final bool? isemulatorallowed,
    final String? privacypolicyTYPE,
    final String? tncTYPE,
    final String? privacypolicy,
    final String? tnc,
    final String? latestappversionandroid,
    final String? newapplinkandroid,
    final String? latestappversionios,
    final String? newapplinkios,
    final bool? isappunderconstructionandroid,
    final bool? isappunderconstructionios,
    final String? accountapprovalmessage,
    final bool? isshowerrorlog,
    final String? maintainancemessage,
    final bool? isPhoneAuthenticationMandatory,
    final bool? isEmailLoginEnabled,
    final bool? exBool4,
    final bool? exbool453,
    final bool? isFbLoginEnabled,
    final bool? isGoogleLoginEnabled,

    //---Extra fields for future scalabality
    final List<dynamic>? exList1,
    final List<dynamic>? exList2,
    final List<dynamic>? exList3,
    final bool? customerRegistationEnabled,
    final bool? isCustomDomainsOnly,
    final bool? exBool8,
    final bool? exBool9,
    final int? exInt1,
    final int? exInt2,
    final double? exDouble4,
    final double? exDouble5,
    final Map? exMap1,
    final Map? exMap2,
    final String? loginTypeUserApp,
    final String? customDomainslist,
    final String? exString3,
    final String? exString4,
    final String? exString5,
  }) {
    return BasicSettingModelUserApp(
      agentVerificationNeeded:
          agentVerificationNeeded ?? this.agentVerificationNeeded,
      agentLoginEnabled: agentLoginEnabled ?? this.agentLoginEnabled,
      agentRegistartionEnabled:
          agentRegistartionEnabled ?? this.agentRegistartionEnabled,
      customerVerificationNeeded:
          customerVerificationNeeded ?? this.customerVerificationNeeded,
      customerLoginEnabled: customerLoginEnabled ?? this.customerLoginEnabled,
      isemulatorallowed: isemulatorallowed ?? this.isemulatorallowed,
      privacypolicyTYPE: privacypolicyTYPE ?? this.privacypolicyTYPE,
      tncTYPE: tncTYPE ?? this.tncTYPE,
      privacypolicy: privacypolicy ?? this.privacypolicy,
      tnc: tnc ?? this.tnc,
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
      customerRegistationEnabled:
          customerRegistationEnabled ?? this.customerRegistationEnabled,
      isCustomDomainsOnly: isCustomDomainsOnly ?? this.isCustomDomainsOnly,
      exBool8: exBool8 ?? this.exBool8,
      exBool9: exBool9 ?? this.exBool9,
      isPhoneAuthenticationMandatory:
          isPhoneAuthenticationMandatory ?? this.isPhoneAuthenticationMandatory,
      isEmailLoginEnabled: isEmailLoginEnabled ?? this.isEmailLoginEnabled,
      exBool4: exBool4 ?? this.exBool4,
      exbool453: exbool453 ?? this.exbool453,
      isFbLoginEnabled: isFbLoginEnabled ?? this.isFbLoginEnabled,
      isGoogleLoginEnabled: isGoogleLoginEnabled ?? this.isGoogleLoginEnabled,
      exInt1: exInt1 ?? this.exInt1,
      exInt2: exInt2 ?? this.exInt2,
      exDouble4: exDouble4 ?? this.exDouble4,
      exDouble5: exDouble5 ?? this.exDouble5,
      exMap1: exMap1 ?? this.exMap1,
      exMap2: exMap2 ?? this.exMap2,
      loginTypeUserApp: loginTypeUserApp ?? this.loginTypeUserApp,
      customDomainslist: customDomainslist ?? this.customDomainslist,
      exString3: exString3 ?? this.exString3,
      exString4: exString4 ?? this.exString4,
      exString5: exString5 ?? this.exString5,
    );
  }

  factory BasicSettingModelUserApp.fromJson(Map<String, dynamic> doc) {
    return BasicSettingModelUserApp(
      agentVerificationNeeded: doc[Dbkeys.agentVerificationNeeded],
      agentLoginEnabled: doc[Dbkeys.agentLoginEnabled],
      agentRegistartionEnabled: doc[Dbkeys.agentRegistartionEnabled],
      customerVerificationNeeded: doc[Dbkeys.customerVerificationNeeded],
      customerLoginEnabled: doc[Dbkeys.customerLoginEnabled],
      isemulatorallowed: doc[Dbkeys.isemulatorallowed],
      privacypolicyTYPE: doc[Dbkeys.privacypolicyTYPE],
      tncTYPE: doc[Dbkeys.tncTYPE],
      privacypolicy: doc[Dbkeys.privacypolicy],
      tnc: doc[Dbkeys.tnc],
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

      customerRegistationEnabled: doc[Dbkeys.customerRegistationEnabled],
      isCustomDomainsOnly: doc[Dbkeys.isCustomDomainsOnly],
      exBool8: doc[Dbkeys.exBool8],
      exBool9: doc[Dbkeys.exBool9],
      isPhoneAuthenticationMandatory:
          doc[Dbkeys.isPhoneAuthenticationMandatory],
      isEmailLoginEnabled: doc[Dbkeys.isEmailLoginEnabled],
      exBool4: doc[Dbkeys.exBool4],
      exbool453: doc[Dbkeys.exbool453],
      isFbLoginEnabled: doc[Dbkeys.isFbLoginEnabled],
      isGoogleLoginEnabled: doc[Dbkeys.isGoogleLoginEnabled],
      exInt2: doc[Dbkeys.exInt2],

      exDouble4: doc[Dbkeys.exDouble4],
      exDouble5: doc[Dbkeys.exDouble5],
      exMap1: doc[Dbkeys.exMap1],
      exMap2: doc[Dbkeys.exMap2],

      loginTypeUserApp: doc[Dbkeys.loginTypeUserApp],
      customDomainslist: doc[Dbkeys.customDomainslist],
      exString3: doc[Dbkeys.exString3],
      exString4: doc[Dbkeys.exString4],
      exString5: doc[Dbkeys.exString5],
    );
  }
  factory BasicSettingModelUserApp.fromSnapshot(DocumentSnapshot doc) {
    return BasicSettingModelUserApp(
      agentVerificationNeeded: doc[Dbkeys.agentVerificationNeeded],

      agentLoginEnabled: doc[Dbkeys.agentLoginEnabled],
      agentRegistartionEnabled: doc[Dbkeys.agentRegistartionEnabled],
      customerVerificationNeeded: doc[Dbkeys.customerVerificationNeeded],

      customerLoginEnabled: doc[Dbkeys.customerLoginEnabled],

      isemulatorallowed: doc[Dbkeys.isemulatorallowed],
      privacypolicyTYPE: doc[Dbkeys.privacypolicyTYPE],
      tncTYPE: doc[Dbkeys.tncTYPE],
      privacypolicy: doc[Dbkeys.privacypolicy],
      tnc: doc[Dbkeys.tnc],
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

      customerRegistationEnabled: doc[Dbkeys.customerRegistationEnabled],
      isCustomDomainsOnly: doc[Dbkeys.isCustomDomainsOnly],
      exBool8: doc[Dbkeys.exBool8],
      exBool9: doc[Dbkeys.exBool9],
      isPhoneAuthenticationMandatory:
          doc[Dbkeys.isPhoneAuthenticationMandatory],
      isEmailLoginEnabled: doc[Dbkeys.isEmailLoginEnabled],
      exBool4: doc[Dbkeys.exBool4],
      exbool453: doc[Dbkeys.exbool453],
      isFbLoginEnabled: doc[Dbkeys.isFbLoginEnabled],
      isGoogleLoginEnabled: doc[Dbkeys.isGoogleLoginEnabled],
      exInt2: doc[Dbkeys.exInt2],

      exDouble4: doc[Dbkeys.exDouble4],
      exDouble5: doc[Dbkeys.exDouble5],
      exMap1: doc[Dbkeys.exMap1],
      exMap2: doc[Dbkeys.exMap2],

      loginTypeUserApp: doc[Dbkeys.loginTypeUserApp],
      customDomainslist: doc[Dbkeys.customDomainslist],
      exString3: doc[Dbkeys.exString3],
      exString4: doc[Dbkeys.exString4],
      exString5: doc[Dbkeys.exString5],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Dbkeys.agentVerificationNeeded: this.agentVerificationNeeded,
      Dbkeys.agentLoginEnabled: this.agentLoginEnabled,
      Dbkeys.agentRegistartionEnabled: this.agentRegistartionEnabled,
      Dbkeys.customerVerificationNeeded: this.customerVerificationNeeded,
      Dbkeys.customerLoginEnabled: this.customerLoginEnabled,

      Dbkeys.isemulatorallowed: this.isemulatorallowed,
      Dbkeys.privacypolicyTYPE: this.privacypolicyTYPE,
      Dbkeys.tncTYPE: this.tncTYPE,
      Dbkeys.privacypolicy: this.privacypolicy,
      Dbkeys.tnc: this.tnc,
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

      Dbkeys.customerRegistationEnabled: this.customerRegistationEnabled,
      Dbkeys.isCustomDomainsOnly: this.isCustomDomainsOnly,
      Dbkeys.exBool8: this.exBool8,
      Dbkeys.exBool9: this.exBool9,
      Dbkeys.isPhoneAuthenticationMandatory:
          this.isPhoneAuthenticationMandatory,
      Dbkeys.isEmailLoginEnabled: this.isEmailLoginEnabled,
      Dbkeys.exBool4: this.exBool4,
      Dbkeys.exbool453: this.exbool453,
      Dbkeys.isFbLoginEnabled: this.isFbLoginEnabled,
      Dbkeys.isGoogleLoginEnabled: this.isGoogleLoginEnabled,
      Dbkeys.exInt2: this.exInt2,
      Dbkeys.exInt1: this.exInt1,

      Dbkeys.exDouble4: this.exDouble4,
      Dbkeys.exDouble5: this.exDouble5,
      Dbkeys.exMap1: this.exMap1,
      Dbkeys.exMap2: this.exMap2,

      Dbkeys.loginTypeUserApp: this.loginTypeUserApp,
      Dbkeys.customDomainslist: this.customDomainslist,
      Dbkeys.exString3: this.exString3,
      Dbkeys.exString4: this.exString4,
      Dbkeys.exString5: this.exString5,
    };
  }
}
