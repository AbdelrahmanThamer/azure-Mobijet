//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseDataAPIProvider.dart';

//  _________ Group Chat Messages ____________
class FirestoreDataProviderMESSAGESforGROUPCHAT extends ChangeNotifier {
  List<DocumentSnapshot> datalistSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  bool _hasNext = true;
  bool _isFetchingData = false;
  String? parentid;
  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List get recievedDocs => datalistSnapshot.map((snap) {
        final recievedData = snap.data();

        return recievedData;
      }).toList();

  reset() {
    _hasNext = true;
    datalistSnapshot.clear();
    _isFetchingData = false;
    _errorMessage = '';
    recievedDocs.clear();
    notifyListeners();
  }

  Future fetchNextData(
      String? dataType, Query? refdataa, bool isAfterNewdocCreated) async {
    if (_isFetchingData) return;

    _errorMessage = '';
    _isFetchingData = true;

    try {
      final snap = isAfterNewdocCreated == true
          ? await FirebaseDataApi.getFirestoreCOLLECTIONData(20,
              // startAfter: null,
              refdata: refdataa)
          : await FirebaseDataApi.getFirestoreCOLLECTIONData(20,
              startAfter:
                  datalistSnapshot.isNotEmpty ? datalistSnapshot.last : null,
              refdata: refdataa);
      if (isAfterNewdocCreated == true) {
        datalistSnapshot.clear();
        datalistSnapshot.addAll(snap.docs);
      } else {
        datalistSnapshot.addAll(snap.docs);
      }
      // notifyListeners();
      if (snap.docs.length < 20) {
        _hasNext = false;
      }
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingData = false;
  }

  addDoc(DocumentSnapshot newDoc) {
    int index = datalistSnapshot.indexWhere(
        (doc) => doc[Dbkeys.groupmsgTIME] == newDoc[Dbkeys.groupmsgTIME]);
    if (index < 0) {
      // List<DocumentSnapshot> list = datalistSnapshot.reversed.toList();
      datalistSnapshot.insert(0, newDoc);
      // datalistSnapshot = list;
      notifyListeners();
    }
  }

  bool checkIfDocAlreadyExits(
      {required DocumentSnapshot newDoc, int? timestamp}) {
    return timestamp != null
        ? datalistSnapshot.indexWhere((doc) =>
                doc[Dbkeys.groupmsgTIME] == newDoc[Dbkeys.groupmsgTIME]) >=
            0
        : datalistSnapshot.contains(newDoc);
  }

  int totalDocsLoadedLength() {
    return datalistSnapshot.length;
  }

  updateparticulardocinProvider({
    required DocumentSnapshot updatedDoc,
  }) async {
    int index = datalistSnapshot.indexWhere(
        (doc) => doc[Dbkeys.groupmsgTIME] == updatedDoc[Dbkeys.groupmsgTIME]);

    datalistSnapshot.removeAt(index);
    datalistSnapshot.insert(index, updatedDoc);
    notifyListeners();
  }

  deleteparticulardocinProvider({required DocumentSnapshot deletedDoc}) async {
    int index = datalistSnapshot.indexWhere(
        (doc) => doc[Dbkeys.groupmsgTIME] == deletedDoc[Dbkeys.groupmsgTIME]);

    if (index >= 0) {
      datalistSnapshot.removeAt(index);
      notifyListeners();
    }
  }
}
