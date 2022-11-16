import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';

class DepartmentModel {
  final String departmentTitle;
  final String departmentDesc;
  final List<dynamic> departmentAgentsUIDList;
  final bool departmentIsShow;
  final String departmentCreatedby;
  final int departmentLastEditedOn;
  final int departmentCreatedTime;
  final String departmentLastEditedby;
  final String departmentLogoURL;
  Map<String, dynamic>? departmentExtraMap1 = {};
  Map<String, dynamic>? departmentExtraMap2 = {};
  Map<String, dynamic>? departmentExtraMap3 = {};
  Map<String, dynamic>? departmentExtraMap4 = {};
  Map<String, dynamic>? departmentExtraMap5 = {};
  Map<String, dynamic>? departmentExtraMap6 = {};
//--
  int? deptint1 = 0;
  int? deptint2 = 0;
  int? deptint3 = 0;
  int? deptint4 = 0;
  int? deptint5 = 0;
  int? deptint6 = 0;
  int? deptint7 = 0;
  int? deptint8 = 0;
  int? deptint9 = 0;
  int? deptint10 = 0;
  int? deptint11 = 0;
  int? deptint12 = 0;
  String departmentManagerID;
  String? deptstring2 = "";
  String? deptstring3 = "";
  String? deptstring4 = "";
  String? deptstring5 = "";
  String? deptstring6 = "";
  String? deptstring7 = "";
  String? deptstring8 = "";
  String? deptstring9 = "";
  String? deptstring10 = "";
  String? deptstring11 = "";
  String? deptstring12 = "";
  String? deptstring13 = "";
  String? deptstring14 = "";
  String? deptstring15 = "";
  String? deptstring16 = "";
  String? deptstring17 = "";
  String? deptstring18 = "";

  List<dynamic>? departmentRatingsList = [];
  List<dynamic>? deptlist2 = [];
  List<dynamic>? deptlist3 = [];
  List<dynamic>? deptlist4 = [];
  List<dynamic>? deptlist5 = [];
  List<dynamic>? deptlist6 = [];
  List<dynamic>? deptlist7 = [];
  List<dynamic>? deptlist8 = [];
  List<dynamic>? deptlist9 = [];
  List<dynamic>? deptlist10 = [];
  bool? deptbool1 = true;
  bool? deptbool2 = true;
  bool? deptbool3 = true;
  bool? deptbool4 = true;
  bool? deptbool5 = true;
  bool? deptbool6 = true;
  bool? deptbool7 = true;
  bool? deptbool8 = true;
  bool? deptbool9 = true;
  bool? deptbool10 = true;
  bool? deptbool11 = false;
  bool? deptbool12 = false;
  bool? deptbool13 = false;
  bool? deptbool14 = false;
  bool? deptbool15 = false;
  bool? deptbool16 = false;
  bool? deptbool17 = false;
  bool? deptbool18 = false;

  DepartmentModel({
    required this.departmentTitle,
    required this.departmentDesc,
    required this.departmentAgentsUIDList,
    required this.departmentIsShow,
    required this.departmentCreatedby,
    required this.departmentLastEditedOn,
    required this.departmentCreatedTime,
    required this.departmentLastEditedby,
    required this.departmentLogoURL,
    this.departmentExtraMap1 = const {},
    this.departmentExtraMap2 = const {},
    this.departmentExtraMap3 = const {},
    this.departmentExtraMap4 = const {},
    this.departmentExtraMap5 = const {},
    this.departmentExtraMap6 = const {},

    //--
    this.deptint1 = 0,
    this.deptint2 = 0,
    this.deptint3 = 0,
    this.deptint4 = 0,
    this.deptint5 = 0,
    this.deptint6 = 0,
    this.deptint7 = 0,
    this.deptint8 = 0,
    this.deptint9 = 0,
    this.deptint10 = 0,
    this.deptint11 = 0,
    this.deptint12 = 0,
    required this.departmentManagerID,
    this.deptstring2 = "",
    this.deptstring3 = "",
    this.deptstring4 = "",
    this.deptstring5 = "",
    this.deptstring6 = "",
    this.deptstring7 = "",
    this.deptstring8 = "",
    this.deptstring9 = "",
    this.deptstring10 = "",
    this.deptstring11 = "",
    this.deptstring12 = "",
    this.deptstring13 = "",
    this.deptstring14 = "",
    this.deptstring15 = "",
    this.deptstring16 = "",
    this.deptstring17 = "",
    this.deptstring18 = "",
    this.departmentRatingsList = const [],
    this.deptlist2 = const [],
    this.deptlist3 = const [],
    this.deptlist4 = const [],
    this.deptlist5 = const [],
    this.deptlist6 = const [],
    this.deptlist7 = const [],
    this.deptlist8 = const [],
    this.deptlist9 = const [],
    this.deptlist10 = const [],
    this.deptbool1 = true,
    this.deptbool2 = true,
    this.deptbool3 = true,
    this.deptbool4 = true,
    this.deptbool5 = true,
    this.deptbool6 = true,
    this.deptbool7 = true,
    this.deptbool8 = true,
    this.deptbool9 = true,
    this.deptbool10 = true,
    this.deptbool11 = false,
    this.deptbool12 = false,
    this.deptbool13 = false,
    this.deptbool14 = false,
    this.deptbool15 = false,
    this.deptbool16 = false,
    this.deptbool17 = false,
    this.deptbool18 = false,
  });

