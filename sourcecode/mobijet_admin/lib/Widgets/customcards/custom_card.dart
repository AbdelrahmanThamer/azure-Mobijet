import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/agent_model.dart';
import 'package:thinkcreative_technologies/Models/customer_model.dart';
import 'package:thinkcreative_technologies/Screens/customers/customer_profile_details.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Utils/hide_keyboard.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Widgets/boxdecoration.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';

import '../../Screens/agents/agent_profile_details.dart';

class AgentCard extends StatefulWidget {
  final AgentModel usermodel;
  final bool? isswitchshow;
  final bool isProfileFetchedFromProvider;
  final EdgeInsets? margin;
  final Function? onpressed;
  final Function(bool val)? onswitchchanged;
  AgentCard({
    required this.usermodel,
    this.isswitchshow,
    this.margin,
    required this.isProfileFetchedFromProvider,
    this.onpressed,
    this.onswitchchanged,
  });
  @override
  _AgentCardState createState() => _AgentCardState();
}

class _AgentCardState extends State<AgentCard> {
  @override
  Widget build(BuildContext context) {
    final observer = Provider.of<Observer>(context, listen: false);
    return InkWell(
      onTap: widget.onpressed as void Function()? ??
          () {
            hidekeyboard(context);
            pageNavigator(
                context,
                AgentProfileDetails(
                    agent: widget.usermodel,
                    currentuserid: Optionalconstants.currentAdminID));
          },
      child: Container(
          height: 100.0,
          margin: widget.margin ?? EdgeInsets.all(7),
          decoration: boxDecoration(showShadow: true),
          child: Stack(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 12, 10.0, 7.0),
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: widget.usermodel.accountstatus ==
                                    Dbkeys.sTATUSblocked
                                ? NetworkImage(AppConstants
                                    .defaultprofilepicfromnetworklink)
                                : NetworkImage(widget.usermodel.photoUrl == ''
                                    ? AppConstants
                                        .defaultprofilepicfromnetworklink
                                    : widget.usermodel.photoUrl),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 5),
                          widget.usermodel.userLoginType ==
                                      LoginType.phone.index &&
                                  widget.usermodel.phoneRaw != ""
                              ? Icon(EvaIcons.phone,
                                  color: Mycolors.black, size: 13)
                              : widget.usermodel.userLoginType ==
                                          LoginType.email.index &&
                                      widget.usermodel.email != ""
                                  ? Icon(EvaIcons.email,
                                      color: Mycolors.black, size: 13)
                                  : SizedBox(),
                          1 == 2
                              ? SizedBox(height: 0, width: 0)
                              : Container(
                                  width: 30,
                                  child: Icon(
                                    Icons.verified_user,
                                    color: Mycolors.blue,
                                    size: 16,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: widget.isswitchshow == false
                        ? MediaQuery.of(context).size.width / 1.5
                        : MediaQuery.of(context).size.width / 1.4,
                    padding: EdgeInsets.fromLTRB(10.0, 25.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: widget.onpressed as void Function()? ?? () {},
                          child: MtCustomfontMedium(
                            maxlines: 1,
                            text: widget.usermodel.nickname,
                            fontsize: 15.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onpressed as void Function()? ?? () {},
                          child: Divider(),
                        ),
                        GestureDetector(
                          onTap: widget.onpressed as void Function()? ?? () {},
                          child: SizedBox(
                            height: 5.0,
                          ),
                        ),
                        observer.basicSettingUserApp == null
                            ? SizedBox()
                            : observer.basicSettingUserApp!.loginTypeUserApp ==
                                        "Email/Password" &&
                                    widget.usermodel.email == ""
                                ? MtCustomfontBold(
                                    text:
                                        "No Email linked | Agent Cannot Login",
                                    color: Mycolors.red,
                                    fontsize: 13,
                                  )
                                : observer.basicSettingUserApp!
                                                .loginTypeUserApp ==
                                            "Phone" &&
                                        widget.usermodel.phone == ""
                                    ? MtCustomfontBold(
                                        text:
                                            "No Phone linked | Agent Cannot Login",
                                        color: Mycolors.red,
                                        fontsize: 13,
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // Icon(
                                              //   Icons.location_on,
                                              //   size: 13,
                                              //   color: Mycolors.grey,
                                              // ),
                                              // SizedBox(
                                              //   width: 5,
                                              // ),
                                              Container(
                                                  // width: 110,
                                                  child: Text(
                                                '${getTranslatedForCurrentUser(context, 'xxidxx')} ${widget.usermodel.id} ',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                ),
                                              )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                  width: 100,
                                                  child: Text(
                                                    DateTime.now()
                                                                .difference(DateTime
                                                                    .fromMillisecondsSinceEpoch(widget
                                                                        .usermodel
                                                                        .joinedOn))
                                                                .inDays <
                                                            1
                                                        ? 'joined today'
                                                        : ' joined ${DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(widget.usermodel.joinedOn)).inDays}d ago',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 12.5,
                                                        color:
                                                            Mycolors.greytext),
                                                  )),
                                            ],
                                          ),
                                          widget.isswitchshow == false
                                              ? SizedBox()
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  width: 40.0,
                                                  child: FlutterSwitch(
                                                    inactiveText: '',
                                                    width: 46.0,
                                                    activeColor: Mycolors
                                                        .greenbuttoncolor,
                                                    inactiveColor: Mycolors.red,
                                                    height: 18.0,
                                                    valueFontSize: 12.0,
                                                    toggleSize: 12.0,
                                                    borderRadius: 25.0,
                                                    padding: 3.0,
                                                    showOnOff: true,
                                                    activeText: '',
                                                    value: widget.usermodel
                                                                .accountstatus ==
                                                            Dbkeys.sTATUSallowed
                                                        ? true
                                                        : widget.usermodel
                                                                    .accountstatus ==
                                                                Dbkeys
                                                                    .sTATUSblocked
                                                            ? false
                                                            : widget.usermodel
                                                                        .accountstatus ==
                                                                    Dbkeys
                                                                        .sTATUSpending
                                                                ? false
                                                                : true,
                                                    onToggle: (value) {
                                                      widget.onswitchchanged!(
                                                          value);
                                                    },
                                                  ),
                                                ),
                                        ],
                                      ),
                        SizedBox(
                          height: 13,
                        ),
                        SizedBox(
                          height: 0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              widget.usermodel.accountstatus == Dbkeys.sTATUSblocked
                  ? Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                        decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(0),
                            ) // green shaped
                            ),
                        child: Text(
                          '  BLOCKED ',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.red[700],
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  : SizedBox(),
              widget.usermodel.accountstatus == Dbkeys.sTATUSpending
                  ? Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                        decoration: BoxDecoration(
                            color: Colors.yellow[300],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(0),
                            ) // green shaped
                            ),
                        child: Text(
                          ' WAITING FOR APPROVAL ',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  : SizedBox(),
              widget.usermodel.lastSeen != true
                  ? SizedBox(height: 0, width: 0)
                  : Positioned(
                      child: Container(
                        width: 30,
                        child: Icon(
                          Icons.circle,
                          color: Mycolors.greensqaush,
                          size: 16,
                        ),
                      ),
                      top: 13,
                      left: 45,
                    ),
              // flagIndex < 0
              //     ? SizedBox(height: 0, width: 0)
              //     : Positioned(
              //         child: Container(
              //             width: 30,
              //             child: Text(
              //               '${countryData[flagIndex].split('---')[1]}',
              //               style: TextStyle(fontSize: 20),
              //             )),
              //         top: 10,
              //         left: 10,
              //       )
            ],
          )),
    );
  }
}

