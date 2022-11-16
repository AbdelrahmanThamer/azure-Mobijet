import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';

class UserRegistryModel {
  String fullname = "";
  String shortname = "";
  String photourl = "";
  String phone = "";
  int usertype = 0;
  String id = "";
  String email = "";
  String extra1 = "";
  String extra2 = "";
  Map extraMap = {};

  UserRegistryModel({
    required this.fullname,
    required this.shortname,
    required this.photourl,
    required this.phone,
    required this.usertype,
    required this.id,
    required this.email,
    required this.extra1,
    required this.extra2,
    required this.extraMap,
  });

  UserRegistryModel copyWith(
      {final String? fullname,
      final String? shortname,
      final String? photourl,
      final String? phone,
      final int? usertype,
      final String? id,
      final String? extra,
      final String? email,
      Map? extraMap = const {}}) {
    return UserRegistryModel(
      fullname: fullname ?? this.fullname,
      shortname: shortname ?? this.shortname,
      photourl: photourl ?? this.photourl,
      phone: phone ?? this.phone,
      usertype: usertype ?? this.usertype,
      id: id ?? this.id,
      extra1: extra1,
      extra2: extra2,
      email: email ?? this.email,
      extraMap: extraMap ?? this.extraMap,
    );
  }

  factory UserRegistryModel.fromJson(Map<String, dynamic> doc) {
    return UserRegistryModel(
      fullname: doc[Dbkeys.rgstFULLNAME],
      shortname: doc[Dbkeys.rgstSHORTNAME],
      photourl: doc[Dbkeys.rgstPHOTOURL],
      phone: doc[Dbkeys.rgstPHONE],
      usertype: doc[Dbkeys.rgstUSERTYPE],
      id: doc[Dbkeys.rgstUSERID],
      extra1: doc[Dbkeys.rgstEXTRA1],
      extra2: doc[Dbkeys.rgstEXTRA2],
      email: doc[Dbkeys.rgstEMAIL],
      extraMap: doc[Dbkeys.rgstEXTRAMAP],
    );
  }
  factory UserRegistryModel.fromSnapshot(DocumentSnapshot doc) {
    return UserRegistryModel(
      fullname: doc[Dbkeys.rgstFULLNAME],
      shortname: doc[Dbkeys.rgstSHORTNAME],
      photourl: doc[Dbkeys.rgstPHOTOURL],
      phone: doc[Dbkeys.rgstPHONE],
      usertype: doc[Dbkeys.rgstUSERTYPE],
      id: doc[Dbkeys.rgstUSERID],
      extra1: doc[Dbkeys.rgstEXTRA1],
      extra2: doc[Dbkeys.rgstEXTRA2],
      email: doc[Dbkeys.rgstEMAIL],
      extraMap: doc[Dbkeys.rgstEXTRAMAP],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Dbkeys.rgstFULLNAME: this.fullname,
      Dbkeys.rgstSHORTNAME: this.shortname,
      Dbkeys.rgstPHOTOURL: this.photourl,
      Dbkeys.rgstPHONE: this.phone,
      Dbkeys.rgstUSERTYPE: this.usertype,
      Dbkeys.rgstUSERID: this.id,
      Dbkeys.rgstEXTRA1: this.extra1,
      Dbkeys.rgstEXTRA2: this.extra2,
      Dbkeys.rgstEMAIL: this.email,
      Dbkeys.rgstEXTRAMAP: this.extraMap,
    };
  }
}
