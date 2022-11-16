import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/number_limits.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';

class FirebaseApi {
  static Future<void> runDELETEmapobjectinListField({
    GlobalKey? keyloader,
    BuildContext? context,
    required DocumentReference docrefdata,
    required String compareKey,
    required dynamic compareVal,
    Function? secondfn,
    String? listkeyname,
    bool? isshowloader = false,
    required Function(String s) onErrorFn,
    required Function() onSuccessFn,
  }) async {
    if (isshowloader == true) {
      ShowLoading().open(context: context!, key: keyloader);
    }

    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      DocumentReference newrefdata = docrefdata;
      DocumentSnapshot docSnapshot = await tx.get(newrefdata);

      if (docSnapshot.exists) {
        List? newlist = docSnapshot[listkeyname ?? Dbkeys.list];

        int ind = newlist!.lastIndexWhere((dc) => dc[compareKey] == compareVal);

        if (ind >= 0) {
          newlist.removeAt(ind);
          tx.update(
              newrefdata,
              listkeyname == null
                  ? {Dbkeys.list: newlist}
                  : {listkeyname: newlist});
        } else {
          if (isshowloader == true) {
            ShowLoading().close(context: context, key: keyloader!);
          }

          onErrorFn("does-not-exists");
        }
      } else {
        if (isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }

        onErrorFn("does-not-exists");
      }
    }).then((result) {
      if (secondfn != null) {
        secondfn();
        if (isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }
        onSuccessFn();
      } else {
        if (isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }
        onSuccessFn();
      }
    }).catchError((error) {
      if (isshowloader == true) {
        ShowLoading().close(context: context, key: keyloader!);
      }
      onErrorFn(
          '${getTranslatedForCurrentUser(context!, 'xxxfailedntryagainxxx')}\n $error');

      print('Error: $error');
    });
  }

  static Future<void> runUPDATEmapobjectinListField({
    GlobalKey? keyloader,
    BuildContext? context,
    required DocumentReference docrefdata,
    required String compareKey,
    required dynamic compareVal,
    Function? secondfn,
    String? listkeyname,
    required Map<String, dynamic> replaceableMapObjectWithOnlyFieldsRequired,
    bool? isshowloader = false,
    required Function(String s) onErrorFn,
    required Function() onSuccessFn,
  }) async {
    if (isshowloader == true) {
      ShowLoading().open(context: context!, key: keyloader);
    }

    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      DocumentReference newrefdata = docrefdata;
      DocumentSnapshot docSnapshot = await tx.get(newrefdata);

      if (docSnapshot.exists) {
        List? newlist = docSnapshot[listkeyname ?? Dbkeys.list];

        List mykeylist =
            replaceableMapObjectWithOnlyFieldsRequired.keys.toList();
        List myvaluelist =
            replaceableMapObjectWithOnlyFieldsRequired.values.toList();
        int ind = newlist!.lastIndexWhere((dc) => dc[compareKey] == compareVal);

        if (ind >= 0) {
          for (int i = 0; i < mykeylist.length; i++) {
            newlist[ind][mykeylist[i]] = myvaluelist[i];
          }
          tx.update(
              newrefdata,
              listkeyname == null
                  ? {Dbkeys.list: newlist}
                  : {listkeyname: newlist});
        } else {
          if (isshowloader == true) {
            ShowLoading().close(context: context, key: keyloader!);
          }

          onErrorFn("does-not-exists");
        }
      } else {
        if (isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }

        onErrorFn("does-not-exists");
      }
    }).then((result) {
      if (secondfn != null) {
        secondfn();
        if (isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }
        onSuccessFn();
      } else {
        if (isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }
        onSuccessFn();
      }
    }).catchError((error) {
      if (isshowloader == true) {
        ShowLoading().close(context: context, key: keyloader!);
      }
      onErrorFn(
          '${getTranslatedForCurrentUser(context!, 'xxxfailedntryagainxxx')}\n $error');

      print('Error: $error');
    });
  }

  static Future<void> runTransactionRecordActivity({
    required String parentid,
    required String title,
    required String postedbyID,
    required Function(String s) onErrorFn,
    required Function() onSuccessFn,
    required String plainDesc,
    String? styledDesc,
    String? imageurl = "",
    bool? isOnlyAlertNotSave = false,
    Function? secondfn,
    bool? isshowloader = false,
    GlobalKey? keyloader,
    BuildContext? context,
  }) async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection(DbPaths.adminapp)
        .doc(DbPaths.collectionhistory);
    if (isshowloader == true) {
      ShowLoading().open(context: context!, key: keyloader);
    }
    if (isOnlyAlertNotSave == true) {
      await docRef.set({
        Dbkeys.nOTIFICATIONxxaction: Dbkeys.nOTIFICATIONactionPUSH,
        Dbkeys.nOTIFICATIONxxdesc: plainDesc,
        Dbkeys.nOTIFICATIONxxtitle: title,
        Dbkeys.nOTIFICATIONxximageurl: imageurl,
      }, SetOptions(merge: true)).then((value) {
        if (isshowloader == true) {
          ShowLoading().close(context: context!, key: keyloader!);
        }
        onSuccessFn();
      });
    } else {
      FirebaseFirestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot docSnapshot = await tx.get(docRef);

        if (docSnapshot.exists) {
          List templist = docSnapshot[Dbkeys.list];
          if (templist.length > Numberlimits.totalhistorystore) {
            templist.removeRange(0, Numberlimits.totalhistorydeleterange);
          }
          templist.add({
            Dbkeys.docid: DateTime.now().millisecondsSinceEpoch.toString(),
            Dbkeys.nOTIFICATIONxxdesc: styledDesc ?? plainDesc,
            Dbkeys.nOTIFICATIONxxtitle: title,
            Dbkeys.nOTIFICATIONxximageurl: imageurl,
            Dbkeys.nOTIFICATIONxxlastupdateepoch:
                DateTime.now().millisecondsSinceEpoch,
            Dbkeys.nOTIFICATIONxxauthor: postedbyID,
            Dbkeys.nOTIFICATIONxxextrafield: parentid
          });

          tx.update(docRef, {
            Dbkeys.nOTIFICATIONxxaction: Dbkeys.nOTIFICATIONactionPUSH,
            Dbkeys.nOTIFICATIONxxdesc: plainDesc,
            Dbkeys.nOTIFICATIONxxtitle: title,
            Dbkeys.nOTIFICATIONxximageurl: imageurl,
            Dbkeys.nOTIFICATIONxxlastupdateepoch:
                DateTime.now().millisecondsSinceEpoch,
            Dbkeys.list: templist
          });
        } else {
          if (isshowloader == true) {
            ShowLoading().close(context: context, key: keyloader!);
          }

          onErrorFn(
              "Document Does not exist. Please contact the developer. DOCREF: ${docRef.toString()}");
        }
      }).then((result) {
        if (isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }

        if (secondfn == null || secondfn == () {}) {
          onSuccessFn();
        } else {
          secondfn();
        }
      }).catchError((error) {
        if (isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }

        onErrorFn(error.toString());
      });
    }
  }

  static Future<void> runTransactionSendNotification({
    required DocumentReference docRef,
    required String title,
    required String postedbyID,
    required Function(String s) onErrorFn,
    required Function() onSuccessFn,
    required String parentid,
    required String plainDesc,
    String? styledDesc,
    String? imageurl = "",
    String? action,
    bool? isOnlyAlertNotSave = false,
    Function? secondfn,
    bool? isshowloader = false,
    int? totallimitfordelete = Numberlimits.totalnotificationstore,
    int? totaldeleterange = Numberlimits.totalnotificationdeleterange,
    String? listkeyname,
    GlobalKey? keyloader,
    BuildContext? context,
  }) async {
    if (isshowloader == true) {
      ShowLoading().open(context: context!, key: keyloader);
    }
    if (isOnlyAlertNotSave == true) {
      await docRef.set({
        Dbkeys.nOTIFICATIONxxaction: action ?? Dbkeys.nOTIFICATIONactionPUSH,
        Dbkeys.nOTIFICATIONxxdesc: plainDesc,
        Dbkeys.nOTIFICATIONxxtitle: title,
        Dbkeys.nOTIFICATIONxximageurl: imageurl,
      }, SetOptions(merge: true)).then((value) {
        if (isshowloader == true) {
          ShowLoading().close(context: context!, key: keyloader!);
        }
        onSuccessFn();
      });
    } else {
      FirebaseFirestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot docSnapshot = await tx.get(docRef);

        if (docSnapshot.exists) {
          List templist = docSnapshot[listkeyname ?? Dbkeys.list];
          if (templist.length > totallimitfordelete!) {
            templist.removeRange(0, totaldeleterange!);
          }
          templist.add({
            Dbkeys.docid: DateTime.now().millisecondsSinceEpoch.toString(),
            Dbkeys.nOTIFICATIONxxdesc: styledDesc ?? plainDesc,
            Dbkeys.nOTIFICATIONxxtitle: title,
            Dbkeys.nOTIFICATIONxximageurl: imageurl,
            Dbkeys.nOTIFICATIONxxlastupdateepoch:
                DateTime.now().millisecondsSinceEpoch,
            Dbkeys.nOTIFICATIONxxauthor: postedbyID,
            Dbkeys.nOTIFICATIONxxextrafield: parentid.toString(),
          });

          tx.update(
              docRef,
              listkeyname == Dbkeys.list || listkeyname == null
                  ? {
                      Dbkeys.nOTIFICATIONxxaction:
                          action ?? Dbkeys.nOTIFICATIONactionPUSH,
                      Dbkeys.nOTIFICATIONxxdesc: plainDesc,
                      Dbkeys.nOTIFICATIONxxtitle: title,
                      Dbkeys.nOTIFICATIONxximageurl: imageurl,
                      Dbkeys.nOTIFICATIONxxlastupdateepoch:
                          DateTime.now().millisecondsSinceEpoch,
                      Dbkeys.list: templist
                    }
                  : {
                      Dbkeys.nOTIFICATIONxxaction:
                          action ?? Dbkeys.nOTIFICATIONactionPUSH,
                      Dbkeys.nOTIFICATIONxxdesc: plainDesc,
                      Dbkeys.nOTIFICATIONxxtitle: title,
                      Dbkeys.nOTIFICATIONxximageurl: imageurl,
                      Dbkeys.nOTIFICATIONxxlastupdateepoch:
                          DateTime.now().millisecondsSinceEpoch,
                      listkeyname: templist
                    });
        } else {
          if (isshowloader == true) {
            ShowLoading().close(context: context, key: keyloader!);
          }

          onErrorFn(
              "Document Does not exist. Please contact the developer. DOCREF: ${docRef.toString()}");
        }
      }).then((result) {
        if (isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }

        if (secondfn == null || secondfn == () {}) {
          onSuccessFn();
        } else {
          secondfn();
        }
      }).catchError((error) {
        if (isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }

        onErrorFn(error.toString());
      });
    }
  }

  static Future<dynamic> deleteFirebaseMediaUsingURL(String url) async {
    Reference storageref = FirebaseStorage.instance.refFromURL(url);

    try {
      await storageref.delete().onError((err, stackTrace) {
        if (err.toString().contains(Dbkeys.firebaseStorageNoObjectFound1) ||
            err.toString().contains(Dbkeys.firebaseStorageNoObjectFound2) ||
            err.toString().contains(Dbkeys.firebaseStorageNoObjectFound3) ||
            err.toString().contains(Dbkeys.firebaseStorageNoObjectFound4) ||
            err.toString().contains(Dbkeys.firebaseStorageNoObjectFound5) ||
            err.toString().contains(Dbkeys.firebaseStorageNoObjectFound6) ||
            err.toString().contains(Dbkeys.firebaseStorageNoObjectFound7) ||
            err.toString().contains(Dbkeys.firebaseStorageNoObjectFound8)) {
          return true;
        } else {
          return "Failed to Delete ! \nError: $err";
        }
      });
    } catch (err) {
      if (err.toString().contains(Dbkeys.firebaseStorageNoObjectFound1) ||
          err.toString().contains(Dbkeys.firebaseStorageNoObjectFound2) ||
          err.toString().contains(Dbkeys.firebaseStorageNoObjectFound3) ||
          err.toString().contains(Dbkeys.firebaseStorageNoObjectFound4) ||
          err.toString().contains(Dbkeys.firebaseStorageNoObjectFound5) ||
          err.toString().contains(Dbkeys.firebaseStorageNoObjectFound6) ||
          err.toString().contains(Dbkeys.firebaseStorageNoObjectFound7) ||
          err.toString().contains(Dbkeys.firebaseStorageNoObjectFound8)) {
        return true;
      } else {
        return "Failed to Delete ! \nError: $err";
      }
    }
  }

