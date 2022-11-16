import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Services/my_providers/firestore_collections_data_admin.dart';
import 'package:thinkcreative_technologies/Widgets/dialogs/loadingDialog.dart';
import 'package:thinkcreative_technologies/Widgets/nodata_widget.dart';

class InfiniteCOLLECTIONListViewWidgetAdmin extends StatefulWidget {
  final FirestoreDataProviderAGENTS? firestoreDataProviderAGENTS;
  final FirestoreDataProviderCHATMESSAGES? firestoreDataProviderMESSAGES;
  final FirestoreDataProviderCUSTOMERS? firestoreDataProviderCUSTOMERS;
  final FirestoreDataProviderREPORTS? firestoreDataProviderREPORTS;
  final FirestoreDataProviderCALLHISTORY? firestoreDataProviderCALLHISTORY;
  final String? datatype;
  final Widget? list;
  final Query? refdata;
  final bool? isreverse;
  final EdgeInsets? padding;
  final String? parentid;
  const InfiniteCOLLECTIONListViewWidgetAdmin({
    this.firestoreDataProviderAGENTS,
    this.firestoreDataProviderMESSAGES,
    this.firestoreDataProviderCUSTOMERS,
    this.firestoreDataProviderCALLHISTORY,
    this.firestoreDataProviderREPORTS,
    this.datatype,
    this.isreverse,
    this.padding,
    this.parentid,
    this.list,
    this.refdata,
    Key? key,
  }) : super(key: key);

  @override
  _InfiniteCOLLECTIONListViewWidgetAdminState createState() =>
      _InfiniteCOLLECTIONListViewWidgetAdminState();
}

