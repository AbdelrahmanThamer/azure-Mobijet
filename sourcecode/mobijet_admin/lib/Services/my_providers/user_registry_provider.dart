//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Models/user_registry_model.dart';
import 'package:thinkcreative_technologies/Utils/error_codes.dart';

class UserRegistry with ChangeNotifier {
  List<UserRegistryModel> users = [];
  List<UserRegistryModel> agents = [];
  List<UserRegistryModel> customers = [];
  UserRegistryModel getUserData(BuildContext context, String userid) {
    int i = users.lastIndexWhere((element) => element.id == userid);
    if (i >= 0) {
      return users[i];
    } else {
      fetchUserRegistry(context);
      return UserRegistryModel(
          fullname: userid,
          shortname: userid,
          photourl: "",
          phone: "",
          usertype: 1,
          id: userid,
          email: "",
          extra1: "",
          extra2: "",
          extraMap: {});
    }
  }

  updateParticularUser(
      BuildContext context, String userid, int usertype) async {
    await FirebaseFirestore.instance
        .collection(usertype == Usertype.agent.index ||
                usertype == Usertype.secondadmin.index
            ? DbPaths.collectionagents
            : DbPaths.collectioncustomers)
        .doc(userid)
        .get()
        .then((value) {
      if (value.exists) {
        int i = users.lastIndexWhere((element) => element.id == userid);
        // users = value.data()!['list'];
        // agents = users
        //     .where((user) => user.usertype == Usertype.agent.index)
        //     .toList();
        // customer = users
        //     .where((user) => user.usertype == Usertype.customer.index)
        //     .toList();
        if (i >= 0) {
          //run transaction
        } else {}

        notifyListeners();
      } else {
        showERRORSheet(context, "",
            message: "User does not exists. kindly contact the developer.");
      }
    }).catchError((e) {
      showERRORSheet(context, "",
          message:
              "App Installation not Completed properly. kindly contact the developer. ERROR: $e");
    });
  }

  fetchUserRegistry(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection(DbPaths.userapp)
        .doc(DbPaths.registry)
        .get()
        .then((value) {
      if (value.exists) {
        users = [];
        agents = [];
        customers = [];
        List<dynamic> list = [];
        list = value.data()!['list'];
        list.forEach((element) {
          users.add(UserRegistryModel.fromJson(element));
        });
        // users = value
        //     .data()!['list']
        //     .map((val) => )
        //     .toList();
        agents = users
            .where((user) => user.usertype == Usertype.agent.index)
            .toList();
        customers = users
            .where((user) => user.usertype == Usertype.customer.index)
            .toList();
        notifyListeners();
      } else {
        showERRORSheet(context, "",
            message:
                "PENDING INSTALLATION !\n\nPLEASE MAKE SURE TO COMPLETE THE USER APP INSTALLATION FIRST.");
      }
    }).catchError((e) {
      showERRORSheet(context, "",
          message: "Error ocuured while fetching registry ERROR: $e");
    });
  }
}