//-----UPDATED
  static Future<QuerySnapshot> getFirestoreCOLLECTIONData(int limit,
      {DocumentSnapshot? startAfter, String? dataType, Query? refdata}) async {
    if (startAfter == null) {
      return refdata!.get();
    } else {
      return refdata!.startAfterDocument(startAfter).get();
    }
  }

  static Future<DocumentSnapshot> getFirestoreDOCUMENTData(
      String? dataType, DocumentReference refdata) async {
    return refdata.get();
  }

  Future<void> runUPDATEtransaction({
    GlobalKey? keyloader,
    GlobalKey? scaffoldkey,
    BuildContext? context,
    DocumentReference? refdata,
    String? compareKey,
    bool? isshowmsg,
    bool? isusesecondfn,
    bool? isreplace,
    String? compareVal,
    Function? secondfn,
    String? listreplaceablekey,
    Map<String, dynamic>? updatemap,
    String? newstringinlist,
    bool? isincremental,
    String? incrementalkey,
    String? decrementalkey,
    bool? isshowloader,
  }) async {
    if (isshowloader == null || isshowloader == true) {
      ShowLoading().open(context: context!, key: keyloader);
    }

    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      DocumentReference newrefdata = refdata!;
      DocumentSnapshot docSnapshot = await tx.get(newrefdata);

      if (docSnapshot.exists) {
        List? newlist = docSnapshot[listreplaceablekey ?? Dbkeys.list];
        if (isincremental == false || isincremental == null) {
          if (newstringinlist == null) {
            List mykeylist = updatemap!.keys.toList();
            List myvaluelist = updatemap.values.toList();
            int ind = newlist!.indexWhere((dc) => dc[compareKey] == compareVal);
            print(ind);
            if (ind >= 0) {
              // newlist[ind][];
              for (int i = 0; i < mykeylist.length; i++) {
                newlist[ind][mykeylist[i]] = myvaluelist[i];
                print('For Loop Called $i Times');
              }
              tx.update(
                  newrefdata,
                  listreplaceablekey == null
                      ? {Dbkeys.list: newlist}
                      : {listreplaceablekey: newlist});
            } else {
              if (isshowloader == null || isshowloader == true) {
                ShowLoading().close(context: context, key: keyloader!);
              }

              ShowSnackbar().open(
                  context: context,
                  scaffoldKey: scaffoldkey as GlobalKey<ScaffoldState>,
                  time: 4,
                  status: 1,
                  label: 'Field doesn\'t exists ! Please reload this page.');
            }
          } else {
            if (isreplace == false || isreplace == null) {
              newlist!.insert(newlist.length, newstringinlist);
              tx.update(
                  newrefdata,
                  listreplaceablekey == null
                      ? {Dbkeys.list: newlist}
                      : {listreplaceablekey: newlist});
            } else {
              // print(newstringinlist);
              int ind = newlist!.indexWhere(
                  (element) => element.toString() == compareKey.toString());
              newlist.removeAt(ind);
              newlist.insert(ind, newstringinlist);
              tx.update(
                  newrefdata,
                  listreplaceablekey == null
                      ? {Dbkeys.list: newlist}
                      : {listreplaceablekey: newlist});
            }
          }
        } else {
          int ind =
              newlist!.indexWhere((dc) => dc[compareKey].contains(compareVal));
          Map updateobject = newlist[ind];
          int val = updateobject[incrementalkey];
          updateobject[incrementalkey] = val + 1;
          if (decrementalkey != null) {
            updateobject[decrementalkey] = val - 1;
          }
          newlist.removeAt(ind);
          newlist.insert(ind, updateobject);
          tx.update(
              newrefdata,
              listreplaceablekey == null
                  ? {Dbkeys.list: newlist}
                  : {listreplaceablekey: newlist});
        }
      } else {
        if (isshowloader == null || isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }

        ShowSnackbar().open(
            context: context,
            scaffoldKey: scaffoldkey as GlobalKey<ScaffoldState>,
            time: 4,
            status: 1,
            label: 'Document doesn\'t exists ! Please reload this page.');
      }
    }).then((result) {
      print('success transaction');
      if (isshowloader == null || isshowloader == true) {
        ShowLoading().close(context: context, key: keyloader!);
      }

      if (isshowmsg == true || isshowmsg == null) {
        ShowSnackbar().open(
            context: context,
            scaffoldKey: scaffoldkey as GlobalKey<ScaffoldState>,
            time: 2,
            status: 2,
            label: 'Success ! Operation successfully performed.');
      }
      if (isusesecondfn == false || isusesecondfn == null) {
      } else {
        secondfn!();
      }

      //  FocusScope.of(context).requestFocus(new FocusNode());
      //  showSnackBar('File Added Succesfully', 2,1);
    }).catchError((error) {
      print('errorr');
      if (isshowloader == null || isshowloader == true) {
        ShowLoading().close(context: context, key: keyloader!);
      }

      //  FocusScope.of(context).requestFocus(new FocusNode());
      print('Error: $error');
      ShowCustomAlertDialog().open(
          context: context!,
          scaffoldkey: scaffoldkey,
          dialogtype: 'error',
          errorlog: error,
          title: 'Operation Failed !',
          description:
              '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}\n $error');
    });
  }

  static Future<void> runUPDATEtransactionInFirestoreDocument({
    GlobalKey? keyloader,
    required BuildContext context,
    required DocumentReference refdata,
    Map<String, dynamic>? updatemap,
    required Function onsuccess,
    required Function(String e) onerror,
    bool? isshowloader = false,
  }) async {
    if (isshowloader == true && keyloader != null) {
      ShowLoading().open(context: context, key: keyloader);
    }

    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      DocumentReference newrefdata = refdata;
      DocumentSnapshot docSnapshot = await tx.get(newrefdata);

      if (docSnapshot.exists) {
        tx.update(newrefdata, updatemap!);
      } else {
        if (isshowloader == true && keyloader != null) {
          ShowLoading().close(context: context, key: keyloader);
        }

        onerror("Document does not exist. please report it to developer");
      }
    }).then((result) {
      if (isshowloader == null || isshowloader == true) {
        ShowLoading().close(context: context, key: keyloader!);
      }
      onsuccess();
    }).catchError((error) {
      print('errorr');
      if (keyloader != null && isshowloader == true) {
        ShowLoading().close(context: context, key: keyloader);
      }

      print('Error: $error');
      onerror("ERROR occured - $error");
    });
  }

  Future<void> runUPDATEtransactionInDocumentIncrement({
    GlobalKey? keyloader,
    GlobalKey? scaffoldkey,
    BuildContext? context,
    DocumentReference? refdata,
    bool? isshowmsg,
    bool? isusesecondfn,
    Function? secondfn,
    Map<String, dynamic>? updatemap,
    bool? isincremental,
    Map<String, dynamic>? insertMapInListfield,
    String? incrementalkey,
    String? decrementalkey,
    bool? isshowloader,
  }) async {
    if (isshowloader == null || isshowloader == true) {
      ShowLoading().open(context: context!, key: keyloader);
    }

    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      DocumentReference newrefdata = refdata!;
      DocumentSnapshot docSnapshot = await tx.get(newrefdata);

      if (docSnapshot.exists) {
        // Extend 'favorites' if the list does not contain the recipe ID:

        if (isincremental == false || isincremental == null) {
          if (insertMapInListfield != null) {
            Map<String, dynamic> updateobject =
                docSnapshot.data() as Map<String, dynamic>;
            updateobject['list'].add(insertMapInListfield);
            updateobject.addAll(updatemap!);
            tx.update(newrefdata, updateobject);
          } else {
            tx.update(newrefdata, updatemap!);
          }
        } else {
          Map<String?, dynamic> updateobject =
              docSnapshot.data() as Map<String?, dynamic>;
          int valincr = updateobject[incrementalkey];
          int? valdecr = updateobject[decrementalkey];
          updateobject[incrementalkey] = valincr + 1;
          if (decrementalkey != null) {
            updateobject[decrementalkey] = valdecr! - 1;
          }

          tx.update(newrefdata, updateobject as Map<String, dynamic>);
        }

        // Delete the recipe ID from 'favorites':
        // } else {
        //   await tx.update(favoritesReference, <String, dynamic>{
        //     'favorites': FieldValue.arrayRemove([recipeId])
        //   });
        // }

      } else {
        if (isshowloader == null || isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }

        ShowSnackbar().open(
            context: context,
            scaffoldKey: scaffoldkey as GlobalKey<ScaffoldState>,
            time: 4,
            status: 1,
            label: 'Document doesn\'t exists ! Please reload this page.');
      }
    }).then((result) {
      if (isshowloader == null || isshowloader == true) {
        ShowLoading().close(context: context, key: keyloader!);
      }

      if (isshowmsg == true || isshowmsg == null) {
        ShowSnackbar().open(
            context: context,
            scaffoldKey: scaffoldkey as GlobalKey<ScaffoldState>,
            time: 2,
            status: 2,
            label: 'Success ! Operation successfully performed.');
      }
      if (isusesecondfn == false || isusesecondfn == null) {
      } else {
        secondfn!();
      }

      //  FocusScope.of(context).requestFocus(new FocusNode());
      //  showSnackBar('File Added Succesfully', 2,1);
    }).catchError((error) {
      print('errorr');
      if (isshowloader == null || isshowloader == true) {
        ShowLoading().close(context: context, key: keyloader!);
      }

      //  FocusScope.of(context).requestFocus(new FocusNode());
      print('Error: $error');
      ShowCustomAlertDialog().open(
          context: context!,
          scaffoldkey: scaffoldkey,
          dialogtype: 'error',
          errorlog: error,
          title: 'Operation Failed !',
          description:
              '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}\n $error');
    });
  }

  Future<void> runUPDATEtransactionWithQuantityCheck({
    GlobalKey? keyloader,
    GlobalKey? scaffoldkey,
    BuildContext? context,
    Function(String val)? onerror,
    DocumentReference? refdata,
    int? totallimitfordelete,
    int? totaldeleterange,
    bool? isshowmsg,
    String? listname,
    bool? isusesecondfn,
    Function? secondfn,
    var newmap,
    bool? isshowloader,
  }) async {
    if (isshowloader == null || isshowloader == true) {
      ShowLoading().open(context: context!, key: keyloader);
    }

    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot docSnapshot = await tx.get(refdata ??
          FirebaseFirestore.instance
              .collection(DbPaths.collectionhistory)
              .doc(DbPaths.collectionhistory));

      if (docSnapshot.exists) {
        List templist = docSnapshot[listname ?? Dbkeys.list];
        if (templist.length > totallimitfordelete!) {
          templist.removeRange(0, totaldeleterange ?? 50);
        }
        templist.add(newmap);

        tx.update(
            refdata ??
                FirebaseFirestore.instance
                    .collection(DbPaths.collectionhistory)
                    .doc(DbPaths.collectionhistory),
            listname == null ? {Dbkeys.list: templist} : {listname: templist});
      } else {
        if (isshowloader == null || isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }

        ShowSnackbar().open(
            context: context,
            scaffoldKey: scaffoldkey as GlobalKey<ScaffoldState>,
            time: 4,
            status: 1,
            label: 'Document doesn\'t exists ! Please reload this page.');
      }
    }).then((result) {
      if (isshowloader == null || isshowloader == true) {
        ShowLoading().close(context: context, key: keyloader!);
      }

      if (isshowmsg == true || isshowmsg == null) {
        ShowSnackbar().open(
            context: context,
            scaffoldKey: scaffoldkey as GlobalKey<ScaffoldState>,
            time: 2,
            status: 2,
            label: 'Success ! Operation successfully performed.');
      }
      if (isusesecondfn == false || isusesecondfn == null) {
      } else {
        secondfn!();
      }

      //  FocusScope.of(context).requestFocus(new FocusNode());
      //  showSnackBar('File Added Succesfully', 2,1);
    }).catchError((error) {
      if (isshowloader == null || isshowloader == true) {
        ShowLoading().close(context: context, key: keyloader!);
      }
      if (onerror == null) {
        print('Error: $error');
        ShowCustomAlertDialog().open(
            context: context!,
            scaffoldkey: scaffoldkey,
            dialogtype: 'error',
            errorlog: error,
            title: 'Operation Failed !',
            description:
                '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}\n $error');
      } else {
        onerror(error);
      }
      //  FocusScope.of(context).requestFocus(new FocusNode());
    });
  }

  Future<void> runDELETEtransaction({
    GlobalKey? keyloader,
    GlobalKey? scaffoldkey,
    BuildContext? context,
    DocumentReference? refdata,
    String? compareKey,
    bool? isshowmsg,
    String? compareVal,
    Function? secondfn,
    bool? isusesecondfn,
    bool? iswholeelementcompareable,
    bool? isshowloader,
    String? listalternative,
  }) async {
    if (isshowloader == null || isshowloader == true) {
      ShowLoading().open(context: context!, key: keyloader);
    }

    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot docSnapshot = await tx.get(refdata!);

      if (docSnapshot.exists) {
        List? newlist = docSnapshot[listalternative ?? Dbkeys.list];
        int ind = iswholeelementcompareable == false ||
                iswholeelementcompareable == null
            ? newlist!.indexWhere((dc) => dc[compareKey] == compareVal)
            : newlist!
                .indexWhere((dc) => dc.toString() == compareKey.toString());
        print(ind);
        if (ind >= 0) {
          // newlist[ind][];
          newlist.removeAt(ind);

          tx.update(
              refdata,
              listalternative == null
                  ? {Dbkeys.list: newlist}
                  : {listalternative: newlist});
        } else {
          if (isshowloader == null || isshowloader == true) {
            ShowLoading().close(context: context, key: keyloader!);
          }

          ShowSnackbar().open(
              context: context,
              scaffoldKey: scaffoldkey as GlobalKey<ScaffoldState>,
              time: 4,
              status: 1,
              label: 'Field doesn\'t exists ! Please reload this page.');
        }
        print('------- UPDATE CODE End --------');
        // Delete the recipe ID from 'favorites':
        // } else {
        //   await tx.update(favoritesReference, <String, dynamic>{
        //     'favorites': FieldValue.arrayRemove([recipeId])
        //   });
        // }

      } else {
        if (isshowloader == null || isshowloader == true) {
          ShowLoading().close(context: context, key: keyloader!);
        }

        ShowSnackbar().open(
            context: context,
            scaffoldKey: scaffoldkey as GlobalKey<ScaffoldState>,
            time: 4,
            status: 1,
            label: 'Document doesn\'t exists ! Please reload this page.');
      }
    }).then((result) {
      print('success result ;$result');
      if (isshowloader == null || isshowloader == true) {
        ShowLoading().close(context: context, key: keyloader!);
      }

      if (isshowmsg == true || isshowmsg == null) {
        ShowSnackbar().open(
            context: context,
            scaffoldKey: scaffoldkey as GlobalKey<ScaffoldState>,
            time: 2,
            status: 2,
            label: 'Success ! Operation successfully performed.');
      }
      if (isusesecondfn == false || isusesecondfn == null) {
      } else {
        secondfn!();
      }
    }).catchError((error) {
      if (isshowloader == null || isshowloader == true) {
        ShowLoading().close(context: context, key: keyloader!);
      }

      //  FocusScope.of(context).requestFocus(new FocusNode());

      ShowCustomAlertDialog().open(
          context: context!,
          scaffoldkey: scaffoldkey,
          dialogtype: 'error',
          errorlog: error,
          title: 'Operation Failed !',
          description:
              '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}\n $error');
    });
  }
}
