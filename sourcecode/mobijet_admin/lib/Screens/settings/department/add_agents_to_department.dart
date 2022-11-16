import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/user_registry_model.dart';
import 'package:thinkcreative_technologies/Services/my_providers/liveListener.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/Avatar.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';
import 'package:thinkcreative_technologies/Widgets/nodata_widget.dart';
import 'package:thinkcreative_technologies/Widgets/others/userrole_based_sticker.dart';

class AddAgentsToDepartment extends StatefulWidget {
  final List<UserRegistryModel> agents;
  final String? title;
  final bool isdepartmentalreadycreated;
  final Function(
    List<String> agentids,
    List<UserRegistryModel> agents,
  ) onselectagents;
  const AddAgentsToDepartment({
    Key? key,
    required this.agents,
    this.title,
    required this.isdepartmentalreadycreated,
    required this.onselectagents,
  }) : super(key: key);

  @override
  _AddAgentsToDepartmentState createState() => _AddAgentsToDepartmentState();
}

class _AddAgentsToDepartmentState extends State<AddAgentsToDepartment> {
  List<UserRegistryModel> selectedlist = [];
  List<UserRegistryModel> availablelist = [];
  @override
  void initState() {
    super.initState();
    setdata();
  }

  setdata() {
    availablelist = widget.agents;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SpecialLiveConfigData? livedata =
        Provider.of<SpecialLiveConfigData?>(context, listen: true);

    bool isready = livedata == null
        ? false
        : !livedata.docmap.containsKey(Dbkeys.secondadminID) ||
                livedata.docmap[Dbkeys.secondadminID] == '' ||
                livedata.docmap[Dbkeys.secondadminID] == null
            ? false
            : true;
    return MyScaffold(
      isforcehideback: true,
      icon1press: () {
        Navigator.of(context).pop();
      },
      icon2press: () {
        Navigator.of(context).pop();
        List<String> selectedids = [];
        selectedlist.forEach((agent) {
          selectedids.add(agent.id);
        });
        widget.onselectagents(selectedids, selectedlist);
      },
      icondata1: Icons.close,
      icondata2: selectedlist.length > 0 ? Icons.check : null,
      title: widget.title != null
          ? widget.title
          : widget.isdepartmentalreadycreated == true
              ? getTranslatedForCurrentUser(context, 'xxaddxxtoxxx')
                  .replaceAll('(####)',
                      '${getTranslatedForCurrentUser(context, 'xxagentsxx')}')
                  .replaceAll('(###)',
                      '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')}')
              : getTranslatedForCurrentUser(context, 'xxxxnewxx').replaceAll(
                  '(####)',
                  '${getTranslatedForCurrentUser(context, 'xxdepartmentxx')} ${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
      body: availablelist.length == 0
          ? noDataWidget(
              context: context,
              title: getTranslatedForCurrentUser(
                      context, 'xxnoxxavailabletoaddxx')
                  .replaceAll('(####)',
                      '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
              iconData: Icons.people)
          : ListView.builder(
              itemCount: availablelist.length,
              itemBuilder: (BuildContext context, int i) {
                var currentselection = availablelist[i];
                return Card(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  margin: EdgeInsets.fromLTRB(6, 8, 6, 2),
                  elevation: 0.4,
                  child: ListTile(
                    trailing: IconButton(
                        onPressed: () {
                          if (selectedlist.contains(currentselection)) {
                            selectedlist.remove(currentselection);
                            setState(() {});
                          } else {
                            selectedlist.add(currentselection);
                            setState(() {});
                          }
                        },
                        icon: Icon(
                          selectedlist.contains(currentselection)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank_outlined,
                          color: !selectedlist.contains(currentselection)
                              ? Mycolors.grey
                              : Mycolors.primary,
                        )),
                    leading: avatar(
                      imageUrl: currentselection.photourl == ""
                          ? null
                          : currentselection.photourl,
                    ),
                    title: Text(
                      currentselection.fullname,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Row(
                      children: [
                        MtCustomfontRegular(
                          fontsize: 13,
                          text:
                              "${getTranslatedForCurrentUser(context, 'xxidxx')} " +
                                  currentselection.id,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        isready == true
                            ? livedata!.docmap[Dbkeys.secondadminID] ==
                                    currentselection.id
                                ? roleBasedSticker(
                                    context, Usertype.secondadmin.index)
                                : SizedBox()
                            : SizedBox(),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