  DepartmentModel copyWith({
    final String? departmentTitle,
    final String? departmentDesc,
    final List<dynamic>? departmentAgentsUIDList,
    final bool? departmentIsShow,
    final String? departmentCreatedby,
    final int? departmentLastEditedOn,
    final int? departmentCreatedTime,
    final String? departmentLastEditedby,
    final String? departmentLogoURL,
    final Map<String, dynamic>? departmentExtraMap1,
    final Map<String, dynamic>? departmentExtraMap2,
    final Map<String, dynamic>? departmentExtraMap3,
    final Map<String, dynamic>? departmentExtraMap4,
    final Map<String, dynamic>? departmentExtraMap5,
    final Map<String, dynamic>? departmentExtraMap6,

    //--
    final int? deptint1,
    final int? deptint2,
    final int? deptint3,
    final int? deptint4,
    final int? deptint5,
    final int? deptint6,
    final int? deptint7,
    final int? deptint8,
    final int? deptint9,
    final int? deptint10,
    final int? deptint11,
    final int? deptint12,
    final String? departmentManagerID,
    final String? deptstring2,
    final String? deptstring3,
    final String? deptstring4,
    final String? deptstring5,
    final String? deptstring6,
    final String? deptstring7,
    final String? deptstring8,
    final String? deptstring9,
    final String? deptstring10,
    final String? deptstring11,
    final String? deptstring12,
    final String? deptstring13,
    final String? deptstring14,
    final String? deptstring15,
    final String? deptstring16,
    final String? deptstring17,
    final String? deptstring18,
    final List<dynamic>? departmentRatingsList,
    final List<dynamic>? deptlist2,
    final List<dynamic>? deptlist3,
    final List<dynamic>? deptlist4,
    final List<dynamic>? deptlist5,
    final List<dynamic>? deptlist6,
    final List<dynamic>? deptlist7,
    final List<dynamic>? deptlist8,
    final List<dynamic>? deptlist9,
    final List<dynamic>? deptlist10,
    final bool? deptbool1,
    final bool? deptbool2,
    final bool? deptbool3,
    final bool? deptbool4,
    final bool? deptbool5,
    final bool? deptbool6,
    final bool? deptbool7,
    final bool? deptbool8,
    final bool? deptbool9,
    final bool? deptbool10,
    final bool? deptbool11,
    final bool? deptbool12,
    final bool? deptbool13,
    final bool? deptbool14,
    final bool? deptbool15,
    final bool? deptbool16,
    final bool? deptbool17,
    final bool? deptbool18,
  }) {
    return DepartmentModel(
      departmentTitle: departmentTitle ?? this.departmentTitle,
      departmentDesc: departmentDesc ?? this.departmentDesc,
      departmentAgentsUIDList:
          departmentAgentsUIDList ?? this.departmentAgentsUIDList,
      departmentIsShow: departmentIsShow ?? this.departmentIsShow,
      departmentCreatedby: departmentCreatedby ?? this.departmentCreatedby,
      departmentLastEditedOn:
          departmentLastEditedOn ?? this.departmentLastEditedOn,
      departmentCreatedTime:
          departmentCreatedTime ?? this.departmentCreatedTime,
      departmentLastEditedby:
          departmentLastEditedby ?? this.departmentLastEditedby,
      departmentLogoURL: departmentLogoURL ?? this.departmentLogoURL,
      departmentExtraMap1: departmentExtraMap1 ?? this.departmentExtraMap1,
      departmentExtraMap2: departmentExtraMap2 ?? this.departmentExtraMap2,
      departmentExtraMap3: departmentExtraMap3 ?? this.departmentExtraMap3,
      departmentExtraMap4: departmentExtraMap4 ?? this.departmentExtraMap4,
      departmentExtraMap5: departmentExtraMap5 ?? this.departmentExtraMap5,
      departmentExtraMap6: departmentExtraMap6 ?? this.departmentExtraMap6,
      deptint1: deptint1 ?? this.deptint1,
      deptint2: deptint2 ?? this.deptint2,
      deptint3: deptint3 ?? this.deptint3,
      deptint4: deptint4 ?? this.deptint4,
      deptint5: deptint5 ?? this.deptint5,
      deptint6: deptint6 ?? this.deptint6,
      deptint7: deptint7 ?? this.deptint7,
      deptint8: deptint8 ?? this.deptint8,
      deptint9: deptint9 ?? this.deptint9,
      deptint10: deptint10 ?? this.deptint10,
      deptint11: deptint11 ?? this.deptint11,
      deptint12: deptint12 ?? this.deptint12,
      departmentManagerID: departmentManagerID ?? this.departmentManagerID,
      deptstring2: deptstring2 ?? this.deptstring2,
      deptstring3: deptstring3 ?? this.deptstring3,
      deptstring4: deptstring4 ?? this.deptstring4,
      deptstring5: deptstring5 ?? this.deptstring5,
      deptstring6: deptstring6 ?? this.deptstring6,
      deptstring7: deptstring7 ?? this.deptstring7,
      deptstring8: deptstring8 ?? this.deptstring8,
      deptstring9: deptstring9 ?? this.deptstring9,
      deptstring10: deptstring10 ?? this.deptstring10,
      deptstring11: deptstring11 ?? this.deptstring11,
      deptstring12: deptstring12 ?? this.deptstring12,
      deptstring13: deptstring13 ?? this.deptstring13,
      deptstring14: deptstring14 ?? this.deptstring14,
      deptstring15: deptstring15 ?? this.deptstring15,
      deptstring16: deptstring16 ?? this.deptstring16,
      deptstring17: deptstring17 ?? this.deptstring17,
      deptstring18: deptstring18 ?? this.deptstring18,
      departmentRatingsList:
          departmentRatingsList ?? this.departmentRatingsList,
      deptlist2: deptlist2 ?? this.deptlist2,
      deptlist3: deptlist3 ?? this.deptlist3,
      deptlist4: deptlist4 ?? this.deptlist4,
      deptlist5: deptlist5 ?? this.deptlist5,
      deptlist6: deptlist6 ?? this.deptlist6,
      deptlist7: deptlist7 ?? this.deptlist7,
      deptlist8: deptlist8 ?? this.deptlist8,
      deptlist9: deptlist9 ?? this.deptlist9,
      deptlist10: deptlist10 ?? this.deptlist10,
      deptbool1: deptbool1 ?? this.deptbool1,
      deptbool2: deptbool2 ?? this.deptbool2,
      deptbool3: deptbool3 ?? this.deptbool3,
      deptbool4: deptbool4 ?? this.deptbool4,
      deptbool5: deptbool5 ?? this.deptbool5,
      deptbool6: deptbool6 ?? this.deptbool6,
      deptbool7: deptbool7 ?? this.deptbool7,
      deptbool8: deptbool8 ?? this.deptbool8,
      deptbool9: deptbool9 ?? this.deptbool9,
      deptbool10: deptbool10 ?? this.deptbool10,
      deptbool11: deptbool11 ?? this.deptbool11,
      deptbool12: deptbool12 ?? this.deptbool12,
      deptbool13: deptbool13 ?? this.deptbool13,
      deptbool14: deptbool14 ?? this.deptbool14,
      deptbool15: deptbool15 ?? this.deptbool15,
      deptbool16: deptbool16 ?? this.deptbool16,
      deptbool17: deptbool17 ?? this.deptbool17,
      deptbool18: deptbool18 ?? this.deptbool18,
    );
  }