class CustomerCard extends StatefulWidget {
  final CustomerModel usermodel;
  final bool? isswitchshow;
  final bool isProfileFetchedFromProvider;
  final EdgeInsets? margin;
  final Function? onpressed;
  final Function(bool val)? onswitchchanged;

  CustomerCard({
    required this.usermodel,
    this.isswitchshow,
    this.margin,
    required this.isProfileFetchedFromProvider,
    this.onpressed,
    this.onswitchchanged,
  });
  @override
  _CustomerCardState createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  @override
  Widget build(BuildContext context) {
    final observer = Provider.of<Observer>(context, listen: false);
    return InkWell(
      onTap: widget.onpressed as void Function()? ??
          () {
            hidekeyboard(context);
            pageNavigator(
                context,
                CustomerProfileDetails(
                  customer: widget.usermodel,
                  currentuserid: Optionalconstants.currentAdminID,
                ));
          },
      child: Container(
          height: 100.0,
          margin: widget.margin ?? EdgeInsets.all(7),
          decoration: boxDecoration(showShadow: true),
          child: Stack(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 12, 10.0, 7.0),
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: widget.usermodel.accountstatus ==
                                    Dbkeys.sTATUSblocked
                                ? NetworkImage(AppConstants
                                    .defaultprofilepicfromnetworklink)
                                : NetworkImage(widget.usermodel.photoUrl == ''
                                    ? AppConstants
                                        .defaultprofilepicfromnetworklink
                                    : widget.usermodel.photoUrl),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 5),
                          widget.usermodel.userLoginType ==
                                      LoginType.phone.index &&
                                  widget.usermodel.phoneRaw != ""
                              ? Icon(EvaIcons.phone,
                                  color: Mycolors.black, size: 13)
                              : widget.usermodel.userLoginType ==
                                          LoginType.email.index &&
                                      widget.usermodel.email != ""
                                  ? Icon(EvaIcons.email,
                                      color: Mycolors.black, size: 13)
                                  : SizedBox(),
                          1 == 2
                              ? SizedBox(height: 0, width: 0)
                              : Container(
                                  width: 30,
                                  child: Icon(
                                    Icons.verified_user,
                                    color: Mycolors.blue,
                                    size: 16,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: widget.isswitchshow == false
                        ? MediaQuery.of(context).size.width / 1.5
                        : MediaQuery.of(context).size.width / 1.4,
                    padding: EdgeInsets.fromLTRB(10.0, 25.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: widget.onpressed as void Function()? ?? () {},
                          child: MtCustomfontMedium(
                            maxlines: 1,
                            text: widget.usermodel.nickname,
                            fontsize: 15.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onpressed as void Function()? ?? () {},
                          child: Divider(),
                        ),
                        GestureDetector(
                          onTap: widget.onpressed as void Function()? ?? () {},
                          child: SizedBox(
                            height: 5.0,
                          ),
                        ),
                        observer.basicSettingUserApp == null
                            ? SizedBox()
                            : observer.basicSettingUserApp!.loginTypeUserApp ==
                                        "Email/Password" &&
                                    widget.usermodel.email == ""
                                ? MtCustomfontBold(
                                    text:
                                        "No Email linked | Customer Cannot Login",
                                    color: Mycolors.red,
                                    fontsize: 13,
                                  )
                                : observer.basicSettingUserApp!
                                                .loginTypeUserApp ==
                                            "Phone" &&
                                        widget.usermodel.phone == ""
                                    ? MtCustomfontBold(
                                        text:
                                            "No Phone linked | Customer Cannot Login",
                                        color: Mycolors.red,
                                        fontsize: 13,
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // Icon(
                                              //   Icons.location_on,
                                              //   size: 13,
                                              //   color: Mycolors.grey,
                                              // ),
                                              // SizedBox(
                                              //   width: 5,
                                              // ),
                                              Container(
                                                  // width: 110,
                                                  child: Text(
                                                '${getTranslatedForCurrentUser(context, 'xxidxx')} ${widget.usermodel.id} ',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                ),
                                              )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                  width: 100,
                                                  child: Text(
                                                    DateTime.now()
                                                                .difference(DateTime
                                                                    .fromMillisecondsSinceEpoch(widget
                                                                        .usermodel
                                                                        .joinedOn))
                                                                .inDays <
                                                            1
                                                        ? 'joined today'
                                                        : ' joined ${DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(widget.usermodel.joinedOn)).inDays}d ago',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 12.5,
                                                        color:
                                                            Mycolors.greytext),
                                                  )),
                                            ],
                                          ),
                                          widget.isswitchshow == false
                                              ? SizedBox()
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  width: 40.0,
                                                  child: FlutterSwitch(
                                                    inactiveText: '',
                                                    width: 46.0,
                                                    activeColor: Mycolors
                                                        .greenbuttoncolor,
                                                    inactiveColor: Mycolors.red,
                                                    height: 18.0,
                                                    valueFontSize: 12.0,
                                                    toggleSize: 12.0,
                                                    borderRadius: 25.0,
                                                    padding: 3.0,
                                                    showOnOff: true,
                                                    activeText: '',
                                                    value: widget.usermodel
                                                                .accountstatus ==
                                                            Dbkeys.sTATUSallowed
                                                        ? true
                                                        : widget.usermodel
                                                                    .accountstatus ==
                                                                Dbkeys
                                                                    .sTATUSblocked
                                                            ? false
                                                            : widget.usermodel
                                                                        .accountstatus ==
                                                                    Dbkeys
                                                                        .sTATUSpending
                                                                ? false
                                                                : true,
                                                    onToggle: (value) {
                                                      widget.onswitchchanged!(
                                                          value);
                                                    },
                                                  ),
                                                ),
                                        ],
                                      ),
                        SizedBox(
                          height: 13,
                        ),
                        SizedBox(
                          height: 0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              widget.usermodel.accountstatus == Dbkeys.sTATUSblocked
                  ? Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                        decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(0),
                            ) // green shaped
                            ),
                        child: Text(
                          '  BLOCKED ',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.red[700],
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  : SizedBox(),
              widget.usermodel.accountstatus == Dbkeys.sTATUSpending
                  ? Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                        decoration: BoxDecoration(
                            color: Colors.yellow[300],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(0),
                            ) // green shaped
                            ),
                        child: Text(
                          ' WAITING FOR APPROVAL ',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  : SizedBox(),
              widget.usermodel.lastSeen != true
                  ? SizedBox(height: 0, width: 0)
                  : Positioned(
                      child: Container(
                        width: 30,
                        child: Icon(
                          Icons.circle,
                          color: Mycolors.greensqaush,
                          size: 16,
                        ),
                      ),
                      top: 13,
                      left: 45,
                    ),
              // flagIndex < 0
              //     ? SizedBox(height: 0, width: 0)
              //     : Positioned(
              //         child: Container(
              //             width: 30,
              //             child: Text(
              //               '${countryData[flagIndex].split('---')[1]}',
              //               style: TextStyle(fontSize: 20),
              //             )),
              //         top: 10,
              //         left: 10,
              //       )
            ],
          )),
    );
  }
}

