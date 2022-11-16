//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Definition attached with source code. *********************

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Models/department_model.dart';
import 'package:thinkcreative_technologies/Models/ticket_message.dart';
import 'package:thinkcreative_technologies/Models/ticket_model.dart';
import 'package:thinkcreative_technologies/Screens/activity/filtered_activity_history.dart';
import 'package:thinkcreative_technologies/Screens/agents/agent_profile_details.dart';
import 'package:thinkcreative_technologies/Screens/customers/customer_profile_details.dart';
import 'package:thinkcreative_technologies/Screens/settings/department/all_departments_list.dart';
import 'package:thinkcreative_technologies/Screens/tickets/chatroom/widgets/ticketStatus.dart';
import 'package:thinkcreative_technologies/Services/firebase_services/FirebaseApi.dart';
import 'package:thinkcreative_technologies/Services/my_providers/liveListener.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Utils/color_light_dark.dart';
import 'package:thinkcreative_technologies/Utils/custom_time_formatter.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/Avatar.dart';
import 'package:thinkcreative_technologies/Widgets/custom_dividers.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/CustomDialog.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_inkwell.dart';
import 'package:thinkcreative_technologies/Widgets/others/userrole_based_sticker.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';

class TicketDetails extends StatefulWidget {
  final String ticketID;

  final Function onrefreshPreviousPage;
  final String ticketCosmeticID;
  const TicketDetails(
      {Key? key,
      required this.ticketID,
      required this.ticketCosmeticID,
      required this.onrefreshPreviousPage})
      : super(key: key);

  @override
  _TicketDetailsState createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  File? imageFile;
  String error = "";
  bool isloading = true;
  final GlobalKey<State> _keyLoader224 =
      new GlobalKey<State>(debugLabel: '272husdfdsf1');
  TicketModel? ticket;

  // final TextEditingController _textEditingController =
  //     new TextEditingController();
  late DocumentReference docRef;
  bool issecondaryloaderon = false;
  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  fetchdata() async {
    docRef = FirebaseFirestore.instance
        .collection(DbPaths.collectiontickets)
        .doc(widget.ticketID);
    await docRef.get().then((dc) async {
      if (dc.exists) {
        ticket = TicketModel.fromSnapshot(dc);

        setState(() {
          isloading = false;
          issecondaryloaderon = false;
        });
      } else {
        setState(() {
          error = "This ticket does not exists.";
        });
      }
    }).catchError((onError) {
      setState(() {
        error = "Error loading ticket. ERROR: $onError";

        isloading = false;
      });
    });
  }

