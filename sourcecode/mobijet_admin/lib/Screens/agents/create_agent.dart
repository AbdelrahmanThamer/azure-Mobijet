import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/number_limits.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/agent_model.dart';
import 'package:thinkcreative_technologies/Models/batch_write_component.dart';
import 'package:thinkcreative_technologies/Models/department_model.dart';
import 'package:thinkcreative_technologies/Models/user_registry_model.dart';
import 'package:thinkcreative_technologies/Screens/agents/builk_import_agents.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseApi.dart';
import 'package:thinkcreative_technologies/Services/my_providers/firestore_collections_data_admin.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Utils/backupUserTable.dart';
import 'package:thinkcreative_technologies/Utils/batch_write.dart';
import 'package:thinkcreative_technologies/Utils/error_codes.dart';
import 'package:thinkcreative_technologies/Utils/hide_keyboard.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/Input_box.dart';
import 'package:thinkcreative_technologies/Widgets/PhoneField/intl_phone_field.dart';
import 'package:thinkcreative_technologies/Widgets/WarningWidgets/warning_tile.dart';
import 'package:thinkcreative_technologies/Widgets/boxdecoration.dart';
import 'package:thinkcreative_technologies/Widgets/custom_buttons.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';

class CreateAgent extends StatefulWidget {
  const CreateAgent({Key? key}) : super(key: key);

  @override
  State<CreateAgent> createState() => _CreateAgentState();
}

class _CreateAgentState extends State<CreateAgent> {
  bool isloading = false;
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phoneRaw = TextEditingController();

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  String deviceid = "";
  String storedproviderID = "";
  String code = "";
  String finalPhone = "";
  String finalname = "";
  var mapDeviceInfo = {};
  @override
  void initState() {
    super.initState();
    code = AppConstants.defaultcountrycodeMobileExtension;
  }

  String error = "";

