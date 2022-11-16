import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/number_limits.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/batch_write_component.dart';
import 'package:thinkcreative_technologies/Models/customer_model.dart';
import 'package:thinkcreative_technologies/Models/user_registry_model.dart';
import 'package:thinkcreative_technologies/Models/userapp_settings_model.dart';
import 'package:thinkcreative_technologies/Services/my_providers/firestore_collections_data_admin.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Utils/backupUserTable.dart';
import 'package:thinkcreative_technologies/Utils/batch_write.dart';
import 'package:thinkcreative_technologies/Utils/custom_url_launcher.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/WarningWidgets/warning_tile.dart';
import 'package:thinkcreative_technologies/Widgets/custom_buttons.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';

class BulkImportCustomers extends StatefulWidget {
  const BulkImportCustomers({Key? key}) : super(key: key);

  @override
  State<BulkImportCustomers> createState() => _BulkImportCustomersState();
}

class _BulkImportCustomersState extends State<BulkImportCustomers> {
  // bool isDeleteChats = false;
  List<dynamic> eventlist = [];
  bool isProcessing = false;
  int totalUsersToPreocess = 0;
  int totalusersProcessingDone = 0;
  int newuserscreated = 0;
  bool isLoading = true;
  String err = "";
  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  String error = "";
  UserAppSettingsModel? userAppSettings;
  fetchdata() async {
    await FirebaseFirestore.instance
        .collection(DbPaths.userapp)
        .doc(DbPaths.appsettings)
        .get()
        .then((dc) async {
      if (dc.exists) {
        userAppSettings = UserAppSettingsModel.fromSnapshot(dc);
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          error = getTranslatedForCurrentUser(
              context, 'xxuserappsetupincompletexx');
        });
      }
    }).catchError((onError) {
      setState(() {
        error =
            getTranslatedForCurrentUser(context, 'xxuserappsetupincompletexx') +
                ". ${onError.toString()}";

        isLoading = false;
      });
    });

    final observer = Provider.of<Observer>(context, listen: false);
    observer.fetchUserAppSettings(context);
  }

  createNewCustomer(
      String finalID,
      String fullname,
      String email,
      String mobilenumber,
      String onlycode,
      String onlynumber,
      String password,
      Observer observer,
      bool islast) async {
    var names = fullname.trim().split(' ');

    String shortname = fullname.trim();
    String lastName = "";
    if (names.length > 1) {
      shortname = names[0];
      lastName = names[1];
      if (shortname.length < 3) {
        shortname = lastName;
        if (lastName.length < 3) {
          shortname = fullname;
        }
      }
    }

    await batchwriteFirestoreData([
      BatchWriteComponent(
              ref: FirebaseFirestore.instance
                  .collection(DbPaths.collectioncustomers)
                  .doc(finalID),
              map: CustomerModel(
                accountcreatedby: Optionalconstants.currentAdminID,
                rolesassigned: [],
                platform: Platform.isAndroid
                    ? "android"
                    : Platform.isIOS
                        ? "ios"
                        : "",
                id: finalID,
                userLoginType: observer.basicSettingUserApp!.loginTypeUserApp ==
                        "Email/Password"
                    ? LoginType.email.index
                    : LoginType.phone.index,
                email: email,
                password: '',
                firebaseuid: "",
                nickname: fullname,
                searchKey: fullname.trim().substring(0, 1).toUpperCase(),
                phone: mobilenumber,
                phoneRaw: onlynumber,
                countryCode: onlycode,
                photoUrl: '',
                aboutMe: '',
                actionmessage: '',
                currentDeviceID: "",
                privateKey: "",
                publicKey: "",
                accountstatus: Dbkeys.sTATUSallowed,
                audioCallMade: 0,
                videoCallMade: 0,
                audioCallRecieved: 0,
                videoCallRecieved: 0,
                groupsCreated: 0,
                authenticationType: 0,
                passcode: '',
                totalvisitsANDROID: 0,
                totalvisitsIOS: 0,
                lastLogin: DateTime.now().millisecondsSinceEpoch,
                joinedOn: DateTime.now().millisecondsSinceEpoch,
                lastOnline: DateTime.now().millisecondsSinceEpoch,
                lastSeen: DateTime.now().millisecondsSinceEpoch,
                lastNotificationSeen: DateTime.now().millisecondsSinceEpoch,
                isNotificationStringsMulitilanguageEnabled: false,
                notificationStringsMap: {},
                kycMap: {},
                geoMap: {},
                phonenumbervariants: [],
                hidden: [],
                locked: [],
                notificationTokens: [],
                deviceDetails: {},
                quickReplies: [],
                lastVerified: 0,
                ratings: [],
                totalRepliesInTickets: 0,
                twoFactorVerification: {},
                userTypeIndex: Usertype.customer.index,
              ).toMap())
          .toMap(),
      BatchWriteComponent(
          ref: FirebaseFirestore.instance
              .collection(DbPaths.collectioncustomers)
              .doc(finalID)
              .collection(DbPaths.customernotifications)
              .doc(DbPaths.customernotifications),
          map: {
            Dbkeys.nOTIFICATIONisunseen: true,
            Dbkeys.nOTIFICATIONxxtitle: '',
            Dbkeys.nOTIFICATIONxxdesc: '',
            Dbkeys.nOTIFICATIONxxaction: Dbkeys.nOTIFICATIONactionNOPUSH,
            Dbkeys.nOTIFICATIONxximageurl: '',

            Dbkeys.nOTIFICATIONxxlastupdateepoch:
                DateTime.now().millisecondsSinceEpoch,
            Dbkeys.nOTIFICATIONxxpagecomparekey: Dbkeys.docid,
            Dbkeys.nOTIFICATIONxxpagecompareval: '',
            Dbkeys.nOTIFICATIONxxparentid: '',
            Dbkeys.nOTIFICATIONxxextrafield: '',
            Dbkeys.nOTIFICATIONxxpagetype:
                Dbkeys.nOTIFICATIONpagetypeSingleLISTinDOCSNAP,
            Dbkeys.nOTIFICATIONxxpageID: DbPaths.customernotifications,
            //-----
            Dbkeys.nOTIFICATIONpagecollection1: DbPaths.collectioncustomers,
            Dbkeys.nOTIFICATIONpagedoc1: finalID,
            Dbkeys.nOTIFICATIONpagecollection2: DbPaths.customernotifications,
            Dbkeys.nOTIFICATIONpagedoc2: DbPaths.customernotifications,
            Dbkeys.nOTIFICATIONtopic: Dbkeys.topicCUSTOMERS,
            Dbkeys.list: [],
          }).toMap(),
      BatchWriteComponent(
        ref: FirebaseFirestore.instance
            .collection(DbPaths.userapp)
            .doc(DbPaths.docusercount),
        map: {
          Dbkeys.totalapprovedcustomers: FieldValue.increment(1),
        },
      ).toMap(),
      BatchWriteComponent(
              ref: FirebaseFirestore.instance
                  .collection(DbPaths.collectioncustomers)
                  .doc(finalID)
                  .collection("backupTable")
                  .doc("backupTable"),
              map: userbackuptable)
          .toMap(),
      BatchWriteComponent(
        ref: FirebaseFirestore.instance
            .collection(DbPaths.userapp)
            .doc(DbPaths.registry),
        map: {
          Dbkeys.lastupdatedepoch: DateTime.now().millisecondsSinceEpoch,
          Dbkeys.list: FieldValue.arrayUnion([
            UserRegistryModel(
                shortname: shortname,
                fullname: fullname.trim(),
                id: finalID,
                phone: mobilenumber,
                photourl: "",
                usertype: Usertype.customer.index,
                email: "",
                extra1: "",
                extra2: "",
                extraMap: {}).toMap()
          ])
        },
      ).toMap(),
    ]).then((value) async {
      if (value == false) {
        totalusersProcessingDone++;
        eventlist.add({
          "t": "e",
          "r": getTranslatedForCurrentUser(context, 'xxxfailedtobatchwritexxx')
              .replaceAll('(####)',
                  '${getTranslatedForCurrentUser(context, 'xxcustomeridxx')} $finalID'),
        });

        setState(() {});

        if (islast == true) {
          eventlist.add({
            "t": "s",
            "r":
                getTranslatedForCurrentUser(context, 'xxxfinishedprocessingxxx')
          });
          isProcessing = false;
          setState(() {});
        }
      } else {
        totalusersProcessingDone++;
        newuserscreated++;
        eventlist.add({
          "t": "s",
          "r": getTranslatedForCurrentUser(
                  context, 'xxxxsuccesfullycreatedxxxx')
              .replaceAll('(####)',
                  '${getTranslatedForCurrentUser(context, 'xxcustomeridxx')} $finalID')
        });

        setState(() {});

        final firestore =
            Provider.of<FirestoreDataProviderCUSTOMERS>(context, listen: false);
        if (islast == true) {
          eventlist.add({
            "t": "s",
            "r":
                getTranslatedForCurrentUser(context, 'xxxfinishedprocessingxxx')
          });
          isProcessing = false;
          setState(() {});
          firestore.fetchNextData(
              Dbkeys.dataTypeCUSTOMERS,
              FirebaseFirestore.instance
                  .collection(DbPaths.collectioncustomers)
                  .orderBy(Dbkeys.joinedOn, descending: true)
                  .limit(Numberlimits.totalDatatoLoadAtOnceFromFirestore),
              true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => isProcessing == true ? false : true,
        child: MyScaffold(
          title: getTranslatedForCurrentUser(context, 'xxximportxfromxxxx')
              .replaceAll('(####)',
                  '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')
              .replaceAll('(###)', 'Excel'),
          leadingIconData: Icons.close,
          leadingIconPress: () {
            if (isProcessing == true) {
            } else {
              Navigator.of(context).pop();
            }
          },
          body: err != ""
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(err),
                  ),
                )
              : isLoading == true
                  ? circularProgress()
                  : Consumer<Observer>(
                      builder: (context, observer, _child) => ListView(
                            padding: EdgeInsets.all(15),
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              isProcessing == true
                                  ? Center(
                                      child: Column(
                                        children: [
                                          MtCustomfontBold(
                                            text:
                                                "${((totalusersProcessingDone / totalUsersToPreocess) * 100).floor()}%",
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          circularProgress(),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          MtCustomfontLight(
                                            text:
                                                "${getTranslatedForCurrentUser(context, 'xxxxprocessingxxx')}\n\n${getTranslatedForCurrentUser(context, 'xxxprogressxxxx')}",
                                            color: Mycolors.greytext,
                                            fontsize: 12,
                                            textalign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    )
                                  : eventlist.length != 0
                                      ? SizedBox()
                                      : Column(
                                          children: [
                                            MtCustomfontBoldSemi(
                                              text: getTranslatedForCurrentUser(
                                                      context, 'xxximportxxx')
                                                  .replaceAll('(####)',
                                                      '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}')
                                                  .toUpperCase(),
                                              fontsize: 14,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            MySimpleButton(
                                                buttoncolor: Mycolors.blue,
                                                buttontext:
                                                    "${getTranslatedForCurrentUser(context, 'xxxxuploadxxx')} Excel (.xlsx)",
                                                onpressed:
                                                    AppConstants.isdemomode ==
                                                            true
                                                        ? () {
                                                            Utils.toast(
                                                                getTranslatedForCurrentUser(
                                                                    context,
                                                                    'xxxnotalwddemoxxaccountxx'));
                                                          }
                                                        : () async {
                                                            setState(() {
                                                              eventlist = [];
                                                              isProcessing =
                                                                  false;
                                                              totalusersProcessingDone =
                                                                  0;
                                                              totalUsersToPreocess =
                                                                  0;
                                                              newuserscreated =
                                                                  0;
                                                            });
                                                            FilePickerResult?
                                                                result =
                                                                await FilePicker
                                                                    .platform
                                                                    .pickFiles(
                                                              type: FileType
                                                                  .custom,
                                                              allowedExtensions: [
                                                                'xlsx'
                                                              ],
                                                            );
                                                            var excel;
                                                            if (result !=
                                                                null) {
                                                              try {
                                                                File file =
                                                                    File(result
                                                                        .files
                                                                        .single
                                                                        .path!);

                                                                excel = Excel
                                                                    .decodeBytes(
                                                                        file.readAsBytesSync());
                                                              } catch (e) {
                                                                Utils.toast(
                                                                    "Error occured parsing file !. $e");
                                                              }

                                                              try {
                                                                eventlist
                                                                    .clear();

                                                                setState(() {
                                                                  isProcessing =
                                                                      true;
                                                                });

                                                                for (var table
                                                                    in excel
                                                                        .tables
                                                                        .keys) {
                                                                  eventlist
                                                                      .add({
                                                                    "t": "s",
                                                                    "r":
                                                                        "${getTranslatedForCurrentUser(context, 'xxxxloadedxxx')} Excel Sheet: $table"
                                                                  });
                                                                  setState(
                                                                      () {});

                                                                  List<List<Data?>>
                                                                      mysheet =
                                                                      excel
                                                                          .tables[
                                                                              table]!
                                                                          .rows;
                                                                  mysheet
                                                                      .removeAt(
                                                                          0);
                                                                  int totalRows = mysheet
                                                                      .where((element) =>
                                                                          element
                                                                              .toList()
                                                                              .length ==
                                                                          5)
                                                                      .toList()
                                                                      .length;
                                                                  totalUsersToPreocess =
                                                                      totalRows;
                                                                  setState(
                                                                      () {});

                                                                  eventlist
                                                                      .add({
                                                                    "t": "s",
                                                                    "r": getTranslatedForCurrentUser(
                                                                            context,
                                                                            'xxxstartinguploadxxx')
                                                                        .replaceAll(
                                                                            '(####)',
                                                                            '$totalRows ${getTranslatedForCurrentUser(context, 'xxcustomersxx')} ....'),
                                                                  });

                                                                  setState(
                                                                      () {});

                                                                  for (var row
                                                                      in mysheet) {
                                                                    if (row.length !=
                                                                        5) {
                                                                      if (mysheet
                                                                              .last[0]!
                                                                              .value ==
                                                                          row[0]!.value) {
                                                                        eventlist
                                                                            .add({
                                                                          "t":
                                                                              "s",
                                                                          "r": getTranslatedForCurrentUser(
                                                                              context,
                                                                              'xxxfinishedprocessingxxx')
                                                                        });
                                                                        setState(
                                                                            () {
                                                                          isProcessing =
                                                                              false;
                                                                        });
                                                                      }
                                                                    } else {
                                                                      if (row[0] ==
                                                                          null) {
                                                                        eventlist
                                                                            .add({
                                                                          "t":
                                                                              "e",
                                                                          "r":
                                                                              "ID cannot be NULL "
                                                                        });
                                                                        setState(
                                                                            () {});
                                                                      } else {
                                                                        String
                                                                            id =
                                                                            "${row[0]!.value}";

                                                                        String countrycode = row[2] ==
                                                                                null
                                                                            ? ""
                                                                            : row[2]!.value == ""
                                                                                ? ""
                                                                                : row[2]!.value.trim().split("-")[0] ?? "";
                                                                        String phoneRaw = row[2] ==
                                                                                null
                                                                            ? ""
                                                                            : row[2]!.value == ""
                                                                                ? ""
                                                                                : row[2]!.value.trim().split("-")[1] ?? "";
                                                                        String phone = row[2] ==
                                                                                null
                                                                            ? ""
                                                                            : row[2]!.value == ""
                                                                                ? ""
                                                                                : "+$countrycode-$phoneRaw";
                                                                        String
                                                                            fullname =
                                                                            "${row[1] == null ? "" : row[1]!.value}";

                                                                        String
                                                                            email =
                                                                            "${row[3] == null ? "" : row[3]!.value}";
                                                                        String
                                                                            password =
                                                                            "${row[4] == null ? "" : row[4]!.value}";

                                                                        // eventlist.add({
                                                                        //   "t": "s",
                                                                        //   "r":
                                                                        //       "Setting up Customer ID:$id - $fullname"
                                                                        // });

                                                                        setState(
                                                                            () {});

                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection(DbPaths.collectioncustomers)
                                                                            .doc(id)
                                                                            .get()
                                                                            .then((customer) async {
                                                                          if (customer
                                                                              .exists) {
                                                                            //throw error as another customer is already regsitered using this ID.
                                                                            eventlist.add({
                                                                              "t": fullname == customer.data()![Dbkeys.nickname] ? "w" : "e",
                                                                              "r": fullname == customer.data()![Dbkeys.nickname] ? getTranslatedForCurrentUser(context, 'xxxskippedsettingupxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxcustomeridxx')} $id - $fullname') : getTranslatedForCurrentUser(context, 'xxxxxcannotsetupxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxcustomeridxx')} $id - $fullname').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxcustomerxx')} ${customer.data()![Dbkeys.nickname]}').replaceAll('(##)', '$fullname').replaceAll('(#)', 'Excel Sheet'),
                                                                            });
                                                                            totalusersProcessingDone++;
                                                                            setState(() {});
                                                                            if (mysheet.last[0]!.value ==
                                                                                row[0]!.value) {
                                                                              eventlist.add({
                                                                                "t": "s",
                                                                                "r": getTranslatedForCurrentUser(context, 'xxxfinishedprocessingxxx')
                                                                              });
                                                                              setState(() {
                                                                                isProcessing = false;
                                                                              });
                                                                            }
                                                                          } else {
                                                                            await FirebaseFirestore.instance.collection(DbPaths.collectionagents).doc(id).get().then((agent) async {
                                                                              if (agent.exists) {
                                                                                //throw error as an agent is already regsitered using this ID.
                                                                                totalusersProcessingDone++;
                                                                                eventlist.add({
                                                                                  "t": "e",
                                                                                  "r": getTranslatedForCurrentUser(context, 'xxxxxcannotsetupxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxcustomeridxx')} $id - $fullname').replaceAll('(###)', '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${agent.data()![Dbkeys.nickname]}').replaceAll('(##)', '$fullname').replaceAll('(#)', 'Excel Sheet'),
                                                                                });
                                                                                setState(() {});
                                                                                if (mysheet.last[0]!.value == row[0]!.value) {
                                                                                  eventlist.add({
                                                                                    "t": "s",
                                                                                    "r": getTranslatedForCurrentUser(context, 'xxxfinishedprocessingxxx')
                                                                                  });
                                                                                  setState(() {
                                                                                    isProcessing = false;
                                                                                  });
                                                                                }
                                                                              } else {
                                                                                //create new Customer with batch write in DB
                                                                                try {
                                                                                  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password == "" ? "UserID@$id#" : password).then((user) async {
                                                                                    await createNewCustomer(id, fullname, email, phone, countrycode, phoneRaw, password, observer, mysheet.last[0]!.value == row[0]!.value);
                                                                                  });
                                                                                } on FirebaseAuthException catch (e) {
                                                                                  if (e.code == 'weak-password') {
                                                                                    totalusersProcessingDone++;
                                                                                    eventlist.add({
                                                                                      "t": "e",
                                                                                      "r": getTranslatedForCurrentUser(context, 'xxxcannotsetupuserxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxcustomeridxx')}$id '),
                                                                                    });
                                                                                    setState(() {});

                                                                                    if (mysheet.last[0]!.value == row[0]!.value) {
                                                                                      totalusersProcessingDone++;
                                                                                      eventlist.add({
                                                                                        "t": "s",
                                                                                        "r": getTranslatedForCurrentUser(context, 'xxxfinishedprocessingxxx')
                                                                                      });
                                                                                      setState(() {
                                                                                        isProcessing = false;
                                                                                      });
                                                                                    }
                                                                                  } else if (e.code == 'email-already-in-use') {
                                                                                    totalusersProcessingDone++;
                                                                                    eventlist.add({
                                                                                      "t": "w",
                                                                                      "r": getTranslatedForCurrentUser(context, 'xxxemailisusedxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxcustomeridxx')}$id').replaceAll('(###)', '$email'),
                                                                                    });
                                                                                    setState(() {});
                                                                                    await createNewCustomer(id, fullname, email, phone, countrycode, phoneRaw, password, observer, mysheet.last[0]!.value == row[0]!.value);
                                                                                  }
                                                                                } catch (e) {
                                                                                  totalusersProcessingDone++;
                                                                                  eventlist.add({
                                                                                    "t": "e",
                                                                                    "r": getTranslatedForCurrentUser(context, 'xxxfailedtocreatexxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxcustomeridxx')}$id').replaceAll('(###)', 'Firebase Auth') + " ERROR: $e"
                                                                                  });
                                                                                  setState(() {});
                                                                                  if (mysheet.last[0]!.value == row[0]!.value) {
                                                                                    eventlist.add({
                                                                                      "t": "s",
                                                                                      "r": getTranslatedForCurrentUser(context, 'xxxfinishedprocessingxxx')
                                                                                    });
                                                                                    setState(() {
                                                                                      isProcessing = false;
                                                                                    });
                                                                                  }
                                                                                }
                                                                              }
                                                                            });
                                                                          }
                                                                        });
                                                                      }
                                                                    }
                                                                  }
                                                                }
                                                              } catch (e) {
                                                                setState(() {
                                                                  isProcessing =
                                                                      false;
                                                                });
                                                                eventlist.add({
                                                                  "t": "e",
                                                                  "r":
                                                                      "${getTranslatedForCurrentUser(context, 'xxxfailedtoxxx')} ERROR: $e"
                                                                });
                                                                setState(() {});
                                                              }
                                                            } else {
                                                              // User canceled the picker
                                                            }
                                                          }),

                                            SizedBox(
                                              height: 30,
                                            ),
                                            eventlist.length == 0
                                                ? Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: Column(
                                                      children: [
                                                        MtCustomfontRegular(
                                                          fontsize: 13,
                                                          textalign:
                                                              TextAlign.center,
                                                          text:
                                                              "${getTranslatedForCurrentUser(context, 'xxxxfillcustomerinfoxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}').replaceAll('(###)', 'Sample Excel File (.xlsx)').replaceAll('(##)', '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}')}\n\n ${getTranslatedForCurrentUser(context, 'xxxmakesurexxx')}",
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        myinkwell(
                                                          onTap: () {
                                                            Utils.toast(
                                                                getTranslatedForCurrentUser(
                                                                    context,
                                                                    'xxplswaitxx'));
                                                            custom_url_launcher(
                                                                'https://tctech.in/media_bucket/mobijet_BULK_CUSTOMERS_FORMAT.xlsx');
                                                          },
                                                          child: MtCustomfontRegular(
                                                              fontsize: 14,
                                                              color:
                                                                  Mycolors.blue,
                                                              weight: FontWeight
                                                                  .w700,
                                                              textalign:
                                                                  TextAlign
                                                                      .center,
                                                              text: getTranslatedForCurrentUser(
                                                                      context,
                                                                      'xxxdownloadsamoplefilexxx')
                                                                  .toUpperCase()),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                            SizedBox(
                                              height: 50,
                                            ),
                                            // MySimpleButton(
                                            //   onpressed: () {
                                            //     FirebaseFirestore.instance
                                            //         .collection(Dbkeys.appsettings)
                                            //         .doc(Dbkeys.userapp)
                                            //         .update({
                                            //       Dbkeys.studentvisibilitytype: 2,
                                            //       Dbkeys.loginType: 1,
                                            //       Dbkeys.isStudentIndividualChatAllowed: true,
                                            //       Dbkeys.isShowAdminMonitoringMessageInChatroom:
                                            //           false
                                            //     });
                                            //   },
                                            // ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            warningTile(
                                                title:
                                                    getTranslatedForCurrentUser(
                                                        context,
                                                        'xxxplnotcrtacxxx'),
                                                warningTypeIndex:
                                                    WarningType.alert.index),
                                            SizedBox(
                                              height: 20,
                                            ),

                                            SizedBox(
                                              height: 20,
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                              SizedBox(
                                height: 20,
                              ),
                              eventlist.length > 0
                                  ? Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          newuserscreated > 0
                                              ? Center(
                                                  child: Text(
                                                    getTranslatedForCurrentUser(
                                                            context,
                                                            'xxxnewxxusercreatedxxx')
                                                        .replaceAll('(####)',
                                                            '$newuserscreated')
                                                        .replaceAll('(###)',
                                                            '${getTranslatedForCurrentUser(context, 'xxcustomersxx')}'),
                                                    style: TextStyle(
                                                        color: Mycolors.green,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 18),
                                                  ),
                                                )
                                              : SizedBox(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          eventlist
                                                      .where((element) =>
                                                          element['t'] == "w")
                                                      .length >
                                                  0
                                              ? Center(
                                                  child: Text(
                                                    isProcessing == false
                                                        ? getTranslatedForCurrentUser(
                                                                context,
                                                                'xxxfinishedwithwarmningsxxx')
                                                            .replaceAll(
                                                                '(####)',
                                                                '${eventlist.where((element) => element['t'] == "w").length}')
                                                        : "${eventlist.where((element) => element['t'] == "w").length} ${getTranslatedForCurrentUser(context, 'xxxwarningsxxx')}",
                                                    style: TextStyle(
                                                        color: Mycolors.orange,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 18),
                                                  ),
                                                )
                                              : SizedBox(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          eventlist
                                                      .where((element) =>
                                                          element['t'] == "e")
                                                      .length >
                                                  0
                                              ? Center(
                                                  child: Text(
                                                    isProcessing == false
                                                        ? getTranslatedForCurrentUser(
                                                                context,
                                                                'xxxfinishedwithxxx')
                                                            .replaceAll(
                                                                '(####)',
                                                                '${eventlist.where((element) => element['t'] == "e").length}  ${getTranslatedForCurrentUser(context, 'xxxerrorsxxx')}')
                                                        : "${eventlist.where((element) => element['t'] == "e").length} ${getTranslatedForCurrentUser(context, 'xxxerrorsxxx')}",
                                                    style: TextStyle(
                                                        color: Mycolors.red,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 18),
                                                  ),
                                                )
                                              : SizedBox(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  MtCustomfontBoldSemi(
                                                    text:
                                                        getTranslatedForCurrentUser(
                                                            context,
                                                            'xxxeventlogxxx'),
                                                    fontsize: 13,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        Clipboard.setData(
                                                            new ClipboardData(
                                                                text: eventlist
                                                                    .toString()));
                                                        Utils.toast(
                                                            'Copied to Clipboard. Paste in JSON Formatter');
                                                      },
                                                      icon: Icon(
                                                        Icons.copy_outlined,
                                                        size: 17,
                                                        color: Mycolors.grey,
                                                      ))
                                                ],
                                              )),
                                          for (var item
                                              in eventlist.reversed.toList())
                                            warningTile(
                                                marginnarrow: true,
                                                title: item['r'],
                                                warningTypeIndex: item['t'] ==
                                                        'e'
                                                    ? WarningType.error.index
                                                    : item['t'] == 's'
                                                        ? WarningType
                                                            .success.index
                                                        : WarningType
                                                            .alert.index)
                                        ],
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          )),
        ));
  }
}
