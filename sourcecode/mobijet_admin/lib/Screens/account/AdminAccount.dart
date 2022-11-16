import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Screens/account/ChangeLoginCredentials.dart';
import 'package:thinkcreative_technologies/Screens/initialization/initialization_constant.dart';
import 'package:thinkcreative_technologies/Screens/networkSensitiveUi/NetworkSensitiveUi.dart';
import 'package:thinkcreative_technologies/Screens/notifications/AllNotifications.dart';
import 'package:thinkcreative_technologies/Services/my_providers/bottom_nav_bar.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/customCircleAvatars.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/custom_buttons.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Utils/my_shared_prefs.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';

class AdminAccount extends StatefulWidget {
  final SharedPreferences prefs;
  AdminAccount({required this.prefs});
  @override
  _AdminAccountState createState() => _AdminAccountState();
}

class _AdminAccountState extends State<AdminAccount>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();

  var top = 0.0;

  @override
  void initState() {
    super.initState();
  }

  unsubscribeFromNotifications() async {
    await FirebaseMessaging.instance
        .unsubscribeFromTopic("Admin")
        .then((value) async {
      await FirebaseMessaging.instance.unsubscribeFromTopic("Activities");
      await FirebaseMessaging.instance.unsubscribeFromTopic("ADMIN");
    });
  }

  late FirebaseAuth _auth;
  signOutAccount() async {
    _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await unsubscribeFromNotifications();
      await FirebaseFirestore.instance
          .collection(DbPaths.adminapp)
          .doc(DbPaths.admincred)
          .update({Dbkeys.admindeviceid: ""});
      await FirebaseAuth.instance.signOut().then((value) async {
        MySharedPrefs().setmybool('isLoggedIn', false);
      }).then((value) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Restart.restartApp();
      });
    } on PlatformException catch (e) {
      Utils.toast("FAILED TO LOGIN. $e");
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double w = size.width;

    return NetworkSensitive(
      child: Utils.getNTPWrappedWidget(Consumer<CommonSession>(
          builder: (context, session, _child) => Consumer<Observer>(
              builder: (context, observer, _child) => Consumer<
                      BottomNavigationBarProvider>(
                  builder: (context, provider, _child) => Scaffold(
                        // resizeToAvoidBottomPadding: true,
                        key: _scaffoldKey,

                        backgroundColor: Colors.white,
                        body: CustomScrollView(
                          controller: _scrollController,
                          slivers: <Widget>[
                            SliverAppBar(
                              backgroundColor: Mycolors.primary,
                              elevation: 1.0,
                              expandedHeight: 173,
                              pinned: true,
                              floating: false,
                              title: MtCustomfontBold(
                                  color: Colors.white,
                                  text: getTranslatedForCurrentUser(
                                      context, 'xxaccountxx'),
                                  fontsize: 20),
                              actions: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: IconButton(
                                      icon: const Icon(LineAwesomeIcons.bell,
                                          size: 24),
                                      color: Mycolors.white,
                                      onPressed: () {
                                        pageNavigator(
                                            context, NotificationCentre());
                                      }),
                                ),
                              ],
                              flexibleSpace: LayoutBuilder(builder:
                                  (BuildContext context,
                                      BoxConstraints constraints) {
                                var top = constraints.biggest.height;
                                // print('TOP:::$top');
                                int triggerheight = 130;
                                return FlexibleSpaceBar(
                                  collapseMode: CollapseMode.parallax,
                                  title: AnimatedOpacity(
                                    opacity: top > 95 && top < 133 ? 0 : 0.99,
                                    duration: Duration(milliseconds: 20),
                                    //opacity: top > 71 && top < 91 ? 1.0 : 0.0,
                                    child: Container(
                                        height:
                                            top > 0 && top < triggerheight - 15
                                                ? 20
                                                : 50,
                                        // width: w / 2,
                                        margin: EdgeInsets.only(
                                            left: top > 0 &&
                                                    top < triggerheight - 32
                                                ? 0
                                                : 27),
                                        child: top > 0 &&
                                                top < triggerheight - 15
                                            ? MtCustomfontBold(
                                                maxlines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                fontsize: top > 0 &&
                                                        top < triggerheight - 6
                                                    ? 19
                                                    : 17,
                                                color: Colors.black,
                                                text: '',
                                              )
                                            : SizedBox()),
                                  ),
                                  background: Container(
                                    color: Mycolors.primary,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      // fit: StackFit.expand,
                                      // overflow: Overflow.visible,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                alignment: Alignment.bottomLeft,
                                                width: 80,
                                                child: customCircleAvatar(
                                                    url: session.photourl,
                                                    radius: 35)),
                                            Container(
                                              // color: Mycolors.red,
                                              margin: EdgeInsets.only(left: 15),
                                              alignment: Alignment.topLeft,
                                              width: w - 125,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  MtCustomfontBoldSemi(
                                                    text: session.fullname,
                                                    color: Colors.white,
                                                    maxlines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    lineheight: 1.2,
                                                    fontsize: 20,
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  MtCustomfontRegular(
                                                    text:
                                                        '${getTranslatedForCurrentUser(context, 'xxadminxx')} ${getTranslatedForCurrentUser(context, 'xxaccountxx')}',
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                    maxlines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    lineheight: 1.2,
                                                    fontsize: 14,
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate(
                                <Widget>[
                                  const SizedBox(
                                    height: 0,
                                  ),
                                  eachsimpletile(
                                      ontap: AppConstants.isdemomode == true
                                          ? () {
                                              Utils.toast(
                                                  getTranslatedForCurrentUser(
                                                      context,
                                                      'xxxnotalwddemoxxaccountxx'));
                                            }
                                          : () {
                                              pageNavigator(
                                                  context,
                                                  ChangeLoginCredentials(
                                                    isFirstTime: false,
                                                  ));
                                            },
                                      context: context,
                                      title: getTranslatedForCurrentUser(
                                          context, 'xxeditprofilexx'),
                                      icondata: LineAwesomeIcons.edit),
                                  eachsimpletile(
                                      ontap: () {
                                        String? applink = Platform.isAndroid
                                            ? session.basicuserappsettings!
                                                .newapplinkandroid
                                            : Platform.isIOS
                                                ? session.basicuserappsettings!
                                                    .newapplinkios
                                                : "";
                                        HapticFeedback.vibrate();
                                        Share.share(
                                          getTranslatedForCurrentUser(context,
                                                  'xxxhelloiamsharingxxx')
                                              .replaceAll('(####)',
                                                  '${AppConstants.appname}')
                                              .replaceAll('(###)', '$applink'),
                                        );
                                      },
                                      context: context,
                                      title: getTranslatedForCurrentUser(
                                          context, 'xxxshareappxxx'),
                                      icondata: LineAwesomeIcons.share),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        8,
                                        MediaQuery.of(context).size.height /
                                            3.6,
                                        8,
                                        8),
                                    child: MySimpleButton(
                                      onpressed: () async {
                                        await _signOut(context);
                                      },
                                      buttontext: getTranslatedForCurrentUser(
                                          context, 'xxlogoutxx'),
                                      buttoncolor: Colors.red[600],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(25),
                                    child: MtCustomfontBoldSemi(
                                        color: Mycolors.grey.withOpacity(0.7),
                                        textalign: TextAlign.center,
                                        fontsize: 13.7,
                                        text: '${getTranslatedForCurrentUser(context, 'xxappversionxx')} ' +
                                            (widget.prefs
                                                    .getString('app_version') ??
                                                "") +
                                            '  |  Build v${InitializationConstant.k4}'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))))),
    );
  }

  // _renderSelectedMedia(BuildContext context, Product product, Size size) {
  //   /// Render selected video
  //   if (selectedUrl != null && isVideoSelected) {
  //     return FeatureVideoPlayer(
  //       url: selectedUrl.replaceAll("http://", "https://"),
  //       autoPlay: true,
  //     );
  //   }

  /// Render selected image
  // if (selectedUrl != null && !isVideoSelected) {
  //   return GestureDetector(
  //     onTap: () {
  //       showDialog<void>(
  //         context: context,
  //         builder: (BuildContext context) {
  //           final images = [...product.images];
  //           final int index = product.images.indexOf(selectedUrl);
  //           if (index == -1) {
  //             images.insert(0, selectedUrl);
  //           }
  //           return ImageGalery(
  //             images: images,
  //             index: index == -1 ? 0 : index,
  //           );
  //         },
  //       );
  //     },
  //     child: Tools.image(
  //       url: selectedUrl,
  //       fit: BoxFit.contain,
  //       width: size.width,
  //       size: kSize.large,
  //       hidePlaceHolder: true,
  //     ),
  //   );
  // }

  /// Render default feature image
  //   return product.type == 'variable'
  //       ? VariantImageFeature(product)
  //       : ImageFeature(product);
  // }
}

eachsimpletile({
  BuildContext? context,
  String? title,
  Function? ontap,
  Widget? iconwidget,
  IconData? icondata,
  double? iconsize,
  double? textfontsize,
  Color? iconcolor,
  Color? tilecolor,
  Color? textcolor,
  bool? isshowtrailing,
}) {
  return myinkwell(
    onTap: ontap ?? null,
    child: Container(
      padding: EdgeInsets.fromLTRB(19, 19, 14, 18),
      decoration: BoxDecoration(
        color: tilecolor ?? Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Mycolors.greylightcolor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                iconwidget ??
                    Icon(
                      icondata ?? Icons.emoji_emotions_sharp,
                      size: iconsize ?? 26,
                      color: iconcolor ?? Mycolors.primary,
                    ),
                SizedBox(
                  width: 19,
                ),
                MtCustomfontMedium(
                  text: title ?? 'My Orders',
                  fontsize: textfontsize ?? 15.0,
                  color: textcolor ?? Mycolors.black.withOpacity(0.89),
                ),
              ],
            ),
          ),
          isshowtrailing == null || isshowtrailing == true
              ? Icon(
                  Icons.keyboard_arrow_right_outlined,
                  size: 22,
                  color: Mycolors.primary.withOpacity(0.8),
                )
              : SizedBox(width: 0),
        ],
      ),
    ),
  );
}
