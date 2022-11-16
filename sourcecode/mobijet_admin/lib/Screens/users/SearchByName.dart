import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/agent_model.dart';
import 'package:thinkcreative_technologies/Models/customer_model.dart';
import 'package:thinkcreative_technologies/Widgets/customcards/custom_card.dart';
import 'package:thinkcreative_technologies/Widgets/my_scaffold.dart';

// import 'package:grokartadmin/main2.dart';
class SearchService {
  searchByName(String searchField, CollectionReference colRef) {
    return colRef
        .where(Dbkeys.searchKey,
            isEqualTo: searchField.trim().substring(0, 1).toUpperCase())
        .where(Dbkeys.searchKey, isNotEqualTo: null)
        .get();
  }
}

class SearchUserByName extends StatefulWidget {
  final int serchusertype;

  final CollectionReference colRef;
  SearchUserByName({required this.serchusertype, required this.colRef});
  @override
  _SearchUserByNameState createState() => new _SearchUserByNameState();
}

class _SearchUserByNameState extends State<SearchUserByName> {
  bool isEmpty = true;
  bool issearching = true;
  var queryResultSet = [];
  var tempSearchStore = [];
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

  initiateSearch(inputvalue, String dbkeysField) async {
    if (issearching == false) {
      setState(() {
        issearching = true;
      });
    }

    if (inputvalue.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = inputvalue.toString().trim().length == 1
        ? inputvalue.toString().toUpperCase()
        : inputvalue.substring(0, 1).toUpperCase() + inputvalue.substring(1);

    if (queryResultSet.length == 0 && inputvalue.length == 1) {
      print('searching');
      SearchService()
          .searchByName(inputvalue, widget.colRef)
          .then((QuerySnapshot docs) {
        if (docs.docs.length > 0) {
          for (int i = 0; i < docs.docs.length; ++i) {
            queryResultSet.add(docs.docs[i].data());
            tempSearchStore = [];
            queryResultSet.forEach((element) {
              if (element[dbkeysField].startsWith(capitalizedValue)) {
                setState(() {
                  tempSearchStore.add(element);
                });
              }
            });
            print('result added');
            setState(() {});
          }
        }
      });
    } else {
      print('not searching');
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element[dbkeysField].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title:
          '${getTranslatedForCurrentUser(context, 'xxxsearchxx')} ${getTranslatedForCurrentUser(context, 'xxxbyxxxxnamexxx').replaceAll('(####)', '${getTranslatedForCurrentUser(context, langKey)}')}',
      body: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (val) {
              if (val.isEmpty) {
                setState(() {
                  isEmpty = true;

                  queryResultSet = [];
                  tempSearchStore = [];
                });
              } else {
                setState(() {
                  isEmpty = false;
                });
                initiateSearch(val, Dbkeys.nickname);
              }
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.search),
                  iconSize: 20.0,
                  onPressed: () {},
                ),
                contentPadding: EdgeInsets.only(left: 25.0),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Mycolors.secondary, width: 1.5),
                    borderRadius: BorderRadius.circular(4.0)),
                hintText: getTranslatedForCurrentUser(context, 'xxnamexx'),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Mycolors.primary, width: 1.5),
                    borderRadius: BorderRadius.circular(4.0))),
          ),
        ),
        SizedBox(height: 10.0),
        isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  Icon(
                    Icons.person_search_rounded,
                    size: 120,
                    color: Mycolors.grey.withOpacity(0.2),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              )
            : ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  tempSearchStore.length > 0
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(18, 10, 18, 13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${getTranslatedForCurrentUser(context, 'xxxsearchresultsxxx')} :',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${tempSearchStore.length} ${getTranslatedForCurrentUser(context, 'langKey')} ${getTranslatedForCurrentUser(context, 'xxxfoundxxx')}',
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  ListView(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      primary: false,
                      shrinkWrap: true,
                      children: tempSearchStore.map((element) {
                        return buildResultCard(
                            context, element, widget.serchusertype);
                      }).toList()),
                ],
              )
      ]),
    );
  }

  Widget buildResultCard(context, data, int usertypeindex) {
    return usertypeindex == Usertype.agent.index
        ? AgentCard(
            isProfileFetchedFromProvider: false,
            usermodel: AgentModel.fromJson(data),
            isswitchshow: false,
          )
        : usertypeindex == Usertype.customer.index
            ? CustomerCard(
                isProfileFetchedFromProvider: false,
                usermodel: CustomerModel.fromJson(data),
                isswitchshow: false,
              )
            : Text('User type not defined');
  }
}
