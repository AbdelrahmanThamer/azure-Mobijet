import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Models/userapp_settings_model.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';

class RoleColumn extends StatelessWidget {
  final bool isDepartmentBased;
  final String taskname;
  final String? tasksubtitle;
  final String? key1secondadmin;
  final String? key2agent;
  final String? key3customer;
  final String? key4departemtmanager;
  final bool? iskey1secondadmindisabled;
  final bool? iskey2agentdisabled;
  final bool? iskey3customerdisabled;
  final bool? iskey4departmentmanagerdisabled;
  final Map<String, dynamic> latestsettings;
  final Function(
    UserAppSettingsModel refreshModelSettings,
    String key,
    bool value,
  ) onSelect;
  const RoleColumn(
      {Key? key,
      this.key1secondadmin,
      required this.isDepartmentBased,
      this.key2agent,
      this.key4departemtmanager,
      this.tasksubtitle,
      this.iskey1secondadmindisabled,
      this.iskey2agentdisabled,
      this.iskey4departmentmanagerdisabled,
      this.iskey3customerdisabled,
      this.key3customer,
      required this.latestsettings,
      required this.onSelect,
      required this.taskname})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Mycolors.greylightcolor),
          // bottom: BorderSide(width: 16.0, color: Colors.lightBlue.shade900),
        ),
        color: Colors.white,
      ),
      child: Row(
        children: isDepartmentBased == true
            ? [
                Center(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                            width: 1.0, color: Mycolors.greylightcolor),
                      ),
                      color: Colors.white,
                    ),
                    width: w * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 5, 5, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: tasksubtitle == null
                            ? [
                                Text(
                                  taskname,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Mycolors.black,
                                  ),
                                ),
                              ]
                            : [
                                Text(
                                  taskname,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Mycolors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  tasksubtitle!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Mycolors.grey,
                                  ),
                                ),
                              ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                            width: 1.0, color: Mycolors.greylightcolor),
                      ),
                      color: Colors.white,
                    ),
                    width: w * 0.15,
                    child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: key1secondadmin == null
                            ? SizedBox()
                            : IconButton(
                                onPressed: AppConstants.isdemomode == true
                                    ? () {
                                        Utils.toast(getTranslatedForCurrentUser(
                                            context,
                                            'xxxnotalwddemoxxaccountxx'));
                                      }
                                    : iskey1secondadmindisabled == true
                                        ? () {}
                                        : () {
                                            latestsettings[key1secondadmin!] =
                                                !latestsettings[
                                                    key1secondadmin!];
                                            onSelect(
                                                UserAppSettingsModel.fromJson(
                                                    latestsettings),
                                                key1secondadmin!,
                                                !latestsettings[
                                                    key1secondadmin!]);
                                          },
                                icon: Icon(
                                  latestsettings[key1secondadmin] == true
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank_outlined,
                                  size: 20,
                                ),
                                color: latestsettings[key1secondadmin] == true
                                    ? iskey1secondadmindisabled == true
                                        ? Mycolors.grey.withOpacity(0.7)
                                        : Mycolors.primary
                                    : Mycolors.grey.withOpacity(0.5),
                              )),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                            width: 1.0, color: Mycolors.greylightcolor),
                      ),
                      color: Colors.white,
                    ),
                    width: w * 0.15,
                    child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: key4departemtmanager == null
                            ? SizedBox()
                            : IconButton(
                                onPressed: AppConstants.isdemomode == true
                                    ? () {
                                        Utils.toast(getTranslatedForCurrentUser(
                                            context,
                                            'xxxnotalwddemoxxaccountxx'));
                                      }
                                    : iskey4departmentmanagerdisabled == true
                                        ? () {}
                                        : () {
                                            latestsettings[
                                                    key4departemtmanager!] =
                                                !latestsettings[
                                                    key4departemtmanager!];
                                            onSelect(
                                                UserAppSettingsModel.fromJson(
                                                    latestsettings),
                                                key4departemtmanager!,
                                                !latestsettings[
                                                    key4departemtmanager!]);
                                          },
                                icon: Icon(
                                  latestsettings[key4departemtmanager] == true
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank_outlined,
                                  size: 20,
                                ),
                                color: latestsettings[key4departemtmanager] ==
                                        true
                                    ? iskey4departmentmanagerdisabled == true
                                        ? Mycolors.grey.withOpacity(0.7)
                                        : Mycolors.primary
                                    : Mycolors.grey.withOpacity(0.5),
                              )),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                            width: 1.0, color: Mycolors.greylightcolor),
                      ),
                      color: Colors.white,
                    ),
                    width: w * 0.15,
                    child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: key2agent == null
                            ? SizedBox()
                            : IconButton(
                                onPressed: AppConstants.isdemomode == true
                                    ? () {
                                        Utils.toast(getTranslatedForCurrentUser(
                                            context,
                                            'xxxnotalwddemoxxaccountxx'));
                                      }
                                    : iskey2agentdisabled == true
                                        ? () {}
                                        : () {
                                            latestsettings[key2agent!] =
                                                !latestsettings[key2agent!];
                                            onSelect(
                                                UserAppSettingsModel.fromJson(
                                                    latestsettings),
                                                key2agent!,
                                                !latestsettings[key2agent!]);
                                          },
                                icon: Icon(
                                  latestsettings[key2agent] == true
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank_outlined,
                                  size: 20,
                                ),
                                color: latestsettings[key2agent] == true
                                    ? iskey2agentdisabled == true
                                        ? Mycolors.grey.withOpacity(0.7)
                                        : Mycolors.primary
                                    : Mycolors.grey.withOpacity(0.5),
                              )),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                            width: 1.0, color: Mycolors.greylightcolor),
                      ),
                      color: Colors.white,
                    ),
                    width: w * 0.15,
                    child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: key3customer == null
                            ? SizedBox()
                            : IconButton(
                                onPressed: AppConstants.isdemomode == true
                                    ? () {
                                        Utils.toast(getTranslatedForCurrentUser(
                                            context,
                                            'xxxnotalwddemoxxaccountxx'));
                                      }
                                    : iskey3customerdisabled == true
                                        ? () {}
                                        : () {
                                            latestsettings[key3customer!] =
                                                !latestsettings[key3customer!];
                                            onSelect(
                                                UserAppSettingsModel.fromJson(
                                                    latestsettings),
                                                key3customer!,
                                                !latestsettings[key3customer!]);
                                          },
                                icon: Icon(
                                  latestsettings[key3customer] == true
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank_outlined,
                                  size: 20,
                                ),
                                color: latestsettings[key3customer] == true
                                    ? iskey3customerdisabled == true
                                        ? Mycolors.grey.withOpacity(0.7)
                                        : Mycolors.primary
                                    : Mycolors.grey.withOpacity(0.5),
                              )),
                  ),
                ),
              ]
            : [
                Center(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                            width: 1.0, color: Mycolors.greylightcolor),
                      ),
                      color: Colors.white,
                    ),
                    width: w / 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 5, 5, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: tasksubtitle == null
                            ? [
                                Text(
                                  taskname,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Mycolors.black,
                                  ),
                                ),
                              ]
                            : [
                                Text(
                                  taskname,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Mycolors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  tasksubtitle!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Mycolors.grey,
                                  ),
                                ),
                              ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                            width: 1.0, color: Mycolors.greylightcolor),
                      ),
                      color: Colors.white,
                    ),
                    width: w / 6,
                    child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: key1secondadmin == null
                            ? SizedBox()
                            : IconButton(
                                onPressed: AppConstants.isdemomode == true
                                    ? () {
                                        Utils.toast(getTranslatedForCurrentUser(
                                            context,
                                            'xxxnotalwddemoxxaccountxx'));
                                      }
                                    : iskey1secondadmindisabled == true
                                        ? () {}
                                        : () {
                                            latestsettings[key1secondadmin!] =
                                                !latestsettings[
                                                    key1secondadmin!];
                                            onSelect(
                                                UserAppSettingsModel.fromJson(
                                                    latestsettings),
                                                key1secondadmin!,
                                                !latestsettings[
                                                    key1secondadmin!]);
                                          },
                                icon: Icon(
                                  latestsettings[key1secondadmin] == true
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank_outlined,
                                  size: 20,
                                ),
                                color: latestsettings[key1secondadmin] == true
                                    ? iskey1secondadmindisabled == true
                                        ? Mycolors.grey.withOpacity(0.7)
                                        : Mycolors.primary
                                    : Mycolors.grey.withOpacity(0.5),
                              )),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                            width: 1.0, color: Mycolors.greylightcolor),
                      ),
                      color: Colors.white,
                    ),
                    width: w / 6,
                    child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: key2agent == null
                            ? SizedBox()
                            : IconButton(
                                onPressed: AppConstants.isdemomode == true
                                    ? () {
                                        Utils.toast(getTranslatedForCurrentUser(
                                            context,
                                            'xxxnotalwddemoxxaccountxx'));
                                      }
                                    : iskey2agentdisabled == true
                                        ? () {}
                                        : () {
                                            latestsettings[key2agent!] =
                                                !latestsettings[key2agent!];
                                            onSelect(
                                                UserAppSettingsModel.fromJson(
                                                    latestsettings),
                                                key2agent!,
                                                !latestsettings[key2agent!]);
                                          },
                                icon: Icon(
                                  latestsettings[key2agent] == true
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank_outlined,
                                  size: 20,
                                ),
                                color: latestsettings[key2agent] == true
                                    ? iskey2agentdisabled == true
                                        ? Mycolors.grey.withOpacity(0.7)
                                        : Mycolors.primary
                                    : Mycolors.grey.withOpacity(0.5),
                              )),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                            width: 1.0, color: Mycolors.greylightcolor),
                      ),
                      color: Colors.white,
                    ),
                    width: w / 6,
                    child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: key3customer == null
                            ? SizedBox()
                            : IconButton(
                                onPressed: AppConstants.isdemomode == true
                                    ? () {
                                        Utils.toast(getTranslatedForCurrentUser(
                                            context,
                                            'xxxnotalwddemoxxaccountxx'));
                                      }
                                    : iskey3customerdisabled == true
                                        ? () {}
                                        : () {
                                            latestsettings[key3customer!] =
                                                !latestsettings[key3customer!];
                                            onSelect(
                                                UserAppSettingsModel.fromJson(
                                                    latestsettings),
                                                key3customer!,
                                                !latestsettings[key3customer!]);
                                          },
                                icon: Icon(
                                  latestsettings[key3customer] == true
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank_outlined,
                                  size: 20,
                                ),
                                color: latestsettings[key3customer] == true
                                    ? iskey3customerdisabled == true
                                        ? Mycolors.grey.withOpacity(0.7)
                                        : Mycolors.primary
                                    : Mycolors.grey.withOpacity(0.5),
                              )),
                  ),
                ),
              ],
      ),
    );
  }
}