class _InfiniteCOLLECTIONListViewWidgetAdminState
    extends State<InfiniteCOLLECTIONListViewWidgetAdmin> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);
    if (widget.datatype == Dbkeys.dataTypeAGENTS) {
      widget.firestoreDataProviderAGENTS!
          .fetchNextData(widget.datatype, widget.refdata, true);
    } else if (widget.datatype == Dbkeys.dataTypeCUSTOMERS) {
      widget.firestoreDataProviderCUSTOMERS!
          .fetchNextData(widget.datatype, widget.refdata, true);
    } else if (widget.datatype == Dbkeys.dataTypeCALLHISTORY) {
      widget.firestoreDataProviderCALLHISTORY!
          .fetchNextData(widget.datatype, widget.refdata, true);
    } else if (widget.datatype == Dbkeys.dataTypeREPORTS) {
      widget.firestoreDataProviderREPORTS!
          .fetchNextData(widget.datatype, widget.refdata, true);
    } else if (widget.datatype == Dbkeys.dataTypeMESSAGES) {
      widget.firestoreDataProviderMESSAGES!
          .fetchNextData(widget.datatype, widget.refdata, true);
    } else {}
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (widget.datatype == Dbkeys.dataTypeAGENTS) {
        if (widget.firestoreDataProviderAGENTS!.hasNext) {
          widget.firestoreDataProviderAGENTS!
              .fetchNextData(widget.datatype, widget.refdata, false);
        }
      } else if (widget.datatype == Dbkeys.dataTypeCUSTOMERS) {
        if (widget.firestoreDataProviderCUSTOMERS!.hasNext) {
          widget.firestoreDataProviderCUSTOMERS!
              .fetchNextData(widget.datatype, widget.refdata, false);
        }
      } else if (widget.datatype == Dbkeys.dataTypeCALLHISTORY) {
        if (widget.firestoreDataProviderCALLHISTORY!.hasNext) {
          widget.firestoreDataProviderCALLHISTORY!
              .fetchNextData(widget.datatype, widget.refdata, false);
        }
      } else if (widget.datatype == Dbkeys.dataTypeREPORTS) {
        if (widget.firestoreDataProviderREPORTS!.hasNext) {
          widget.firestoreDataProviderREPORTS!
              .fetchNextData(widget.datatype, widget.refdata, false);
        }
      } else if (widget.datatype == Dbkeys.dataTypeMESSAGES) {
        if (widget.firestoreDataProviderMESSAGES!.hasNext) {
          widget.firestoreDataProviderMESSAGES!
              .fetchNextData(widget.datatype, widget.refdata, false);
        }
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      reverse:
          widget.isreverse == null || widget.isreverse == false ? false : true,
      controller: scrollController,
      padding: widget.padding == null ? EdgeInsets.all(0) : widget.padding,
      children: (widget.datatype == Dbkeys.dataTypeMESSAGES)
          ? [
              Container(child: widget.list),
              (widget.firestoreDataProviderMESSAGES!.hasNext == true)
                  ? Center(
                      child: GestureDetector(
                        onTap: () {
                          widget.firestoreDataProviderMESSAGES!.fetchNextData(
                              widget.datatype, widget.refdata, false);
                        },
                        child: Padding(
                          padding: widget.firestoreDataProviderMESSAGES!
                                      .recievedDocs.length ==
                                  0
                              ? EdgeInsets.fromLTRB(
                                  38,
                                  MediaQuery.of(context).size.height / 3,
                                  38,
                                  38)
                              : const EdgeInsets.all(18.0),
                          child: Container(child: circularProgress()),
                        ),
                      ),
                    )
                  : widget.firestoreDataProviderMESSAGES!.recievedDocs.length <
                          1
                      ? noDataWidget(
                          context: context,
                          padding: EdgeInsets.fromLTRB(28,
                              MediaQuery.of(context).size.height / 3.7, 28, 10),
                          title: 'No Messages',
                        )
                      : SizedBox(),
            ]
          : (widget.datatype == Dbkeys.dataTypeCUSTOMERS)
              ? [
                  Container(child: widget.list),
                  (widget.firestoreDataProviderCUSTOMERS!.hasNext == true)
                      ? Center(
                          child: GestureDetector(
                            onTap: () {
                              widget.firestoreDataProviderCUSTOMERS!
                                  .fetchNextData(
                                      widget.datatype, widget.refdata, false);
                            },
                            child: Padding(
                              padding: widget.firestoreDataProviderCUSTOMERS!
                                          .recievedDocs.length ==
                                      0
                                  ? EdgeInsets.fromLTRB(
                                      38,
                                      MediaQuery.of(context).size.height / 3,
                                      38,
                                      38)
                                  : const EdgeInsets.all(18.0),
                              child: Container(child: circularProgress()),
                            ),
                          ),
                        )
                      : widget.firestoreDataProviderCUSTOMERS!.recievedDocs
                                  .length <
                              1
                          ? noDataWidget(
                              context: context,
                              padding: EdgeInsets.fromLTRB(
                                  28,
                                  MediaQuery.of(context).size.height / 3.7,
                                  28,
                                  10),
                              title: 'No Customers',
                            )
                          : SizedBox(),
                ]
              : (widget.datatype == Dbkeys.dataTypeAGENTS)
                  ?
                  //-----USERS
                  [
                      Container(child: widget.list),
                      (widget.firestoreDataProviderAGENTS!.hasNext == true)
                          ? Center(
                              child: GestureDetector(
                                onTap: () {
                                  widget.firestoreDataProviderAGENTS!
                                      .fetchNextData(widget.datatype,
                                          widget.refdata, false);
                                },
                                child: Padding(
                                  padding: widget.firestoreDataProviderAGENTS!
                                              .recievedDocs.length ==
                                          0
                                      ? EdgeInsets.fromLTRB(
                                          38,
                                          MediaQuery.of(context).size.height /
                                              3,
                                          38,
                                          38)
                                      : const EdgeInsets.all(18.0),
                                  child: Container(child: circularProgress()),
                                ),
                              ),
                            )
                          : widget.firestoreDataProviderAGENTS!.recievedDocs
                                      .length <
                                  1
                              ? noDataWidget(
                                  context: context,
                                  padding: EdgeInsets.fromLTRB(
                                      28,
                                      MediaQuery.of(context).size.height / 3.7,
                                      28,
                                      10),
                                  title: 'No Agents',
                                )
                              : SizedBox(),
                    ]
                  : (widget.datatype == Dbkeys.dataTypeCALLHISTORY)
                      ?
                      //-----USERS
                      [
                          Container(child: widget.list),
                          (widget.firestoreDataProviderCALLHISTORY!.hasNext ==
                                  true)
                              ? Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      widget.firestoreDataProviderCALLHISTORY!
                                          .fetchNextData(widget.datatype,
                                              widget.refdata, false);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Mycolors.loadingindicator),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : widget.firestoreDataProviderCALLHISTORY!
                                          .recievedDocs.length <
                                      1
                                  ? noDataWidget(
                                      context: context,
                                      padding: EdgeInsets.fromLTRB(
                                          28,
                                          MediaQuery.of(context).size.height /
                                              7.7,
                                          28,
                                          10),
                                      title: 'No Call history',
                                      iconData: Icons.phone,
                                      iconColor: Mycolors.primary,
                                      subtitle: '')
                                  : SizedBox(),
                        ]
                      : (widget.datatype == Dbkeys.dataTypeREPORTS)
                          ?
                          //-----USERS
                          [
                              Container(child: widget.list),
                              (widget.firestoreDataProviderREPORTS!.hasNext ==
                                      true)
                                  ? Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          widget.firestoreDataProviderREPORTS!
                                              .fetchNextData(widget.datatype,
                                                  widget.refdata, false);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Mycolors
                                                          .loadingindicator),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : widget.firestoreDataProviderREPORTS!
                                              .recievedDocs.length <
                                          1
                                      ? noDataWidget(
                                          context: context,
                                          padding: EdgeInsets.fromLTRB(
                                              28,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  7.7,
                                              28,
                                              10),
                                          title: 'No Reports sent by users',
                                          iconData: Icons.report,
                                          iconColor: Mycolors.primary,
                                          subtitle: '')
                                      : SizedBox(),
                            ]
                          :
                          //----- COUPON
                          []);
}