  factory DepartmentModel.fromJson(Map<String, dynamic> doc) {
    return DepartmentModel(
      departmentTitle: doc[Dbkeys.departmentTitle],
      departmentDesc: doc[Dbkeys.departmentDesc],
      departmentAgentsUIDList: doc[Dbkeys.departmentAgentsUIDList],
      departmentIsShow: doc[Dbkeys.departmentIsShow],
      departmentCreatedby: doc[Dbkeys.departmentCreatedby],
      departmentCreatedTime: doc[Dbkeys.departmentCreatedTime],
      departmentLastEditedOn: doc[Dbkeys.departmentLastEditedOn],
      departmentLastEditedby: doc[Dbkeys.departmentLastEditedby],
      departmentLogoURL: doc[Dbkeys.departmentLogoURL],
      departmentExtraMap1: doc[Dbkeys.departmentExtraMap1],
      departmentExtraMap2: doc[Dbkeys.departmentExtraMap2],
      departmentExtraMap3: doc[Dbkeys.departmentExtraMap3],
      departmentExtraMap4: doc[Dbkeys.departmentExtraMap4],
      departmentExtraMap5: doc[Dbkeys.departmentExtraMap5],
      departmentExtraMap6: doc[Dbkeys.departmentExtraMap6],
      departmentManagerID: doc[Dbkeys.departmentManagerID],
      deptint1: doc[Dbkeys.deptint1],
      deptint2: doc[Dbkeys.deptint2],
      deptint3: doc[Dbkeys.deptint3],
      deptint4: doc[Dbkeys.deptint4],
      deptint5: doc[Dbkeys.deptint5],
      deptint6: doc[Dbkeys.deptint6],
      deptint7: doc[Dbkeys.deptint7],
      deptint8: doc[Dbkeys.deptint8],
      deptint9: doc[Dbkeys.deptint9],
      deptint10: doc[Dbkeys.deptint10],
      deptint11: doc[Dbkeys.deptint11],
      deptint12: doc[Dbkeys.deptint12],
      deptstring2: doc[Dbkeys.deptstring2],
      deptstring3: doc[Dbkeys.deptstring3],
      deptstring4: doc[Dbkeys.deptstring4],
      deptstring5: doc[Dbkeys.deptstring5],
      deptstring6: doc[Dbkeys.deptstring6],
      deptstring7: doc[Dbkeys.deptstring7],
      deptstring8: doc[Dbkeys.deptstring8],
      deptstring9: doc[Dbkeys.deptstring9],
      deptstring10: doc[Dbkeys.deptstring10],
      deptstring11: doc[Dbkeys.deptstring11],
      deptstring12: doc[Dbkeys.deptstring12],
      deptstring13: doc[Dbkeys.deptstring13],
      deptstring14: doc[Dbkeys.deptstring14],
      deptstring15: doc[Dbkeys.deptstring15],
      deptstring16: doc[Dbkeys.deptstring16],
      deptstring17: doc[Dbkeys.deptstring17],
      deptstring18: doc[Dbkeys.deptstring18],
      departmentRatingsList: doc[Dbkeys.departmentRatingsList],
      deptlist2: doc[Dbkeys.deptlist2],
      deptlist3: doc[Dbkeys.deptlist3],
      deptlist4: doc[Dbkeys.deptlist4],
      deptlist5: doc[Dbkeys.deptlist5],
      deptlist6: doc[Dbkeys.deptlist6],
      deptlist7: doc[Dbkeys.deptlist7],
      deptlist8: doc[Dbkeys.deptlist8],
      deptlist9: doc[Dbkeys.deptlist9],
      deptlist10: doc[Dbkeys.deptlist10],
      deptbool1: doc[Dbkeys.deptbool1],
      deptbool2: doc[Dbkeys.deptbool2],
      deptbool3: doc[Dbkeys.deptbool3],
      deptbool4: doc[Dbkeys.deptbool4],
      deptbool5: doc[Dbkeys.deptbool5],
      deptbool6: doc[Dbkeys.deptbool6],
      deptbool7: doc[Dbkeys.deptbool7],
      deptbool8: doc[Dbkeys.deptbool8],
      deptbool9: doc[Dbkeys.deptbool9],
      deptbool10: doc[Dbkeys.deptbool10],
      deptbool11: doc[Dbkeys.deptbool11],
      deptbool12: doc[Dbkeys.deptbool12],
      deptbool13: doc[Dbkeys.deptbool13],
      deptbool14: doc[Dbkeys.deptbool14],
      deptbool15: doc[Dbkeys.deptbool15],
      deptbool16: doc[Dbkeys.deptbool16],
      deptbool17: doc[Dbkeys.deptbool17],
      deptbool18: doc[Dbkeys.deptbool18],
    );
  }
  factory DepartmentModel.fromSnapshot(DocumentSnapshot doc) {
    return DepartmentModel(
      departmentTitle: doc[Dbkeys.departmentTitle],
      departmentDesc: doc[Dbkeys.departmentDesc],
      departmentAgentsUIDList: doc[Dbkeys.departmentAgentsUIDList],
      departmentIsShow: doc[Dbkeys.departmentIsShow],
      departmentCreatedby: doc[Dbkeys.departmentCreatedby],
      departmentCreatedTime: doc[Dbkeys.departmentCreatedTime],
      departmentLastEditedOn: doc[Dbkeys.departmentLastEditedOn],
      departmentLastEditedby: doc[Dbkeys.departmentLastEditedby],
      departmentLogoURL: doc[Dbkeys.departmentLogoURL],
      departmentExtraMap1: doc[Dbkeys.departmentExtraMap1],
      departmentExtraMap2: doc[Dbkeys.departmentExtraMap2],
      departmentExtraMap3: doc[Dbkeys.departmentExtraMap3],
      departmentExtraMap4: doc[Dbkeys.departmentExtraMap4],
      departmentExtraMap5: doc[Dbkeys.departmentExtraMap5],
      departmentExtraMap6: doc[Dbkeys.departmentExtraMap6],
      departmentManagerID: doc[Dbkeys.departmentManagerID],
      deptint1: doc[Dbkeys.deptint1],
      deptint2: doc[Dbkeys.deptint2],
      deptint3: doc[Dbkeys.deptint3],
      deptint4: doc[Dbkeys.deptint4],
      deptint5: doc[Dbkeys.deptint5],
      deptint6: doc[Dbkeys.deptint6],
      deptint7: doc[Dbkeys.deptint7],
      deptint8: doc[Dbkeys.deptint8],
      deptint9: doc[Dbkeys.deptint9],
      deptint10: doc[Dbkeys.deptint10],
      deptint11: doc[Dbkeys.deptint11],
      deptint12: doc[Dbkeys.deptint12],
      deptstring2: doc[Dbkeys.deptstring2],
      deptstring3: doc[Dbkeys.deptstring3],
      deptstring4: doc[Dbkeys.deptstring4],
      deptstring5: doc[Dbkeys.deptstring5],
      deptstring6: doc[Dbkeys.deptstring6],
      deptstring7: doc[Dbkeys.deptstring7],
      deptstring8: doc[Dbkeys.deptstring8],
      deptstring9: doc[Dbkeys.deptstring9],
      deptstring10: doc[Dbkeys.deptstring10],
      deptstring11: doc[Dbkeys.deptstring11],
      deptstring12: doc[Dbkeys.deptstring12],
      deptstring13: doc[Dbkeys.deptstring13],
      deptstring14: doc[Dbkeys.deptstring14],
      deptstring15: doc[Dbkeys.deptstring15],
      deptstring16: doc[Dbkeys.deptstring16],
      deptstring17: doc[Dbkeys.deptstring17],
      deptstring18: doc[Dbkeys.deptstring18],
      departmentRatingsList: doc[Dbkeys.departmentRatingsList],
      deptlist2: doc[Dbkeys.deptlist2],
      deptlist3: doc[Dbkeys.deptlist3],
      deptlist4: doc[Dbkeys.deptlist4],
      deptlist5: doc[Dbkeys.deptlist5],
      deptlist6: doc[Dbkeys.deptlist6],
      deptlist7: doc[Dbkeys.deptlist7],
      deptlist8: doc[Dbkeys.deptlist8],
      deptlist9: doc[Dbkeys.deptlist9],
      deptlist10: doc[Dbkeys.deptlist10],
      deptbool1: doc[Dbkeys.deptbool1],
      deptbool2: doc[Dbkeys.deptbool2],
      deptbool3: doc[Dbkeys.deptbool3],
      deptbool4: doc[Dbkeys.deptbool4],
      deptbool5: doc[Dbkeys.deptbool5],
      deptbool6: doc[Dbkeys.deptbool6],
      deptbool7: doc[Dbkeys.deptbool7],
      deptbool8: doc[Dbkeys.deptbool8],
      deptbool9: doc[Dbkeys.deptbool9],
      deptbool10: doc[Dbkeys.deptbool10],
      deptbool11: doc[Dbkeys.deptbool11],
      deptbool12: doc[Dbkeys.deptbool12],
      deptbool13: doc[Dbkeys.deptbool13],
      deptbool14: doc[Dbkeys.deptbool14],
      deptbool15: doc[Dbkeys.deptbool15],
      deptbool16: doc[Dbkeys.deptbool16],
      deptbool17: doc[Dbkeys.deptbool17],
      deptbool18: doc[Dbkeys.deptbool18],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Dbkeys.departmentTitle: departmentTitle,
      Dbkeys.departmentDesc: departmentDesc,
      Dbkeys.departmentAgentsUIDList: departmentAgentsUIDList,
      Dbkeys.departmentCreatedTime: departmentCreatedTime,
      Dbkeys.departmentIsShow: departmentIsShow,
      Dbkeys.departmentCreatedby: departmentCreatedby,
      Dbkeys.departmentLastEditedOn: departmentLastEditedOn,
      Dbkeys.departmentLogoURL: departmentLogoURL,
      Dbkeys.departmentExtraMap1: departmentExtraMap1,
      Dbkeys.departmentExtraMap2: departmentExtraMap2,
      Dbkeys.departmentExtraMap3: departmentExtraMap3,
      Dbkeys.departmentExtraMap4: departmentExtraMap4,
      Dbkeys.departmentExtraMap5: departmentExtraMap5,
      Dbkeys.departmentExtraMap6: departmentExtraMap6,
      Dbkeys.departmentLastEditedby: departmentLastEditedby,
      Dbkeys.deptint1: deptint1,
      Dbkeys.deptint2: deptint2,
      Dbkeys.deptint3: deptint3,
      Dbkeys.deptint4: deptint4,
      Dbkeys.deptint5: deptint5,
      Dbkeys.deptint6: deptint6,
      Dbkeys.deptint7: deptint7,
      Dbkeys.deptint8: deptint8,
      Dbkeys.deptint9: deptint9,
      Dbkeys.deptint10: deptint10,
      Dbkeys.deptint11: deptint11,
      Dbkeys.deptint12: deptint12,
      Dbkeys.departmentManagerID: departmentManagerID,
      Dbkeys.deptstring2: deptstring2,
      Dbkeys.deptstring3: deptstring3,
      Dbkeys.deptstring4: deptstring4,
      Dbkeys.deptstring5: deptstring5,
      Dbkeys.deptstring6: deptstring6,
      Dbkeys.deptstring7: deptstring7,
      Dbkeys.deptstring8: deptstring8,
      Dbkeys.deptstring9: deptstring9,
      Dbkeys.deptstring10: deptstring10,
      Dbkeys.deptstring11: deptstring11,
      Dbkeys.deptstring12: deptstring12,
      Dbkeys.deptstring13: deptstring13,
      Dbkeys.deptstring14: deptstring14,
      Dbkeys.deptstring15: deptstring15,
      Dbkeys.deptstring16: deptstring16,
      Dbkeys.deptstring17: deptstring17,
      Dbkeys.deptstring18: deptstring18,
      Dbkeys.departmentRatingsList: departmentRatingsList,
      Dbkeys.deptlist2: deptlist2,
      Dbkeys.deptlist3: deptlist3,
      Dbkeys.deptlist4: deptlist4,
      Dbkeys.deptlist5: deptlist5,
      Dbkeys.deptlist6: deptlist6,
      Dbkeys.deptlist7: deptlist7,
      Dbkeys.deptlist8: deptlist8,
      Dbkeys.deptlist9: deptlist9,
      Dbkeys.deptlist10: deptlist10,
      Dbkeys.deptbool1: deptbool1,
      Dbkeys.deptbool2: deptbool2,
      Dbkeys.deptbool3: deptbool3,
      Dbkeys.deptbool4: deptbool4,
      Dbkeys.deptbool5: deptbool5,
      Dbkeys.deptbool6: deptbool6,
      Dbkeys.deptbool7: deptbool7,
      Dbkeys.deptbool8: deptbool8,
      Dbkeys.deptbool9: deptbool9,
      Dbkeys.deptbool10: deptbool10,
      Dbkeys.deptbool11: deptbool11,
      Dbkeys.deptbool12: deptbool12,
      Dbkeys.deptbool13: deptbool13,
      Dbkeys.deptbool14: deptbool14,
      Dbkeys.deptbool15: deptbool15,
      Dbkeys.deptbool16: deptbool16,
      Dbkeys.deptbool17: deptbool17,
      Dbkeys.deptbool18: deptbool18,
    };
  }
}