Widget customcardStatistics(
    {Function? onTap,
    Color? cardcolor,
    Color? cardcolorInner,
    required BuildContext context,
    String? l,
    String? r1,
    String? r2,
    String? r3,
    String? r1base,
    String? r2base,
    String? r3base,
    String? lbase,
    required bool isthreecolumn}) {
  return myinkwell(
    onTap: onTap ?? () {},
    child: isthreecolumn == false
        ? Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: cardcolor ?? Color(0xff1B213D), width: 2.0),
              color: cardcolor ?? Color(0xff1B213D),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 3.0,
                  offset: new Offset(0.0, 2.0),
                ),
              ],
            ),
            margin: EdgeInsets.fromLTRB(8.0, 7.0, 8.0, 7.0),
            height: 150.0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: cardcolorInner ?? Color(0xff2A2B4A), width: 0.0),
                    color: cardcolorInner ?? Color(0xff2A2B4A),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width / 2.56,
                  padding: EdgeInsets.all(3.0),
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.person, size: 30, color: Mycolors.grey),

                      SizedBox(
                        height: 8.0,
                      ),
                      MtPoppinsBold(
                          text: l ?? '2000',
                          color: Mycolors.orange,
                          fontsize: 27),
                      SizedBox(
                        height: 12.0,
                      ),
                      MtCustomfontMedium(
                        fontsize: 15.0,
                        color: Colors.white70,
                        text: lbase ?? 'Total',
                      ),

                      // SizedBox(height: 3.0,), Text('Manage >',style: TextStyle(fontFamily: 'PNR',fontSize: 13.0,color: cardcolor.greylightcolor),),
                      SizedBox(
                        height: 2.0,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: cardcolorInner ?? Color(0xff2A2B4A),
                            width: 0.0),
                        color: cardcolorInner ?? Color(0xff2A2B4A),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width / 2.1,
                      height: 57.0,
                      padding: EdgeInsets.all(2.0),
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 7.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 0.0,
                          ),
                          Text(
                            r1 ?? '0',
                            style: TextStyle(
                                fontFamily: 'Poppins-Bold',
                                fontSize: 19.0,
                                color: Mycolors.green),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            r1base ?? 'title',
                            style: TextStyle(
                                fontFamily: 'PNR',
                                fontSize: 13.4,
                                color: Colors.white70),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: cardcolorInner ?? Color(0xff2A2B4A),
                            width: 0.0),
                        color: cardcolorInner ?? Color(0xff2A2B4A),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width / 2.1,
                      height: 57.0,
                      padding: EdgeInsets.all(2.0),
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 7.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 0.0,
                          ),
                          Text(
                            r2 ?? '0',
                            style: TextStyle(
                                fontFamily: 'Poppins-Bold',
                                fontSize: 19.0,
                                color: Mycolors.red),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            r2base ?? 'Title',
                            style: TextStyle(
                                fontFamily: 'PNR',
                                fontSize: 13.4,
                                color: Colors.white70),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ))
        : Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: cardcolor ?? Color(0xff1B213D), width: 2.0),
              color: cardcolor ?? Color(0xff1B213D),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 3.0,
                  offset: new Offset(0.0, 2.0),
                ),
              ],
            ),
            margin: EdgeInsets.fromLTRB(8.0, 7.0, 8.0, 7.0),
            height: 215.0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: cardcolorInner ?? Color(0xff2A2B4A), width: 0.0),
                    color: cardcolorInner ?? Color(0xff2A2B4A),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width / 2.56,
                  padding: EdgeInsets.all(3.0),
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.person, size: 30, color: Mycolors.grey),

                      SizedBox(
                        height: 8.0,
                      ),
                      MtPoppinsBold(
                          text: l ?? '2000',
                          color: Mycolors.blue,
                          fontsize: 27),
                      SizedBox(
                        height: 12.0,
                      ),
                      MtCustomfontMedium(
                        fontsize: 15.0,
                        color: Colors.white70,
                        text: lbase ?? 'Total',
                      ),

                      // SizedBox(height: 3.0,), Text('Manage >',style: TextStyle(fontFamily: 'PNR',fontSize: 13.0,color: cardcolor.greylightcolor),),
                      SizedBox(
                        height: 2.0,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: cardcolorInner ?? Color(0xff2A2B4A),
                            width: 0.0),
                        color: cardcolorInner ?? Color(0xff2A2B4A),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width / 2.1,
                      height: 57.0,
                      padding: EdgeInsets.all(2.0),
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 7.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 0.0,
                          ),
                          Text(
                            r1 ?? '0',
                            style: TextStyle(
                                fontFamily: 'Poppins-Bold',
                                fontSize: 19.0,
                                color: Mycolors.green),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            r1base ?? 'title',
                            style: TextStyle(
                                fontFamily: 'PNR',
                                fontSize: 13.4,
                                color: Colors.white70),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: cardcolorInner ?? Color(0xff2A2B4A),
                            width: 0.0),
                        color: cardcolorInner ?? Color(0xff2A2B4A),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width / 2.1,
                      height: 57.0,
                      padding: EdgeInsets.all(2.0),
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 7.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 0.0,
                          ),
                          Text(
                            r2 ?? '0',
                            style: TextStyle(
                                fontFamily: 'Poppins-Bold',
                                fontSize: 19.0,
                                color: Mycolors.red),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            r2base ?? 'Title',
                            style: TextStyle(
                                fontFamily: 'PNR',
                                fontSize: 13.4,
                                color: Colors.white70),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: cardcolorInner ?? Color(0xff2A2B4A),
                            width: 0.0),
                        color: cardcolorInner ?? Color(0xff2A2B4A),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width / 2.1,
                      height: 57.0,
                      padding: EdgeInsets.all(2.0),
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 7.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 0.0,
                          ),
                          Text(
                            r3 ?? '0',
                            style: TextStyle(
                                fontFamily: 'Poppins-Bold',
                                fontSize: 19.0,
                                color: Mycolors.orange),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            r3base ?? 'Title',
                            style: TextStyle(
                                fontFamily: 'PNR',
                                fontSize: 13.4,
                                color: Colors.white70),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )),
  );
}