  selectADepartment({
    required BuildContext context,
    required String title,
    required List<DepartmentModel> datalist,
    DepartmentModel? alreadyselected,
    required Function(DepartmentModel cat) onselected,
  }) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Wrap(children: <Widget>[
            Container(
              padding: EdgeInsets.all(7),
              child: Container(
                decoration: new BoxDecoration(
                    color: Mycolors.scaffoldbcg,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 19,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MtCustomfontBoldSemi(
                          text: "   $title",
                          fontsize: 16,
                          color: Mycolors.grey,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                              color: Mycolors.grey,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                        padding: EdgeInsets.only(bottom: 10),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: datalist.length,
                        itemBuilder: (BuildContext context, int i) {
                          var dc = datalist[i];

                          return categoryCard(context, dc, (selectedCat) {
                            Navigator.of(context).pop();
                            onselected(selectedCat);
                          });
                        }),
                  ],
                ),
              ),
            )
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    // var w = MediaQuery.of(context).size.width;
    var observer = Provider.of<Observer>(context, listen: true);

    var registry = Provider.of<UserRegistry>(context, listen: true);
    SpecialLiveConfigData? livedata =
        Provider.of<SpecialLiveConfigData?>(context, listen: true);
    bool isready = livedata == null
        ? false
        : !livedata.docmap.containsKey(Dbkeys.secondadminID) ||
                livedata.docmap[Dbkeys.secondadminID] == '' ||
                livedata.docmap[Dbkeys.secondadminID] == null
            ? false
            : true;
    String secondadminID =
        isready == true ? livedata!.docmap[Dbkeys.secondadminID] : "";

    return Utils.getNTPWrappedWidget(Scaffold(
      backgroundColor: Mycolors.backgroundcolor,
      appBar: AppBar(
        elevation: 0.4,
        titleSpacing: -5,
        leading: Container(
          margin: EdgeInsets.only(right: 0),
          width: 10,
          child: IconButton(
            icon: Icon(LineAwesomeIcons.arrow_left,
                size: 24, color: Mycolors.grey),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: <Widget>[
          isloading == true
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    width: 70,
                    child: Center(
                      child: Text(
                        ticketStatusTextShortForAgents(
                            context, ticket!.ticketStatus),
                        style: TextStyle(
                            color: ticketStatusColorForAgents(
                                ticket!.ticketStatus),
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ticketStatusColorForAgents(ticket!.ticketStatus)
                          .withOpacity(0.2),
                    ),
                    height: 20,
                  ),
                ),
        ],
        backgroundColor: Mycolors.white,
        title: InkWell(
          onTap: () {
            // Navigator.push(
            //     context,
            //     PageRouteBuilder(
            //         opaque: false,
            //         pageBuilder: (context, a1, a2) => ProfileView(peer)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MtCustomfontBoldSemi(
                text: getTranslatedForCurrentUser(context, 'xxsupporttktxx'),
                fontsize: 17,
                color: Mycolors.black,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "${getTranslatedForCurrentUser(context, 'xxidxx')} ${widget.ticketCosmeticID}",
                style: TextStyle(
                    color: Mycolors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
      body: error != ""
          ? Center(
              child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Mycolors.red),
                  )),
            )
          : isloading == true
              ? circularProgress()
              : Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: Stack(
                    children: [
                      ListView(
                        children: [
                          ticket!.ticketStatus == TicketStatus.active.index
                              ? SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Container(
                                    padding: EdgeInsets.all(7),
                                    child: Center(
                                      child: Text(
                                        ticketStatusTextLongForAgent(
                                            context, ticket!.ticketStatus),
                                        style: TextStyle(
                                            color: ticketStatusColorForAgents(
                                                ticket!.ticketStatus),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white),
                                  ),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          myinkwell(
                            onTap: () {
                              pageNavigator(
                                  context,
                                  FilteredActivityHistory(
                                    subtitle:
                                        "${getTranslatedForCurrentUser(context, 'xxticketidxx')} " +
                                            widget.ticketID,
                                    isShowDesc: true,
                                    extrafieldid: "TICKET--" + widget.ticketID,
                                  ));
                            },
                            child: Chip(
                                backgroundColor: Mycolors.cyan,
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      EvaIcons.activity,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    MtCustomfontBoldSemi(
                                      fontsize: 13,
                                      text: getTranslatedForCurrentUser(
                                              context, 'xxtrackxxactivityxx')
                                          .replaceAll('(####)',
                                              '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                                      color: Colors.white,
                                    )
                                  ],
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${getTranslatedForCurrentUser(context, 'xxtitlexx')}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Mycolors.secondary,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Divider(),
                                SizedBox(
                                  height: 7,
                                ),
                                MtCustomfontBold(
                                  text: ticket!.ticketTitle == ""
                                      ? getTranslatedForCurrentUser(
                                              context, 'xxnoxxavailabletoaddxx')
                                          .replaceAll('(####)',
                                              '${getTranslatedForCurrentUser(context, 'xxtitlexx')}')
                                      : ticket!.ticketTitle,
                                  fontsize: 16,
                                  isitalic: ticket!.ticketTitle == "",
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   height: 8,
                          // ),
                          // Container(
                          //   color: Colors.white,
                          //   padding: EdgeInsets.all(16),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.stretch,
                          //     children: [
                          //       Row(
                          //         mainAxisSize: MainAxisSize.max,
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Text(
                          //             "Ticket Description",
                          //             textAlign: TextAlign.left,
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.bold,
                          //                 color: Mycolors.secondary,
                          //                 fontSize: 15),
                          //           ),
                          //           IconButton(
                          //               onPressed: () {
                          //                 editDescription(context,
                          //                     ticket!.ticketDescription);
                          //               },
                          //               icon: Icon(
                          //                 Icons.edit,
                          //                 size: 21,
                          //                 color: Mycolors.primary,
                          //               ))
                          //         ],
                          //       ),
                          //       Divider(),
                          //       SizedBox(
                          //         height: 7,
                          //       ),
                          //       MtCustomfontBoldSemi(
                          //         text: ticket!.ticketDescription == ""
                          //             ? "No Description"
                          //             : ticket!.ticketDescription,
                          //         fontsize: 14,
                          //         color: Mycolors.grey,
                          //         lineheight: 1.3,
                          //         isitalic: ticket!.ticketDescription == "",
                          //       ),
                          //       SizedBox(
                          //         height: 7,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            color: lighten(Colors.yellow, 0.3),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslatedForCurrentUser(
                                          context, 'xxcustomerxx'),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Mycolors.secondary,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Divider(),
                                ListTile(
                                  onTap: () {
                                    pageNavigator(
                                        context,
                                        CustomerProfileDetails(
                                          currentuserid:
                                              Optionalconstants.currentAdminID,
                                          customerID: ticket!.ticketcustomerID,
                                        ));
                                  },
                                  contentPadding:
                                      EdgeInsets.fromLTRB(6, 6, 6, 0),
                                  leading: avatar(
                                      imageUrl: registry
                                          .getUserData(
                                              context, ticket!.ticketcustomerID)
                                          .photourl),
                                  title: MtCustomfontBoldSemi(
                                    color: Mycolors.black,
                                    text: registry
                                        .getUserData(
                                            context, ticket!.ticketcustomerID)
                                        .fullname,
                                    fontsize: 15,
                                  ),
                                  subtitle: Row(
                                    children: [
                                      MtCustomfontRegular(
                                        fontsize: 13,
                                        text:
                                            "${getTranslatedForCurrentUser(context, 'xxidxx')} " +
                                                registry
                                                    .getUserData(
                                                        context,
                                                        ticket!
                                                            .ticketcustomerID)
                                                    .id,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      // isready == true
                                      //     ? roleBasedSticker(
                                      //         Usertype.manager.index)
                                      //     : SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ticket!.ticketStatusShort ==
                                      TicketStatusShort.close.index &&
                                  ticket!.rating != 0
                              ? Container(
                                  padding: EdgeInsets.all(15),
                                  margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MtCustomfontBoldSemi(
                                        text:
                                            "${getTranslatedForCurrentUser(context, 'xxcustomerxx')} ${getTranslatedForCurrentUser(context, 'xxfeedbackxx')}",
                                        fontsize: 15,
                                        color: Mycolors.secondary,
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          MtCustomfontBoldSemi(
                                              fontsize: 14,
                                              text: ticket!.rating.toString()),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Mycolors.yellow,
                                            size: 15,
                                          ),
                                          ticket!.feedback == null ||
                                                  ticket!.feedback == ""
                                              ? SizedBox()
                                              : myverticaldivider(
                                                  marginwidth: 20),
                                          MtCustomfontRegular(
                                              isitalic: true,
                                              fontsize: 16,
                                              text:
                                                  ticket!.feedback.toString()),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 38,
                          ),

                          observer.userAppSettingsDoc!.departmentBasedContent ==
                                  true
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 3, 10, 3),
                                      child: Text(
                                        observer.userAppSettingsDoc!
                                                    .departmentList!
                                                    .firstWhere(
                                                      (department) =>
                                                          department[Dbkeys
                                                                  .departmentTitle]
                                                              .toString()
                                                              .trim() ==
                                                          ticket!
                                                              .ticketDepartmentID
                                                              .trim(),
                                                    )[Dbkeys
                                                        .departmentAgentsUIDList]
                                                    .length <
                                                1
                                            ? "${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${getTranslatedForCurrentUser(context, 'xxagentsxx')} "
                                            : observer.userAppSettingsDoc!
                                                    .departmentList!
                                                    .firstWhere(
                                                      (department) =>
                                                          department[Dbkeys
                                                                  .departmentTitle]
                                                              .toString()
                                                              .trim() ==
                                                          ticket!
                                                              .ticketDepartmentID
                                                              .trim(),
                                                    )[Dbkeys
                                                        .departmentAgentsUIDList]
                                                    .length
                                                    .toString() +
                                                " ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${getTranslatedForCurrentUser(context, 'xxagentsxx')} ",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Mycolors.secondary,
                                            fontSize: 15),
                                      ),
                                    ),
                                    ListView.builder(
                                        padding: EdgeInsets.all(26),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: observer
                                            .userAppSettingsDoc!.departmentList!
                                            .firstWhere(
                                              (department) =>
                                                  department[Dbkeys
                                                          .departmentTitle]
                                                      .toString()
                                                      .trim() ==
                                                  ticket!.ticketDepartmentID
                                                      .trim(),
                                            )[Dbkeys.departmentAgentsUIDList]
                                            .length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          var agentid = observer
                                              .userAppSettingsDoc!
                                              .departmentList!
                                              .firstWhere(
                                            (department) =>
                                                department[
                                                        Dbkeys.departmentTitle]
                                                    .toString()
                                                    .trim() ==
                                                ticket!.ticketDepartmentID
                                                    .trim(),
                                          )[Dbkeys.departmentAgentsUIDList][i];
                                          return agentid ==
                                                  ticket!.ticketcustomerID
                                              ? SizedBox()
                                              : Column(
                                                  children: [
                                                    ListTile(
                                                      onTap: () {
                                                        pageNavigator(
                                                            context,
                                                            AgentProfileDetails(
                                                              currentuserid:
                                                                  Optionalconstants
                                                                      .currentAdminID,
                                                              agentID: agentid,
                                                            ));
                                                      },
                                                      contentPadding:
                                                          EdgeInsets.all(0),
                                                      leading: avatar(
                                                          imageUrl: registry
                                                              .getUserData(
                                                                  context,
                                                                  agentid)
                                                              .photourl),
                                                      title:
                                                          MtCustomfontRegular(
                                                              fontsize: 16,
                                                              color: Mycolors
                                                                  .black,
                                                              text: registry
                                                                  .getUserData(
                                                                      context,
                                                                      agentid)
                                                                  .fullname),
                                                      subtitle: Row(children: [
                                                        MtCustomfontRegular(
                                                          fontsize: 13,
                                                          text: "${getTranslatedForCurrentUser(context, 'xxidxx')} " +
                                                              registry
                                                                  .getUserData(
                                                                      context,
                                                                      agentid)
                                                                  .id,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        secondadminID == agentid
                                                            ? roleBasedSticker(
                                                                context,
                                                                Usertype
                                                                    .secondadmin
                                                                    .index)
                                                            : SizedBox(),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        observer.userAppSettingsDoc!
                                                                    .departmentList!
                                                                    .firstWhere(
                                                                  (department) =>
                                                                      department[Dbkeys
                                                                              .departmentTitle]
                                                                          .toString()
                                                                          .trim() ==
                                                                      ticket!
                                                                          .ticketDepartmentID
                                                                          .trim(),
                                                                )[Dbkeys
                                                                    .departmentManagerID] ==
                                                                agentid
                                                            ? roleBasedSticker(
                                                                context,
                                                                Usertype
                                                                    .departmentmanager
                                                                    .index)
                                                            : SizedBox(),
                                                      ]),
                                                    ),
                                                    i ==
                                                            observer.userAppSettingsDoc!
                                                                    .departmentList!
                                                                    .firstWhere(
                                                                      (department) =>
                                                                          department[Dbkeys.departmentTitle]
                                                                              .toString()
                                                                              .trim() ==
                                                                          ticket!
                                                                              .ticketDepartmentID
                                                                              .trim(),
                                                                    )[Dbkeys
                                                                        .departmentAgentsUIDList]
                                                                    .length -
                                                                1
                                                        ? SizedBox()
                                                        : Divider(
                                                            height: 1,
                                                          ),
                                                  ],
                                                );
                                        }),
                                  ],
                                )
                              : Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ticket!.tktMEMBERSactiveList
                                                        .length <
                                                    1
                                                ? "${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${getTranslatedForCurrentUser(context, 'xxagentsxx')}"
                                                : ticket!.tktMEMBERSactiveList
                                                        .length
                                                        .toString() +
                                                    " ${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${getTranslatedForCurrentUser(context, 'xxagentsxx')} ",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Mycolors.secondary,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      ticket!.tktMEMBERSactiveList.length == 0
                                          ? MtCustomfontRegular(
                                              fontsize: 14,
                                              isitalic: true,
                                              text: getTranslatedForCurrentUser(
                                                      context,
                                                      'xxnoaggentsassignedxx')
                                                  .replaceAll('(####)',
                                                      '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                                  .replaceAll('(###)',
                                                      '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'),
                                            )
                                          : ListView.builder(
                                              padding: EdgeInsets.all(6),
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: ticket!
                                                  .tktMEMBERSactiveList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                var agentid = ticket!
                                                    .tktMEMBERSactiveList[i];
                                                return agentid ==
                                                        ticket!.ticketcustomerID
                                                    ? SizedBox()
                                                    : Column(
                                                        children: [
                                                          ListTile(
                                                            onTap: () {
                                                              pageNavigator(
                                                                  context,
                                                                  AgentProfileDetails(
                                                                    currentuserid:
                                                                        Optionalconstants
                                                                            .currentAdminID,
                                                                    agentID:
                                                                        agentid,
                                                                  ));
                                                            },
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            leading: avatar(
                                                                imageUrl: registry
                                                                    .getUserData(
                                                                        context,
                                                                        agentid)
                                                                    .photourl),
                                                            title: MtCustomfontRegular(
                                                                fontsize: 16,
                                                                color: Mycolors
                                                                    .black,
                                                                text: registry
                                                                    .getUserData(
                                                                        context,
                                                                        agentid)
                                                                    .fullname),
                                                            subtitle:
                                                                Row(children: [
                                                              MtCustomfontRegular(
                                                                fontsize: 13,
                                                                text: "${getTranslatedForCurrentUser(context, 'xxidxx')} " +
                                                                    registry
                                                                        .getUserData(
                                                                            context,
                                                                            agentid)
                                                                        .id,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              secondadminID ==
                                                                      agentid
                                                                  ? roleBasedSticker(
                                                                      context,
                                                                      Usertype
                                                                          .secondadmin
                                                                          .index)
                                                                  : SizedBox()
                                                            ]),
                                                          ),
                                                          i ==
                                                                  observer.userAppSettingsDoc!
                                                                          .departmentList!
                                                                          .firstWhere(
                                                                            (department) =>
                                                                                department[Dbkeys.departmentTitle].toString().trim() ==
                                                                                ticket!.ticketDepartmentID.trim(),
                                                                          )[Dbkeys
                                                                              .departmentAgentsUIDList]
                                                                          .length -
                                                                      1
                                                              ? SizedBox()
                                                              : Divider(
                                                                  height: 1,
                                                                ),
                                                        ],
                                                      );
                                              }),
                                      SizedBox(
                                        height: 7,
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ticket!.ticketStatus == TicketStatus.active.index ||
                                  ticket!.ticketStatus ==
                                      TicketStatus.needsAttention.index ||
                                  ticket!.ticketStatus ==
                                      TicketStatus.reOpenedByAgent.index ||
                                  ticket!.ticketStatus ==
                                      TicketStatus.reOpenedByCustomer.index
                              ? Container(
                                  margin: EdgeInsets.all(9),
                                  // height: 100,
                                  // width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    border: Border.all(
                                      color: Colors.green,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ListTile(
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: MtCustomfontBoldSemi(
                                            color: Colors.green,
                                            text: getTranslatedForCurrentUser(
                                                    context, 'xxcallxxxx')
                                                .replaceAll(
                                                    '(####)',
                                                    getTranslatedForCurrentUser(
                                                        context, 'xxagentxx')),
                                            fontsize: 16.6,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: MtCustomfontRegular(
                                            lineheight: 1.3,
                                            text: getTranslatedForCurrentUser(
                                                    context,
                                                    'xxwhowillrecievecallsxx')
                                                .replaceAll(
                                                    '(####)',
                                                    getTranslatedForCurrentUser(
                                                        context, 'xxagentxx'))
                                                .replaceAll(
                                                    '(###)',
                                                    getTranslatedForCurrentUser(
                                                        context,
                                                        'xxcustomerxx'))
                                                .replaceAll(
                                                    '(##)',
                                                    getTranslatedForCurrentUser(
                                                        context, 'xxtktsxx')),
                                            color: Colors.green[700],
                                            fontsize: 11,
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons.phone,
                                          color: Colors.green,
                                        ),
                                        isThreeLine: false,
                                        onTap: () {},
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      ticket!.ticketCallInfoMap!.isEmpty == true
                                          ? MtCustomfontBoldSemi(
                                              text: getTranslatedForCurrentUser(
                                                      context,
                                                      'xxnoxxisassignedinxx')
                                                  .replaceAll(
                                                      '(####)',
                                                      getTranslatedForCurrentUser(
                                                          context, 'xxagentxx'))
                                                  .replaceAll(
                                                    '(###)',
                                                    getTranslatedForCurrentUser(
                                                            context,
                                                            'xxcallxxxx')
                                                        .replaceAll(
                                                            '(####)', ''),
                                                  ),
                                              fontsize: 13,
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      18, 3, 18, 3),
                                              child: ListTile(
                                                onTap: () {
                                                  pageNavigator(
                                                      context,
                                                      AgentProfileDetails(
                                                        currentuserid:
                                                            Optionalconstants
                                                                .currentAdminID,
                                                        agentID: ticket!
                                                                .ticketCallInfoMap![
                                                            Dbkeys
                                                                .ticketCallId],
                                                      ));
                                                },
                                                trailing: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [],
                                                ),
                                                contentPadding:
                                                    EdgeInsets.all(0),
                                                leading: avatar(
                                                    imageUrl: registry
                                                        .getUserData(
                                                            context,
                                                            ticket!.ticketCallInfoMap![
                                                                Dbkeys
                                                                    .ticketCallId])
                                                        .photourl),
                                                title: MtCustomfontRegular(
                                                    fontsize: 16,
                                                    color: Mycolors.black,
                                                    text: registry
                                                        .getUserData(
                                                            context,
                                                            ticket!.ticketCallInfoMap![
                                                                Dbkeys
                                                                    .ticketCallId])
                                                        .fullname),
                                                subtitle: MtCustomfontRegular(
                                                  fontsize: 13,
                                                  text: "${getTranslatedForCurrentUser(context, 'xxagentidxx')} " +
                                                      registry
                                                          .getUserData(
                                                              context,
                                                              ticket!.ticketCallInfoMap![
                                                                  Dbkeys
                                                                      .ticketCallId])
                                                          .id,
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                        height: 17,
                                      )
                                    ],
                                  ))
                              : SizedBox(
                                  height: 8,
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          observer.userAppSettingsDoc!.departmentBasedContent ==
                                  true
                              ? Container(
                                  color: Colors.white,
                                  child: ListTile(
                                    trailing:
                                        ticket!.ticketStatusShort ==
                                                TicketStatusShort.active.index
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                  color: Mycolors.primary,
                                                ),
                                                onPressed: () {
                                                  List<DepartmentModel> deps =
                                                      observer
                                                          .userAppSettingsDoc!
                                                          .departmentList!
                                                          .map((e) =>
                                                              DepartmentModel
                                                                  .fromJson(e))
                                                          .toList();
                                                  deps.removeAt(0);
                                                  int i = deps.indexWhere(
                                                      (element) =>
                                                          element
                                                              .departmentTitle ==
                                                          ticket!
                                                              .ticketDepartmentID);

                                                  DepartmentModel?
                                                      currentDepartment =
                                                      i >= 0 ? deps[i] : null;

                                                  deps.retainWhere((element) =>
                                                      element
                                                          .departmentIsShow ==
                                                      true);
                                                  deps.retainWhere((element) =>
                                                      element.departmentTitle !=
                                                      ticket!
                                                          .ticketDepartmentID);
                                                  selectADepartment(
                                                      context: context,
                                                      title: getTranslatedForCurrentUser(
                                                              context,
                                                              'xxxgetTranslatedForCurrentUserxx')
                                                          .replaceAll('(####)',
                                                              '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                                      datalist: deps,
                                                      onselected: (department) {
                                                        ShowConfirmDialog()
                                                            .open(
                                                                rightbtntext:
                                                                    getTranslatedForCurrentUser(
                                                                        context, 'xxxchangeshortxx'),
                                                                rightbtnonpress:
                                                                    AppConstants.isdemomode ==
                                                                            true
                                                                        ? () {
                                                                            Utils.toast(getTranslatedForCurrentUser(context,
                                                                                'xxxnotalwddemoxxaccountxx'));
                                                                          }
                                                                        : () async {
                                                                            Navigator.of(context).pop();
                                                                            List<dynamic>
                                                                                tktMEMBERSactiveList =
                                                                                ticket!.tktMEMBERSactiveList;
                                                                            ShowLoading().open(
                                                                                context: context,
                                                                                key: _keyLoader224);
                                                                            await FirebaseFirestore.instance.collection(DbPaths.collectiontickets).doc(ticket!.ticketID).update({
                                                                              Dbkeys.ticketDepartmentID: department.departmentTitle,
                                                                              Dbkeys.tktdepartmentNameList: [
                                                                                department.departmentTitle
                                                                              ],
                                                                              Dbkeys.departmentNamestoredinList: department.departmentTitle,
                                                                              Dbkeys.tktMEMBERSactiveList: department.departmentAgentsUIDList
                                                                            }).then((value) async {
                                                                              tktMEMBERSactiveList.forEach((agent) async {
                                                                                await Utils.sendDirectNotification(title: getTranslatedForCurrentUser(context, 'xxchangedxxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'), parentID: "DEPT--${ticket!.ticketDepartmentID}", plaindesc: '${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}' + ". ${getTranslatedForCurrentUser(context, 'xxchangedfromxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxticketidxx')} ${ticket!.ticketID} - ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}').replaceAll('(###)', '${ticket!.ticketDepartmentID}').replaceAll('(##)', '${ticket!.ticketID}')}", docRef: FirebaseFirestore.instance.collection(DbPaths.collectionagents).doc(agent).collection(DbPaths.agentnotifications).doc(DbPaths.agentnotifications), postedbyID: 'Admin');
                                                                              });
                                                                              department.departmentAgentsUIDList.forEach((agent) async {
                                                                                await Utils.sendDirectNotification(title: department.departmentManagerID == agent ? "Ticket Assigned to your Department" : "Ticket Assigned to you", parentID: "DEPT--${department.departmentTitle}", plaindesc: "Ticket ID:  Assigned to ${department.departmentTitle} department by Admin. The department was changed from ${ticket!.ticketDepartmentID} to ${department.departmentTitle}", docRef: FirebaseFirestore.instance.collection(DbPaths.collectionagents).doc(agent).collection(DbPaths.agentnotifications).doc(DbPaths.agentnotifications), postedbyID: 'Admin');
                                                                              });
                                                                              await FirebaseFirestore.instance.collection(DbPaths.collectiontickets).doc(ticket!.ticketID).collection(DbPaths.collectionticketChats).doc(DateTime.now().millisecondsSinceEpoch.toString() + '--' + 'Admin').set(
                                                                                  TicketMessage(
                                                                                    tktMssgCONTENT: "${department.departmentTitle}-xx-${ticket!.ticketDepartmentID}",
                                                                                    tktMssgISDELETED: false,
                                                                                    tktMssgTIME: DateTime.now().millisecondsSinceEpoch,
                                                                                    tktMssgSENDBY: 'Admin',
                                                                                    tktMssgTYPE: MessageType.rROBOTdepartmentChanged.index,
                                                                                    tktMssgSENDERNAME: 'Admin',
                                                                                    tktMssgISREPLY: false,
                                                                                    tktMssgISFORWARD: false,
                                                                                    tktMssgREPLYTOMSSGDOC: {},
                                                                                    tktMssgTicketName: ticket!.ticketTitle,
                                                                                    tktMssgTicketIDflitered: ticket!.ticketidFiltered,
                                                                                    tktMssgSENDFOR: [
                                                                                      MssgSendFor.agent.index,
                                                                                      MssgSendFor.customer.index,
                                                                                    ],
                                                                                    tktMsgSenderIndex: Usertype.agent.index,
                                                                                    tktMsgInt2: 0,
                                                                                    isShowSenderNameInNotification: false,
                                                                                    tktMsgBool2: true,
                                                                                    notificationActiveList: department.departmentAgentsUIDList,
                                                                                    tktMssgLISToptional: [],
                                                                                    tktMsgList2: [],
                                                                                    tktMsgList3: [],
                                                                                    tktMsgMap1: {},
                                                                                    tktMsgMap2: {},
                                                                                    tktMsgDELETEDby: '',
                                                                                    tktMsgDELETEREASON: '',
                                                                                    tktMsgString4: '',
                                                                                    tktMsgString5: '',
                                                                                    ttktMsgString3: '',
                                                                                    tktMsgCUSTOMERID: ticket!.ticketcustomerID,
                                                                                  ).toMap(),
                                                                                  SetOptions(merge: true));

                                                                              await FirebaseApi.runTransactionRecordActivity(
                                                                                parentid: "DEPT--${department.departmentTitle}",
                                                                                title: getTranslatedForCurrentUser(context, 'xxxassignedtothexxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxtktsxx')}').replaceAll('(###)', '${department.departmentTitle} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                                                                postedbyID: "sys",
                                                                                onErrorFn: (e) {},
                                                                                onSuccessFn: () async {
                                                                                  await FirebaseFirestore.instance.collection(DbPaths.collectiontickets).doc(ticket!.ticketID).get().then((v) {
                                                                                    if (v.exists) {
                                                                                      ticket = TicketModel.fromSnapshot(v);
                                                                                      setState(() {});
                                                                                      ShowLoading().close(context: context, key: _keyLoader224);
                                                                                      Utils.toast("Ticket Department Changed successfully !");
                                                                                    } else {
                                                                                      ShowLoading().close(context: context, key: _keyLoader224);
                                                                                      Utils.toast("Failed to change department ! ${getTranslatedForCurrentUser(context, 'xxxfailedntryagainxxx')}\n $error");
                                                                                    }
                                                                                  });
                                                                                },
                                                                                plainDesc: '${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}' + ". ${getTranslatedForCurrentUser(context, 'xxchangedfromxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, 'xxticketidxx')} ${ticket!.ticketID} - ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}').replaceAll('(###)', '${ticket!.ticketDepartmentID}').replaceAll('(##)', '${ticket!.ticketID}')}",
                                                                              );
                                                                            });
                                                                          },
                                                                context:
                                                                    context,
                                                                title: getTranslatedForCurrentUser(context, 'xxxchangexxx').replaceAll(
                                                                    '(####)',
                                                                    '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}'),
                                                                subtitle: getTranslatedForCurrentUser(
                                                                        context,
                                                                        'xxxxchangedepttoxxx')
                                                                    .replaceAll(
                                                                        '(######)',
                                                                        '${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                                                                    .replaceAll(
                                                                        '(####)',
                                                                        '${department.departmentTitle.toUpperCase()}  ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
                                                                    .replaceAll(
                                                                        '(#####)',
                                                                        '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                                                                    .replaceAll(
                                                                        '(###)',
                                                                        '${department.departmentTitle.toUpperCase()}')
                                                                    .replaceAll(
                                                                        '(##)',
                                                                        '${getTranslatedForCurrentUser(context, 'xxtktsxx')}'));
                                                      },
                                                      alreadyselected:
                                                          currentDepartment);
                                                },
                                              )
                                            : SizedBox(),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: MtCustomfontBoldSemi(
                                        color: Mycolors.black,
                                        text:
                                            '${getTranslatedForCurrentUser(context, 'xxtktsxx')} ${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}',
                                        fontsize: 15.6,
                                      ),
                                    ),
                                    subtitle: InkWell(
                                      onTap: () {
                                        pageNavigator(
                                            context,
                                            AllDepartmentList(
                                                currentuserid: 'Admin',
                                                filteragentid: "",
                                                onbackpressed: () {},
                                                isShowForSignleAgent: false));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: MtCustomfontRegular(
                                          color: Mycolors.grey,
                                          text: ticket!.ticketDepartmentID,
                                          fontsize: 12.8,
                                        ),
                                      ),
                                    ),
                                    leading: Icon(
                                      Icons.location_city,
                                      color: Mycolors.secondary,
                                    ),
                                    isThreeLine: false,
                                    onTap: () {},
                                  ))
                              : SizedBox(),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                              color: Colors.white,
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: MtCustomfontBoldSemi(
                                    color: Mycolors.black,
                                    text: getTranslatedForCurrentUser(
                                            context, 'xxcreatedbyxx')
                                        .replaceAll(
                                            '(####)',
                                            getTranslatedForCurrentUser(
                                                context, 'xxtktsxx'))
                                        .replaceAll('(###)', ""),
                                    fontsize: 15.6,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: ticket!.ticketcreatedBy == "sys"
                                      ? MtCustomfontRegular(
                                          text: getTranslatedForCurrentUser(
                                              context, 'xxsystemxx'),
                                          fontsize: 12.8,
                                        )
                                      : ticket!.ticketcreatedBy == "Admin"
                                          ? MtCustomfontRegular(
                                              text: getTranslatedForCurrentUser(
                                                  context, 'xxadminxx'),
                                              fontsize: 12.8,
                                            )
                                          : MtCustomfontRegular(
                                              lineheight: 1.4,
                                              color: Mycolors.grey,
                                              text: "${registry.getUserData(context, ticket!.ticketcreatedBy).fullname} (${getTranslatedForCurrentUser(context, 'xxidxx')} ${registry.getUserData(context, ticket!.ticketcreatedBy).id})" +
                                                  "\n${registry.getUserData(context, ticket!.ticketcreatedBy).usertype == Usertype.agent.index ? "Agent" : "Customer"}",
                                              fontsize: 12.8,
                                            ),
                                ),
                                leading: Icon(
                                  Icons.person,
                                  color: Mycolors.secondary,
                                ),
                                isThreeLine: false,
                                onTap: () {},
                              )),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                              color: Colors.white,
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: MtCustomfontBoldSemi(
                                    color: Mycolors.black,
                                    text: getTranslatedForCurrentUser(
                                            context, 'xxcreatedonxx')
                                        .replaceAll(
                                            '(####)',
                                            getTranslatedForCurrentUser(
                                                context, 'xxtktsxx')),
                                    fontsize: 15.6,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: MtCustomfontRegular(
                                    color: Mycolors.grey,
                                    text: formatTimeDateCOMLPETEString(
                                        isdateTime: true,
                                        isshowutc: false,
                                        context: context,
                                        datetimetargetTime:
                                            DateTime.fromMillisecondsSinceEpoch(
                                          ticket!.ticketcreatedOn,
                                        )),
                                    fontsize: 12.8,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.access_time_rounded,
                                  color: Mycolors.secondary,
                                ),
                                isThreeLine: false,
                                onTap: () {},
                              )),
                          SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                      // Positioned(
                      //   child: isloading
                      //       ? Container(
                      //           child: Center(
                      //             child: CircularProgressIndicator(
                      //                 valueColor:
                      //                     AlwaysStoppedAnimation<Color>(Mycolors.secondary)),
                      //           ),
                      //           color: DESIGN_TYPE == Themetype.whatsapp
                      //               ? Mycolors.black.withOpacity(0.6)
                      //               : Colors.white.withOpacity(0.6))
                      //       : Container(),
                      // )
                    ],
                  ),
                ),
    ));
  }
}

formatDate(DateTime timeToFormat) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final String formatted = formatter.format(timeToFormat);
  return formatted;
}

categoryCard(BuildContext context, DepartmentModel cat,
    Function(DepartmentModel c) onSelect) {
  return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 2),
          onTap: AppConstants.isdemomode == true
              ? () {
                  Utils.toast(getTranslatedForCurrentUser(
                      context, 'xxxnotalwddemoxxaccountxx'));
                }
              : () {
                  onSelect(cat);
                },
          title: MtCustomfontBoldSemi(
            text: cat.departmentTitle,
          ),
          tileColor: Colors.white,
          subtitle: cat.departmentDesc == ''
              ? null
              : MtCustomfontRegular(
                  text: cat.departmentDesc,
                  maxlines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontsize: 14,
                ),
          leading: cat.departmentLogoURL == ""
              ? Utils.squareAvatarIcon(
                  backgroundColor: Utils.randomColorgenratorBasedOnFirstLetter(
                      cat.departmentTitle),
                  iconData: Icons.location_city,
                  size: 45)
              : Utils.squareAvatarImage(url: cat.departmentLogoURL, size: 45)));
}
