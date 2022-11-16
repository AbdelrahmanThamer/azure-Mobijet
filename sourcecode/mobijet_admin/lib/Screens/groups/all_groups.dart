import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Screens/groups/groupchat/GroupChatPage.dart';
import 'package:thinkcreative_technologies/Utils/page_navigator.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/customCircleAvatars.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Widgets/nodata_widget.dart';

class AllGroups extends StatefulWidget {
  final Query? query;
  final String? subtitle;
  const AllGroups({Key? key, this.query, this.subtitle}) : super(key: key);

  @override
  _AllGroupsState createState() => _AllGroupsState();
}

class _AllGroupsState extends State<AllGroups> {
  List groups = [];
  String error = "";
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    fetchData(widget.query ??
        FirebaseFirestore.instance
            .collection(DbPaths.collectionAgentGroups)
            .orderBy(Dbkeys.groupLATESTMESSAGETIME, descending: true));
  }

  fetchData(Query query) async {
    await query.get().then((docs) {
      groups = docs.docs.toList();
      isloading = false;
      setState(() {});
    }).catchError((onError) {
      error = onError.toString();
      isloading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title:
          "${getTranslatedForCurrentUser(context, 'xxagentxx')} ${getTranslatedForCurrentUser(context, 'xxxgroupsxxx')}",
      subtitle: widget.subtitle,
      icondata1: Icons.refresh,
      icon1press: () async {
        setState(() {
          isloading = true;
        });
        await fetchData(widget.query ??
            FirebaseFirestore.instance
                .collection(DbPaths.collectionAgentGroups)
                .orderBy(Dbkeys.groupLATESTMESSAGETIME, descending: true));
      },
      body: error != ""
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : isloading
              ? circularProgress()
              : groups.length == 0
                  ? noDataWidget(
                      context: context,
                      title: getTranslatedForCurrentUser(
                              context, 'xxnoxxavailabletoaddxx')
                          .replaceAll('(####)',
                              '${getTranslatedForCurrentUser(context, 'xxxgroupxxx')}'),
                      subtitle: "",
                      iconData: Icons.people)
                  : ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            tileColor: Colors.white,
                            onLongPress: () {},
                            contentPadding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                            leading: groups[i][Dbkeys.groupPHOTOURL] == ""
                                ? CircleAvatar(
                                    child: Icon(
                                      Icons.people,
                                      color: Colors.white,
                                    ),
                                    radius: 26,
                                    backgroundColor: Utils
                                        .randomColorgenratorBasedOnFirstLetter(
                                            groups[i][Dbkeys.groupNAME]),
                                  )
                                : customCircleAvatarGroup(
                                    url: groups[i][Dbkeys.groupPHOTOURL],
                                    radius: 26),
                            title: MtCustomfontBold(
                              overflow: TextOverflow.ellipsis,
                              text: groups[i][Dbkeys.groupNAME],
                              maxlines: 2,
                              color: Mycolors.black,
                              fontsize: 17,
                              lineheight: 1.0,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  MtCustomfontRegular(
                                    text:
                                        '${groups[i][Dbkeys.groupMEMBERSLIST].length} ${getTranslatedForCurrentUser(context, 'xxagentsxx')}',
                                    color: Mycolors.grey,
                                    fontsize: 14.5,
                                  ),
                                  MtCustomfontBoldSemi(
                                    text:
                                        "  ${getTranslatedForCurrentUser(context, 'xxxgroupidxxx')} ${groups[i][Dbkeys.groupID]}",
                                    color: Utils
                                        .randomColorgenratorBasedOnFirstLetter(
                                            groups[i][Dbkeys.groupNAME]),
                                    fontsize: 10.5,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              pageNavigator(
                                  context,
                                  GroupChatPage(
                                      onDelete: () {
                                        fetchData(widget.query ??
                                            FirebaseFirestore.instance
                                                .collection(DbPaths
                                                    .collectionAgentGroups)
                                                .orderBy(
                                                    Dbkeys
                                                        .groupLATESTMESSAGETIME,
                                                    descending: true));
                                      },
                                      groupMap: groups[i].data(),
                                      groupID: groups[i][Dbkeys.groupID],
                                      isCurrentUserMuted: false));
                            },
                          ),
                        );
                      }),
    );
  }
}
//