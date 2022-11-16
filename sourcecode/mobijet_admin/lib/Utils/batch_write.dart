import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> batchwriteFirestoreData(List taskList) async {
  WriteBatch writeBatch = FirebaseFirestore.instance.batch();
//-------Below Firestore Document for Admin Credentials ---------
  taskList.forEach((f) {
    var task = Map<String, dynamic>.from(f);
    writeBatch.set(task['ref'], task['map'], SetOptions(merge: true));
  });

  // writeBatch.set(
  //     FirebaseFirestore.instance
  //         .collection(DbPaths.adminapp)
  //         .doc(DbPaths.admincred),
  //     adminappsettingsmap);

// unless commit is called, nothing happens. So commit is called below---
  await writeBatch.commit().catchError((err) {
    // ignore: invalid_return_type_for_catch_error
    return false;
  });
  return true;
}
