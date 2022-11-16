import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';

import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/number_limits.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/agent_model.dart';
import 'package:thinkcreative_technologies/Models/customer_model.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/ticketWidget.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/MediaQuery/mediaquerytools.dart';
import 'package:thinkcreative_technologies/Widgets/PhoneField/intl_phone_field.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/custom_buttons.dart';
import 'package:thinkcreative_technologies/Widgets/customcards/custom_card.dart';
import 'package:thinkcreative_technologies/Widgets/Input_box.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Utils/hide_keyboard.dart';

class SearchUser extends StatefulWidget {
  final String searchtype;
  final int serchusertype;
  final CollectionReference colRef;
  SearchUser({
    required this.searchtype,
    required this.colRef,
    required this.serchusertype,
  });
  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  bool isloading = false;
  String? message;
  dynamic userDoc;
  String? phonenumber;
  String? email;
  String? phonecode;
  String? uid;
  String? id;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String langKey = "";
  @override
  void initState() {
    super.initState();
    langKey = widget.serchusertype == Usertype.agent.index
        ? "xxagentxx"
        : widget.serchusertype == Usertype.customer.index
            ? "xxcustomerxx"
            : '';
  }

  searchUser({DocumentReference? docRef, Query? queryRef}) async {
    final observer = Provider.of<Observer>(context, listen: false);
    setState(() {
      isloading = true;
    });
    if (docRef == null) {
      await queryRef!.get().then((query) async {
        if (query.docs.length > 0) {
          message = null;
          userDoc = query.docs[0].data();
          isloading = false;
          setState(() {});
        } else {
          message =
              '${getTranslatedForCurrentUser(context, langKey)} ${getTranslatedForCurrentUser(context, 'xxxnotfoundxxx')}';

          isloading = false;
          setState(() {});
        }
      }).catchError((err) {
        message = observer.isshowerrorlog == false
            ? '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}'
            : '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}\n $err';
        userDoc = null;
        isloading = false;
        setState(() {});
      });
    } else {
      await docRef.get().then((doc) async {
        if (doc.exists) {
          message = null;
          userDoc = doc.data();
          isloading = false;
          setState(() {});
        } else {
          message =
              '${getTranslatedForCurrentUser(context, langKey)} ${getTranslatedForCurrentUser(context, 'xxxnotfoundxxx')}';

          isloading = false;
          setState(() {});
        }
      }).catchError((err) {
        message = observer.isshowerrorlog == false
            ? '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}'
            : '${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}\n $err';
        userDoc = null;
        isloading = false;
        setState(() {});
      });
    }
  }