Widget customcardVersionControl({
  Color? cardcolor,
  Color? cardcolorInner,
  required BuildContext context,
  String? androidUserappVersion,
  String? androidAdminappVersion,
  String? iosAdminappVersion,
  String? iosUserappVersion,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 15, top: 6, bottom: 2),
        child: MtCustomfontBold(
          textalign: TextAlign.left,
          text: 'App Versions ',
          fontsize: 16.6,
        ),
      ),
      SizedBox(
        height: 7,
      ),
      Container(
          decoration: boxDecoration(showShadow: true),
          margin: EdgeInsets.fromLTRB(8.0, 7.0, 8.0, 7.0),
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7.0),
          height: 170.0,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: cardcolorInner ?? Color(0xff2A2B4A),
                          width: 0.0),
                      color: cardcolorInner ?? Color(0xff2A2B4A),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: 67.0,
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.fromLTRB(7.0, 10.0, 7.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/COMMON_ASSETS/android.png',
                          height: 25,
                          width: 25,
                        ),
                        SizedBox(
                          width: 17,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 0.0,
                            ),
                            Text(
                              androidUserappVersion ?? '0',
                              style: TextStyle(
                                  fontFamily: 'Poppins-Bold',
                                  fontSize: 19.0,
                                  color: Color(0xFFA3C327)),
                            ),
                            Text(
                              'User app',
                              style: TextStyle(
                                  fontFamily: 'PNR',
                                  fontSize: 13.4,
                                  color: Mycolors.grey),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: cardcolorInner ?? Color(0xff2A2B4A),
                          width: 0.0),
                      color: cardcolorInner ?? Color(0xff2A2B4A),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: 67.0,
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.fromLTRB(3.0, 10.0, 7.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/COMMON_ASSETS/apple.png',
                          height: 25,
                          width: 25,
                        ),
                        SizedBox(
                          width: 17,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 0.0,
                            ),
                            Text(
                              iosUserappVersion ?? '0',
                              style: TextStyle(
                                  fontFamily: 'Poppins-Bold',
                                  fontSize: 19.0,
                                  color: Mycolors.grey.withOpacity(0.85)),
                            ),
                            Text(
                              'User app',
                              style: TextStyle(
                                  fontFamily: 'PNR',
                                  fontSize: 13.4,
                                  color: Mycolors.grey),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: cardcolorInner ?? Color(0xff2A2B4A),
                          width: 0.0),
                      color: cardcolorInner ?? Color(0xff2A2B4A),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: 67.0,
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.fromLTRB(7.0, 10.0, 7.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/COMMON_ASSETS/android.png',
                          height: 25,
                          width: 25,
                        ),
                        SizedBox(
                          width: 17,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 0.0,
                            ),
                            Text(
                              androidAdminappVersion ?? '0',
                              style: TextStyle(
                                  fontFamily: 'Poppins-Bold',
                                  fontSize: 19.0,
                                  color: Color(0xFFA3C327)),
                            ),
                            Text(
                              'Admin app',
                              style: TextStyle(
                                  fontFamily: 'PNR',
                                  fontSize: 13.4,
                                  color: Mycolors.grey),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: cardcolorInner ?? Color(0xff2A2B4A),
                          width: 0.0),
                      color: cardcolorInner ?? Color(0xff2A2B4A),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: 67.0,
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.fromLTRB(3.0, 10.0, 7.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/COMMON_ASSETS/apple.png',
                          height: 25,
                          width: 25,
                        ),
                        SizedBox(
                          width: 17,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 0.0,
                            ),
                            Text(
                              iosAdminappVersion ?? '0',
                              style: TextStyle(
                                  fontFamily: 'Poppins-Bold',
                                  fontSize: 19.0,
                                  color: Mycolors.grey.withOpacity(0.85)),
                            ),
                            Text(
                              'Admin App',
                              style: TextStyle(
                                  fontFamily: 'PNR',
                                  fontSize: 13.4,
                                  color: Mycolors.grey),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    ],
  );
}
