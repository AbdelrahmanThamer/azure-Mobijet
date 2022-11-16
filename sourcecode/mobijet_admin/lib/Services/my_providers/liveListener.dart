import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseLiveDataServices {
  // FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;/

  //recieve the data

  Stream<SpecialLiveConfigData> getLiveData(DocumentReference query) {
    return query
        .snapshots()
        .map((document) => SpecialLiveConfigData.fromJson(document.data()));
  }
}

class SpecialLiveConfigData {
  var docmap = {};

  SpecialLiveConfigData.fromJson(var parsedJSON) : docmap = parsedJSON;
}