  Widget userwidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MtCustomfontBold(
          textalign: TextAlign.left,
          text:
              '  ${getTranslatedForCurrentUser(context, 'xxxsearchresultsxxx')} :',
          fontsize: 17,
        ),
        Divider(),
        widget.serchusertype == Usertype.agent.index
            ? AgentCard(
                isProfileFetchedFromProvider: false,
                margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                usermodel: AgentModel.fromJson(userDoc),
                isswitchshow: false,
              )
            : widget.serchusertype == Usertype.customer.index
                ? CustomerCard(
                    isProfileFetchedFromProvider: false,
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    usermodel: CustomerModel.fromJson(userDoc),
                    isswitchshow: false,
                  )
                : Text('user type not defined')
      ],
    );
  }

  TextEditingController _controller = new TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: widget.searchtype == 'byid'
          ? '${getTranslatedForCurrentUser(context, 'xxxsearchxx')} ${getTranslatedForCurrentUser(context, 'xxxbyxxxxidxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, langKey)}')}'
          : widget.searchtype == 'byemailid'
              ? '${getTranslatedForCurrentUser(context, 'xxxsearchxx')} ${getTranslatedForCurrentUser(context, 'xxxbyxxxxemailxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, langKey)}')}'
              : widget.searchtype == 'byphone'
                  ? '${getTranslatedForCurrentUser(context, 'xxxsearchxx')} ${getTranslatedForCurrentUser(context, 'xxxbyxxxxphonexxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, langKey)}')}'
                  : widget.searchtype == 'byuid'
                      ? '${getTranslatedForCurrentUser(context, 'xxxsearchxx')} ${getTranslatedForCurrentUser(context, 'xxxbyxxxxuidxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, langKey)}')}'
                      : widget.searchtype == 'byemailid'
                          ? '${getTranslatedForCurrentUser(context, 'xxxsearchxx')} ${getTranslatedForCurrentUser(context, 'xxxbyxxxxemailxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, langKey)}')}'
                          : '${getTranslatedForCurrentUser(context, 'xxxsearchxx')} ${getTranslatedForCurrentUser(context, 'xxxbyxxxxnamexxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, langKey)}')}',
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Form(
              key: _formKey,
              child: widget.searchtype == 'byphone'
                  ? Container(
                      margin: EdgeInsets.all(7),
                      padding: EdgeInsetsDirectional.only(bottom: 7, top: 5),
                      height: 50,
                      width: MediaQuery.of(this.context).size.width,
                      decoration: boxDecoration(bgColor: Mycolors.white),
                      child: IntlPhoneField(
                        dropDownArrowColor: Mycolors.grey,
                        textAlign: TextAlign.left,
                        initialCountryCode: AppConstants.defaultcountrycodeISO,
                        controller: _controller,
                        style: TextStyle(
                            height: 1.35,
                            letterSpacing: 1,
                            fontSize: 16.0,
                            color: Mycolors.black,
                            fontWeight: FontWeight.bold),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(3, 15, 8, 0),
                            hintText: getTranslatedForCurrentUser(
                                context, 'xxenter_mobilenumberxx'),
                            hintStyle: TextStyle(
                                letterSpacing: 1,
                                height: 0.0,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w400,
                                color: Mycolors.grey.withOpacity(0.4)),
                            fillColor: Mycolors.white,
                            filled: true,
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide.none,
                            )),
                        onChanged: (phone) {
                          setState(() {
                            phonecode = phone.countryCode;
                            phonenumber = phone.number;

                            // istyping = true;
                          });
                        },
                        validator: (v) {
                          return null;
                        },
                        onSaved: (phone) {
                          setState(() {
                            phonecode = phone?.countryCode;
                            phonenumber = phone?.number;

                            // istyping = true;
                          });
                        },
                      ),
                    )
                  //  MobileInputWithOutline(
                  //           buttonhintTextColor: Mycolors.grey,
                  //           borderColor: Mycolors.grey.withOpacity(0.2),
                  //           // controller: _phoneNo,
                  //           initialCountryCode: AppConstants.defaultcountrycodeISO,
                  //           onSaved: (phone) {
                  //             setState(() {
                  //               phonecode = phone?.countryCode;
                  //               phonenumber = phone?.number;

                  //               // istyping = true;
                  //             });
                  //           },
                  //         )
                  : widget.searchtype == 'byemailid'
                      ? InpuTextBox(
                          hinttext:
                              getTranslatedForCurrentUser(context, 'xxemailxx'),
                          autovalidate: true,
                          controller: _controller,
                          keyboardtype: TextInputType.emailAddress,
                          onSaved: (val) {},
                          isboldinput: true,
                        )
                      : widget.searchtype == 'byid'
                          ? InpuTextBox(
                              hinttext: getTranslatedForCurrentUser(
                                  context, 'xxidxx'),
                              autovalidate: true,
                              keyboardtype: TextInputType.number,
                              onSaved: (val) {
                                id = val;
                              },
                              isboldinput: true,
                            )
                          : widget.searchtype == 'byuid'
                              ? InpuTextBox(
                                  hinttext: 'Firebase UID',
                                  autovalidate: true,
                                  keyboardtype: TextInputType.name,
                                  inputFormatter: [
                                    LengthLimitingTextInputFormatter(
                                        Numberlimits.maxuiddigits),
                                  ],
                                  onSaved: (val) {
                                    uid = val;
                                  },
                                  isboldinput: true,
                                  validator: (val) {
                                    if (val!.trim().length < 1) {
                                      return 'Enter User UID generated by Firebase Authentication';
                                    } else if (val.trim().length >
                                        Numberlimits.maxuiddigits) {
                                      return getTranslatedForCurrentUser(
                                              context, 'xxmaxxxcharxx')
                                          .replaceAll('(####)',
                                              '${Numberlimits.maxuiddigits}');
                                    } else {
                                      return null;
                                    }
                                  },
                                )
                              : InpuTextBox(
                                  hinttext: getTranslatedForCurrentUser(
                                      context, 'xxnamexx'),
                                  autovalidate: false,
                                  keyboardtype: TextInputType.name,
                                  inputFormatter: [
                                    LengthLimitingTextInputFormatter(
                                        Numberlimits.maxnamedigits),
                                  ],
                                  onSaved: (val) {
                                    uid = val;
                                  },
                                  isboldinput: true,
                                )),
          SizedBox(
            height: 20,
          ),
          MySimpleButton(
            buttoncolor: Mycolors.greenbuttoncolor,
            buttontext: getTranslatedForCurrentUser(context, 'xxxsearchxxx')
                .toUpperCase(),
            onpressed: widget.searchtype == 'byphone'
                ? () async {
                    if (_controller.text.trim().length < 5) {
                      Utils.toast(getTranslatedForCurrentUser(
                          context, 'xxentervalidmobxx'));
                    } else {
                      setState(() {
                        phonenumber = _controller.text.trim();
                      });
                      await searchUser(
                          queryRef: widget.colRef.where(Dbkeys.phone,
                              isEqualTo: phonecode! + phonenumber!));
                    }
                  }
                : widget.searchtype == 'byemailid'
                    ? () async {
                        if (_controller.text.trim().length < 3 ||
                            !_controller.text.trim().contains('@') ||
                            !_controller.text.trim().contains('.')) {
                          Utils.toast(getTranslatedForCurrentUser(
                              context, 'xxvalidemailxx'));
                        } else {
                          setState(() {
                            email = _controller.text.trim().toLowerCase();
                          });
                          await searchUser(
                              queryRef: widget.colRef
                                  .where(Dbkeys.email, isEqualTo: email));
                        }
                      }
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          hidekeyboard(context);
                          await searchUser(
                              queryRef: widget.searchtype == 'byid'
                                  ? widget.colRef
                                      .where(Dbkeys.id, isEqualTo: id)
                                  : widget.searchtype == 'byphone'
                                      ? widget.colRef.where(Dbkeys.phone,
                                          isEqualTo: phonecode! + phonenumber!)
                                      : widget.colRef.where(Dbkeys.firebaseuid,
                                          isEqualTo: uid));
                        }
                      },
          ),
          Center(
            child: isloading == true
                ? Padding(
                    padding: EdgeInsets.only(top: height(context) / 4.4),
                    child: circularProgress())
                : message != null
                    ? Padding(
                        padding: EdgeInsets.only(top: height(context) / 4.4),
                        child: MtCustomfontRegular(text: message),
                      )
                    : userDoc != null
                        ? Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: userwidget(context))
                        : SizedBox(),
          )
        ],
      ),
    );
  }
}
