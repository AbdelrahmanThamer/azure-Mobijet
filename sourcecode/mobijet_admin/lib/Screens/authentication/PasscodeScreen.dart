import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/basic_settings_model_adminapp.dart';
import 'package:thinkcreative_technologies/Screens/dashboard/BottomNavBarAdminApp.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseApi.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Widgets/boxdecoration.dart';
import '../../Services/my_providers/user_registry_provider.dart';

class PasscodeScreen extends StatefulWidget {
  PasscodeScreen({
    Key? key,
    required this.isfirsttime,
    required this.docmap,
    required this.prefs,
    required this.basicsettings,
    required this.deviceInfoMap,
    required this.currentdeviceID,
  }) : super(key: key);
  final BasicSettingModelAdminApp basicsettings;
  final bool isfirsttime;
  final SharedPreferences prefs;
  final docmap;
  final deviceInfoMap;
  final String currentdeviceID;
  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  bool isobsured = true;
  int attempt = 0;
  List<String> numbers = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: '_hhddbh');
  GlobalKey<State> _keyLoader = new GlobalKey<State>(debugLabel: '7338hh83833');
  bool isemulator = false;

  @override
  void initState() {
    super.initState();
  }

  checkcredentials(BuildContext context) async {
    if (AppConstants.isdemomode == true) {
      await FirebaseFirestore.instance
          .collection(DbPaths.adminapp)
          .doc(DbPaths.admincred)
          .update({Dbkeys.admindeviceid: widget.currentdeviceID});

      var provider = Provider.of<UserRegistry>(context, listen: false);

      provider.fetchUserRegistry(context);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MyBottomNavBarAdminApp(
              prefs: widget.prefs,
              currentdeviceid: widget.currentdeviceID,
              isFirstTimeSetup: widget.isfirsttime),
        ),
        (route) => false,
      );
    } else {
      final session = Provider.of<CommonSession>(context, listen: false);
      //----  Checking if entered pin correct-------
      String formattedpin =
          '${numbers[0]}${numbers[1]}${numbers[2]}${numbers[3]}${numbers[4]}${numbers[5]}';

      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String decoded =
          stringToBase64.decode(widget.docmap[Dbkeys.adminpin]).toString();

      if (decoded == formattedpin || AppConstants.isdemomode == true) {
        setState(() {});
        session.setData(
          newfullname: widget.docmap[Dbkeys.adminfullname],
          newphotourl: widget.docmap[Dbkeys.adminphotourl],
        );
        // session.setData(basicuserappsettings: widget.docmap);
        ShowLoading().open(
          context: context,
          key: _keyLoader,
        );
        await FirebaseApi().runUPDATEtransactionWithQuantityCheck(
            isshowmsg: false,
            context: context,
            scaffoldkey: _scaffoldKey,
            isusesecondfn: true,
            listname: Dbkeys.admindeviceslist,
            refdata: FirebaseFirestore.instance
                .collection(DbPaths.adminapp)
                .doc(DbPaths.admincred),
            keyloader: _keyLoader,
            totaldeleterange: 7,
            totallimitfordelete: 20,
            onerror: (e) {
              ShowLoading().close(
                context: context,
                key: _keyLoader,
              );
            },
            isshowloader: false,
            newmap: widget.deviceInfoMap,
            secondfn: () async {
              await FirebaseFirestore.instance
                  .collection(DbPaths.adminapp)
                  .doc(DbPaths.admincred)
                  .update({Dbkeys.admindeviceid: widget.currentdeviceID});

              var provider = Provider.of<UserRegistry>(context, listen: false);
              ShowLoading().close(
                context: context,
                key: _keyLoader,
              );
              provider.fetchUserRegistry(context);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MyBottomNavBarAdminApp(
                      prefs: widget.prefs,
                      currentdeviceid: widget.currentdeviceID,
                      isFirstTimeSetup: widget.isfirsttime),
                ),
                (route) => false,
              );
            });
      } else {
        //----  Incorrect pin entered-------

        Utils.toast(attempt > 5
            ? '${getTranslatedForCurrentUser(context, 'xxxincorrectpinxxx')}\n\nPlease contact the developer !'
            : getTranslatedForCurrentUser(context, 'xxxincorrectpinxxx'));

        numbers.clear();
        attempt++;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Mycolors.scaffoldbcg,
      appBar: AppBar(
        leading: SizedBox(),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: Text(getTranslatedForCurrentUser(context, 'xxxenter6dpinxxx'),
            style: TextStyle(color: Colors.black87, fontSize: 19)),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(18.0),
        //     child: Icon(Icons.help_outline_rounded, color: Colors.grey),
        //   )
        // ],
      ),
      bottomSheet: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppConstants.isdemomode == true
              ? MtCustomfontRegular(
                  text: getTranslatedForCurrentUser(
                      context, 'xxxanyenter6dpinxxx'),
                  fontsize: 14,
                )
              : SizedBox(height: 0),
          SizedBox(
            height: 60,
          ),
          Container(
            alignment: Alignment.center,
            decoration: boxDecoration(bgColor: Colors.white, showShadow: true),
            height: 80,
            width: w / 1.2,
            child: ListView.builder(
                itemCount: numbers.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int i) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      isobsured == false ? numbers[i].toString() : '\•',
                      style: TextStyle(
                          fontSize: isobsured == true ? 42 : 28,
                          fontWeight: FontWeight.bold,
                          color: Mycolors.primary),
                    ),
                  ));
                }),
          ),
          SizedBox(height: 18),
          Container(
              color: Colors.white,
              height: h / 2,
              width: w,
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 2),
                shrinkWrap: true,
                children: [
                  cutomtexttappable(context, 1),
                  cutomtexttappable(context, 2),
                  cutomtexttappable(context, 3),
                  cutomtexttappable(context, 4),
                  cutomtexttappable(context, 5),
                  cutomtexttappable(context, 6),
                  cutomtexttappable(context, 7),
                  cutomtexttappable(context, 8),
                  cutomtexttappable(context, 9),
                  widget10(),
                  cutomtexttappable(context, 0),
                  widget12(),
                ],
              )),
        ],
      ),
    );
  }

  widget12() {
    return myinkwell(
      onLongPress: () {
        numbers.clear();
        setState(() {});
      },
      onTap: numbers.length <= 0
          ? () {}
          : () {
              setState(() {
                numbers.removeLast();
              });
              HapticFeedback.lightImpact();
            },
      child: Container(
        child: Icon(Icons.backspace_rounded, size: 30, color: Colors.grey),
      ),
    );
  }

  widget10() {
    return myinkwell(
      onTap: numbers.length == 0
          ? null
          : () {
              setState(() {
                isobsured = !isobsured;
              });
              HapticFeedback.mediumImpact();
            },
      child: Container(
        child: Icon(
            isobsured == true
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 30,
            color: Colors.grey),
      ),
    );
  }

  widget11() {
    return Container(
      child: Icon(Icons.check_circle,
          size: 50, color: numbers.length == 6 ? Colors.green : Colors.grey),
    );
  }

  cutomtexttappable(BuildContext context, int number) {
    return myinkwell(
      onTap: () {
        if (numbers.length == 6) {
        } else if (numbers.length == 5) {
          numbers.add('$number');
          setState(() {});
          HapticFeedback.lightImpact();
          checkcredentials(context);
        } else {
          numbers.add('$number');
          setState(() {});
          HapticFeedback.lightImpact();
        }
      },
      child: Container(
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800]),
          )),
    );
  }
}
