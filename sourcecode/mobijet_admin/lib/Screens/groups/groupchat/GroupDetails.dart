//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/optional_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Widgets/avatars/customCircleAvatars.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GroupDetails extends StatefulWidget {
  final String groupID;
  final Map<String, dynamic> groupMap;
  const GroupDetails({Key? key, required this.groupID, required this.groupMap})
      : super(key: key);

  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  File? imageFile;

  getImage(File image) {
    // ignore: unnecessary_null_comparison
    if (image != null) {
      setStateIfMounted(() {
        imageFile = image;
      });
    }
    return uploadFile(false);
  }

  bool isloading = false;
  String? videometadata;
  int? uploadTimestamp;
  int? thumnailtimestamp;
  final TextEditingController textEditingController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future uploadFile(bool isthumbnail) async {
    uploadTimestamp = DateTime.now().millisecondsSinceEpoch;
    String fileName = 'GROUP_ICON';
    Reference reference = FirebaseStorage.instance
        .ref("+00_AGENT_GROUP_MEDIA/${widget.groupID}/")
        .child(fileName);
    TaskSnapshot uploading = await reference.putFile(imageFile!);
    if (isthumbnail == false) {
      setStateIfMounted(() {
        thumnailtimestamp = uploadTimestamp;
      });
    }

    return uploading.ref.getDownloadURL();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    // final observer = Provider.of<Observer>(context, listen: false);
    return Scaffold(
        backgroundColor: Mycolors.backgroundcolor,
        appBar: AppBar(
          elevation: 0.4,
          titleSpacing: -5,
          leading: Container(
            margin: EdgeInsets.only(right: 0),
            width: 10,
            child: IconButton(
              icon: Icon(LineAwesomeIcons.arrow_left,
                  size: 24, color: Mycolors.primary),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: <Widget>[],
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
                  text: widget.groupMap[Dbkeys.groupNAME],
                  fontsize: 17,
                  color: Mycolors.black,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  getTranslatedForCurrentUser(
                          context, 'xxxcreatedthegrouponxxx')
                      .replaceAll('(####)',
                          '${getTranslatedForCurrentUser(context, 'xxagentidxx')} ${widget.groupMap[Dbkeys.groupCREATEDBY]}')
                      .replaceAll('(###)',
                          '${formatDate(widget.groupMap[Dbkeys.groupCREATEDON].toDate())}'),
                  style: TextStyle(
                      color: Mycolors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Stack(
            children: [
              ListView(
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.groupMap[Dbkeys.groupPHOTOURL] ?? '',
                        imageBuilder: (context, imageProvider) => Container(
                          width: w,
                          height: w / 1.2,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          width: w,
                          height: w / 1.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: Icon(Icons.people,
                              color: Mycolors.grey.withOpacity(0.5), size: 75),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: w,
                          height: w / 1.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: Icon(Icons.people,
                              color: Mycolors.grey.withOpacity(0.5), size: 75),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        width: w,
                        height: w / 1.2,
                        decoration: BoxDecoration(
                          color: widget.groupMap[Dbkeys.groupPHOTOURL] == null
                              ? Mycolors.black.withOpacity(0.2)
                              : Mycolors.black.withOpacity(0.3),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SizedBox()),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTranslatedForCurrentUser(
                                  context, 'xxgroupdescxx'),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Mycolors.primary,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          widget.groupMap[Dbkeys.groupDESCRIPTION] == ''
                              ? getTranslatedForCurrentUser(
                                  context, 'xxnodescxx')
                              : widget.groupMap[Dbkeys.groupDESCRIPTION],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color:
                                  widget.groupMap[Dbkeys.groupDESCRIPTION] == ''
                                      ? Mycolors.grey
                                      : Mycolors.black,
                              fontSize: 15.3),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTranslatedForCurrentUser(
                                  context, 'xxgrouptypexx'),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Mycolors.primary,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          widget.groupMap[Dbkeys.groupTYPE] ==
                                  Dbkeys.groupTYPEonlyadminmessageallowed
                              ? getTranslatedForCurrentUser(
                                  context, 'xxonlyadminsendxx')
                              : getTranslatedForCurrentUser(
                                      context, 'xxbothxxmssgalowedxx')
                                  .replaceAll('(####)',
                                      '${getTranslatedForCurrentUser(context, 'xxagentsxx')}'),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Mycolors.black,
                              fontSize: 15.3),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.groupMap[Dbkeys.groupMEMBERSLIST].length}' +
                                        ' ' +
                                        getTranslatedForCurrentUser(
                                            context, 'xxagentsxx'),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Mycolors.primary,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        getAdminList(),
                        getUsersList(),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                child: isloading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Mycolors.secondary)),
                        ),
                        color: Colors.white.withOpacity(0.6))
                    : Container(),
              )
            ],
          ),
        ));
  }

  getAdminList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: widget.groupMap[Dbkeys.groupADMINLIST].length,
        itemBuilder: (context, int i) {
          List adminlist = widget.groupMap[Dbkeys.groupADMINLIST].toList();
          return Consumer<UserRegistry>(builder: (context, registry, _child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  height: 3,
                ),
                Stack(
                  children: [
                    ListTile(
                      isThreeLine: false,
                      contentPadding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: registry
                                      .getUserData(context, adminlist[i])
                                      .photourl ==
                                  ""
                              ? Container(
                                  width: 50.0,
                                  height: 50.0,
                                  child: Icon(Icons.person),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: registry
                                      .getUserData(context, adminlist[i])
                                      .photourl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                  placeholder: (context, url) => Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: customCircleAvatar(radius: 50),
                                      )),
                        ),
                      ),
                      title: Text(
                        registry.getUserData(context, adminlist[i]).fullname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      enabled: true,
                      subtitle: Text(
                        //-- or about me
                        "${getTranslatedForCurrentUser(context, 'xxidxx')} " +
                            registry.getUserData(context, adminlist[i]).id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(height: 1.4),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     new MaterialPageRoute(
                        //         builder: (context) => new ProfileView(
                        //               snapshot.data.data(),
                        //               widget.currentUserID,
                        //               widget.model,
                        //               widget.prefs,
                        //               firestoreUserDoc: snapshot.data,
                        //             )));
                      },
                    ),
                    widget.groupMap[Dbkeys.groupADMINLIST]
                            .contains(adminlist[i])
                        ? Positioned(
                            right: 27,
                            top: 10,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                              // width: 50.0,
                              height: 18.0,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                border: new Border.all(
                                    color: adminlist[i] ==
                                            widget
                                                .groupMap[Dbkeys.groupCREATEDBY]
                                        ? Colors.purple[400]!
                                        : Colors.green[400]!,
                                    width: 1.0),
                                borderRadius: new BorderRadius.circular(5.0),
                              ),
                              child: new Center(
                                child: new Text(
                                  Optionalconstants.currentAdminID,
                                  style: new TextStyle(
                                    fontSize: 11.0,
                                    color: adminlist[i] ==
                                            widget
                                                .groupMap[Dbkeys.groupCREATEDBY]
                                        ? Colors.purple[400]
                                        : Colors.green[400],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            );
          });
        });
  }

  getUsersList() {
    List onlyuserslist = widget.groupMap[Dbkeys.groupMEMBERSLIST];
    widget.groupMap[Dbkeys.groupMEMBERSLIST].toList().forEach((member) {
      if (widget.groupMap[Dbkeys.groupADMINLIST].contains(member)) {
        onlyuserslist.remove(member);
      }
    });
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: onlyuserslist.length,
        itemBuilder: (context, int i) {
          List viewerslist = onlyuserslist;
          return Consumer<UserRegistry>(builder: (context, registry, _child) {
            // bool isListUserSuperAdmin =
            //     widget.groupMap[Dbkeys.groupCREATEDBY] == viewerslist[i];
            // //----
            // bool islisttUserAdmin =
            //     widget.groupMap[Dbkeys.groupADMINLIST].contains(viewerslist[i]);
            // bool isListUserOnlyUser = !widget.groupMap[Dbkeys.groupADMINLIST]
            //     .contains(viewerslist[i]);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  height: 3,
                ),
                Stack(
                  children: [
                    ListTile(
                      isThreeLine: false,
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: registry
                                      .getUserData(context, viewerslist[i])
                                      .photourl ==
                                  ""
                              ? Container(
                                  width: 50.0,
                                  height: 50.0,
                                  child: Icon(Icons.person),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: registry
                                      .getUserData(context, viewerslist[i])
                                      .photourl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                  placeholder: (context, url) => Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: customCircleAvatar(radius: 40),
                                      )),
                        ),
                      ),
                      title: MtCustomfontBoldSemi(
                        text: registry
                            .getUserData(context, viewerslist[i])
                            .fullname,
                        fontsize: 16,
                      ),
                      subtitle: Text(
                        //-- or about me
                        '${getTranslatedForCurrentUser(context, 'xxidxx')} ' +
                            registry
                                .getUserData(context, viewerslist[i])
                                .id
                                .toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14, height: 1.4, color: Mycolors.grey),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     new MaterialPageRoute(
                        //         builder: (context) => new ProfileView(
                        //             snapshot.data.data(),
                        //             widget.currentUserID,
                        //             widget.model,
                        //             widget.prefs,
                        //             firestoreUserDoc: snapshot.data)));
                      },
                      enabled: true,
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }
}

formatDate(DateTime timeToFormat) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final String formatted = formatter.format(timeToFormat);
  return formatted;
}