  createNewUser({
    required String email,
    required String password,
    required String name,
    required String phoneraw,
    required String code,
    required Observer observer,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        await checkUserWithEmail(
            password: password,
            email: email,
            phoneraw: phoneraw,
            code: code,
            name: name,
            observer: observer);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Navigator.of(context).pop();
        showERRORSheet(context, "EM_114",
            message:
                "${getTranslatedForCurrentUser(context, 'xxfailedxx')}\n\n${getTranslatedForCurrentUser(context, 'xxpwdweakxx')}");
      } else if (e.code == 'email-already-in-use') {
        Navigator.of(context).pop();
        showERRORSheet(context, "EM_113",
            message:
                "${getTranslatedForCurrentUser(context, 'xxfailedxx')}\n\n${getTranslatedForCurrentUser(context, 'xxacalreadyexistsxx')}");
      }
    } catch (e) {
      Navigator.of(context).pop();
      showERRORSheet(context, "EM_102",
          message:
              "${getTranslatedForCurrentUser(context, 'xxfailedxx')}\n\n. Error: $e");
    }
  }

  checkUserWithEmail({
    UserCredential? registereduserCredential,
    required String email,
    required String name,
    required String password,
    required String phoneraw,
    required String code,
    required Observer observer,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        observer.fetchUserAppSettings(context);
        await loginChecks(
            registereduserCredential: registereduserCredential,
            password: password,
            phoneraw: phoneraw,
            code: code,
            name: name,
            email: email,
            observer: observer);
      } else {
        Navigator.of(context).pop();
        Utils.toast("not found");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        Navigator.of(context).pop();
        showERRORSheet(context, "EM_115",
            message: getTranslatedForCurrentUser(context, 'xxinvalidemailxx'));
      } else if (e.code == 'user-disabled') {
        Navigator.of(context).pop();
        showERRORSheet(context, "EM_116",
            message: getTranslatedForCurrentUser(context, 'xxemaildisabledxx'));
      } else if (e.code == 'user-not-found') {
        await createNewUser(
            email: email,
            password: password,
            phoneraw: phoneraw,
            code: code,
            name: name,
            observer: observer);
      } else if (e.code == 'wrong-password') {
        Navigator.of(context).pop();
        showERRORSheet(context, "EM_112",
            message:
                "${getTranslatedForCurrentUser(context, 'xxfailedxx')}\n\n${getTranslatedForCurrentUser(context, 'xxincorrectpwdxx')}");
      }
    } catch (e) {
      if (e.toString().contains("no user") ||
          e.toString().contains("user record") ||
          e.toString().contains("not-found")) {
        //---create a user if Allowed

        await createNewUser(
            email: email,
            password: password,
            phoneraw: phoneraw,
            code: code,
            name: name,
            observer: observer);
      } else if (e.toString().contains("does not have a password") ||
          e.toString().contains("password is invalid") ||
          e.toString().contains("wrong-password")) {
        //---create a user if Allowed
        if (e.toString().contains("does not have a password")) {
          Navigator.of(context).pop();
          showERRORSheet(context, "EM_111",
              message:
                  "${getTranslatedForCurrentUser(context, 'xxfailedxx')}\n\n. Error: Cannot use this email. Use a different email OR ask admin to Reset this email.");
        } else if (e.toString().contains("password is invalid") ||
            e.toString().contains("wrong-password")) {
          Navigator.of(context).pop();
          showERRORSheet(context, "EM_120",
              message:
                  "${getTranslatedForCurrentUser(context, 'xxfailedxx')}\n\n ${getTranslatedForCurrentUser(context, 'xxincorrectpwdxx')}");
        } else {
          await createNewUser(
              email: email,
              password: password,
              phoneraw: phoneraw,
              code: code,
              name: name,
              observer: observer);
        }
      } else {
        Navigator.of(context).pop();
        showERRORSheet(context, "EM_100",
            message:
                "${getTranslatedForCurrentUser(context, 'xxfailedxx')}\n\n. Error: $e");
      }
    }
  }

  loginChecks(
      {UserCredential? registereduserCredential,
      required Observer observer,
      required String email,
      required String name,
      required String password,
      required String phoneraw,
      required String code}) async {
    //------ check user account after he has has verified email and password & is signed currently
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection(DbPaths.collectionagents)
        .where(Dbkeys.email, isEqualTo: email)
        .get()
        .then((agents) async {
      await FirebaseFirestore.instance
          .collection(DbPaths.collectioncustomers)
          .where(Dbkeys.email, isEqualTo: email)
          .get()
          .then((customers) async {
        if (customers.docs.length > 0) {
          firebaseAuth.signOut();
          Navigator.of(context).pop();
          showERRORSheet(context, "EM_105",
              message:
                  "${getTranslatedForCurrentUser(context, 'xxfailedxx')}\n\n. Error: An Customer account (${customers.docs[0][Dbkeys.nickname]}) exists with same email. You cannot use this email to login as Agent");
        } else {
          if (agents.docs.length == 0) {
            String finalID1 = randomNumeric(Numberlimits.agentIDlength);
            await FirebaseFirestore.instance
                .collection(DbPaths.collectionagents)
                .doc(finalID1)
                .get()
                .then((value1) async {
              if (value1.exists) {
                String finalID2 = randomNumeric(Numberlimits.agentIDlength);
                await FirebaseFirestore.instance
                    .collection(DbPaths.collectionagents)
                    .doc(finalID2)
                    .get()
                    .then((value2) async {
                  if (value2.exists) {
                    String finalID3 = randomNumeric(Numberlimits.agentIDlength);
                    await FirebaseFirestore.instance
                        .collection(DbPaths.collectionagents)
                        .doc(finalID3)
                        .get()
                        .then((value3) async {
                      if (value3.exists) {
                        String finalID4 =
                            randomNumeric(Numberlimits.agentIDlength);
                        await FirebaseFirestore.instance
                            .collection(DbPaths.collectionagents)
                            .doc(finalID4)
                            .get()
                            .then((value4) async {
                          if (value4.exists) {
                            Navigator.of(context).pop();
                            Utils.toast(getTranslatedForCurrentUser(
                                context, 'xxplsreloadxx'));
                          } else {
                            await createFreshNewAccountInFirebase(finalID4, 0,
                                registereduserCredential:
                                    registereduserCredential,
                                name: name,
                                password: password,
                                email: email,
                                code: code,
                                phoneraw: phoneraw);
                          }
                        });
                      } else {
                        await createFreshNewAccountInFirebase(
                          finalID3,
                          0,
                          registereduserCredential: registereduserCredential,
                          name: name,
                          password: password,
                          email: email,
                          code: code,
                          phoneraw: phoneraw,
                        );
                      }
                    });
                  } else {
                    await createFreshNewAccountInFirebase(finalID2, 0,
                        registereduserCredential: registereduserCredential,
                        name: name,
                        password: password,
                        email: email,
                        code: code,
                        phoneraw: phoneraw);
                  }
                });
              } else {
                await createFreshNewAccountInFirebase(finalID1, 0,
                    registereduserCredential: registereduserCredential,
                    name: name,
                    password: password,
                    email: email,
                    code: code,
                    phoneraw: phoneraw);
              }
            });
          } else if (agents.docs.length == 1) {
            await updateExistingUser(agents.docs[0], 0,
                registereduserCredential: registereduserCredential,
                password: password,
                phoneraw: phoneraw,
                email: email,
                code: code,
                name: name);
          } else {
            firebaseAuth.signOut();
            Navigator.of(context).pop();
            showERRORSheet(context, "EM_104",
                message:
                    "${getTranslatedForCurrentUser(context, 'xxfailedxx')}\n\n.${getTranslatedForCurrentUser(context, 'xxmultipleacxx')}");
          }
        }
      });
    }).catchError((err) {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      firebaseAuth.signOut();
      Navigator.of(context).pop();
      showERRORSheet(context, "EM_103",
          message:
              "${getTranslatedForCurrentUser(context, 'xxfailedxx')}\n\n. Error: $err");
    });
    // } else {
    //   //existing registered in firebase

    // }
  }

  String storedFinalID = "";
  UserCredential? storedregistereduserCredential;
  createFreshNewAccountInFirebase(String finalID, int tries,
      {UserCredential? registereduserCredential,
      required String name,
      required String email,
      required String phoneraw,
      required String code,
      required String password}) async {
    final observer = Provider.of<Observer>(context, listen: false);
    if (observer.userAppSettingsDoc == null) {
      if (tries > 5) {
        Navigator.of(context).pop();
        showERRORSheet(context, "EM_121",
            message:
                "${getTranslatedForCurrentUser(context, 'xxfailedxx')}\n\n.Error occured while registering a new account. Please try again . Unable to fetch settings");
      } else {
        observer.fetchUserAppSettings(context);
        await createFreshNewAccountInFirebase(finalID, tries + 1,
            registereduserCredential: registereduserCredential,
            name: name,
            password: password,
            email: email,
            code: code,
            phoneraw: phoneraw);
      }
    } else {
      // int id = DateTime.now().millisecondsSinceEpoch;

      String myname = name;

      var names = myname.trim().split(' ');

      String shortname = myname.trim();
      String lastName = "";
      if (names.length > 1) {
        shortname = names[0];
        lastName = names[1];
        if (shortname.length < 3) {
          shortname = lastName;
          if (lastName.length < 3) {
            shortname = myname;
          }
        }
      }

      //Add user to default ticket category for future new tickets

      // DepartmentModel cat = DepartmentModel.fromJson(
      //     observer.userAppSettingsDoc!.departmentList![0]);

      // List<dynamic> l = observer.userAppSettingsDoc!.departmentList![0]
      //     [Dbkeys.departmentAgentsUIDList];
      // l.add((finalID));

      // var modified = cat.copyWith(departmentAgentsUIDList: l);

      // List<dynamic> list = observer.userAppSettingsDoc!.departmentList!;

      // list[0] = modified.toMap();
      // setStateIfMounted(() {});

      await batchwriteFirestoreData([
        BatchWriteComponent(
                ref: FirebaseFirestore.instance
                    .collection(DbPaths.collectionagents)
                    .doc(finalID),
                map: AgentModel(
                  accountcreatedby: Optionalconstants.currentAdminID,
                  rolesassigned: [],
                  platform: Platform.isAndroid
                      ? "android"
                      : Platform.isIOS
                          ? "ios"
                          : "",
                  id: finalID,
                  userLoginType: LoginType.email.index,
                  email: email,
                  password: "",
                  firebaseuid: registereduserCredential == null
                      ? ""
                      : registereduserCredential.user == null
                          ? ""
                          : registereduserCredential.user!.uid,
                  nickname: name.trim(),
                  searchKey: name.trim().substring(0, 1).toUpperCase(),
                  phone: code + phoneraw,
                  phoneRaw: phoneraw,
                  countryCode: code,
                  photoUrl: registereduserCredential == null
                      ? ""
                      : registereduserCredential.user == null
                          ? ""
                          : registereduserCredential.user!.photoURL ?? "",
                  aboutMe: '',
                  actionmessage: '',
                  currentDeviceID: deviceid,
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
                  deviceDetails: mapDeviceInfo,
                  quickReplies: [],
                  lastVerified: 0,
                  ratings: [],
                  totalRepliesInTickets: 0,
                  twoFactorVerification: {},
                  userTypeIndex: Usertype.agent.index,
                ).toMap())
            .toMap(),
        BatchWriteComponent(
            ref: FirebaseFirestore.instance
                .collection(DbPaths.collectionagents)
                .doc(finalID)
                .collection(DbPaths.agentnotifications)
                .doc(DbPaths.agentnotifications),
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
              Dbkeys.nOTIFICATIONxxpageID: DbPaths.agentnotifications,
              //-----
              Dbkeys.nOTIFICATIONpagecollection1: DbPaths.collectionagents,
              Dbkeys.nOTIFICATIONpagedoc1: finalID,
              Dbkeys.nOTIFICATIONpagecollection2: DbPaths.agentnotifications,
              Dbkeys.nOTIFICATIONpagedoc2: DbPaths.agentnotifications,
              Dbkeys.nOTIFICATIONtopic: Dbkeys.topicAGENTS,
              Dbkeys.list: [],
            }).toMap(),
        BatchWriteComponent(
          ref: FirebaseFirestore.instance
              .collection(DbPaths.userapp)
              .doc(DbPaths.docusercount),
          map: {
            Dbkeys.totalpendingagents: FieldValue.increment(1),
          },
        ).toMap(),
        // BatchWriteComponent(
        //   ref: FirebaseFirestore.instance
        //       .collection(DbPaths.collectioncountrywiseAgentData)
        //       .doc(widget.onlyCode),
        //   map: {
        //     Dbkeys.totalusers: FieldValue.increment(1),
        //   },
        // ).toMap(),
        BatchWriteComponent(
                ref: FirebaseFirestore.instance
                    .collection(DbPaths.collectionagents)
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
                  fullname: name.trim(),
                  id: finalID,
                  phone: code + phoneraw,
                  photourl: registereduserCredential == null
                      ? ""
                      : registereduserCredential.user == null
                          ? ""
                          : registereduserCredential.user!.photoURL ?? "",
                  usertype: Usertype.agent.index,
                  email: email,
                  extra1: "",
                  extra2: "",
                  extraMap: {}).toMap()
            ])
          },
        ).toMap(),
      ]).then((value) async {
        if (value == false) {
          //faild to write
          if (registereduserCredential != null) {
            final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
            await firebaseAuth.signOut();
          }

          Navigator.of(context).pop();
          showERRORSheet(context, "EM_100",
              message:
                  "${getTranslatedForCurrentUser(context, 'xxfailedxx')}\n\n. Error occured while authentication. Please try again,  Failed to batch Write for Agent Doc");
        } else {
          await Utils.sendDirectNotification(
              title: getTranslatedForCurrentUser(
                      context, 'xxxadmincreatedupdatexxx')
                  .replaceAll('(####)',
                      '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
              parentID: "AGENT--$finalID",
              plaindesc: getTranslatedForCurrentUser(
                      context, 'xxxadmincreatedupdatexxx')
                  .replaceAll('(####)',
                      '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
              docRef: FirebaseFirestore.instance
                  .collection(DbPaths.collectionagents)
                  .doc(finalID)
                  .collection(DbPaths.agentnotifications)
                  .doc(DbPaths.agentnotifications),
              postedbyID: 'Admin');
          await FirebaseApi.runTransactionRecordActivity(
            parentid: "AGENT_REGISTRATION--$finalID",
            title: getTranslatedForCurrentUser(context, 'xxxnewjoinedxxx')
                .replaceAll('(####)',
                    '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
            postedbyID: "sys",
            onErrorFn: (e) {},
            onSuccessFn: () {},
            styledDesc: getTranslatedForCurrentUser(context, 'xxcareatednewxxx')
                .replaceAll('(##)',
                    '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                .replaceAll('(####)',
                    '<bold>${getTranslatedForCurrentUser(context, 'xxagentxx')} ${name.trim()}</bold>')
                .replaceAll('(###)',
                    '<bold>${getTranslatedForCurrentUser(context, 'xxagentsxx')}</bold>'),
            plainDesc: getTranslatedForCurrentUser(context, 'xxcareatednewxxx')
                .replaceAll('(##)',
                    '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
                .replaceAll('(####)',
                    '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${name.trim()}')
                .replaceAll('(###)',
                    '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
          );

          setStateIfMounted(() {
            isNewAgentCreated = true;
            storedFinalID = finalID;
            storedproviderID = email == "" ? code + "-" + phoneraw : email;
            isloading = false;
          });

          final firestore =
              Provider.of<FirestoreDataProviderAGENTS>(context, listen: false);
          firestore.fetchNextData(
              Dbkeys.dataTypeAGENTS,
              FirebaseFirestore.instance
                  .collection(DbPaths.collectionagents)
                  .orderBy(Dbkeys.joinedOn, descending: true)
                  .limit(Numberlimits.totalDatatoLoadAtOnceFromFirestore),
              true);
        }
      });
    }
  }

  bool isNewAgentCreated = false;
  bool isNewAgentupdated = false;

  updateExistingUser(DocumentSnapshot doc, int tries,
      {UserCredential? registereduserCredential,
      required String name,
      required String email,
      required String phoneraw,
      required String code,
      required String password}) async {
    if (registereduserCredential != null) {
      // freshly registered in firebase - need to update firebase UID & notifcation token

      // if (registereduserCredential.user == null) {
      //   firebaseAuth.signOut();
      //   Navigator.of(context).pop();
      //   showERRORSheet(context, "EM_107",
      //       message: "${getTranslatedForCurrentUser(context, 'xxfailedxx')}\n\n. Error: Unexpected error occured");
      // } else {
      await doc.reference.update({
        Dbkeys.userLoginType: LoginType.email.index,
        Dbkeys.email: email,
        Dbkeys.firebaseuid: registereduserCredential.user!.uid,
        Dbkeys.notificationTokens: [],
        Dbkeys.lastLogin: DateTime.now().millisecondsSinceEpoch,
        Dbkeys.currentDeviceID: deviceid,
        Dbkeys.deviceDetails: mapDeviceInfo
      });
      await Utils.sendDirectNotification(
          title: getTranslatedForCurrentUser(
                  context, 'xxxadmincreatedupdatexxx')
              .replaceAll('(####)',
                  '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
          parentID: "AGENT--${doc[Dbkeys.id]}",
          plaindesc: getTranslatedForCurrentUser(context, 'xxxlinkedactoxxx')
              .replaceAll('(####)',
                  '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
              .replaceAll(
                  '(###)', '${email == "" ? code + "-" + phoneraw : email}'),
          docRef: FirebaseFirestore.instance
              .collection(DbPaths.collectionagents)
              .doc(doc[Dbkeys.id])
              .collection(DbPaths.agentnotifications)
              .doc(DbPaths.agentnotifications),
          postedbyID: 'Admin');
      await FirebaseApi.runTransactionRecordActivity(
        parentid: "AGENT_REGISTRATION--${doc[Dbkeys.id]}",
        title: getTranslatedForCurrentUser(context, 'xxxcreatedupdateacxxx')
            .replaceAll('(####)',
                '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
        postedbyID: "sys",
        onErrorFn: (e) {},
        onSuccessFn: () {},
        styledDesc:
            '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${doc[Dbkeys.nickname]} ${getTranslatedForCurrentUser(context, 'xxxcreatedorupdatedxxx')}. ${getTranslatedForCurrentUser(context, 'xxxislinkedtoxxx')} ${email == "" ? code + "-" + phoneraw : email}',
        plainDesc:
            '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${doc[Dbkeys.nickname]} ${getTranslatedForCurrentUser(context, 'xxxcreatedorupdatedxxx')}. ${getTranslatedForCurrentUser(context, 'xxxislinkedtoxxx')} ${email == "" ? code + "-" + phoneraw : email}',
      );
      setStateIfMounted(() {
        isNewAgentupdated = true;
        storedproviderID = email == "" ? code + "-" + phoneraw : email;
      });
      final firestore =
          Provider.of<FirestoreDataProviderAGENTS>(context, listen: false);
      firestore.fetchNextData(
          Dbkeys.dataTypeAGENTS,
          FirebaseFirestore.instance
              .collection(DbPaths.collectionagents)
              .orderBy(Dbkeys.joinedOn, descending: true)
              .limit(Numberlimits.totalDatatoLoadAtOnceFromFirestore),
          false);
      // }
    } else {
      await doc.reference.update({
        Dbkeys.userLoginType: LoginType.email.index,
        Dbkeys.email: email,
        Dbkeys.notificationTokens: [],
        Dbkeys.lastLogin: DateTime.now().millisecondsSinceEpoch,
        Dbkeys.currentDeviceID: deviceid,
        Dbkeys.deviceDetails: mapDeviceInfo
      });
      await Utils.sendDirectNotification(
          title: getTranslatedForCurrentUser(
                  context, 'xxxadmincreatedupdatexxx')
              .replaceAll('(####)',
                  '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
          parentID: "AGENT--${doc[Dbkeys.id]}",
          plaindesc: getTranslatedForCurrentUser(context, 'xxxlinkedactoxxx')
              .replaceAll('(####)',
                  '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
              .replaceAll(
                  '(###)', '${email == "" ? code + "-" + phoneraw : email}'),
          docRef: FirebaseFirestore.instance
              .collection(DbPaths.collectionagents)
              .doc(doc[Dbkeys.id])
              .collection(DbPaths.agentnotifications)
              .doc(DbPaths.agentnotifications),
          postedbyID: 'Admin');
      await FirebaseApi.runTransactionRecordActivity(
        parentid: "AGENT_REGISTRATION--${doc[Dbkeys.id]}",
        title: getTranslatedForCurrentUser(context, 'xxxcreatedupdateacxxx')
            .replaceAll('(####)',
                '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
        postedbyID: "sys",
        onErrorFn: (e) {},
        onSuccessFn: () {},
        styledDesc:
            '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${doc[Dbkeys.nickname]} ${getTranslatedForCurrentUser(context, 'xxxcreatedorupdatedxxx')}. ${getTranslatedForCurrentUser(context, 'xxxislinkedtoxxx')} ${email == "" ? code + "-" + phoneraw : email}',
        plainDesc:
            '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${doc[Dbkeys.nickname]} ${getTranslatedForCurrentUser(context, 'xxxcreatedorupdatedxxx')}. ${getTranslatedForCurrentUser(context, 'xxxislinkedtoxxx')} ${email == "" ? code + "-" + phoneraw : email}',
      );

      setStateIfMounted(() {
        isNewAgentupdated = true;
        storedproviderID = email == "" ? code + "-" + phoneraw : email;
      });
      final firestore =
          Provider.of<FirestoreDataProviderAGENTS>(context, listen: false);
      firestore.fetchNextData(
          Dbkeys.dataTypeAGENTS,
          FirebaseFirestore.instance
              .collection(DbPaths.collectionagents)
              .orderBy(Dbkeys.joinedOn, descending: true)
              .limit(Numberlimits.totalDatatoLoadAtOnceFromFirestore),
          false);
    }
  }

  checkUserWithPhone({
    required String fullname,
    required String pcode,
    required String pnumber,
    required Observer observer,
  }) async {
    await FirebaseFirestore.instance
        .collection(DbPaths.collectionagents)
        .where(Dbkeys.phone, isEqualTo: pcode + pnumber)
        .get()
        .then((agents) async {
      if (agents.docs.length >= 1) {
        setStateIfMounted(() {
          error = getTranslatedForCurrentUser(context, 'xxxalreadylinkedxxx')
              .replaceAll('(####)',
                  '${getTranslatedForCurrentUser(context, 'xxagentxx')}')
              .replaceAll('(###)', '${agents.docs[0][Dbkeys.nickname]}');
        });
      } else {
        await FirebaseFirestore.instance
            .collection(DbPaths.collectioncustomers)
            .where(Dbkeys.phone, isEqualTo: pcode + pnumber)
            .get()
            .then((customers) async {
          if (customers.docs.length >= 1) {
            setStateIfMounted(() {
              error = getTranslatedForCurrentUser(
                      context, 'xxxalreadylinkedxxx')
                  .replaceAll('(####)',
                      '${getTranslatedForCurrentUser(context, 'xxcustomerxx')}')
                  .replaceAll('(###)', '${customers.docs[0][Dbkeys.nickname]}');
            });
          } else {
            String finalID1 = randomNumeric(Numberlimits.agentIDlength);
            await FirebaseFirestore.instance
                .collection(DbPaths.collectionagents)
                .doc(finalID1)
                .get()
                .then((value1) async {
              if (value1.exists) {
                String finalID2 = randomNumeric(Numberlimits.agentIDlength);
                await FirebaseFirestore.instance
                    .collection(DbPaths.collectionagents)
                    .doc(finalID2)
                    .get()
                    .then((value2) async {
                  if (value2.exists) {
                    String finalID3 = randomNumeric(Numberlimits.agentIDlength);
                    await FirebaseFirestore.instance
                        .collection(DbPaths.collectionagents)
                        .doc(finalID3)
                        .get()
                        .then((value3) async {
                      if (value3.exists) {
                        String finalID4 =
                            randomNumeric(Numberlimits.agentIDlength);
                        await FirebaseFirestore.instance
                            .collection(DbPaths.collectionagents)
                            .doc(finalID4)
                            .get()
                            .then((value4) async {
                          if (value4.exists) {
                            error = getTranslatedForCurrentUser(
                                context, 'xxerroroccuredxx');
                            setState(() {});
                            Utils.toast(getTranslatedForCurrentUser(
                                context, 'xxerroroccuredxx'));
                          } else {
                            await createNewUserWithPhone(
                                finalID4, fullname, pcode, pnumber, observer);
                          }
                        });
                      } else {
                        await createNewUserWithPhone(
                            finalID3, fullname, pcode, pnumber, observer);
                      }
                    });
                  } else {
                    await createNewUserWithPhone(
                        finalID2, fullname, pcode, pnumber, observer);
                  }
                });
              } else {
                await createNewUserWithPhone(
                    finalID1, fullname, pcode, pnumber, observer);
              }
            });
          }
        });
      }
    });
  }

  createNewUserWithPhone(String finalID, String fullname, String pcode,
      String pnumber, Observer observer) async {
    var phoneNo = (pcode + pnumber).trim();
    // final observer = Provider.of<Observer>(context, listen: false);
    // int id = DateTime.now().millisecondsSinceEpoch;

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

    DepartmentModel cat = DepartmentModel.fromJson(
        observer.userAppSettingsDoc!.departmentList![0]);

    List<dynamic> l = observer.userAppSettingsDoc!.departmentList![0]
        [Dbkeys.departmentAgentsUIDList];
    l.add((finalID));

    var modified = cat.copyWith(departmentAgentsUIDList: l);

    List<dynamic> list = observer.userAppSettingsDoc!.departmentList!;

    list[0] = modified.toMap();
    setStateIfMounted(() {});

    await batchwriteFirestoreData([
      BatchWriteComponent(
              ref: FirebaseFirestore.instance
                  .collection(DbPaths.collectionagents)
                  .doc(finalID),
              map: AgentModel(
                accountcreatedby: Optionalconstants.currentAdminID,
                rolesassigned: [],
                platform: Platform.isAndroid
                    ? "android"
                    : Platform.isIOS
                        ? "ios"
                        : "",
                id: finalID,
                userLoginType: LoginType.phone.index,
                email: '',
                password: '',
                firebaseuid: "",
                nickname: fullname,
                searchKey: fullname.trim().substring(0, 1).toUpperCase(),
                phone: phoneNo,
                phoneRaw: pnumber,
                countryCode: pcode,
                photoUrl: '',
                aboutMe: '',
                actionmessage: '',
                currentDeviceID: deviceid,
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
                deviceDetails: mapDeviceInfo,
                quickReplies: [],
                lastVerified: 0,
                ratings: [],
                totalRepliesInTickets: 0,
                twoFactorVerification: {},
                userTypeIndex: Usertype.agent.index,
              ).toMap())
          .toMap(),
      BatchWriteComponent(
          ref: FirebaseFirestore.instance
              .collection(DbPaths.collectionagents)
              .doc(finalID)
              .collection(DbPaths.agentnotifications)
              .doc(DbPaths.agentnotifications),
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
            Dbkeys.nOTIFICATIONxxpageID: DbPaths.agentnotifications,
            //-----
            Dbkeys.nOTIFICATIONpagecollection1: DbPaths.collectionagents,
            Dbkeys.nOTIFICATIONpagedoc1: finalID,
            Dbkeys.nOTIFICATIONpagecollection2: DbPaths.agentnotifications,
            Dbkeys.nOTIFICATIONpagedoc2: DbPaths.agentnotifications,
            Dbkeys.nOTIFICATIONtopic: Dbkeys.topicAGENTS,
            Dbkeys.list: [],
          }).toMap(),
      BatchWriteComponent(
        ref: FirebaseFirestore.instance
            .collection(DbPaths.userapp)
            .doc(DbPaths.docusercount),
        map: {
          Dbkeys.totalapprovedagents: FieldValue.increment(1),
        },
      ).toMap(),
      BatchWriteComponent(
        ref: FirebaseFirestore.instance
            .collection(DbPaths.collectioncountrywiseAgentData)
            .doc(pcode),
        map: {
          Dbkeys.totalusers: FieldValue.increment(1),
        },
      ).toMap(),
      BatchWriteComponent(
              ref: FirebaseFirestore.instance
                  .collection(DbPaths.collectionagents)
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
                fullname: _name.text.trim(),
                id: finalID,
                phone: phoneNo,
                photourl: "",
                usertype: Usertype.agent.index,
                email: "",
                extra1: "",
                extra2: "",
                extraMap: {}).toMap()
          ])
        },
      ).toMap(),
    ]).then((value) async {
      if (value == false) {
        Navigator.of(context).pop();
        setStateIfMounted(() {
          error = 'Error occured while authentication. Please try again' +
              'Failed to batch Write for Agent Doc';
        });
      } else {
        if (observer.userAppSettingsDoc!.autoJoinNewAgentsToDefaultList ==
            true) {
          FirebaseFirestore.instance
              .collection(DbPaths.userapp)
              .doc(DbPaths.appsettings)
              .set({Dbkeys.departmentList: list}, SetOptions(merge: true));
        }
        // Write d
        //ata to local
        await Utils.sendDirectNotification(
            title:
                getTranslatedForCurrentUser(context, 'xxxadmincreatedupdatexxx')
                    .replaceAll('(####)',
                        '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
            parentID: "AGENT--$finalID",
            plaindesc:
                getTranslatedForCurrentUser(context, 'xxxadmincreatedupdatexxx')
                    .replaceAll('(####)',
                        '${getTranslatedForCurrentUser(context, 'xxadminxx')}'),
            docRef: FirebaseFirestore.instance
                .collection(DbPaths.collectionagents)
                .doc(finalID)
                .collection(DbPaths.agentnotifications)
                .doc(DbPaths.agentnotifications),
            postedbyID: 'Admin');
        await FirebaseApi.runTransactionRecordActivity(
          parentid: "AGENT_REGISTRATION--$finalID",
          title: getTranslatedForCurrentUser(context, 'xxxnewjoinedxxx')
              .replaceAll('(####)',
                  '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
          postedbyID: "sys",
          onErrorFn: (e) {},
          onSuccessFn: () {},
          styledDesc: getTranslatedForCurrentUser(context, 'xxcareatednewxxx')
              .replaceAll('(##)',
                  '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
              .replaceAll('(####)',
                  '<bold>${getTranslatedForCurrentUser(context, 'xxagentxx')} ${getTranslatedForCurrentUser(context, 'xxidxx')}$finalID</bold>')
              .replaceAll('(###)',
                  '<bold>${getTranslatedForCurrentUser(context, 'xxagentsxx')}</bold>'),
          plainDesc: getTranslatedForCurrentUser(context, 'xxcareatednewxxx')
              .replaceAll('(##)',
                  '${getTranslatedForCurrentUser(context, 'xxadminxx')}')
              .replaceAll('(####)',
                  '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${getTranslatedForCurrentUser(context, 'xxidxx')}$finalID')
              .replaceAll('(###)',
                  '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
        );

        setStateIfMounted(() {
          isNewAgentCreated = true;
          storedFinalID = finalID;
          storedproviderID = pcode + "-" + pnumber;
          isloading = false;
        });
        final firestore =
            Provider.of<FirestoreDataProviderAGENTS>(context, listen: false);
        firestore.fetchNextData(
            Dbkeys.dataTypeAGENTS,
            FirebaseFirestore.instance
                .collection(DbPaths.collectionagents)
                .orderBy(Dbkeys.joinedOn, descending: true)
                .limit(Numberlimits.totalDatatoLoadAtOnceFromFirestore),
            true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phoneRaw.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Utils.getNTPWrappedWidget(Consumer<Observer>(
        builder: (context, observer, _child) => WillPopScope(
            onWillPop: () async => error != ""
                ? true
                : isloading == true
                    ? false
                    : true,
            child: MyScaffold(
                isforcehideback: error != ""
                    ? false
                    : isloading == true
                        ? true
                        : false,
                title: getTranslatedForCurrentUser(context, 'xxcreatexx')
                    .replaceAll('(####)',
                        '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${getTranslatedForCurrentUser(context, 'xxaccountxx')}'),
                body: error != "" || observer.userAppSettingsDoc == null
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(25),
                          child: MtCustomfontRegular(
                            text: observer.userAppSettingsDoc == null
                                ? "$error . ${getTranslatedForCurrentUser(context, 'xxplsreloadxx')}"
                                : error,
                            fontsize: 15,
                            lineheight: 1.3,
                            textalign: TextAlign.center,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : observer.basicSettingUserApp == null || isloading == true
                        ? Center(
                            child: circularProgress(),
                          )
                        : isNewAgentupdated
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.all(25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        size: 50,
                                        color: Colors.green,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      MtCustomfontBold(
                                        text: storedproviderID,
                                        fontsize: 17,
                                        textalign: TextAlign.center,
                                        color: Mycolors.primary,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      MtCustomfontBold(
                                        text: getTranslatedForCurrentUser(
                                                context, 'xxxxxemailsuccessxxx')
                                            .replaceAll('(####)',
                                                '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${getTranslatedForCurrentUser(context, 'xxaccountxx')}'),
                                        fontsize: 17,
                                        textalign: TextAlign.center,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : isNewAgentCreated
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(25),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check,
                                            size: 50,
                                            color: Colors.green,
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          MtCustomfontBold(
                                            text: getTranslatedForCurrentUser(
                                                    context,
                                                    'xxxxxcreatedsuccessxxx')
                                                .replaceAll('(####)',
                                                    '${getTranslatedForCurrentUser(context, 'xxagentxx')} ${getTranslatedForCurrentUser(context, 'xxaccountxx')}'),
                                            fontsize: 17,
                                            textalign: TextAlign.center,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          MtCustomfontBold(
                                            text: finalname,
                                            fontsize: 20,
                                            textalign: TextAlign.center,
                                            color: Mycolors.secondary,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          MtCustomfontBold(
                                            text: storedproviderID,
                                            fontsize: 17,
                                            textalign: TextAlign.center,
                                            color: Mycolors.primary,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          storedFinalID == ""
                                              ? SizedBox()
                                              : MtCustomfontBold(
                                                  text:
                                                      "${getTranslatedForCurrentUser(context, 'xxidxx')} $storedFinalID",
                                                  fontsize: 17,
                                                  textalign: TextAlign.center,
                                                  color: Colors.grey,
                                                ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ListView(
                                    padding: EdgeInsets.all(15),
                                    children: [
                                      InpuTextBox(
                                        title: observer.basicSettingUserApp!
                                                    .loginTypeUserApp ==
                                                "Email/Password"
                                            ? getTranslatedForCurrentUser(
                                                context, 'xxnamexx')
                                            : "${getTranslatedForCurrentUser(context, 'xxpleasefillrequiredinfoxx')}\n\n",
                                        hinttext:
                                            "${getTranslatedForCurrentUser(context, 'xxagentxx')} ${getTranslatedForCurrentUser(context, 'xxfullnamexx')}",
                                        controller: _name,
                                      ),
                                      observer.basicSettingUserApp!
                                                  .loginTypeUserApp ==
                                              "Email/Password"
                                          ? InpuTextBox(
                                              title:
                                                  getTranslatedForCurrentUser(
                                                      context, 'xxemailxx'),
                                              hinttext:
                                                  "${getTranslatedForCurrentUser(context, 'xxagentxx')} ${getTranslatedForCurrentUser(context, 'xxemailxx')}",
                                              controller: _email,
                                            )
                                          : SizedBox(),
                                      observer.basicSettingUserApp!
                                                  .loginTypeUserApp ==
                                              "Email/Password"
                                          ? InpuTextBox(
                                              title:
                                                  getTranslatedForCurrentUser(
                                                      context, 'xxpasswordxx'),
                                              hinttext:
                                                  getTranslatedForCurrentUser(
                                                      context,
                                                      'xxxsetapassxxx'),
                                              subtitle: getTranslatedForCurrentUser(
                                                      context, 'xxxcanresetxxx')
                                                  .replaceAll('(####)',
                                                      '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                                              controller: _password,
                                            )
                                          : Container(
                                              margin: EdgeInsets.all(7),
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      bottom: 7, top: 5),
                                              height: 50,
                                              width: MediaQuery.of(this.context)
                                                  .size
                                                  .width,
                                              decoration: boxDecoration(
                                                  bgColor: Mycolors.white),
                                              child: IntlPhoneField(
                                                  dropDownArrowColor:
                                                      Mycolors.grey,
                                                  textAlign: TextAlign.left,
                                                  initialCountryCode:
                                                      AppConstants
                                                          .defaultcountrycodeISO,
                                                  controller: _phoneRaw,
                                                  style: TextStyle(
                                                      height: 1.35,
                                                      letterSpacing: 1,
                                                      fontSize: 16.0,
                                                      color: Mycolors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              3, 15, 8, 0),
                                                      hintText:
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxenter_mobilenumberxx'),
                                                      hintStyle: TextStyle(
                                                          letterSpacing: 1,
                                                          height: 0.0,
                                                          fontSize: 15.5,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Mycolors.grey
                                                              .withOpacity(
                                                                  0.4)),
                                                      fillColor: Mycolors.white,
                                                      filled: true,
                                                      border:
                                                          new OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                        borderSide:
                                                            BorderSide.none,
                                                      )),
                                                  onChanged: (phone) {
                                                    setStateIfMounted(() {
                                                      code = phone.countryCode!;
                                                    });
                                                  },
                                                  validator: (v) {
                                                    return null;
                                                  },
                                                  onSaved: (phone) {
                                                    setStateIfMounted(() {
                                                      code =
                                                          phone!.countryCode!;
                                                      finalPhone =
                                                          phone.number!;
                                                    });
                                                  }),
                                            ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      MySimpleButtonWithIcon(
                                        buttontext: getTranslatedForCurrentUser(
                                                context, 'xxcreatexx')
                                            .replaceAll('(####)',
                                                '${getTranslatedForCurrentUser(context, 'xxagentxx')}'),
                                        buttoncolor: Mycolors.primary,
                                        onpressed: AppConstants.isdemomode ==
                                                true
                                            ? () {
                                                Utils.toast(
                                                    getTranslatedForCurrentUser(
                                                        context,
                                                        'xxxnotalwddemoxxaccountxx'));
                                              }
                                            : observer.basicSettingUserApp!
                                                        .loginTypeUserApp ==
                                                    "Email/Password"
                                                ? () async {
                                                    if (!_email.text
                                                            .trim()
                                                            .contains('@') ||
                                                        !_email.text
                                                            .trim()
                                                            .contains('.') ||
                                                        _email.text
                                                            .trim()
                                                            .endsWith('.') ||
                                                        _email.text
                                                            .trim()
                                                            .startsWith('@')) {
                                                      Utils.toast(
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxvalidemailxx'));
                                                    } else if (_password.text
                                                            .trim()
                                                            .length <
                                                        6) {
                                                      Utils.toast(
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxpwdcharactersxx'));
                                                    } else if (_password.text
                                                            .trim()
                                                            .length >
                                                        20) {
                                                      Utils.toast(
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxpwdcharactersxx'));
                                                    } else if (Utils
                                                            .isValidPassword(
                                                                _password.text
                                                                    .trim()) ==
                                                        false) {
                                                      Utils.toast(
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxpwdcharactersxx'));
                                                    } else if (_name.text
                                                            .trim()
                                                            .length <
                                                        2) {
                                                      Utils.toast(
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxenterfullnamexx'));
                                                    } else {
                                                      hidekeyboard(context);

                                                      setStateIfMounted(() {
                                                        isloading = true;
                                                      });
                                                      String myEmail = _email
                                                          .text
                                                          .trim()
                                                          .toLowerCase();
                                                      String myPassWord =
                                                          _password.text.trim();
                                                      finalname =
                                                          _name.text.trim();
                                                      _email.clear();
                                                      _password.clear();
                                                      await checkUserWithEmail(
                                                          phoneraw: "",
                                                          code: "",
                                                          name: finalname,
                                                          email: myEmail,
                                                          password: myPassWord,
                                                          observer: observer);
                                                      observer
                                                          .fetchUserAppSettings(
                                                              context);
                                                    }
                                                  }
                                                : () async {
                                                    if (_phoneRaw.text
                                                                .trim()
                                                                .length <
                                                            6 ||
                                                        _name.text
                                                                .trim()
                                                                .length <
                                                            2) {
                                                      Utils.toast(
                                                          getTranslatedForCurrentUser(
                                                              context,
                                                              'xxvaliddetailsxx'));
                                                    } else {
                                                      String ph =
                                                          _phoneRaw.text.trim();
                                                      finalPhone = ph;
                                                      finalname =
                                                          _name.text.trim();
                                                      hidekeyboard(context);

                                                      setStateIfMounted(() {
                                                        isloading = true;
                                                      });

                                                      //check user with phone
                                                      await checkUserWithPhone(
                                                          pcode: code,
                                                          pnumber: ph,
                                                          fullname: finalname,
                                                          observer: observer);
                                                      observer
                                                          .fetchUserAppSettings(
                                                              context);
                                                    }
                                                  },
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      warningTile(
                                          title: getTranslatedForCurrentUser(
                                              context, 'xxxplnotcrtacxxx'),
                                          warningTypeIndex:
                                              WarningType.alert.index),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      myinkwell(
                                        onTap: () {
                                          pageNavigator(
                                              context, BulkImportAgents());
                                        },
                                        child: Chip(
                                            backgroundColor:
                                                Mycolors.cyan.withOpacity(0.3),
                                            label: Text(
                                              "${getTranslatedForCurrentUser(context, 'xxxbulkimportxxx').toUpperCase()} ${getTranslatedForCurrentUser(context, 'xxagentsxx').toUpperCase()} (.xlsx)",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Mycolors.cyan),
                                            )),
                                      )
                                    ],
                                  )))));
  }
}
