//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Definition attached with source code. *********************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thinkcreative_technologies/Configs/db_keys.dart';
import 'package:thinkcreative_technologies/Configs/enum.dart';

class UserAppSettingsModel {
  String? companyName = '';
  String? companyLogoUrl = '';
  bool? autoJoinNewAgentsToDefaultList = true;

  //--- Login Page Settings
  List<dynamic>? preVerifiedAgents = [];
  List<dynamic>? preVerifiedCustomers = [];
  bool? customerUnderReviewAfterEditProfile = false;
  bool? isTwoFactorAuthCompulsoryforAgents = false;
  bool? isTwoFactorAuthCompulsoryforUsers = false;
  //----All users list -------
  bool? agentsCanViewAllCustomerGlobally = false;
  bool? departmentmanagerCanViewAllCustomerGlobally = false;
  bool? secondadminCanViewAllCustomerGlobally = true;

  bool? departmentmanagerCanViewAllAgentsGlobally = false;
  bool? agentsCanViewAllAgentsGlobally = false;
  bool? secondadminCanViewAllAgentsGlobally = true;
  //---- Profile Settings
  bool? customerCanSeeAgentStatisticsProfile = false;
  bool? secondadmincanseeagentnameandphoto = true;
  bool? agentcanseeagentnameandphoto = true;
  bool? customercanseeagentnameandphoto = true;
  bool? departmentmanagercanseeagentnameandphoto = true;
  bool? departmentmanagercanseecustomernameandphoto = true;
  bool? agentcanseecustomernameandphoto = true;
  bool? secondadmincanseecustomernameandphoto = true;

  bool? agentCanSeeCustomerContactInfo = false;
  bool? secondadminCanSeeCustomerContactInfo = false;
  bool? departmentmanagerCanSeeCustomerStatisticsProfile = false;
  bool? departmentmanagerCanSeeCustomerContactinfo = false;
  bool? exbool244 = false;
  bool? secondadminCanSeeCustomerContactinfo = false;
  bool? departmentmanagerCanSeeAgentStatisticsProfile = false;
  bool? secondadminCanSeeAgentContactinfo = false;
  bool? departmentmanagerCanSeeAgentContactinfo = false;
  bool? agentCanSeeAgentContactinfo = false;
  bool? customerCanSeeAgentContactinfo = false;
  bool? agentUnderReviewAfterEditProfile = false;
  bool? agentsCanSeeCustomerStatisticsProfile = false;
  bool? secondadminCanSeeCustomerStatisticsProfile = false;
  bool? secondadminCanSeeAgentStatisticsProfile = false;
  bool? agentCanSeeAgentStatisticsProfile = false;
  //---- Group Chat Settings

  bool? agentsCanCreateAgentsGroup = true;
  bool? secondadminCanCreateAgentsGroup = true;
  bool? departmentManagerCanCreateAgentsGroup = true;
  bool? departmentManagerCanViewDepartmentGroups = true;
  bool? secondadminCanViewDepartmentGroups = true;
  bool? departmentManagerCanViewAllGlobalgroups = true;
  bool? departmentManagerCanViewAllGlobalChats = false;
  bool? isMediaSendingAllowedInGroupChat = true;
  int? defaultMessageDeletingTimeForGroup = 15;
  bool? deleteConversationEnabledInGroup = false;
  int? groupMemberslimit = 100;
//---- Broadcast Settings

  bool? agentCanCreateBroadcastToAgents = false;
  bool? secondadminCanCreateBroadcastToAgents = true;
  bool? departmentmanagerCanCreateBroadcastToAgents = true;
  bool? departmentmanagerCanDeleteBroadcast = false;
  bool? agentCanDeleteBroadcast = false;
  bool? secondadminCanDeleteBroadcast = true;
  bool? secondadminCanViewGloabalBroadcast = true;
  bool? departmentmanagerCanViewGloabalBroadcast = false;
  int? broadcastMemberslimit = 100;
  //---- One To One Agent Chats
  int? personalcalltypeagents = CallType.both.index;
  bool? secondadminCanViewAllGlobalChats = true;
  bool? agentCancreateandViewNewIndividualChat = true;
  bool? secondadminCancreateandViewNewIndividualChat = true;
  bool? departmentmanagerCancreateandViewNewIndividualChat = false;
  int? defaultMessageDeletingTimeForOneToOneChat = 15;
  bool? isMediaSendingAllowedInOneToOneChat = true;
  bool? deleteConversationEnabledInPersonalChat = false;
  //----  Agent Calling feature
  bool? agentCanCallAgents = true;
  bool? secondadminCanCallAgents = true;
  bool? customerCanSeeAgentNameInTicketCallScreen = true;
  int? callTypeForAgents = CallType.both.index;
  //----  Ticket settings
  bool? agentCanViewAllTicketGlobally = false;
  bool? departmentmanagerCanViewAllTicketGlobally = false;
  bool? secondadminCanViewAllTicketGlobally = true;

  bool? customerCanCreateTicket = true;
  bool? agentCanCreateTicket = false;
  bool? secondadminCanCreateTicket = true;
  bool? departmentManagerCanCreateTicket = true;

  bool? agentcanChatWithCustomerInTicket = true;
  bool? secondadminCanChatWithCustomerInTicket = true;
  bool? departmentmanagerCanChatWithCustomerInTicket = true;

  bool? customerCanViewAgentsListJoinedTicket = false;
  bool? departmentmanagerCanViewAgentsListJoinedTicket = true;
  bool? secondadminCanViewAgentsListJoinedTicket = true;
  bool? agentCanViewAgentsListJoinedTicket = true;

  bool? agentCanScheduleCalls = false;
  bool? secondadminCanScheduleCalls = true;
  bool? departmentManagerCanScheduleCalls = true;
  bool? customerCanDialCallsInTicketChatroom = false;

  bool? agentCanChangeTicketStatus = false;
  bool? secondadminCanChangeTicketStatus = true;
  bool? customerCanChangeTicketStatus = true;
  bool? departmentmanagerCanChangeTicketStatus = true;

  bool? customerCanCloseTicket = false;
  bool? agentCanCloseTicket = true;
  bool? departmentmanagerCanCloseTicket = true;
  bool? secondAdminCanCloseTicket = true;

  bool? agentCanReopenTicket = false;
  bool? customerCanReopenTicket = false;
  bool? departmentManagerCanReopenTicket = true;
  bool? secondadminCanReopenTicket = true;

  bool? viewOwnAgentsWithinDepartments = true;
  bool? viewOwnCustomerWithinDepartments = true;
  bool? viewowntickets = true;
  int? defaultTicketMssgsDeletingTimeAfterClosing = 15;
  bool? showIsTypingInTicketChatRoom = true;
  bool? showIsCustomerOnline = true;
  bool? showIsAgentOnline = true;
  bool? isMediaSendingAllowedInTicketChatRoom = true;
  bool? isCallAssigningAllowed = true;
  int? callTypeForTicketChatRoom = CallType.both.index;
  bool? customerCanRateTicket = true;
  int? reopenTicketTillDays = 3;
  String? defaultTopicsOnLoginName = 'New request';
  bool? departmentBasedContent = true;
  List<dynamic>? departmentList = [];
  bool? autocreatesupportticket = false;
  //---Department settings
  bool? secondadminCanViewGlobalDepartments = true;
  bool? departmentmanagerCanViewGlobalDepartments = false;
  bool? agentsCanViewGlobalDepartments = true;
  bool? customerCanViewGlobalDepartments = true;
  bool? secondAdminCanviewDepartmentStatistics = true;
  bool? departmentmanagerCanviewDepartmentStatistics = true;
  bool? departmentManagerCanCreateDepartmentGlobally = false;
  bool? exbool1123 = false;
  bool? exbool384 = false;
  bool? secondAdminCanCreateDepartmentGlobally = true;
  bool? departmentmanagerCanDeleteDepartment = false;
  bool? secondadminCanDeleteDepartment = true;

  bool? secondAdminCanEditDepartment = true;
  bool? departmentManagerCanEditAddAgentstodepartment = true;
  //----  Payment settings
  bool? agentCanCreateInvoice = false;
  bool? secondadminCanCreateInvoice = true;
  bool? showPaymentsTabInAgentAccount = false;
  bool? showPaymentsTabInCustomerAccount = true;
  List<dynamic>? allowedCurrencyList = [];
  //--- App Core Settings

  bool? is24hrsTimeformat = true;
  bool? isPercentProgressShowWhileUploading = true;

  String? feedbackEmail = '';
  bool? isLogoutButtonShowInSettingsPage = true;
  int? maxFileSizeAllowedInMB = 60;
  int? maxNoOfFilesInMultiSharing = 10;
  int? maxNoOfContactsSelectForForward = 10;
  String? appShareMessageStringAndroid = '';
  String? appShareMessageStringiOS = '';
  bool? isCustomAppShareLink = true;

//--notification when settings updated
  int notificationtime = 0;
  String notificationtitle = "";
  String notificationdesc = "";
  String notifcationpostedby = "";
  //---Extra fields for future scalabality
  List<dynamic>? demoIDsList = [];
  List<dynamic>? exList2 = [];
  List<dynamic>? exList3 = [];
  List<dynamic>? exList4 = [];
  List<dynamic>? exList5 = [];
  List<dynamic>? exList6 = [];
  List<dynamic>? exList7 = [];
  List<dynamic>? exList8 = [];
  List<dynamic>? exList9 = [];
  List<dynamic>? exList10 = [];
  List<dynamic>? exList11 = [];
  List<dynamic>? exList12 = [];

  bool? exBool20 = false;
  bool? agentsCanSeeOwnDepartmentACustomer = false;
  bool? agentsCanSeeOwnDepartmentAgents = false;

  bool? departmentManagerCanSeeOwnDepartmentCustomers = true;
  bool? departmentManagerCanSeeOwnDepartmentAgents = true;
  bool? isShowHeaderAgentsTab = true;
  bool? isShowHeaderCustomersTab = true;
  bool? isShowFooterAgentsTab = true;
  bool? isShowFooterCustomersTab = true;
  bool? exBool89 = true;
  bool? exBool90 = true;
  bool? exBool100 = true;
  bool? exBool101 = true;
  bool? exBool102 = true;
  bool? exBool103 = true;
  bool? exBool104 = true;
  bool? exBool105 = true;
  bool? exBool106 = true;
  bool? exBool107 = true;
  bool? exBool108 = true;
  bool? exBool109 = true;
  bool? exBool110 = true;
  bool? exBool111 = true;
  bool? exBool112 = true;
  bool? exBool113 = true;
  bool? exBool114 = true;
  bool? exBool115 = true;
  bool? exBool116 = true;
  bool? exBool117 = true;
  bool? exBool118 = true;
  bool? exBool119 = true;
  bool? exBool120 = true;
  bool? exBool121 = true;
  bool? exBool122 = true;
  bool? exBool123 = true;
  bool? exBool124 = true;
  bool? exBool125 = true;
  bool? exBool126 = true;
  bool? exBool127 = true;
  bool? exBool128 = true;
  bool? exBool129 = true;
  bool? exBool130 = true;
  bool? exBool131 = true;
  bool? exBool132 = true;
  bool? exBool133 = true;
  bool? exBool134 = true;
  bool? exBool135 = true;
  bool? exBool136 = true;
  bool? exBool137 = true;
  bool? exBool138 = true;
  bool? exBool139 = true;
  bool? exBool140 = true;
  bool? exBool141 = true;
  bool? exBool142 = true;
  bool? exBool143 = true;
  bool? exBool144 = true;
  bool? exBool145 = true;
  bool? exBool146 = true;
  bool? exBool147 = true;
  bool? exBool148 = true;
  bool? exBool149 = true;
  bool? exBool150 = true;
  bool? exBool151 = true;
  bool? exBool152 = true;
  bool? exBool153 = true;
  bool? exBool154 = true;
  bool? exBool156 = true;
  bool? exBool157 = true;
  bool? exBool158 = true;
  bool? exBool159 = true;
  bool? exBool160 = true;
  bool? exBool161 = false;
  bool? exBool162 = false;
  bool? exBool163 = false;
  bool? exBool164 = false;
  bool? exBool165 = false;
  bool? exBool166 = false;
  bool? exBool167 = false;
  bool? exBool168 = false;
  bool? exBool169 = false;
  bool? exBool170 = false;
  bool? exBool171 = false;
  bool? exBool172 = false;
  bool? exBool173 = false;
  bool? exBool174 = false;
  bool? exBool175 = false;
  bool? exBool176 = false;
  bool? exBool177 = false;
  bool? exBool178 = false;
  bool? exBool179 = false;
  bool? exBool180 = false;
  bool? exBool181 = false;
  bool? exBool182 = false;
  bool? exBool183 = false;
  bool? exBool184 = false;
  bool? exBool185 = false;
  bool? exBool186 = false;
  bool? exBool187 = false;
  bool? exBool188 = false;
  bool? exBool189 = false;
  bool? exBool190 = false;
  bool? exBool191 = false;
  bool? exBool192 = false;
  bool? exBool193 = false;
  bool? exBool194 = false;
  bool? exBool195 = false;
  bool? exBool196 = false;
  bool? exBool197 = false;
  bool? exBool198 = false;
  bool? exBool199 = false;
  bool? exBool200 = false;

  int? customerTabIndexPosition = 0;
  int? agentTabIndexPosition = 0;
  int? exInt5 = 0;
  int? exInt6 = 0;
  int? exInt7 = 0;
  int? exInt8 = 0;
  int? exInt9 = 0;
  int? exInt10 = 0;
  int? exInt11 = 0;
  int? exInt12 = 0;
  int? exInt13 = 0;
  int? exInt14 = 0;
  int? exInt15 = 0;
  int? exInt16 = 0;
  int? exInt17 = 0;
  int? exInt18 = 0;
  int? exInt19 = 0;
  int? exInt20 = 0;
  int? exInt21 = 0;
  int? exInt22 = 0;
  int? exInt23 = 0;
  int? exInt24 = 0;
  int? exInt25 = 0;
  int? exInt26 = 0;
  int? exInt27 = 0;
  int? exInt28 = 0;
  int? exInt29 = 0;
  int? exInt30 = 0;
  int? exInt31 = 0;
  int? exInt32 = 0;
  int? exInt33 = 0;
  int? exInt34 = 0;
  int? exInt35 = 0;
  int? exInt36 = 0;
  int? exInt37 = 0;
  int? exInt38 = 0;
  int? exInt39 = 0;
  int? exInt40 = 0;
  int? exInt41 = 0;
  int? exInt42 = 0;
  int? exInt43 = 0;
  int? exInt44 = 0;
  int? exInt45 = 0;
  int? exInt46 = 0;
  int? exInt47 = 0;
  int? exInt48 = 0;
  int? exInt49 = 0;
  int? exInt50 = 0;
  int? exInt51 = 0;
  int? exInt52 = 0;
  int? exInt53 = 0;
  int? exInt54 = 0;
  double? exDouble1 = 0.001;
  double? exDouble2 = 0.001;
  double? exDouble3 = 0.001;
  double? exDouble4 = 0.001;
  double? exDouble5 = 0.001;
  double? exDouble6 = 0.001;
  double? exDouble7 = 0.001;
  double? exDouble8 = 0.001;
  double? exDouble9 = 0.001;
  double? exDouble10 = 0.001;

  Map? exMap1 = {};
  Map? exMap2 = {};
  Map? exMap3 = {};
  Map? exMap4 = {};
  Map? exMap5 = {};
  Map? exMap6 = {};
  Map? exMap7 = {};
  Map? exMap8 = {};
  Map? exMap9 = {};

  String? agentsLandingCustomTabURL = '';
  String? customersLandingCustomTabURL = '';
  String? agentCustomTabLabel = '';
  String? customerCustomTabLabel = '';
  String? exString8 = '';
  String? exString9 = '';
  String? exString10 = '';
  String? exString11 = '';
  String? exString12 = '';
  String? exString13 = '';
  String? exString14 = '';
  String? exString15 = '';
  String? exString16 = '';
  String? exString17 = '';
  String? exString18 = '';
  String? exString19 = '';
  String? exString20 = '';
  String? exString21 = '';
  String? exString22 = '';
  String? exString23 = '';
  String? exString24 = '';
  String? exString25 = '';
  String? exString26 = '';
  String? exString27 = '';
  String? exString28 = '';
  String? exString29 = '';
  String? exString30 = '';
  String? exString31 = '';
  String? exString32 = '';
  String? exString33 = '';
  String? exString34 = '';
  //-----
  bool? istextmessageallowed = true;
  bool? iscallsallowed = true;
  bool? ismediamessageallowed = true;
  bool? isadmobshow = true;
  // bool? isblocknewlogins = false;
  // bool? isaccountapprovalbyadminneeded = false;
  bool? isAllowCreatingGroups = true;
  bool? isAllowCreatingBroadcasts = true;
  bool? isAllowCreatingStatus = true;
  int? statusDeleteAfterInHours = 24;
  bool? updateV7done = true;

  UserAppSettingsModel({
    this.companyName = '',
    this.companyLogoUrl = '',
    this.preVerifiedAgents = const [],
    this.preVerifiedCustomers = const [],
    this.customerUnderReviewAfterEditProfile = false,
    this.isTwoFactorAuthCompulsoryforAgents = false,
    this.isTwoFactorAuthCompulsoryforUsers = false,
    //---- Profile Settings
    this.agentUnderReviewAfterEditProfile = false,
    this.agentsCanSeeCustomerStatisticsProfile = false,
    this.secondadminCanSeeCustomerStatisticsProfile = false,
    this.secondadminCanSeeAgentStatisticsProfile = false,
    this.agentCanSeeAgentStatisticsProfile = false,
    //---- Group Chat Settings
    this.deleteConversationEnabledInGroup = false,
    this.agentsCanCreateAgentsGroup = true,
    this.secondadminCanCreateAgentsGroup = true,
    this.isMediaSendingAllowedInGroupChat = true,
    this.defaultMessageDeletingTimeForGroup = 30,
//---- Broadcast Settings
    this.agentCanCreateBroadcastToAgents = false,
    this.secondadminCanCreateBroadcastToAgents = true,
    //---- One To One Agent Chats
    this.agentCancreateandViewNewIndividualChat = true,
    this.secondadminCancreateandViewNewIndividualChat = true,
    this.defaultMessageDeletingTimeForOneToOneChat = 30,
    this.isMediaSendingAllowedInOneToOneChat = true,
    this.deleteConversationEnabledInPersonalChat = false,
    //----  Agent Calling feature
    this.agentCanCallAgents = true,
    this.secondadminCanCallAgents = true,
    this.customerCanSeeAgentNameInTicketCallScreen = true,
    this.callTypeForAgents = 2,
    //----  Ticket settings
    this.customerCanCreateTicket = true,
    this.agentCanCreateTicket = false,
    this.secondadminCanCreateTicket = true,
    this.customerCanChangeTicketStatus = true,
    this.agentCanChangeTicketStatus = false,
    this.secondadminCanChangeTicketStatus = true,
    this.defaultTicketMssgsDeletingTimeAfterClosing = 30,
    this.showIsTypingInTicketChatRoom = true,
    this.showIsCustomerOnline = true,
    this.showIsAgentOnline = true,
    this.isMediaSendingAllowedInTicketChatRoom = true,
    this.isCallAssigningAllowed = true,
    this.callTypeForTicketChatRoom = 2,
    this.customerCanRateTicket = true,
    this.reopenTicketTillDays = 3,
    this.defaultTopicsOnLoginName = 'New request',
    this.departmentBasedContent = true,
    this.departmentList = const [],
    this.autocreatesupportticket = false,
    //----  Payment settings
    this.agentCanCreateInvoice = false,
    this.secondadminCanCreateInvoice = true,
    this.secondadminCanDeleteBroadcast = true,
    this.showPaymentsTabInAgentAccount = false,
    this.showPaymentsTabInCustomerAccount = true,
    this.allowedCurrencyList = const [],
    this.is24hrsTimeformat = true,
    this.isPercentProgressShowWhileUploading = true,
    this.groupMemberslimit = 100,
    this.broadcastMemberslimit = 100,
    this.feedbackEmail = '',
    this.isLogoutButtonShowInSettingsPage = true,
    this.maxFileSizeAllowedInMB = 60,
    this.maxNoOfFilesInMultiSharing = 10,
    this.maxNoOfContactsSelectForForward = 10,
    this.appShareMessageStringAndroid = '',
    this.appShareMessageStringiOS = '',
    this.isCustomAppShareLink = true,

    //---Extra fields for future scalabality
    this.demoIDsList = const [],
    this.exList2 = const [],
    this.exList3 = const [],
    this.exList4 = const [],
    this.exList5 = const [],
    this.exList6 = const [],
    this.exList7 = const [],
    this.exList8 = const [],
    this.exList9 = const [],
    this.exList10 = const [],
    this.exList11 = const [],
    this.exList12 = const [],
    this.exbool384 = false,
    this.exbool1123 = false,
    this.customerCanSeeAgentStatisticsProfile = false,
    this.departmentmanagerCancreateandViewNewIndividualChat = false,
    this.departmentmanagerCanViewGlobalDepartments = false,
    this.autoJoinNewAgentsToDefaultList = true,
    this.secondadminCanViewGloabalBroadcast = true,
    this.departmentManagerCanCreateAgentsGroup = true,
    this.secondadminCanViewAllGlobalChats = true,
    this.departmentmanagerCanDeleteBroadcast = true,
    this.departmentmanagerCanViewGloabalBroadcast = true,
    this.agentCanViewAllTicketGlobally = true,
    this.departmentmanagerCanViewAllTicketGlobally = true,
    this.departmentManagerCanViewDepartmentGroups = true,
    this.secondadminCanViewDepartmentGroups = true,
    this.departmentManagerCanViewAllGlobalgroups = true,
    this.agentsCanViewGlobalDepartments = true,
    this.departmentmanagerCanDeleteDepartment = true,
    this.departmentManagerCanCreateDepartmentGlobally = true,
    this.exBool20 = true,
    this.agentCanDeleteBroadcast = true,
    this.departmentmanagercanseeagentnameandphoto = true,
    this.departmentmanagercanseecustomernameandphoto = true,
    this.agentcanseecustomernameandphoto = true,
    this.secondadmincanseecustomernameandphoto = true,
    this.agentsCanSeeOwnDepartmentACustomer = false,
    this.agentCanSeeCustomerContactInfo = false,
    this.secondadminCanSeeCustomerContactInfo = false,
    this.departmentmanagerCanSeeCustomerStatisticsProfile = false,
    this.departmentmanagerCanSeeCustomerContactinfo = false,
    this.exbool244 = false,
    this.secondadminCanSeeCustomerContactinfo = false,
    this.departmentmanagerCanSeeAgentStatisticsProfile = false,
    this.secondadminCanSeeAgentContactinfo = false,
    this.departmentmanagerCanSeeAgentContactinfo = false,
    this.agentCanSeeAgentContactinfo = false,
    this.customerCanSeeAgentContactinfo = false,
    this.agentsCanSeeOwnDepartmentAgents = false,
    this.departmentManagerCanViewAllGlobalChats = false,
    this.departmentmanagerCanViewAllAgentsGlobally = false,
    this.agentsCanViewAllAgentsGlobally = false,
    this.agentsCanViewAllCustomerGlobally = false,
    this.departmentmanagerCanViewAllCustomerGlobally = false,
    this.customerCanDialCallsInTicketChatroom = false,
    this.agentCanReopenTicket = false,
    this.customerCanReopenTicket = false,
    this.customerCanCloseTicket = false,
    this.agentCanScheduleCalls = false,
    this.customerCanViewAgentsListJoinedTicket = false,
    this.secondadmincanseeagentnameandphoto = true,
    this.agentcanseeagentnameandphoto = true,
    this.customercanseeagentnameandphoto = true,
    this.departmentmanagerCanCreateBroadcastToAgents = true,
    this.secondadminCanViewGlobalDepartments = true,
    this.customerCanViewGlobalDepartments = true,
    this.secondAdminCanviewDepartmentStatistics = true,
    this.departmentmanagerCanviewDepartmentStatistics = true,
    this.secondadminCanDeleteDepartment = true,
    this.secondAdminCanEditDepartment = true,
    this.departmentManagerCanEditAddAgentstodepartment = true,
    this.secondAdminCanCreateDepartmentGlobally = true,
    this.departmentManagerCanCreateTicket = true,
    this.secondadminCanViewAllTicketGlobally = true,
    this.agentcanChatWithCustomerInTicket = true,
    this.secondadminCanChatWithCustomerInTicket = true,
    this.departmentmanagerCanChatWithCustomerInTicket = true,
    this.departmentmanagerCanChangeTicketStatus = true,
    this.departmentmanagerCanViewAgentsListJoinedTicket = true,
    this.secondadminCanViewAgentsListJoinedTicket = true,
    this.agentCanViewAgentsListJoinedTicket = true,
    this.secondadminCanScheduleCalls = true,
    this.departmentManagerCanScheduleCalls = true,
    this.agentCanCloseTicket = true,
    this.departmentmanagerCanCloseTicket = true,
    this.secondAdminCanCloseTicket = true,
    this.departmentManagerCanReopenTicket = true,
    this.secondadminCanReopenTicket = true,
    this.viewowntickets = true,
    this.secondadminCanViewAllCustomerGlobally = true,
    this.viewOwnCustomerWithinDepartments = true,
    this.viewOwnAgentsWithinDepartments = true,
    this.secondadminCanViewAllAgentsGlobally = true,
    this.departmentManagerCanSeeOwnDepartmentCustomers = true,
    this.departmentManagerCanSeeOwnDepartmentAgents = true,
    this.isShowHeaderAgentsTab = true,
    this.isShowHeaderCustomersTab = true,
    this.isShowFooterAgentsTab = true,
    this.isShowFooterCustomersTab = true,
    this.exBool89 = true,
    this.exBool90 = true,
    this.exBool100 = true,
    this.exBool101 = true,
    this.exBool102 = true,
    this.exBool103 = true,
    this.exBool104 = true,
    this.exBool105 = true,
    this.exBool106 = true,
    this.exBool107 = true,
    this.exBool108 = true,
    this.exBool109 = true,
    this.exBool110 = true,
    this.exBool111 = true,
    this.exBool112 = true,
    this.exBool113 = true,
    this.exBool114 = true,
    this.exBool115 = true,
    this.exBool116 = true,
    this.exBool117 = true,
    this.exBool118 = true,
    this.exBool119 = true,
    this.exBool120 = true,
    this.exBool121 = true,
    this.exBool122 = true,
    this.exBool123 = true,
    this.exBool124 = true,
    this.exBool125 = true,
    this.exBool126 = true,
    this.exBool127 = true,
    this.exBool128 = true,
    this.exBool129 = true,
    this.exBool130 = true,
    this.exBool131 = true,
    this.exBool132 = true,
    this.exBool133 = true,
    this.exBool134 = true,
    this.exBool135 = true,
    this.exBool136 = true,
    this.exBool137 = true,
    this.exBool138 = true,
    this.exBool139 = true,
    this.exBool140 = true,
    this.exBool141 = true,
    this.exBool142 = true,
    this.exBool143 = true,
    this.exBool144 = true,
    this.exBool145 = true,
    this.exBool146 = true,
    this.exBool147 = true,
    this.exBool148 = true,
    this.exBool149 = true,
    this.exBool150 = true,
    this.exBool151 = true,
    this.exBool152 = true,
    this.exBool153 = true,
    this.exBool154 = true,
    this.exBool156 = true,
    this.exBool157 = true,
    this.exBool158 = true,
    this.exBool159 = true,
    this.exBool160 = true,
    this.exBool161 = false,
    this.exBool162 = false,
    this.exBool163 = false,
    this.exBool164 = false,
    this.exBool165 = false,
    this.exBool166 = false,
    this.exBool167 = false,
    this.exBool168 = false,
    this.exBool169 = false,
    this.exBool170 = false,
    this.exBool171 = false,
    this.exBool172 = false,
    this.exBool173 = false,
    this.exBool174 = false,
    this.exBool175 = false,
    this.exBool176 = false,
    this.exBool177 = false,
    this.exBool178 = false,
    this.exBool179 = false,
    this.exBool180 = false,
    this.exBool181 = false,
    this.exBool182 = false,
    this.exBool183 = false,
    this.exBool184 = false,
    this.exBool185 = false,
    this.exBool186 = false,
    this.exBool187 = false,
    this.exBool188 = false,
    this.exBool189 = false,
    this.exBool190 = false,
    this.exBool191 = false,
    this.exBool192 = false,
    this.exBool193 = false,
    this.exBool194 = false,
    this.exBool195 = false,
    this.exBool196 = false,
    this.exBool197 = false,
    this.exBool198 = false,
    this.exBool199 = false,
    this.exBool200 = false,
    this.personalcalltypeagents = 2,
    this.notificationtime = 0,
    this.customerTabIndexPosition = 0,
    this.agentTabIndexPosition = 0,
    this.exInt5 = 0,
    this.exInt6 = 0,
    this.exInt7 = 0,
    this.exInt8 = 0,
    this.exInt9 = 0,
    this.exInt10 = 0,
    this.exInt11 = 0,
    this.exInt12 = 0,
    this.exInt13 = 0,
    this.exInt14 = 0,
    this.exInt15 = 0,
    this.exInt16 = 0,
    this.exInt17 = 0,
    this.exInt18 = 0,
    this.exInt19 = 0,
    this.exInt20 = 0,
    this.exInt21 = 0,
    this.exInt22 = 0,
    this.exInt23 = 0,
    this.exInt24 = 0,
    this.exInt25 = 0,
    this.exInt26 = 0,
    this.exInt27 = 0,
    this.exInt28 = 0,
    this.exInt29 = 0,
    this.exInt30 = 0,
    this.exInt31 = 0,
    this.exInt32 = 0,
    this.exInt33 = 0,
    this.exInt34 = 0,
    this.exInt35 = 0,
    this.exInt36 = 0,
    this.exInt37 = 0,
    this.exInt38 = 0,
    this.exInt39 = 0,
    this.exInt40 = 0,
    this.exInt41 = 0,
    this.exInt42 = 0,
    this.exInt43 = 0,
    this.exInt44 = 0,
    this.exInt45 = 0,
    this.exInt46 = 0,
    this.exInt47 = 0,
    this.exInt48 = 0,
    this.exInt49 = 0,
    this.exInt50 = 0,
    this.exInt51 = 0,
    this.exInt52 = 0,
    this.exInt53 = 0,
    this.exInt54 = 0,
    this.exDouble1 = 0.001,
    this.exDouble2 = 0.001,
    this.exDouble3 = 0.001,
    this.exDouble4 = 0.001,
    this.exDouble5 = 0.001,
    this.exDouble6 = 0.001,
    this.exDouble7 = 0.001,
    this.exDouble8 = 0.001,
    this.exDouble9 = 0.001,
    this.exDouble10 = 0.001,
    this.exMap1 = const {},
    this.exMap2 = const {},
    this.exMap3 = const {},
    this.exMap4 = const {},
    this.exMap5 = const {},
    this.exMap6 = const {},
    this.exMap7 = const {},
    this.exMap8 = const {},
    this.exMap9 = const {},
    this.notificationtitle = '',
    this.notificationdesc = '',
    this.notifcationpostedby = '',
    this.agentsLandingCustomTabURL = '',
    this.customersLandingCustomTabURL = '',
    this.agentCustomTabLabel = '',
    this.customerCustomTabLabel = '',
    this.exString8 = '',
    this.exString9 = '',
    this.exString10 = '',
    this.exString11 = '',
    this.exString12 = '',
    this.exString13 = '',
    this.exString14 = '',
    this.exString15 = '',
    this.exString16 = '',
    this.exString17 = '',
    this.exString18 = '',
    this.exString19 = '',
    this.exString20 = '',
    this.exString21 = '',
    this.exString22 = '',
    this.exString23 = '',
    this.exString24 = '',
    this.exString25 = '',
    this.exString26 = '',
    this.exString27 = '',
    this.exString28 = '',
    this.exString29 = '',
    this.exString30 = '',
    this.exString31 = '',
    this.exString32 = '',
    this.exString33 = '',
    this.exString34 = '',
    //-----
    this.istextmessageallowed = true,
    this.iscallsallowed = true,
    this.ismediamessageallowed = true,
    this.isadmobshow = true,
    this.isAllowCreatingGroups = true,
    this.isAllowCreatingBroadcasts = true,
    this.isAllowCreatingStatus = true,
    this.statusDeleteAfterInHours = 24,
    this.updateV7done = true,
  });

  UserAppSettingsModel copyWith({
    final String? companyName,
    final String? companyLogoUrl,
    //--- Login Page Settings
    final List<dynamic>? preVerifiedAgents,
    final List<dynamic>? preVerifiedCustomers,
    final bool? customerUnderReviewAfterEditProfile,
    final bool? isTwoFactorAuthCompulsoryforAgents,
    final bool? isTwoFactorAuthCompulsoryforUsers,
    //---- Profile Settings
    final bool? agentUnderReviewAfterEditProfile,
    final bool? agentsCanSeeCustomerStatisticsProfile,
    final bool? secondadminCanSeeCustomerStatisticsProfile,
    final bool? secondadminCanSeeAgentStatisticsProfile,
    final bool? agentCanSeeAgentStatisticsProfile,
    //---- Group Chat Settings
    final bool? deleteConversationEnabledInGroup,
    final bool? agentsCanCreateAgentsGroup,
    final bool? secondadminCanCreateAgentsGroup,
    final bool? isMediaSendingAllowedInGroupChat,
    final int? defaultMessageDeletingTimeForGroup,
//---- Broadcast Settings
    final bool? agentCanCreateBroadcastToAgents,
    final bool? secondadminCanCreateBroadcastToAgents,
    //---- One To One Agent Chats
    final bool? agentCancreateandViewNewIndividualChat,
    final bool? secondadminCancreateandViewNewIndividualChat,
    final int? defaultMessageDeletingTimeForOneToOneChat,
    final bool? isMediaSendingAllowedInOneToOneChat,
    final bool? deleteConversationEnabledInPersonalChat,
    //----  Agent Calling feature
    final bool? agentCanCallAgents,
    final bool? secondadminCanCallAgents,
    final bool? customerCanSeeAgentNameInTicketCallScreen,
    final int? callTypeForAgents,
    //----  Ticket settings
    final bool? customerCanCreateTicket,
    final bool? agentCanCreateTicket,
    final bool? secondadminCanCreateTicket,
    final bool? customerCanChangeTicketStatus,
    final bool? agentCanChangeTicketStatus,
    final bool? secondadminCanChangeTicketStatus,
    final int? defaultTicketMssgsDeletingTimeAfterClosing,
    final bool? showIsTypingInTicketChatRoom,
    final bool? showIsCustomerOnline,
    final bool? showIsAgentOnline,
    final bool? isMediaSendingAllowedInTicketChatRoom,
    final bool? isCallAssigningAllowed,
    final int? callTypeForTicketChatRoom,
    final bool? customerCanRateTicket,
    final int? reopenTicketTillDays,
    final bool? defaulttickettitle,
    final String? defaultTopicsOnLoginName,
    final bool? departmentBasedContent,
    final List<dynamic>? departmentList,
    final bool? autocreatesupportticket,
    //----  Payment settings
    final bool? agentCanCreateInvoice,
    final bool? secondadminCanCreateInvoice,
    final bool? secondadminCanDeleteBroadcast,
    final bool? showPaymentsTabInAgentAccount,
    final bool? showPaymentsTabInCustomerAccount,
    final List<dynamic>? allowedCurrencyList,
    //--- App Core Settings
    final bool? is24hrsTimeformat,
    final bool? isPercentProgressShowWhileUploading,
    final int? groupMemberslimit,
    final int? broadcastMemberslimit,
    final String? feedbackEmail,
    final bool? isLogoutButtonShowInSettingsPage,
    final int? maxFileSizeAllowedInMB,
    final int? maxNoOfFilesInMultiSharing,
    final int? maxNoOfContactsSelectForForward,
    final String? appShareMessageStringAndroid,
    final String? appShareMessageStringiOS,
    final bool? isCustomAppShareLink,
    //---Extra fields for future scalabality
    final List<dynamic>? demoIDsList,
    final List<dynamic>? exList2,
    final List<dynamic>? exList3,
    final List<dynamic>? exList4,
    final List<dynamic>? exList5,
    final List<dynamic>? exList6,
    final List<dynamic>? exList7,
    final List<dynamic>? exList8,
    final List<dynamic>? exList9,
    final List<dynamic>? exList10,
    final List<dynamic>? exList11,
    final List<dynamic>? exList12,
    final bool? exbool384,
    final bool? exbool1123,
    final bool? customerCanSeeAgentStatisticsProfile,
    final bool? departmentmanagerCancreateandViewNewIndividualChat,
    final bool? departmentmanagerCanViewGlobalDepartments,
    final bool? autoJoinNewAgentsToDefaultList,
    final bool? secondadminCanViewGloabalBroadcast,
    final bool? departmentManagerCanCreateAgentsGroup,
    final bool? secondadminCanViewAllGlobalChats,
    final bool? departmentmanagerCanDeleteBroadcast,
    final bool? departmentmanagerCanViewGloabalBroadcast,
    final bool? agentCanViewAllTicketGlobally,
    final bool? departmentmanagerCanViewAllTicketGlobally,
    final bool? departmentManagerCanViewDepartmentGroups,
    final bool? secondadminCanViewDepartmentGroups,
    final bool? departmentManagerCanViewAllGlobalgroups,
    final bool? agentsCanViewGlobalDepartments,
    final bool? departmentmanagerCanDeleteDepartment,
    final bool? departmentManagerCanCreateDepartmentGlobally,
    final bool? exBool20,
    final bool? agentCanDeleteBroadcast,
    final bool? departmentmanagercanseeagentnameandphoto,
    final bool? departmentmanagercanseecustomernameandphoto,
    final bool? agentcanseecustomernameandphoto,
    final bool? secondadmincanseecustomernameandphoto,
    final bool? agentsCanSeeOwnDepartmentACustomer,
    final bool? agentCanSeeCustomerContactInfo,
    final bool? secondadminCanSeeCustomerContactInfo,
    final bool? departmentmanagerCanSeeCustomerStatisticsProfile,
    final bool? departmentmanagerCanSeeCustomerContactinfo,
    final bool? exbool244,
    final bool? secondadminCanSeeCustomerContactinfo,
    final bool? departmentmanagerCanSeeAgentStatisticsProfile,
    final bool? secondadminCanSeeAgentContactinfo,
    final bool? departmentmanagerCanSeeAgentContactinfo,
    final bool? agentCanSeeAgentContactinfo,
    final bool? customerCanSeeAgentContactinfo,
    final bool? agentsCanSeeOwnDepartmentAgents,
    final bool? departmentManagerCanViewAllGlobalChats,
    final bool? departmentmanagerCanViewAllAgentsGlobally,
    final bool? agentsCanViewAllAgentsGlobally,
    final bool? agentsCanViewAllCustomerGlobally,
    final bool? departmentmanagerCanViewAllCustomerGlobally,
    final bool? customerCanDialCallsInTicketChatroom,
    final bool? agentCanReopenTicket,
    final bool? customerCanReopenTicket,
    final bool? customerCanCloseTicket,
    final bool? agentCanScheduleCalls,
    final bool? customerCanViewAgentsListJoinedTicket,
    final bool? secondadmincanseeagentnameandphoto,
    final bool? agentcanseeagentnameandphoto,
    final bool? customercanseeagentnameandphoto,
    final bool? departmentmanagerCanCreateBroadcastToAgents,
    final bool? secondadminCanViewGlobalDepartments,
    final bool? customerCanViewGlobalDepartments,
    final bool? secondAdminCanviewDepartmentStatistics,
    final bool? departmentmanagerCanviewDepartmentStatistics,
    final bool? secondadminCanDeleteDepartment,
    final bool? secondAdminCanEditDepartment,
    final bool? departmentManagerCanEditAddAgentstodepartment,
    final bool? secondAdminCanCreateDepartmentGlobally,
    final bool? departmentManagerCanCreateTicket,
    final bool? secondadminCanViewAllTicketGlobally,
    final bool? agentcanChatWithCustomerInTicket,
    final bool? secondadminCanChatWithCustomerInTicket,
    final bool? departmentmanagerCanChatWithCustomerInTicket,
    final bool? departmentmanagerCanChangeTicketStatus,
    final bool? departmentmanagerCanViewAgentsListJoinedTicket,
    final bool? secondadminCanViewAgentsListJoinedTicket,
    final bool? agentCanViewAgentsListJoinedTicket,
    final bool? secondadminCanScheduleCalls,
    final bool? departmentManagerCanScheduleCalls,
    final bool? agentCanCloseTicket,
    final bool? departmentmanagerCanCloseTicket,
    final bool? secondAdminCanCloseTicket,
    final bool? departmentManagerCanReopenTicket,
    final bool? secondadminCanReopenTicket,
    final bool? viewowntickets,
    final bool? secondadminCanViewAllCustomerGlobally,
    final bool? viewOwnCustomerWithinDepartments,
    final bool? viewOwnAgentsWithinDepartments,
    final bool? secondadminCanViewAllAgentsGlobally,
    final bool? departmentManagerCanSeeOwnDepartmentCustomers,
    final bool? departmentManagerCanSeeOwnDepartmentAgents,
    final bool? isShowHeaderAgentsTab,
    final bool? isShowHeaderCustomersTab,
    final bool? isShowFooterAgentsTab,
    final bool? isShowFooterCustomersTab,
    final bool? exBool89,
    final bool? exBool90,
    final int? personalcalltypeagents,
    final int? notificationtime,
    final int? customerTabIndexPosition,
    final int? agentTabIndexPosition,
    final int? exInt5,
    final int? exInt6,
    final int? exInt7,
    final int? exInt8,
    final int? exInt9,
    final int? exInt10,
    final int? exInt11,
    final int? exInt12,
    final int? exInt13,
    final int? exInt14,
    final int? exInt15,
    final int? exInt16,
    final int? exInt17,
    final int? exInt18,
    final int? exInt19,
    final int? exInt20,
    final int? exInt21,
    final int? exInt22,
    final int? exInt23,
    final int? exInt24,
    final int? exInt25,
    final int? exInt26,
    final int? exInt27,
    final int? exInt28,
    final int? exInt29,
    final int? exInt30,
    final int? exInt31,
    final int? exInt32,
    final int? exInt33,
    final int? exInt34,
    final int? exInt35,
    final int? exInt36,
    final int? exInt37,
    final int? exInt38,
    final int? exInt39,
    final int? exInt40,
    final int? exInt41,
    final int? exInt42,
    final int? exInt43,
    final int? exInt44,
    final int? exInt45,
    final int? exInt46,
    final int? exInt47,
    final int? exInt48,
    final int? exInt49,
    final int? exInt50,
    final int? exInt51,
    final int? exInt52,
    final int? exInt53,
    final int? exInt54,
    final double? exDouble1,
    final double? exDouble2,
    final double? exDouble3,
    final double? exDouble4,
    final double? exDouble5,
    final double? exDouble6,
    final double? exDouble7,
    final double? exDouble8,
    final double? exDouble9,
    final double? exDouble10,
    final bool? exBool100,
    final bool? exBool101,
    final bool? exBool102,
    final bool? exBool103,
    final bool? exBool104,
    final bool? exBool105,
    final bool? exBool106,
    final bool? exBool107,
    final bool? exBool108,
    final bool? exBool109,
    final bool? exBool110,
    final bool? exBool111,
    final bool? exBool112,
    final bool? exBool113,
    final bool? exBool114,
    final bool? exBool115,
    final bool? exBool116,
    final bool? exBool117,
    final bool? exBool118,
    final bool? exBool119,
    final bool? exBool120,
    final bool? exBool121,
    final bool? exBool122,
    final bool? exBool123,
    final bool? exBool124,
    final bool? exBool125,
    final bool? exBool126,
    final bool? exBool127,
    final bool? exBool128,
    final bool? exBool129,
    final bool? exBool130,
    final bool? exBool131,
    final bool? exBool132,
    final bool? exBool133,
    final bool? exBool134,
    final bool? exBool135,
    final bool? exBool136,
    final bool? exBool137,
    final bool? exBool138,
    final bool? exBool139,
    final bool? exBool140,
    final bool? exBool141,
    final bool? exBool142,
    final bool? exBool143,
    final bool? exBool144,
    final bool? exBool145,
    final bool? exBool146,
    final bool? exBool147,
    final bool? exBool148,
    final bool? exBool149,
    final bool? exBool150,
    final bool? exBool151,
    final bool? exBool152,
    final bool? exBool153,
    final bool? exBool154,
    final bool? exBool156,
    final bool? exBool157,
    final bool? exBool158,
    final bool? exBool159,
    final bool? exBool160,
    final bool? exBool161,
    final bool? exBool162,
    final bool? exBool163,
    final bool? exBool164,
    final bool? exBool165,
    final bool? exBool166,
    final bool? exBool167,
    final bool? exBool168,
    final bool? exBool169,
    final bool? exBool170,
    final bool? exBool171,
    final bool? exBool172,
    final bool? exBool173,
    final bool? exBool174,
    final bool? exBool175,
    final bool? exBool176,
    final bool? exBool177,
    final bool? exBool178,
    final bool? exBool179,
    final bool? exBool180,
    final bool? exBool181,
    final bool? exBool182,
    final bool? exBool183,
    final bool? exBool184,
    final bool? exBool185,
    final bool? exBool186,
    final bool? exBool187,
    final bool? exBool188,
    final bool? exBool189,
    final bool? exBool190,
    final bool? exBool191,
    final bool? exBool192,
    final bool? exBool193,
    final bool? exBool194,
    final bool? exBool195,
    final bool? exBool196,
    final bool? exBool197,
    final bool? exBool198,
    final bool? exBool199,
    final bool? exBool200,
    final Map? exMap1,
    final Map? exMap2,
    final Map? exMap3,
    final Map? exMap4,
    final Map? exMap5,
    final Map? exMap6,
    final Map? exMap7,
    final Map? exMap8,
    final Map? exMap9,
    final String? notificationtitle,
    final String? notificationdesc,
    final String? notifcationpostedby,
    final String? agentsLandingCustomTabURL,
    final String? customersLandingCustomTabURL,
    final String? agentCustomTabLabel,
    final String? customerCustomTabLabel,
    final String? exString8,
    final String? exString9,
    final String? exString10,
    final String? exString11,
    final String? exString12,
    final String? exString13,
    final String? exString14,
    final String? exString15,
    final String? exString16,
    final String? exString17,
    final String? exString18,
    final String? exString19,
    final String? exString20,
    final String? exString21,
    final String? exString22,
    final String? exString23,
    final String? exString24,
    final String? exString25,
    final String? exString26,
    final String? exString27,
    final String? exString28,
    final String? exString29,
    final String? exString30,
    final String? exString31,
    final String? exString32,
    final String? exString33,
    final String? exString34,
    //--
    final bool? istextmessageallowed,
    final bool? iscallsallowed,
    final bool? ismediamessageallowed,
    final bool? isadmobshow,
    final bool? isblocknewlogins,
    final bool? isaccountapprovalbyadminneeded,
    final bool? isAllowCreatingGroups,
    final bool? isAllowCreatingBroadcasts,
    final bool? isAllowCreatingStatus,
    final int? statusDeleteAfterInHours,
    final bool? updateV7done,
  }) {
    return UserAppSettingsModel(
      companyName: companyName ?? this.companyName,
      companyLogoUrl: companyLogoUrl ?? this.companyLogoUrl,
      preVerifiedAgents: preVerifiedAgents ?? this.preVerifiedAgents,
      preVerifiedCustomers: preVerifiedCustomers ?? this.preVerifiedCustomers,
      customerUnderReviewAfterEditProfile:
          customerUnderReviewAfterEditProfile ??
              this.customerUnderReviewAfterEditProfile,
      isTwoFactorAuthCompulsoryforAgents: isTwoFactorAuthCompulsoryforAgents ??
          this.isTwoFactorAuthCompulsoryforAgents,
      isTwoFactorAuthCompulsoryforUsers: isTwoFactorAuthCompulsoryforUsers ??
          this.isTwoFactorAuthCompulsoryforUsers,
      agentUnderReviewAfterEditProfile: agentUnderReviewAfterEditProfile ??
          this.agentUnderReviewAfterEditProfile,
      agentsCanSeeCustomerStatisticsProfile:
          agentsCanSeeCustomerStatisticsProfile ??
              this.agentsCanSeeCustomerStatisticsProfile,
      secondadminCanSeeCustomerStatisticsProfile:
          secondadminCanSeeCustomerStatisticsProfile ??
              this.secondadminCanSeeCustomerStatisticsProfile,
      secondadminCanSeeAgentStatisticsProfile:
          secondadminCanSeeAgentStatisticsProfile ??
              this.secondadminCanSeeAgentStatisticsProfile,
      agentCanSeeAgentStatisticsProfile: agentCanSeeAgentStatisticsProfile ??
          this.agentCanSeeAgentStatisticsProfile,
      deleteConversationEnabledInGroup: deleteConversationEnabledInGroup ??
          this.deleteConversationEnabledInGroup,
      agentsCanCreateAgentsGroup:
          agentsCanCreateAgentsGroup ?? this.agentsCanCreateAgentsGroup,
      secondadminCanCreateAgentsGroup: secondadminCanCreateAgentsGroup ??
          this.secondadminCanCreateAgentsGroup,
      isMediaSendingAllowedInGroupChat: isMediaSendingAllowedInGroupChat ??
          this.isMediaSendingAllowedInGroupChat,
      defaultMessageDeletingTimeForGroup: defaultMessageDeletingTimeForGroup ??
          this.defaultMessageDeletingTimeForGroup,
      agentCanCreateBroadcastToAgents: agentCanCreateBroadcastToAgents ??
          this.agentCanCreateBroadcastToAgents,
      secondadminCanCreateBroadcastToAgents:
          secondadminCanCreateBroadcastToAgents ??
              this.secondadminCanCreateBroadcastToAgents,
      agentCancreateandViewNewIndividualChat:
          agentCancreateandViewNewIndividualChat ??
              this.agentCancreateandViewNewIndividualChat,
      secondadminCancreateandViewNewIndividualChat:
          secondadminCancreateandViewNewIndividualChat ??
              this.secondadminCancreateandViewNewIndividualChat,
      defaultMessageDeletingTimeForOneToOneChat:
          defaultMessageDeletingTimeForOneToOneChat ??
              this.defaultMessageDeletingTimeForOneToOneChat,
      isMediaSendingAllowedInOneToOneChat:
          isMediaSendingAllowedInOneToOneChat ??
              this.isMediaSendingAllowedInOneToOneChat,
      deleteConversationEnabledInPersonalChat:
          deleteConversationEnabledInPersonalChat ??
              this.deleteConversationEnabledInPersonalChat,
      agentCanCallAgents: agentCanCallAgents ?? this.agentCanCallAgents,
      secondadminCanCallAgents:
          secondadminCanCallAgents ?? this.secondadminCanCallAgents,
      customerCanSeeAgentNameInTicketCallScreen:
          customerCanSeeAgentNameInTicketCallScreen ??
              this.customerCanSeeAgentNameInTicketCallScreen,
      callTypeForAgents: callTypeForAgents ?? this.callTypeForAgents,
      customerCanCreateTicket:
          customerCanCreateTicket ?? this.customerCanCreateTicket,
      agentCanCreateTicket: agentCanCreateTicket ?? this.agentCanCreateTicket,
      secondadminCanCreateTicket:
          secondadminCanCreateTicket ?? this.secondadminCanCreateTicket,
      customerCanChangeTicketStatus:
          customerCanChangeTicketStatus ?? this.customerCanChangeTicketStatus,
      agentCanChangeTicketStatus:
          agentCanChangeTicketStatus ?? this.agentCanChangeTicketStatus,
      secondadminCanChangeTicketStatus: secondadminCanChangeTicketStatus ??
          this.secondadminCanChangeTicketStatus,
      defaultTicketMssgsDeletingTimeAfterClosing:
          defaultTicketMssgsDeletingTimeAfterClosing ??
              this.defaultTicketMssgsDeletingTimeAfterClosing,
      showIsTypingInTicketChatRoom:
          showIsTypingInTicketChatRoom ?? this.showIsTypingInTicketChatRoom,
      showIsCustomerOnline: showIsCustomerOnline ?? this.showIsCustomerOnline,
      showIsAgentOnline: showIsAgentOnline ?? this.showIsAgentOnline,
      isMediaSendingAllowedInTicketChatRoom:
          isMediaSendingAllowedInTicketChatRoom ??
              this.isMediaSendingAllowedInTicketChatRoom,
      isCallAssigningAllowed:
          isCallAssigningAllowed ?? this.isCallAssigningAllowed,
      callTypeForTicketChatRoom:
          callTypeForTicketChatRoom ?? this.callTypeForTicketChatRoom,
      customerCanRateTicket:
          customerCanRateTicket ?? this.customerCanRateTicket,
      reopenTicketTillDays: reopenTicketTillDays ?? this.reopenTicketTillDays,

      defaultTopicsOnLoginName:
          defaultTopicsOnLoginName ?? this.defaultTopicsOnLoginName,
      departmentBasedContent:
          departmentBasedContent ?? this.departmentBasedContent,
      departmentList: departmentList ?? this.departmentList,
      autocreatesupportticket:
          autocreatesupportticket ?? this.autocreatesupportticket,
      agentCanCreateInvoice:
          agentCanCreateInvoice ?? this.agentCanCreateInvoice,
      secondadminCanCreateInvoice:
          secondadminCanCreateInvoice ?? this.secondadminCanCreateInvoice,
      secondadminCanDeleteBroadcast:
          secondadminCanDeleteBroadcast ?? this.secondadminCanDeleteBroadcast,
      showPaymentsTabInAgentAccount:
          showPaymentsTabInAgentAccount ?? this.showPaymentsTabInAgentAccount,
      showPaymentsTabInCustomerAccount: showPaymentsTabInCustomerAccount ??
          this.showPaymentsTabInCustomerAccount,
      allowedCurrencyList: allowedCurrencyList ?? this.allowedCurrencyList,
      isCustomAppShareLink: isCustomAppShareLink ?? this.isCustomAppShareLink,
      appShareMessageStringAndroid:
          appShareMessageStringAndroid ?? this.appShareMessageStringAndroid,
      appShareMessageStringiOS:
          appShareMessageStringiOS ?? this.appShareMessageStringiOS,
      isLogoutButtonShowInSettingsPage: isLogoutButtonShowInSettingsPage ??
          this.isLogoutButtonShowInSettingsPage,
      maxFileSizeAllowedInMB:
          maxFileSizeAllowedInMB ?? this.maxFileSizeAllowedInMB,
      maxNoOfFilesInMultiSharing:
          maxNoOfFilesInMultiSharing ?? this.maxNoOfFilesInMultiSharing,
      is24hrsTimeformat: is24hrsTimeformat ?? this.is24hrsTimeformat,
      isPercentProgressShowWhileUploading:
          isPercentProgressShowWhileUploading ??
              this.isPercentProgressShowWhileUploading,
      groupMemberslimit: groupMemberslimit ?? this.groupMemberslimit,
      broadcastMemberslimit:
          broadcastMemberslimit ?? this.broadcastMemberslimit,
      feedbackEmail: feedbackEmail ?? this.feedbackEmail,
//-
      demoIDsList: demoIDsList ?? this.demoIDsList,
      exList2: exList2 ?? this.exList2,
      exList3: exList3 ?? this.exList3,
      exList4: exList4 ?? this.exList4,
      exList5: exList5 ?? this.exList5,
      exList6: exList6 ?? this.exList6,
      exList7: exList7 ?? this.exList7,
      exList8: exList8 ?? this.exList8,
      exList9: exList9 ?? this.exList9,
      exList10: exList10 ?? this.exList10,
      exList11: exList11 ?? this.exList11,
      exList12: exList12 ?? this.exList12,
      exbool384: exbool384 ?? this.exbool384,
      exbool1123: exbool1123 ?? this.exbool1123,
      customerCanSeeAgentStatisticsProfile:
          customerCanSeeAgentStatisticsProfile ??
              this.customerCanSeeAgentStatisticsProfile,
      departmentmanagerCancreateandViewNewIndividualChat:
          departmentmanagerCancreateandViewNewIndividualChat ??
              this.departmentmanagerCancreateandViewNewIndividualChat,
      departmentmanagerCanViewGlobalDepartments:
          departmentmanagerCanViewGlobalDepartments ??
              this.departmentmanagerCanViewGlobalDepartments,
      autoJoinNewAgentsToDefaultList:
          autoJoinNewAgentsToDefaultList ?? this.autoJoinNewAgentsToDefaultList,
      secondadminCanViewGloabalBroadcast: secondadminCanViewGloabalBroadcast ??
          this.secondadminCanViewGloabalBroadcast,
      departmentManagerCanCreateAgentsGroup:
          departmentManagerCanCreateAgentsGroup ??
              this.departmentManagerCanCreateAgentsGroup,
      secondadminCanViewAllGlobalChats: secondadminCanViewAllGlobalChats ??
          this.secondadminCanViewAllGlobalChats,
      departmentmanagerCanDeleteBroadcast:
          departmentmanagerCanDeleteBroadcast ??
              this.departmentmanagerCanDeleteBroadcast,
      departmentmanagerCanViewGloabalBroadcast:
          departmentmanagerCanViewGloabalBroadcast ??
              this.departmentmanagerCanViewGloabalBroadcast,
      agentCanViewAllTicketGlobally:
          agentCanViewAllTicketGlobally ?? this.agentCanViewAllTicketGlobally,
      departmentmanagerCanViewAllTicketGlobally:
          departmentmanagerCanViewAllTicketGlobally ??
              this.departmentmanagerCanViewAllTicketGlobally,
      departmentManagerCanViewDepartmentGroups:
          departmentManagerCanViewDepartmentGroups ??
              this.departmentManagerCanViewDepartmentGroups,
      secondadminCanViewDepartmentGroups: secondadminCanViewDepartmentGroups ??
          this.secondadminCanViewDepartmentGroups,
      departmentManagerCanViewAllGlobalgroups:
          departmentManagerCanViewAllGlobalgroups ??
              this.departmentManagerCanViewAllGlobalgroups,
      agentsCanViewGlobalDepartments:
          agentsCanViewGlobalDepartments ?? this.agentsCanViewGlobalDepartments,
      departmentmanagerCanDeleteDepartment:
          departmentmanagerCanDeleteDepartment ??
              this.departmentmanagerCanDeleteDepartment,
      departmentManagerCanCreateDepartmentGlobally:
          departmentManagerCanCreateDepartmentGlobally ??
              this.departmentManagerCanCreateDepartmentGlobally,
      exBool20: exBool20 ?? this.exBool20,
      agentCanDeleteBroadcast:
          agentCanDeleteBroadcast ?? this.agentCanDeleteBroadcast,
      departmentmanagercanseeagentnameandphoto:
          departmentmanagercanseeagentnameandphoto ??
              this.departmentmanagercanseeagentnameandphoto,
      departmentmanagercanseecustomernameandphoto:
          departmentmanagercanseecustomernameandphoto ??
              this.departmentmanagercanseecustomernameandphoto,
      agentcanseecustomernameandphoto: agentcanseecustomernameandphoto ??
          this.agentcanseecustomernameandphoto,
      secondadmincanseecustomernameandphoto:
          secondadmincanseecustomernameandphoto ??
              this.secondadmincanseecustomernameandphoto,
      agentsCanSeeOwnDepartmentACustomer: agentsCanSeeOwnDepartmentACustomer ??
          this.agentsCanSeeOwnDepartmentACustomer,
      agentCanSeeCustomerContactInfo:
          agentCanSeeCustomerContactInfo ?? this.agentCanSeeCustomerContactInfo,
      secondadminCanSeeCustomerContactInfo:
          secondadminCanSeeCustomerContactInfo ??
              this.secondadminCanSeeCustomerContactInfo,
      departmentmanagerCanSeeCustomerStatisticsProfile:
          departmentmanagerCanSeeCustomerStatisticsProfile ??
              this.departmentmanagerCanSeeCustomerStatisticsProfile,
      departmentmanagerCanSeeCustomerContactinfo:
          departmentmanagerCanSeeCustomerContactinfo ??
              this.departmentmanagerCanSeeCustomerContactinfo,
      exbool244: exbool244 ?? this.exbool244,
      secondadminCanSeeCustomerContactinfo:
          secondadminCanSeeCustomerContactinfo ??
              this.secondadminCanSeeCustomerContactinfo,
      departmentmanagerCanSeeAgentStatisticsProfile:
          departmentmanagerCanSeeAgentStatisticsProfile ??
              this.departmentmanagerCanSeeAgentStatisticsProfile,
      secondadminCanSeeAgentContactinfo: secondadminCanSeeAgentContactinfo ??
          this.secondadminCanSeeAgentContactinfo,
      departmentmanagerCanSeeAgentContactinfo:
          departmentmanagerCanSeeAgentContactinfo ??
              this.departmentmanagerCanSeeAgentContactinfo,
      agentCanSeeAgentContactinfo:
          agentCanSeeAgentContactinfo ?? this.agentCanSeeAgentContactinfo,
      customerCanSeeAgentContactinfo:
          customerCanSeeAgentContactinfo ?? this.customerCanSeeAgentContactinfo,
      agentsCanSeeOwnDepartmentAgents: agentsCanSeeOwnDepartmentAgents ??
          this.agentsCanSeeOwnDepartmentAgents,
      departmentManagerCanViewAllGlobalChats:
          departmentManagerCanViewAllGlobalChats ??
              this.departmentManagerCanViewAllGlobalChats,
      departmentmanagerCanViewAllAgentsGlobally:
          departmentmanagerCanViewAllAgentsGlobally ??
              this.departmentmanagerCanViewAllAgentsGlobally,
      agentsCanViewAllAgentsGlobally:
          agentsCanViewAllAgentsGlobally ?? this.agentsCanViewAllAgentsGlobally,
      agentsCanViewAllCustomerGlobally: agentsCanViewAllCustomerGlobally ??
          this.agentsCanViewAllCustomerGlobally,
      departmentmanagerCanViewAllCustomerGlobally:
          departmentmanagerCanViewAllCustomerGlobally ??
              this.departmentmanagerCanViewAllCustomerGlobally,
      customerCanDialCallsInTicketChatroom:
          customerCanDialCallsInTicketChatroom ??
              this.customerCanDialCallsInTicketChatroom,
      agentCanReopenTicket: agentCanReopenTicket ?? this.agentCanReopenTicket,
      customerCanReopenTicket:
          customerCanReopenTicket ?? this.customerCanReopenTicket,
      customerCanCloseTicket:
          customerCanCloseTicket ?? this.customerCanCloseTicket,
      agentCanScheduleCalls:
          agentCanScheduleCalls ?? this.agentCanScheduleCalls,
      customerCanViewAgentsListJoinedTicket:
          customerCanViewAgentsListJoinedTicket ??
              this.customerCanViewAgentsListJoinedTicket,
      secondadmincanseeagentnameandphoto: secondadmincanseeagentnameandphoto ??
          this.secondadmincanseeagentnameandphoto,
      agentcanseeagentnameandphoto:
          agentcanseeagentnameandphoto ?? this.agentcanseeagentnameandphoto,
      customercanseeagentnameandphoto: customercanseeagentnameandphoto ??
          this.customercanseeagentnameandphoto,
      departmentmanagerCanCreateBroadcastToAgents:
          departmentmanagerCanCreateBroadcastToAgents ??
              this.departmentmanagerCanCreateBroadcastToAgents,
      secondadminCanViewGlobalDepartments:
          secondadminCanViewGlobalDepartments ??
              this.secondadminCanViewGlobalDepartments,
      customerCanViewGlobalDepartments: customerCanViewGlobalDepartments ??
          this.customerCanViewGlobalDepartments,
      secondAdminCanviewDepartmentStatistics:
          secondAdminCanviewDepartmentStatistics ??
              this.secondAdminCanviewDepartmentStatistics,
      departmentmanagerCanviewDepartmentStatistics:
          departmentmanagerCanviewDepartmentStatistics ??
              this.departmentmanagerCanviewDepartmentStatistics,
      secondadminCanDeleteDepartment:
          secondadminCanDeleteDepartment ?? this.secondadminCanDeleteDepartment,
      secondAdminCanEditDepartment:
          secondAdminCanEditDepartment ?? this.secondAdminCanEditDepartment,
      departmentManagerCanEditAddAgentstodepartment:
          departmentManagerCanEditAddAgentstodepartment ??
              this.departmentManagerCanEditAddAgentstodepartment,
      secondAdminCanCreateDepartmentGlobally:
          secondAdminCanCreateDepartmentGlobally ??
              this.secondAdminCanCreateDepartmentGlobally,
      departmentManagerCanCreateTicket: departmentManagerCanCreateTicket ??
          this.departmentManagerCanCreateTicket,
      secondadminCanViewAllTicketGlobally:
          secondadminCanViewAllTicketGlobally ??
              this.secondadminCanViewAllTicketGlobally,
      agentcanChatWithCustomerInTicket: agentcanChatWithCustomerInTicket ??
          this.agentcanChatWithCustomerInTicket,
      secondadminCanChatWithCustomerInTicket:
          secondadminCanChatWithCustomerInTicket ??
              this.secondadminCanChatWithCustomerInTicket,
      departmentmanagerCanChatWithCustomerInTicket:
          departmentmanagerCanChatWithCustomerInTicket ??
              this.departmentmanagerCanChatWithCustomerInTicket,
      departmentmanagerCanChangeTicketStatus:
          departmentmanagerCanChangeTicketStatus ??
              this.departmentmanagerCanChangeTicketStatus,
      departmentmanagerCanViewAgentsListJoinedTicket:
          departmentmanagerCanViewAgentsListJoinedTicket ??
              this.departmentmanagerCanViewAgentsListJoinedTicket,
      secondadminCanViewAgentsListJoinedTicket:
          secondadminCanViewAgentsListJoinedTicket ??
              this.secondadminCanViewAgentsListJoinedTicket,
      agentCanViewAgentsListJoinedTicket: agentCanViewAgentsListJoinedTicket ??
          this.agentCanViewAgentsListJoinedTicket,
      secondadminCanScheduleCalls:
          secondadminCanScheduleCalls ?? this.secondadminCanScheduleCalls,
      departmentManagerCanScheduleCalls: departmentManagerCanScheduleCalls ??
          this.departmentManagerCanScheduleCalls,
      agentCanCloseTicket: agentCanCloseTicket ?? this.agentCanCloseTicket,
      departmentmanagerCanCloseTicket: departmentmanagerCanCloseTicket ??
          this.departmentmanagerCanCloseTicket,
      secondAdminCanCloseTicket:
          secondAdminCanCloseTicket ?? this.secondAdminCanCloseTicket,
      departmentManagerCanReopenTicket: departmentManagerCanReopenTicket ??
          this.departmentManagerCanReopenTicket,
      secondadminCanReopenTicket:
          secondadminCanReopenTicket ?? this.secondadminCanReopenTicket,
      viewowntickets: viewowntickets ?? this.viewowntickets,
      secondadminCanViewAllCustomerGlobally:
          secondadminCanViewAllCustomerGlobally ??
              this.secondadminCanViewAllCustomerGlobally,
      viewOwnCustomerWithinDepartments: viewOwnCustomerWithinDepartments ??
          this.viewOwnCustomerWithinDepartments,
      viewOwnAgentsWithinDepartments:
          viewOwnAgentsWithinDepartments ?? this.viewOwnAgentsWithinDepartments,
      secondadminCanViewAllAgentsGlobally:
          secondadminCanViewAllAgentsGlobally ??
              this.secondadminCanViewAllAgentsGlobally,
      departmentManagerCanSeeOwnDepartmentCustomers:
          departmentManagerCanSeeOwnDepartmentCustomers ??
              this.departmentManagerCanSeeOwnDepartmentCustomers,
      departmentManagerCanSeeOwnDepartmentAgents:
          departmentManagerCanSeeOwnDepartmentAgents ??
              this.departmentManagerCanSeeOwnDepartmentAgents,
      isShowHeaderAgentsTab:
          isShowHeaderAgentsTab ?? this.isShowHeaderAgentsTab,
      isShowHeaderCustomersTab:
          isShowHeaderCustomersTab ?? this.isShowHeaderCustomersTab,
      isShowFooterAgentsTab:
          isShowFooterAgentsTab ?? this.isShowFooterAgentsTab,
      isShowFooterCustomersTab:
          isShowFooterCustomersTab ?? this.isShowFooterCustomersTab,
      exBool89: exBool89 ?? this.exBool89,
      exBool90: exBool90 ?? this.exBool90,

      exBool100: exBool100 ?? this.exBool100,
      exBool101: exBool101 ?? this.exBool101,
      exBool102: exBool102 ?? this.exBool102,
      exBool103: exBool103 ?? this.exBool103,
      exBool104: exBool104 ?? this.exBool104,
      exBool105: exBool105 ?? this.exBool105,
      exBool106: exBool106 ?? this.exBool106,
      exBool107: exBool107 ?? this.exBool107,
      exBool108: exBool108 ?? this.exBool108,
      exBool109: exBool109 ?? this.exBool109,
      exBool110: exBool110 ?? this.exBool110,
      exBool111: exBool111 ?? this.exBool111,
      exBool112: exBool112 ?? this.exBool112,
      exBool113: exBool113 ?? this.exBool113,
      exBool114: exBool114 ?? this.exBool114,
      exBool115: exBool115 ?? this.exBool115,
      exBool116: exBool116 ?? this.exBool116,
      exBool117: exBool117 ?? this.exBool117,
      exBool118: exBool118 ?? this.exBool118,
      exBool119: exBool119 ?? this.exBool119,
      exBool120: exBool120 ?? this.exBool120,
      exBool121: exBool121 ?? this.exBool121,
      exBool122: exBool122 ?? this.exBool122,
      exBool123: exBool123 ?? this.exBool123,
      exBool124: exBool124 ?? this.exBool124,
      exBool125: exBool125 ?? this.exBool125,
      exBool126: exBool126 ?? this.exBool126,
      exBool127: exBool127 ?? this.exBool127,
      exBool128: exBool128 ?? this.exBool128,
      exBool129: exBool129 ?? this.exBool129,
      exBool130: exBool130 ?? this.exBool130,
      exBool131: exBool131 ?? this.exBool131,
      exBool132: exBool132 ?? this.exBool132,
      exBool133: exBool133 ?? this.exBool133,
      exBool134: exBool134 ?? this.exBool134,
      exBool135: exBool135 ?? this.exBool135,
      exBool136: exBool136 ?? this.exBool136,
      exBool137: exBool137 ?? this.exBool137,
      exBool138: exBool138 ?? this.exBool138,
      exBool139: exBool139 ?? this.exBool139,
      exBool140: exBool140 ?? this.exBool140,
      exBool141: exBool141 ?? this.exBool141,
      exBool142: exBool142 ?? this.exBool142,
      exBool143: exBool143 ?? this.exBool143,
      exBool144: exBool144 ?? this.exBool144,
      exBool145: exBool145 ?? this.exBool145,
      exBool146: exBool146 ?? this.exBool146,
      exBool147: exBool147 ?? this.exBool147,
      exBool148: exBool148 ?? this.exBool148,
      exBool149: exBool149 ?? this.exBool149,
      exBool150: exBool150 ?? this.exBool150,
      exBool151: exBool151 ?? this.exBool151,
      exBool152: exBool152 ?? this.exBool152,
      exBool153: exBool153 ?? this.exBool153,
      exBool154: exBool154 ?? this.exBool154,
      exBool156: exBool156 ?? this.exBool156,
      exBool157: exBool157 ?? this.exBool157,
      exBool158: exBool158 ?? this.exBool158,
      exBool159: exBool159 ?? this.exBool159,
      exBool160: exBool160 ?? this.exBool160,
      exBool161: exBool161 ?? this.exBool161,
      exBool162: exBool162 ?? this.exBool162,
      exBool163: exBool163 ?? this.exBool163,
      exBool164: exBool164 ?? this.exBool164,
      exBool165: exBool165 ?? this.exBool165,
      exBool166: exBool166 ?? this.exBool166,
      exBool167: exBool167 ?? this.exBool167,
      exBool168: exBool168 ?? this.exBool168,
      exBool169: exBool169 ?? this.exBool169,
      exBool170: exBool170 ?? this.exBool170,
      exBool171: exBool171 ?? this.exBool171,
      exBool172: exBool172 ?? this.exBool172,
      exBool173: exBool173 ?? this.exBool173,
      exBool174: exBool174 ?? this.exBool174,
      exBool175: exBool175 ?? this.exBool175,
      exBool176: exBool176 ?? this.exBool176,
      exBool177: exBool177 ?? this.exBool177,
      exBool178: exBool178 ?? this.exBool178,
      exBool179: exBool179 ?? this.exBool179,
      exBool180: exBool180 ?? this.exBool180,
      exBool181: exBool181 ?? this.exBool181,
      exBool182: exBool182 ?? this.exBool182,
      exBool183: exBool183 ?? this.exBool183,
      exBool184: exBool184 ?? this.exBool184,
      exBool185: exBool185 ?? this.exBool185,
      exBool186: exBool186 ?? this.exBool186,
      exBool187: exBool187 ?? this.exBool187,
      exBool188: exBool188 ?? this.exBool188,
      exBool189: exBool189 ?? this.exBool189,
      exBool190: exBool190 ?? this.exBool190,
      exBool191: exBool191 ?? this.exBool191,
      exBool192: exBool192 ?? this.exBool192,
      exBool193: exBool193 ?? this.exBool193,
      exBool194: exBool194 ?? this.exBool194,
      exBool195: exBool195 ?? this.exBool195,
      exBool196: exBool196 ?? this.exBool196,
      exBool197: exBool197 ?? this.exBool197,
      exBool198: exBool198 ?? this.exBool198,
      exBool199: exBool199 ?? this.exBool199,
      exBool200: exBool200 ?? this.exBool200,

      personalcalltypeagents:
          personalcalltypeagents ?? this.personalcalltypeagents,
      notificationtime: notificationtime ?? this.notificationtime,
      customerTabIndexPosition:
          customerTabIndexPosition ?? this.customerTabIndexPosition,
      agentTabIndexPosition:
          agentTabIndexPosition ?? this.agentTabIndexPosition,
      exInt5: exInt5 ?? this.exInt5,
      exInt6: exInt6 ?? this.exInt6,
      exInt7: exInt7 ?? this.exInt7,
      exInt8: exInt8 ?? this.exInt8,
      exInt9: exInt9 ?? this.exInt9,
      exInt10: exInt10 ?? this.exInt10,
      exInt11: exInt11 ?? this.exInt11,
      exInt12: exInt12 ?? this.exInt12,
      exInt13: exInt13 ?? this.exInt13,
      exInt14: exInt14 ?? this.exInt14,
      exInt15: exInt15 ?? this.exInt15,
      exInt16: exInt16 ?? this.exInt16,
      exInt17: exInt17 ?? this.exInt17,
      exInt18: exInt18 ?? this.exInt18,
      exInt19: exInt19 ?? this.exInt19,
      exInt20: exInt20 ?? this.exInt20,
      exInt21: exInt21 ?? this.exInt21,
      exInt22: exInt22 ?? this.exInt22,
      exInt23: exInt23 ?? this.exInt23,
      exInt24: exInt24 ?? this.exInt24,
      exInt25: exInt25 ?? this.exInt25,
      exInt26: exInt26 ?? this.exInt26,
      exInt27: exInt27 ?? this.exInt27,
      exInt28: exInt28 ?? this.exInt28,
      exInt29: exInt29 ?? this.exInt29,
      exInt30: exInt30 ?? this.exInt30,
      exInt31: exInt31 ?? this.exInt31,
      exInt32: exInt32 ?? this.exInt32,
      exInt33: exInt33 ?? this.exInt33,
      exInt34: exInt34 ?? this.exInt34,
      exInt35: exInt35 ?? this.exInt35,
      exInt36: exInt36 ?? this.exInt36,
      exInt37: exInt37 ?? this.exInt37,
      exInt38: exInt38 ?? this.exInt38,
      exInt39: exInt39 ?? this.exInt39,
      exInt40: exInt40 ?? this.exInt40,
      exInt41: exInt41 ?? this.exInt41,
      exInt42: exInt42 ?? this.exInt42,
      exInt43: exInt43 ?? this.exInt43,
      exInt44: exInt44 ?? this.exInt44,
      exInt45: exInt45 ?? this.exInt45,
      exInt46: exInt46 ?? this.exInt46,
      exInt47: exInt47 ?? this.exInt47,
      exInt48: exInt48 ?? this.exInt48,
      exInt49: exInt49 ?? this.exInt49,
      exInt50: exInt50 ?? this.exInt50,
      exInt51: exInt51 ?? this.exInt51,
      exInt52: exInt52 ?? this.exInt52,
      exInt53: exInt53 ?? this.exInt53,
      exInt54: exInt54 ?? this.exInt54,

      exDouble1: exDouble1 ?? this.exDouble1,
      exDouble2: exDouble2 ?? this.exDouble2,
      exDouble3: exDouble3 ?? this.exDouble3,
      exDouble4: exDouble4 ?? this.exDouble4,
      exDouble5: exDouble5 ?? this.exDouble5,
      exDouble6: exDouble6 ?? this.exDouble6,
      exDouble7: exDouble7 ?? this.exDouble7,
      exDouble8: exDouble8 ?? this.exDouble8,
      exDouble9: exDouble9 ?? this.exDouble9,
      exDouble10: exDouble10 ?? this.exDouble10,
      exMap1: exMap1 ?? this.exMap1,
      exMap2: exMap2 ?? this.exMap2,
      exMap3: exMap3 ?? this.exMap3,
      exMap4: exMap4 ?? this.exMap4,
      exMap5: exMap5 ?? this.exMap5,
      exMap6: exMap6 ?? this.exMap6,
      exMap7: exMap7 ?? this.exMap7,
      exMap8: exMap8 ?? this.exMap8,
      exMap9: exMap9 ?? this.exMap9,
      notificationtitle: notificationtitle ?? this.notificationtitle,
      notificationdesc: notificationdesc ?? this.notificationdesc,
      notifcationpostedby: notifcationpostedby ?? this.notifcationpostedby,
      agentsLandingCustomTabURL:
          agentsLandingCustomTabURL ?? this.agentsLandingCustomTabURL,
      customersLandingCustomTabURL:
          customersLandingCustomTabURL ?? this.customersLandingCustomTabURL,
      agentCustomTabLabel: agentCustomTabLabel ?? this.agentCustomTabLabel,
      customerCustomTabLabel:
          customerCustomTabLabel ?? this.customerCustomTabLabel,
      exString8: exString8 ?? this.exString8,
      exString9: exString9 ?? this.exString9,
      exString10: exString10 ?? this.exString10,
      exString11: exString11 ?? this.exString11,
      exString12: exString12 ?? this.exString12,
      exString13: exString13 ?? this.exString13,
      exString14: exString14 ?? this.exString14,
      exString15: exString15 ?? this.exString15,
      exString16: exString16 ?? this.exString16,
      exString17: exString17 ?? this.exString17,
      exString18: exString18 ?? this.exString18,
      exString19: exString19 ?? this.exString19,
      exString20: exString20 ?? this.exString20,
      exString21: exString21 ?? this.exString21,
      exString22: exString22 ?? this.exString22,
      exString23: exString23 ?? this.exString23,
      exString24: exString24 ?? this.exString24,
      exString25: exString25 ?? this.exString25,
      exString26: exString26 ?? this.exString26,
      exString27: exString27 ?? this.exString27,
      exString28: exString28 ?? this.exString28,
      exString29: exString29 ?? this.exString29,
      exString30: exString30 ?? this.exString30,
      exString31: exString31 ?? this.exString31,
      exString32: exString32 ?? this.exString32,
      exString33: exString33 ?? this.exString33,
      exString34: exString34 ?? this.exString34,

      //-
      istextmessageallowed: istextmessageallowed ?? this.istextmessageallowed,
      iscallsallowed: iscallsallowed ?? this.iscallsallowed,
      ismediamessageallowed:
          ismediamessageallowed ?? this.ismediamessageallowed,

      isAllowCreatingGroups:
          isAllowCreatingGroups ?? this.isAllowCreatingGroups,
      isAllowCreatingBroadcasts:
          isAllowCreatingBroadcasts ?? this.isAllowCreatingBroadcasts,
      isAllowCreatingStatus:
          isAllowCreatingStatus ?? this.isAllowCreatingStatus,
      statusDeleteAfterInHours:
          statusDeleteAfterInHours ?? this.statusDeleteAfterInHours,
      updateV7done: updateV7done ?? this.updateV7done,
      isadmobshow: isadmobshow ?? this.isadmobshow,
    );
  }

  factory UserAppSettingsModel.fromJson(Map<String, dynamic> doc) {
    return UserAppSettingsModel(
      companyName: doc[Dbkeys.companyName],
      companyLogoUrl: doc[Dbkeys.companyLogoUrl],
      preVerifiedAgents: doc[Dbkeys.preVerifiedAgents],
      preVerifiedCustomers: doc[Dbkeys.preVerifiedCustomers],
      customerUnderReviewAfterEditProfile:
          doc[Dbkeys.customerUnderReviewAfterEditProfile],
      isTwoFactorAuthCompulsoryforAgents:
          doc[Dbkeys.isTwoFactorAuthCompulsoryforAgents],
      isTwoFactorAuthCompulsoryforUsers:
          doc[Dbkeys.isTwoFactorAuthCompulsoryforUsers],
      agentUnderReviewAfterEditProfile:
          doc[Dbkeys.agentUnderReviewAfterEditProfile],
      agentsCanSeeCustomerStatisticsProfile:
          doc[Dbkeys.agentsCanSeeCustomerStatisticsProfile],
      secondadminCanSeeCustomerStatisticsProfile:
          doc[Dbkeys.secondadminCanSeeCustomerStatisticsProfile],
      secondadminCanSeeAgentStatisticsProfile:
          doc[Dbkeys.secondadminCanSeeAgentStatisticsProfile],
      agentCanSeeAgentStatisticsProfile:
          doc[Dbkeys.agentCanSeeAgentStatisticsProfile],
      deleteConversationEnabledInGroup:
          doc[Dbkeys.deleteConversationEnabledInGroup],
      agentsCanCreateAgentsGroup: doc[Dbkeys.agentsCanCreateAgentsGroup],
      secondadminCanCreateAgentsGroup:
          doc[Dbkeys.secondadminCanCreateAgentsGroup],
      isMediaSendingAllowedInGroupChat:
          doc[Dbkeys.isMediaSendingAllowedInGroupChat],
      defaultMessageDeletingTimeForGroup:
          doc[Dbkeys.defaultMessageDeletingTimeForGroup],
      agentCanCreateBroadcastToAgents:
          doc[Dbkeys.agentCanCreateBroadcastToAgents],
      secondadminCanCreateBroadcastToAgents:
          doc[Dbkeys.secondadminCanCreateBroadcastToAgents],
      agentCancreateandViewNewIndividualChat:
          doc[Dbkeys.agentCancreateandViewNewIndividualChat],
      secondadminCancreateandViewNewIndividualChat:
          doc[Dbkeys.secondadminCancreateandViewNewIndividualChat],
      defaultMessageDeletingTimeForOneToOneChat:
          doc[Dbkeys.defaultMessageDeletingTimeForOneToOneChat],
      isMediaSendingAllowedInOneToOneChat:
          doc[Dbkeys.isMediaSendingAllowedInOneToOneChat],
      deleteConversationEnabledInPersonalChat:
          doc[Dbkeys.deleteConversationEnabledInPersonalChat],
      agentCanCallAgents: doc[Dbkeys.agentCanCallAgents],
      secondadminCanCallAgents: doc[Dbkeys.secondadminCanCallAgents],
      customerCanSeeAgentNameInTicketCallScreen:
          doc[Dbkeys.customerCanSeeAgentNameInTicketCallScreen],
      callTypeForAgents: doc[Dbkeys.callTypeForAgents],
      customerCanCreateTicket: doc[Dbkeys.customerCanCreateTicket],
      agentCanCreateTicket: doc[Dbkeys.agentCanCreateTicket],
      secondadminCanCreateTicket: doc[Dbkeys.secondadminCanCreateTicket],
      customerCanChangeTicketStatus: doc[Dbkeys.customerCanChangeTicketStatus],
      agentCanChangeTicketStatus: doc[Dbkeys.agentCanChangeTicketStatus],
      secondadminCanChangeTicketStatus:
          doc[Dbkeys.secondadminCanChangeTicketStatus],
      defaultTicketMssgsDeletingTimeAfterClosing:
          doc[Dbkeys.defaultTicketMssgsDeletingTimeAfterClosing],
      showIsTypingInTicketChatRoom: doc[Dbkeys.showIsTypingInTicketChatRoom],
      showIsCustomerOnline: doc[Dbkeys.showIsCustomerOnline],
      showIsAgentOnline: doc[Dbkeys.showIsAgentOnline],
      isMediaSendingAllowedInTicketChatRoom:
          doc[Dbkeys.isMediaSendingAllowedInTicketChatRoom],
      isCallAssigningAllowed: doc[Dbkeys.isCallAssigningAllowed],
      callTypeForTicketChatRoom: doc[Dbkeys.callTypeForTicketChatRoom],
      customerCanRateTicket: doc[Dbkeys.customerCanRateTicket],
      reopenTicketTillDays: doc[Dbkeys.reopenTicketTillDays],

      defaultTopicsOnLoginName: doc[Dbkeys.defaultTopicsOnLoginName],
      departmentBasedContent: doc[Dbkeys.departmentBasedContent],
      departmentList: doc[Dbkeys.departmentList],
      autocreatesupportticket: doc[Dbkeys.autocreatesupportticket],
      agentCanCreateInvoice: doc[Dbkeys.agentCanCreateInvoice],
      secondadminCanCreateInvoice: doc[Dbkeys.secondadminCanCreateInvoice],
      secondadminCanDeleteBroadcast: doc[Dbkeys.secondadminCanDeleteBroadcast],
      showPaymentsTabInAgentAccount: doc[Dbkeys.showPaymentsTabInAgentAccount],
      showPaymentsTabInCustomerAccount:
          doc[Dbkeys.showPaymentsTabInCustomerAccount],
      allowedCurrencyList: doc[Dbkeys.allowedCurrencyList],
      isCustomAppShareLink: doc[Dbkeys.isCustomAppShareLink],
      appShareMessageStringAndroid: doc[Dbkeys.appShareMessageStringAndroid],
      appShareMessageStringiOS: doc[Dbkeys.appShareMessageStringiOS],
      isLogoutButtonShowInSettingsPage:
          doc[Dbkeys.isLogoutButtonShowInSettingsPage],
      maxFileSizeAllowedInMB: doc[Dbkeys.maxFileSizeAllowedInMB],
      maxNoOfFilesInMultiSharing: doc[Dbkeys.maxNoOfFilesInMultiSharing],
      is24hrsTimeformat: doc[Dbkeys.is24hrsTimeformat],
      isPercentProgressShowWhileUploading:
          doc[Dbkeys.isPercentProgressShowWhileUploading],
      groupMemberslimit: doc[Dbkeys.groupMemberslimit],
      broadcastMemberslimit: doc[Dbkeys.broadcastMemberslimit],
      feedbackEmail: doc[Dbkeys.feedbackEmail],
//-------
      demoIDsList: doc[Dbkeys.demoIDsList],
      exList2: doc[Dbkeys.exList2],
      exList3: doc[Dbkeys.exList3],
      exList4: doc[Dbkeys.exList4],
      exList5: doc[Dbkeys.exList5],
      exList6: doc[Dbkeys.exList6],
      exList7: doc[Dbkeys.exList7],
      exList8: doc[Dbkeys.exList8],
      exList9: doc[Dbkeys.exList9],
      exList10: doc[Dbkeys.exList10],
      exList11: doc[Dbkeys.exList11],
      exList12: doc[Dbkeys.exList12],
      exbool384: doc[Dbkeys.exbool384],
      exbool1123: doc[Dbkeys.exbool1123],
      customerCanSeeAgentStatisticsProfile:
          doc[Dbkeys.customerCanSeeAgentStatisticsProfile],
      departmentmanagerCancreateandViewNewIndividualChat:
          doc[Dbkeys.departmentmanagerCancreateandViewNewIndividualChat],
      departmentmanagerCanViewGlobalDepartments:
          doc[Dbkeys.departmentmanagerCanViewGlobalDepartments],
      autoJoinNewAgentsToDefaultList:
          doc[Dbkeys.autoJoinNewAgentsToDefaultList],
      secondadminCanViewGloabalBroadcast:
          doc[Dbkeys.secondadminCanViewGloabalBroadcast],
      departmentManagerCanCreateAgentsGroup:
          doc[Dbkeys.departmentManagerCanCreateAgentsGroup],
      secondadminCanViewAllGlobalChats:
          doc[Dbkeys.secondadminCanViewAllGlobalChats],
      departmentmanagerCanDeleteBroadcast:
          doc[Dbkeys.departmentmanagerCanDeleteBroadcast],
      departmentmanagerCanViewGloabalBroadcast:
          doc[Dbkeys.departmentmanagerCanViewGloabalBroadcast],
      agentCanViewAllTicketGlobally: doc[Dbkeys.agentCanViewAllTicketGlobally],
      departmentmanagerCanViewAllTicketGlobally:
          doc[Dbkeys.departmentmanagerCanViewAllTicketGlobally],
      departmentManagerCanViewDepartmentGroups:
          doc[Dbkeys.departmentManagerCanViewDepartmentGroups],
      secondadminCanViewDepartmentGroups:
          doc[Dbkeys.secondadminCanViewDepartmentGroups],
      departmentManagerCanViewAllGlobalgroups:
          doc[Dbkeys.departmentManagerCanViewAllGlobalgroups],
      agentsCanViewGlobalDepartments:
          doc[Dbkeys.agentsCanViewGlobalDepartments],
      departmentmanagerCanDeleteDepartment:
          doc[Dbkeys.departmentmanagerCanDeleteDepartment],
      departmentManagerCanCreateDepartmentGlobally:
          doc[Dbkeys.departmentManagerCanCreateDepartmentGlobally],
      exBool20: doc[Dbkeys.exBool20],
      agentCanDeleteBroadcast: doc[Dbkeys.agentCanDeleteBroadcast],
      departmentmanagercanseeagentnameandphoto:
          doc[Dbkeys.departmentmanagercanseeagentnameandphoto],
      departmentmanagercanseecustomernameandphoto:
          doc[Dbkeys.departmentmanagercanseecustomernameandphoto],
      agentcanseecustomernameandphoto:
          doc[Dbkeys.agentcanseecustomernameandphoto],
      secondadmincanseecustomernameandphoto:
          doc[Dbkeys.secondadmincanseecustomernameandphoto],
      agentsCanSeeOwnDepartmentACustomer:
          doc[Dbkeys.agentsCanSeeOwnDepartmentACustomer],
      agentCanSeeCustomerContactInfo:
          doc[Dbkeys.agentCanSeeCustomerContactInfo],
      secondadminCanSeeCustomerContactInfo:
          doc[Dbkeys.secondadminCanSeeCustomerContactInfo],
      departmentmanagerCanSeeCustomerStatisticsProfile:
          doc[Dbkeys.departmentmanagerCanSeeCustomerStatisticsProfile],
      departmentmanagerCanSeeCustomerContactinfo:
          doc[Dbkeys.departmentmanagerCanSeeCustomerContactinfo],
      exbool244: doc[Dbkeys.exbool244],
      secondadminCanSeeCustomerContactinfo:
          doc[Dbkeys.secondadminCanSeeCustomerContactinfo],
      departmentmanagerCanSeeAgentStatisticsProfile:
          doc[Dbkeys.departmentmanagerCanSeeAgentStatisticsProfile],
      secondadminCanSeeAgentContactinfo:
          doc[Dbkeys.secondadminCanSeeAgentContactinfo],
      departmentmanagerCanSeeAgentContactinfo:
          doc[Dbkeys.departmentmanagerCanSeeAgentContactinfo],
      agentCanSeeAgentContactinfo: doc[Dbkeys.agentCanSeeAgentContactinfo],
      customerCanSeeAgentContactinfo:
          doc[Dbkeys.customerCanSeeAgentContactinfo],
      agentsCanSeeOwnDepartmentAgents:
          doc[Dbkeys.agentsCanSeeOwnDepartmentAgents],
      departmentManagerCanViewAllGlobalChats:
          doc[Dbkeys.departmentManagerCanViewAllGlobalChats],
      departmentmanagerCanViewAllAgentsGlobally:
          doc[Dbkeys.departmentmanagerCanViewAllAgentsGlobally],
      agentsCanViewAllAgentsGlobally:
          doc[Dbkeys.agentsCanViewAllAgentsGlobally],
      agentsCanViewAllCustomerGlobally:
          doc[Dbkeys.agentsCanViewAllCustomerGlobally],
      departmentmanagerCanViewAllCustomerGlobally:
          doc[Dbkeys.departmentmanagerCanViewAllCustomerGlobally],
      customerCanDialCallsInTicketChatroom:
          doc[Dbkeys.customerCanDialCallsInTicketChatroom],
      agentCanReopenTicket: doc[Dbkeys.agentCanReopenTicket],
      customerCanReopenTicket: doc[Dbkeys.customerCanReopenTicket],
      customerCanCloseTicket: doc[Dbkeys.customerCanCloseTicket],
      agentCanScheduleCalls: doc[Dbkeys.agentCanScheduleCalls],
      customerCanViewAgentsListJoinedTicket:
          doc[Dbkeys.customerCanViewAgentsListJoinedTicket],
      secondadmincanseeagentnameandphoto:
          doc[Dbkeys.secondadmincanseeagentnameandphoto],
      agentcanseeagentnameandphoto: doc[Dbkeys.agentcanseeagentnameandphoto],
      customercanseeagentnameandphoto:
          doc[Dbkeys.customercanseeagentnameandphoto],
      departmentmanagerCanCreateBroadcastToAgents:
          doc[Dbkeys.departmentmanagerCanCreateBroadcastToAgents],
      secondadminCanViewGlobalDepartments:
          doc[Dbkeys.secondadminCanViewGlobalDepartments],
      customerCanViewGlobalDepartments:
          doc[Dbkeys.customerCanViewGlobalDepartments],
      secondAdminCanviewDepartmentStatistics:
          doc[Dbkeys.secondAdminCanviewDepartmentStatistics],
      departmentmanagerCanviewDepartmentStatistics:
          doc[Dbkeys.departmentmanagerCanviewDepartmentStatistics],
      secondadminCanDeleteDepartment:
          doc[Dbkeys.secondadminCanDeleteDepartment],
      secondAdminCanEditDepartment: doc[Dbkeys.secondAdminCanEditDepartment],
      departmentManagerCanEditAddAgentstodepartment:
          doc[Dbkeys.departmentManagerCanEditAddAgentstodepartment],
      secondAdminCanCreateDepartmentGlobally:
          doc[Dbkeys.secondAdminCanCreateDepartmentGlobally],
      departmentManagerCanCreateTicket:
          doc[Dbkeys.departmentManagerCanCreateTicket],
      secondadminCanViewAllTicketGlobally:
          doc[Dbkeys.secondadminCanViewAllTicketGlobally],
      agentcanChatWithCustomerInTicket:
          doc[Dbkeys.agentcanChatWithCustomerInTicket],
      secondadminCanChatWithCustomerInTicket:
          doc[Dbkeys.secondadminCanChatWithCustomerInTicket],
      departmentmanagerCanChatWithCustomerInTicket:
          doc[Dbkeys.departmentmanagerCanChatWithCustomerInTicket],
      departmentmanagerCanChangeTicketStatus:
          doc[Dbkeys.departmentmanagerCanChangeTicketStatus],
      departmentmanagerCanViewAgentsListJoinedTicket:
          doc[Dbkeys.departmentmanagerCanViewAgentsListJoinedTicket],
      secondadminCanViewAgentsListJoinedTicket:
          doc[Dbkeys.secondadminCanViewAgentsListJoinedTicket],
      agentCanViewAgentsListJoinedTicket:
          doc[Dbkeys.agentCanViewAgentsListJoinedTicket],
      secondadminCanScheduleCalls: doc[Dbkeys.secondadminCanScheduleCalls],
      departmentManagerCanScheduleCalls:
          doc[Dbkeys.departmentManagerCanScheduleCalls],
      agentCanCloseTicket: doc[Dbkeys.agentCanCloseTicket],
      departmentmanagerCanCloseTicket:
          doc[Dbkeys.departmentmanagerCanCloseTicket],
      secondAdminCanCloseTicket: doc[Dbkeys.secondAdminCanCloseTicket],
      departmentManagerCanReopenTicket:
          doc[Dbkeys.departmentManagerCanReopenTicket],
      secondadminCanReopenTicket: doc[Dbkeys.secondadminCanReopenTicket],
      viewowntickets: doc[Dbkeys.viewowntickets],
      secondadminCanViewAllCustomerGlobally:
          doc[Dbkeys.secondadminCanViewAllCustomerGlobally],
      viewOwnCustomerWithinDepartments:
          doc[Dbkeys.viewOwnCustomerWithinDepartments],
      viewOwnAgentsWithinDepartments:
          doc[Dbkeys.viewOwnAgentsWithinDepartments],
      secondadminCanViewAllAgentsGlobally:
          doc[Dbkeys.secondadminCanViewAllAgentsGlobally],
      departmentManagerCanSeeOwnDepartmentCustomers:
          doc[Dbkeys.departmentManagerCanSeeOwnDepartmentCustomers],
      departmentManagerCanSeeOwnDepartmentAgents:
          doc[Dbkeys.departmentManagerCanSeeOwnDepartmentAgents],
      isShowHeaderAgentsTab: doc[Dbkeys.isShowHeaderAgentsTab],
      isShowHeaderCustomersTab: doc[Dbkeys.isShowHeaderCustomersTab],
      isShowFooterAgentsTab: doc[Dbkeys.isShowFooterAgentsTab],
      isShowFooterCustomersTab: doc[Dbkeys.isShowFooterCustomersTab],
      exBool89: doc[Dbkeys.exBool89],
      exBool90: doc[Dbkeys.exBool90],

      exBool100: doc[Dbkeys.exBool100],
      exBool101: doc[Dbkeys.exBool101],
      exBool102: doc[Dbkeys.exBool102],
      exBool103: doc[Dbkeys.exBool103],
      exBool104: doc[Dbkeys.exBool104],
      exBool105: doc[Dbkeys.exBool105],
      exBool106: doc[Dbkeys.exBool106],
      exBool107: doc[Dbkeys.exBool107],
      exBool108: doc[Dbkeys.exBool108],
      exBool109: doc[Dbkeys.exBool109],
      exBool110: doc[Dbkeys.exBool110],
      exBool111: doc[Dbkeys.exBool111],
      exBool112: doc[Dbkeys.exBool112],
      exBool113: doc[Dbkeys.exBool113],
      exBool114: doc[Dbkeys.exBool114],
      exBool115: doc[Dbkeys.exBool115],
      exBool116: doc[Dbkeys.exBool116],
      exBool117: doc[Dbkeys.exBool117],
      exBool118: doc[Dbkeys.exBool118],
      exBool119: doc[Dbkeys.exBool119],
      exBool120: doc[Dbkeys.exBool120],
      exBool121: doc[Dbkeys.exBool121],
      exBool122: doc[Dbkeys.exBool122],
      exBool123: doc[Dbkeys.exBool123],
      exBool124: doc[Dbkeys.exBool124],
      exBool125: doc[Dbkeys.exBool125],
      exBool126: doc[Dbkeys.exBool126],
      exBool127: doc[Dbkeys.exBool127],
      exBool128: doc[Dbkeys.exBool128],
      exBool129: doc[Dbkeys.exBool129],
      exBool130: doc[Dbkeys.exBool130],
      exBool131: doc[Dbkeys.exBool131],
      exBool132: doc[Dbkeys.exBool132],
      exBool133: doc[Dbkeys.exBool133],
      exBool134: doc[Dbkeys.exBool134],
      exBool135: doc[Dbkeys.exBool135],
      exBool136: doc[Dbkeys.exBool136],
      exBool137: doc[Dbkeys.exBool137],
      exBool138: doc[Dbkeys.exBool138],
      exBool139: doc[Dbkeys.exBool139],
      exBool140: doc[Dbkeys.exBool140],
      exBool141: doc[Dbkeys.exBool141],
      exBool142: doc[Dbkeys.exBool142],
      exBool143: doc[Dbkeys.exBool143],
      exBool144: doc[Dbkeys.exBool144],
      exBool145: doc[Dbkeys.exBool145],
      exBool146: doc[Dbkeys.exBool146],
      exBool147: doc[Dbkeys.exBool147],
      exBool148: doc[Dbkeys.exBool148],
      exBool149: doc[Dbkeys.exBool149],
      exBool150: doc[Dbkeys.exBool150],
      exBool151: doc[Dbkeys.exBool151],
      exBool152: doc[Dbkeys.exBool152],
      exBool153: doc[Dbkeys.exBool153],
      exBool154: doc[Dbkeys.exBool154],
      exBool156: doc[Dbkeys.exBool156],
      exBool157: doc[Dbkeys.exBool157],
      exBool158: doc[Dbkeys.exBool158],
      exBool159: doc[Dbkeys.exBool159],
      exBool160: doc[Dbkeys.exBool160],
      exBool161: doc[Dbkeys.exBool161],
      exBool162: doc[Dbkeys.exBool162],
      exBool163: doc[Dbkeys.exBool163],
      exBool164: doc[Dbkeys.exBool164],
      exBool165: doc[Dbkeys.exBool165],
      exBool166: doc[Dbkeys.exBool166],
      exBool167: doc[Dbkeys.exBool167],
      exBool168: doc[Dbkeys.exBool168],
      exBool169: doc[Dbkeys.exBool169],
      exBool170: doc[Dbkeys.exBool170],
      exBool171: doc[Dbkeys.exBool171],
      exBool172: doc[Dbkeys.exBool172],
      exBool173: doc[Dbkeys.exBool173],
      exBool174: doc[Dbkeys.exBool174],
      exBool175: doc[Dbkeys.exBool175],
      exBool176: doc[Dbkeys.exBool176],
      exBool177: doc[Dbkeys.exBool177],
      exBool178: doc[Dbkeys.exBool178],
      exBool179: doc[Dbkeys.exBool179],
      exBool180: doc[Dbkeys.exBool180],
      exBool181: doc[Dbkeys.exBool181],
      exBool182: doc[Dbkeys.exBool182],
      exBool183: doc[Dbkeys.exBool183],
      exBool184: doc[Dbkeys.exBool184],
      exBool185: doc[Dbkeys.exBool185],
      exBool186: doc[Dbkeys.exBool186],
      exBool187: doc[Dbkeys.exBool187],
      exBool188: doc[Dbkeys.exBool188],
      exBool189: doc[Dbkeys.exBool189],
      exBool190: doc[Dbkeys.exBool190],
      exBool191: doc[Dbkeys.exBool191],
      exBool192: doc[Dbkeys.exBool192],
      exBool193: doc[Dbkeys.exBool193],
      exBool194: doc[Dbkeys.exBool194],
      exBool195: doc[Dbkeys.exBool195],
      exBool196: doc[Dbkeys.exBool196],
      exBool197: doc[Dbkeys.exBool197],
      exBool198: doc[Dbkeys.exBool198],
      exBool199: doc[Dbkeys.exBool199],
      exBool200: doc[Dbkeys.exBool200],

      notificationtime: doc[Dbkeys.notificationtime],
      customerTabIndexPosition: doc[Dbkeys.customerTabIndexPosition],
      agentTabIndexPosition: doc[Dbkeys.agentTabIndexPosition],
      exInt5: doc[Dbkeys.exInt5],
      exInt6: doc[Dbkeys.exInt6],
      exInt7: doc[Dbkeys.exInt7],
      exInt8: doc[Dbkeys.exInt8],
      exInt9: doc[Dbkeys.exInt9],

      exInt10: doc[Dbkeys.exInt10],
      exInt11: doc[Dbkeys.exInt11],
      exInt12: doc[Dbkeys.exInt12],
      exInt13: doc[Dbkeys.exInt13],
      exInt14: doc[Dbkeys.exInt14],
      exInt15: doc[Dbkeys.exInt15],
      exInt16: doc[Dbkeys.exInt16],
      exInt17: doc[Dbkeys.exInt17],
      exInt18: doc[Dbkeys.exInt18],
      exInt19: doc[Dbkeys.exInt19],
      exInt20: doc[Dbkeys.exInt20],
      exInt21: doc[Dbkeys.exInt21],
      exInt22: doc[Dbkeys.exInt22],
      exInt23: doc[Dbkeys.exInt23],
      exInt24: doc[Dbkeys.exInt24],
      exInt25: doc[Dbkeys.exInt25],
      exInt26: doc[Dbkeys.exInt26],
      exInt27: doc[Dbkeys.exInt27],
      exInt28: doc[Dbkeys.exInt28],
      exInt29: doc[Dbkeys.exInt29],
      exInt30: doc[Dbkeys.exInt30],
      exInt31: doc[Dbkeys.exInt31],
      exInt32: doc[Dbkeys.exInt32],
      exInt33: doc[Dbkeys.exInt33],
      exInt34: doc[Dbkeys.exInt34],
      exInt35: doc[Dbkeys.exInt35],
      exInt36: doc[Dbkeys.exInt36],
      exInt37: doc[Dbkeys.exInt37],
      exInt38: doc[Dbkeys.exInt38],
      exInt39: doc[Dbkeys.exInt39],
      exInt40: doc[Dbkeys.exInt40],
      exInt41: doc[Dbkeys.exInt41],
      exInt42: doc[Dbkeys.exInt42],
      exInt43: doc[Dbkeys.exInt43],
      exInt44: doc[Dbkeys.exInt44],
      exInt45: doc[Dbkeys.exInt45],
      exInt46: doc[Dbkeys.exInt46],
      exInt47: doc[Dbkeys.exInt47],
      exInt48: doc[Dbkeys.exInt48],
      exInt49: doc[Dbkeys.exInt49],
      exInt50: doc[Dbkeys.exInt50],
      exInt51: doc[Dbkeys.exInt51],
      exInt52: doc[Dbkeys.exInt52],
      exInt53: doc[Dbkeys.exInt53],
      exInt54: doc[Dbkeys.exInt54],

      personalcalltypeagents: doc[Dbkeys.personalcalltypeagents],
      exDouble1: doc[Dbkeys.exDouble1],
      exDouble2: doc[Dbkeys.exDouble2],
      exDouble3: doc[Dbkeys.exDouble3],
      exDouble4: doc[Dbkeys.exDouble4],
      exDouble5: doc[Dbkeys.exDouble5],
      exDouble6: doc[Dbkeys.exDouble6],
      exDouble7: doc[Dbkeys.exDouble7],
      exDouble8: doc[Dbkeys.exDouble8],
      exDouble9: doc[Dbkeys.exDouble9],
      exDouble10: doc[Dbkeys.exDouble10],

      exMap1: doc[Dbkeys.exMap1],
      exMap2: doc[Dbkeys.exMap2],
      exMap3: doc[Dbkeys.exMap3],
      exMap4: doc[Dbkeys.exMap4],
      exMap5: doc[Dbkeys.exMap5],
      exMap6: doc[Dbkeys.exMap6],
      exMap7: doc[Dbkeys.exMap7],
      exMap8: doc[Dbkeys.exMap8],
      exMap9: doc[Dbkeys.exMap9],
      notificationtitle: doc[Dbkeys.notificationtitle],
      notificationdesc: doc[Dbkeys.notificationdesc],
      notifcationpostedby: doc[Dbkeys.notifcationpostedby],
      agentsLandingCustomTabURL: doc[Dbkeys.agentsLandingCustomTabURL],
      customersLandingCustomTabURL: doc[Dbkeys.customersLandingCustomTabURL],
      agentCustomTabLabel: doc[Dbkeys.agentCustomTabLabel],
      customerCustomTabLabel: doc[Dbkeys.customerCustomTabLabel],
      exString8: doc[Dbkeys.exString8],
      exString9: doc[Dbkeys.exString9],
      exString10: doc[Dbkeys.exString10],
      exString11: doc[Dbkeys.exString11],
      exString12: doc[Dbkeys.exString12],
      exString13: doc[Dbkeys.exString13],
      exString14: doc[Dbkeys.exString14],
      exString15: doc[Dbkeys.exString15],
      exString16: doc[Dbkeys.exString16],
      exString17: doc[Dbkeys.exString17],
      exString18: doc[Dbkeys.exString18],
      exString19: doc[Dbkeys.exString19],
      exString20: doc[Dbkeys.exString20],
      exString21: doc[Dbkeys.exString21],
      exString22: doc[Dbkeys.exString22],
      exString23: doc[Dbkeys.exString23],
      exString24: doc[Dbkeys.exString24],
      exString25: doc[Dbkeys.exString25],
      exString26: doc[Dbkeys.exString26],
      exString27: doc[Dbkeys.exString27],
      exString28: doc[Dbkeys.exString28],
      exString29: doc[Dbkeys.exString29],
      exString30: doc[Dbkeys.exString30],
      exString31: doc[Dbkeys.exString31],
      exString32: doc[Dbkeys.exString32],
      exString33: doc[Dbkeys.exString33],
      exString34: doc[Dbkeys.exString34],

      istextmessageallowed: doc[Dbkeys.istextmessageallowed],
      iscallsallowed: doc[Dbkeys.iscallsallowed],
      ismediamessageallowed: doc[Dbkeys.ismediamessageallowed],

      isAllowCreatingGroups: doc[Dbkeys.isAllowCreatingGroups],
      isAllowCreatingBroadcasts: doc[Dbkeys.isAllowCreatingBroadcasts],
      isAllowCreatingStatus: doc[Dbkeys.isAllowCreatingStatus],
      statusDeleteAfterInHours: doc[Dbkeys.statusDeleteAfterInHours],
      updateV7done: doc[Dbkeys.updateV7done],
      isadmobshow: doc[Dbkeys.isadmobshow],
    );
  }
  factory UserAppSettingsModel.fromSnapshot(DocumentSnapshot doc) {
    return UserAppSettingsModel(
      companyName: doc[Dbkeys.companyName],
      companyLogoUrl: doc[Dbkeys.companyLogoUrl],
      preVerifiedAgents: doc[Dbkeys.preVerifiedAgents],
      preVerifiedCustomers: doc[Dbkeys.preVerifiedCustomers],
      customerUnderReviewAfterEditProfile:
          doc[Dbkeys.customerUnderReviewAfterEditProfile],
      isTwoFactorAuthCompulsoryforAgents:
          doc[Dbkeys.isTwoFactorAuthCompulsoryforAgents],
      isTwoFactorAuthCompulsoryforUsers:
          doc[Dbkeys.isTwoFactorAuthCompulsoryforUsers],
      agentUnderReviewAfterEditProfile:
          doc[Dbkeys.agentUnderReviewAfterEditProfile],
      agentsCanSeeCustomerStatisticsProfile:
          doc[Dbkeys.agentsCanSeeCustomerStatisticsProfile],
      secondadminCanSeeCustomerStatisticsProfile:
          doc[Dbkeys.secondadminCanSeeCustomerStatisticsProfile],
      secondadminCanSeeAgentStatisticsProfile:
          doc[Dbkeys.secondadminCanSeeAgentStatisticsProfile],
      agentCanSeeAgentStatisticsProfile:
          doc[Dbkeys.agentCanSeeAgentStatisticsProfile],
      deleteConversationEnabledInGroup:
          doc[Dbkeys.deleteConversationEnabledInGroup],
      agentsCanCreateAgentsGroup: doc[Dbkeys.agentsCanCreateAgentsGroup],
      secondadminCanCreateAgentsGroup:
          doc[Dbkeys.secondadminCanCreateAgentsGroup],
      isMediaSendingAllowedInGroupChat:
          doc[Dbkeys.isMediaSendingAllowedInGroupChat],
      defaultMessageDeletingTimeForGroup:
          doc[Dbkeys.defaultMessageDeletingTimeForGroup],
      agentCanCreateBroadcastToAgents:
          doc[Dbkeys.agentCanCreateBroadcastToAgents],
      secondadminCanCreateBroadcastToAgents:
          doc[Dbkeys.secondadminCanCreateBroadcastToAgents],
      agentCancreateandViewNewIndividualChat:
          doc[Dbkeys.agentCancreateandViewNewIndividualChat],
      secondadminCancreateandViewNewIndividualChat:
          doc[Dbkeys.secondadminCancreateandViewNewIndividualChat],
      defaultMessageDeletingTimeForOneToOneChat:
          doc[Dbkeys.defaultMessageDeletingTimeForOneToOneChat],
      isMediaSendingAllowedInOneToOneChat:
          doc[Dbkeys.isMediaSendingAllowedInOneToOneChat],
      deleteConversationEnabledInPersonalChat:
          doc[Dbkeys.deleteConversationEnabledInPersonalChat],
      agentCanCallAgents: doc[Dbkeys.agentCanCallAgents],
      secondadminCanCallAgents: doc[Dbkeys.secondadminCanCallAgents],
      customerCanSeeAgentNameInTicketCallScreen:
          doc[Dbkeys.customerCanSeeAgentNameInTicketCallScreen],
      callTypeForAgents: doc[Dbkeys.callTypeForAgents],
      customerCanCreateTicket: doc[Dbkeys.customerCanCreateTicket],
      agentCanCreateTicket: doc[Dbkeys.agentCanCreateTicket],
      secondadminCanCreateTicket: doc[Dbkeys.secondadminCanCreateTicket],
      customerCanChangeTicketStatus: doc[Dbkeys.customerCanChangeTicketStatus],
      agentCanChangeTicketStatus: doc[Dbkeys.agentCanChangeTicketStatus],
      secondadminCanChangeTicketStatus:
          doc[Dbkeys.secondadminCanChangeTicketStatus],
      defaultTicketMssgsDeletingTimeAfterClosing:
          doc[Dbkeys.defaultTicketMssgsDeletingTimeAfterClosing],
      showIsTypingInTicketChatRoom: doc[Dbkeys.showIsTypingInTicketChatRoom],
      showIsCustomerOnline: doc[Dbkeys.showIsCustomerOnline],
      showIsAgentOnline: doc[Dbkeys.showIsAgentOnline],
      isMediaSendingAllowedInTicketChatRoom:
          doc[Dbkeys.isMediaSendingAllowedInTicketChatRoom],
      isCallAssigningAllowed: doc[Dbkeys.isCallAssigningAllowed],
      callTypeForTicketChatRoom: doc[Dbkeys.callTypeForTicketChatRoom],
      customerCanRateTicket: doc[Dbkeys.customerCanRateTicket],
      reopenTicketTillDays: doc[Dbkeys.reopenTicketTillDays],

      defaultTopicsOnLoginName: doc[Dbkeys.defaultTopicsOnLoginName],
      departmentBasedContent: doc[Dbkeys.departmentBasedContent],
      departmentList: doc[Dbkeys.departmentList],
      autocreatesupportticket: doc[Dbkeys.autocreatesupportticket],
      agentCanCreateInvoice: doc[Dbkeys.agentCanCreateInvoice],
      secondadminCanCreateInvoice: doc[Dbkeys.secondadminCanCreateInvoice],
      secondadminCanDeleteBroadcast: doc[Dbkeys.secondadminCanDeleteBroadcast],
      showPaymentsTabInAgentAccount: doc[Dbkeys.showPaymentsTabInAgentAccount],
      showPaymentsTabInCustomerAccount:
          doc[Dbkeys.showPaymentsTabInCustomerAccount],
      allowedCurrencyList: doc[Dbkeys.allowedCurrencyList],
      isCustomAppShareLink: doc[Dbkeys.isCustomAppShareLink],
      appShareMessageStringAndroid: doc[Dbkeys.appShareMessageStringAndroid],
      appShareMessageStringiOS: doc[Dbkeys.appShareMessageStringiOS],
      isLogoutButtonShowInSettingsPage:
          doc[Dbkeys.isLogoutButtonShowInSettingsPage],
      maxFileSizeAllowedInMB: doc[Dbkeys.maxFileSizeAllowedInMB],
      maxNoOfFilesInMultiSharing: doc[Dbkeys.maxNoOfFilesInMultiSharing],
      is24hrsTimeformat: doc[Dbkeys.is24hrsTimeformat],
      isPercentProgressShowWhileUploading:
          doc[Dbkeys.isPercentProgressShowWhileUploading],
      groupMemberslimit: doc[Dbkeys.groupMemberslimit],
      broadcastMemberslimit: doc[Dbkeys.broadcastMemberslimit],
      feedbackEmail: doc[Dbkeys.feedbackEmail],
//-------
      demoIDsList: doc[Dbkeys.demoIDsList],
      exList2: doc[Dbkeys.exList2],
      exList3: doc[Dbkeys.exList3],
      exList4: doc[Dbkeys.exList4],
      exList5: doc[Dbkeys.exList5],
      exList6: doc[Dbkeys.exList6],
      exList7: doc[Dbkeys.exList7],
      exList8: doc[Dbkeys.exList8],
      exList9: doc[Dbkeys.exList9],
      exList10: doc[Dbkeys.exList10],
      exList11: doc[Dbkeys.exList11],
      exList12: doc[Dbkeys.exList12],
      exbool384: doc[Dbkeys.exbool384],
      exbool1123: doc[Dbkeys.exbool1123],
      customerCanSeeAgentStatisticsProfile:
          doc[Dbkeys.customerCanSeeAgentStatisticsProfile],
      departmentmanagerCancreateandViewNewIndividualChat:
          doc[Dbkeys.departmentmanagerCancreateandViewNewIndividualChat],
      departmentmanagerCanViewGlobalDepartments:
          doc[Dbkeys.departmentmanagerCanViewGlobalDepartments],
      autoJoinNewAgentsToDefaultList:
          doc[Dbkeys.autoJoinNewAgentsToDefaultList],
      secondadminCanViewGloabalBroadcast:
          doc[Dbkeys.secondadminCanViewGloabalBroadcast],
      departmentManagerCanCreateAgentsGroup:
          doc[Dbkeys.departmentManagerCanCreateAgentsGroup],
      secondadminCanViewAllGlobalChats:
          doc[Dbkeys.secondadminCanViewAllGlobalChats],
      departmentmanagerCanDeleteBroadcast:
          doc[Dbkeys.departmentmanagerCanDeleteBroadcast],
      departmentmanagerCanViewGloabalBroadcast:
          doc[Dbkeys.departmentmanagerCanViewGloabalBroadcast],
      agentCanViewAllTicketGlobally: doc[Dbkeys.agentCanViewAllTicketGlobally],
      departmentmanagerCanViewAllTicketGlobally:
          doc[Dbkeys.departmentmanagerCanViewAllTicketGlobally],
      departmentManagerCanViewDepartmentGroups:
          doc[Dbkeys.departmentManagerCanViewDepartmentGroups],
      secondadminCanViewDepartmentGroups:
          doc[Dbkeys.secondadminCanViewDepartmentGroups],
      departmentManagerCanViewAllGlobalgroups:
          doc[Dbkeys.departmentManagerCanViewAllGlobalgroups],
      agentsCanViewGlobalDepartments:
          doc[Dbkeys.agentsCanViewGlobalDepartments],
      departmentmanagerCanDeleteDepartment:
          doc[Dbkeys.departmentmanagerCanDeleteDepartment],
      departmentManagerCanCreateDepartmentGlobally:
          doc[Dbkeys.departmentManagerCanCreateDepartmentGlobally],
      exBool20: doc[Dbkeys.exBool20],
      agentCanDeleteBroadcast: doc[Dbkeys.agentCanDeleteBroadcast],
      departmentmanagercanseeagentnameandphoto:
          doc[Dbkeys.departmentmanagercanseeagentnameandphoto],
      departmentmanagercanseecustomernameandphoto:
          doc[Dbkeys.departmentmanagercanseecustomernameandphoto],
      agentcanseecustomernameandphoto:
          doc[Dbkeys.agentcanseecustomernameandphoto],
      secondadmincanseecustomernameandphoto:
          doc[Dbkeys.secondadmincanseecustomernameandphoto],
      agentsCanSeeOwnDepartmentACustomer:
          doc[Dbkeys.agentsCanSeeOwnDepartmentACustomer],
      agentCanSeeCustomerContactInfo:
          doc[Dbkeys.agentCanSeeCustomerContactInfo],
      secondadminCanSeeCustomerContactInfo:
          doc[Dbkeys.secondadminCanSeeCustomerContactInfo],
      departmentmanagerCanSeeCustomerStatisticsProfile:
          doc[Dbkeys.departmentmanagerCanSeeCustomerStatisticsProfile],
      departmentmanagerCanSeeCustomerContactinfo:
          doc[Dbkeys.departmentmanagerCanSeeCustomerContactinfo],
      exbool244: doc[Dbkeys.exbool244],
      secondadminCanSeeCustomerContactinfo:
          doc[Dbkeys.secondadminCanSeeCustomerContactinfo],
      departmentmanagerCanSeeAgentStatisticsProfile:
          doc[Dbkeys.departmentmanagerCanSeeAgentStatisticsProfile],
      secondadminCanSeeAgentContactinfo:
          doc[Dbkeys.secondadminCanSeeAgentContactinfo],
      departmentmanagerCanSeeAgentContactinfo:
          doc[Dbkeys.departmentmanagerCanSeeAgentContactinfo],
      agentCanSeeAgentContactinfo: doc[Dbkeys.agentCanSeeAgentContactinfo],
      customerCanSeeAgentContactinfo:
          doc[Dbkeys.customerCanSeeAgentContactinfo],
      agentsCanSeeOwnDepartmentAgents:
          doc[Dbkeys.agentsCanSeeOwnDepartmentAgents],
      departmentManagerCanViewAllGlobalChats:
          doc[Dbkeys.departmentManagerCanViewAllGlobalChats],
      departmentmanagerCanViewAllAgentsGlobally:
          doc[Dbkeys.departmentmanagerCanViewAllAgentsGlobally],
      agentsCanViewAllAgentsGlobally:
          doc[Dbkeys.agentsCanViewAllAgentsGlobally],
      agentsCanViewAllCustomerGlobally:
          doc[Dbkeys.agentsCanViewAllCustomerGlobally],
      departmentmanagerCanViewAllCustomerGlobally:
          doc[Dbkeys.departmentmanagerCanViewAllCustomerGlobally],
      customerCanDialCallsInTicketChatroom:
          doc[Dbkeys.customerCanDialCallsInTicketChatroom],
      agentCanReopenTicket: doc[Dbkeys.agentCanReopenTicket],
      customerCanReopenTicket: doc[Dbkeys.customerCanReopenTicket],
      customerCanCloseTicket: doc[Dbkeys.customerCanCloseTicket],
      agentCanScheduleCalls: doc[Dbkeys.agentCanScheduleCalls],
      customerCanViewAgentsListJoinedTicket:
          doc[Dbkeys.customerCanViewAgentsListJoinedTicket],
      secondadmincanseeagentnameandphoto:
          doc[Dbkeys.secondadmincanseeagentnameandphoto],
      agentcanseeagentnameandphoto: doc[Dbkeys.agentcanseeagentnameandphoto],
      customercanseeagentnameandphoto:
          doc[Dbkeys.customercanseeagentnameandphoto],
      departmentmanagerCanCreateBroadcastToAgents:
          doc[Dbkeys.departmentmanagerCanCreateBroadcastToAgents],
      secondadminCanViewGlobalDepartments:
          doc[Dbkeys.secondadminCanViewGlobalDepartments],
      customerCanViewGlobalDepartments:
          doc[Dbkeys.customerCanViewGlobalDepartments],
      secondAdminCanviewDepartmentStatistics:
          doc[Dbkeys.secondAdminCanviewDepartmentStatistics],
      departmentmanagerCanviewDepartmentStatistics:
          doc[Dbkeys.departmentmanagerCanviewDepartmentStatistics],
      secondadminCanDeleteDepartment:
          doc[Dbkeys.secondadminCanDeleteDepartment],
      secondAdminCanEditDepartment: doc[Dbkeys.secondAdminCanEditDepartment],
      departmentManagerCanEditAddAgentstodepartment:
          doc[Dbkeys.departmentManagerCanEditAddAgentstodepartment],
      secondAdminCanCreateDepartmentGlobally:
          doc[Dbkeys.secondAdminCanCreateDepartmentGlobally],
      departmentManagerCanCreateTicket:
          doc[Dbkeys.departmentManagerCanCreateTicket],
      secondadminCanViewAllTicketGlobally:
          doc[Dbkeys.secondadminCanViewAllTicketGlobally],
      agentcanChatWithCustomerInTicket:
          doc[Dbkeys.agentcanChatWithCustomerInTicket],
      secondadminCanChatWithCustomerInTicket:
          doc[Dbkeys.secondadminCanChatWithCustomerInTicket],
      departmentmanagerCanChatWithCustomerInTicket:
          doc[Dbkeys.departmentmanagerCanChatWithCustomerInTicket],
      departmentmanagerCanChangeTicketStatus:
          doc[Dbkeys.departmentmanagerCanChangeTicketStatus],
      departmentmanagerCanViewAgentsListJoinedTicket:
          doc[Dbkeys.departmentmanagerCanViewAgentsListJoinedTicket],
      secondadminCanViewAgentsListJoinedTicket:
          doc[Dbkeys.secondadminCanViewAgentsListJoinedTicket],
      agentCanViewAgentsListJoinedTicket:
          doc[Dbkeys.agentCanViewAgentsListJoinedTicket],
      secondadminCanScheduleCalls: doc[Dbkeys.secondadminCanScheduleCalls],
      departmentManagerCanScheduleCalls:
          doc[Dbkeys.departmentManagerCanScheduleCalls],
      agentCanCloseTicket: doc[Dbkeys.agentCanCloseTicket],
      departmentmanagerCanCloseTicket:
          doc[Dbkeys.departmentmanagerCanCloseTicket],
      secondAdminCanCloseTicket: doc[Dbkeys.secondAdminCanCloseTicket],
      departmentManagerCanReopenTicket:
          doc[Dbkeys.departmentManagerCanReopenTicket],
      secondadminCanReopenTicket: doc[Dbkeys.secondadminCanReopenTicket],
      viewowntickets: doc[Dbkeys.viewowntickets],
      secondadminCanViewAllCustomerGlobally:
          doc[Dbkeys.secondadminCanViewAllCustomerGlobally],
      viewOwnCustomerWithinDepartments:
          doc[Dbkeys.viewOwnCustomerWithinDepartments],
      viewOwnAgentsWithinDepartments:
          doc[Dbkeys.viewOwnAgentsWithinDepartments],
      secondadminCanViewAllAgentsGlobally:
          doc[Dbkeys.secondadminCanViewAllAgentsGlobally],
      departmentManagerCanSeeOwnDepartmentCustomers:
          doc[Dbkeys.departmentManagerCanSeeOwnDepartmentCustomers],
      departmentManagerCanSeeOwnDepartmentAgents:
          doc[Dbkeys.departmentManagerCanSeeOwnDepartmentAgents],
      isShowHeaderAgentsTab: doc[Dbkeys.isShowHeaderAgentsTab],
      isShowHeaderCustomersTab: doc[Dbkeys.isShowHeaderCustomersTab],
      isShowFooterAgentsTab: doc[Dbkeys.isShowFooterAgentsTab],
      isShowFooterCustomersTab: doc[Dbkeys.isShowFooterCustomersTab],
      exBool89: doc[Dbkeys.exBool89],
      exBool90: doc[Dbkeys.exBool90],

      exBool100: doc[Dbkeys.exBool100],
      exBool101: doc[Dbkeys.exBool101],
      exBool102: doc[Dbkeys.exBool102],
      exBool103: doc[Dbkeys.exBool103],
      exBool104: doc[Dbkeys.exBool104],
      exBool105: doc[Dbkeys.exBool105],
      exBool106: doc[Dbkeys.exBool106],
      exBool107: doc[Dbkeys.exBool107],
      exBool108: doc[Dbkeys.exBool108],
      exBool109: doc[Dbkeys.exBool109],
      exBool110: doc[Dbkeys.exBool110],
      exBool111: doc[Dbkeys.exBool111],
      exBool112: doc[Dbkeys.exBool112],
      exBool113: doc[Dbkeys.exBool113],
      exBool114: doc[Dbkeys.exBool114],
      exBool115: doc[Dbkeys.exBool115],
      exBool116: doc[Dbkeys.exBool116],
      exBool117: doc[Dbkeys.exBool117],
      exBool118: doc[Dbkeys.exBool118],
      exBool119: doc[Dbkeys.exBool119],
      exBool120: doc[Dbkeys.exBool120],
      exBool121: doc[Dbkeys.exBool121],
      exBool122: doc[Dbkeys.exBool122],
      exBool123: doc[Dbkeys.exBool123],
      exBool124: doc[Dbkeys.exBool124],
      exBool125: doc[Dbkeys.exBool125],
      exBool126: doc[Dbkeys.exBool126],
      exBool127: doc[Dbkeys.exBool127],
      exBool128: doc[Dbkeys.exBool128],
      exBool129: doc[Dbkeys.exBool129],
      exBool130: doc[Dbkeys.exBool130],
      exBool131: doc[Dbkeys.exBool131],
      exBool132: doc[Dbkeys.exBool132],
      exBool133: doc[Dbkeys.exBool133],
      exBool134: doc[Dbkeys.exBool134],
      exBool135: doc[Dbkeys.exBool135],
      exBool136: doc[Dbkeys.exBool136],
      exBool137: doc[Dbkeys.exBool137],
      exBool138: doc[Dbkeys.exBool138],
      exBool139: doc[Dbkeys.exBool139],
      exBool140: doc[Dbkeys.exBool140],
      exBool141: doc[Dbkeys.exBool141],
      exBool142: doc[Dbkeys.exBool142],
      exBool143: doc[Dbkeys.exBool143],
      exBool144: doc[Dbkeys.exBool144],
      exBool145: doc[Dbkeys.exBool145],
      exBool146: doc[Dbkeys.exBool146],
      exBool147: doc[Dbkeys.exBool147],
      exBool148: doc[Dbkeys.exBool148],
      exBool149: doc[Dbkeys.exBool149],
      exBool150: doc[Dbkeys.exBool150],
      exBool151: doc[Dbkeys.exBool151],
      exBool152: doc[Dbkeys.exBool152],
      exBool153: doc[Dbkeys.exBool153],
      exBool154: doc[Dbkeys.exBool154],
      exBool156: doc[Dbkeys.exBool156],
      exBool157: doc[Dbkeys.exBool157],
      exBool158: doc[Dbkeys.exBool158],
      exBool159: doc[Dbkeys.exBool159],
      exBool160: doc[Dbkeys.exBool160],
      exBool161: doc[Dbkeys.exBool161],
      exBool162: doc[Dbkeys.exBool162],
      exBool163: doc[Dbkeys.exBool163],
      exBool164: doc[Dbkeys.exBool164],
      exBool165: doc[Dbkeys.exBool165],
      exBool166: doc[Dbkeys.exBool166],
      exBool167: doc[Dbkeys.exBool167],
      exBool168: doc[Dbkeys.exBool168],
      exBool169: doc[Dbkeys.exBool169],
      exBool170: doc[Dbkeys.exBool170],
      exBool171: doc[Dbkeys.exBool171],
      exBool172: doc[Dbkeys.exBool172],
      exBool173: doc[Dbkeys.exBool173],
      exBool174: doc[Dbkeys.exBool174],
      exBool175: doc[Dbkeys.exBool175],
      exBool176: doc[Dbkeys.exBool176],
      exBool177: doc[Dbkeys.exBool177],
      exBool178: doc[Dbkeys.exBool178],
      exBool179: doc[Dbkeys.exBool179],
      exBool180: doc[Dbkeys.exBool180],
      exBool181: doc[Dbkeys.exBool181],
      exBool182: doc[Dbkeys.exBool182],
      exBool183: doc[Dbkeys.exBool183],
      exBool184: doc[Dbkeys.exBool184],
      exBool185: doc[Dbkeys.exBool185],
      exBool186: doc[Dbkeys.exBool186],
      exBool187: doc[Dbkeys.exBool187],
      exBool188: doc[Dbkeys.exBool188],
      exBool189: doc[Dbkeys.exBool189],
      exBool190: doc[Dbkeys.exBool190],
      exBool191: doc[Dbkeys.exBool191],
      exBool192: doc[Dbkeys.exBool192],
      exBool193: doc[Dbkeys.exBool193],
      exBool194: doc[Dbkeys.exBool194],
      exBool195: doc[Dbkeys.exBool195],
      exBool196: doc[Dbkeys.exBool196],
      exBool197: doc[Dbkeys.exBool197],
      exBool198: doc[Dbkeys.exBool198],
      exBool199: doc[Dbkeys.exBool199],
      exBool200: doc[Dbkeys.exBool200],

      notificationtime: doc[Dbkeys.notificationtime],
      customerTabIndexPosition: doc[Dbkeys.customerTabIndexPosition],
      agentTabIndexPosition: doc[Dbkeys.agentTabIndexPosition],
      exInt5: doc[Dbkeys.exInt5],
      exInt6: doc[Dbkeys.exInt6],
      exInt7: doc[Dbkeys.exInt7],
      exInt8: doc[Dbkeys.exInt8],
      exInt9: doc[Dbkeys.exInt9],

      exInt10: doc[Dbkeys.exInt10],
      exInt11: doc[Dbkeys.exInt11],
      exInt12: doc[Dbkeys.exInt12],
      exInt13: doc[Dbkeys.exInt13],
      exInt14: doc[Dbkeys.exInt14],
      exInt15: doc[Dbkeys.exInt15],
      exInt16: doc[Dbkeys.exInt16],
      exInt17: doc[Dbkeys.exInt17],
      exInt18: doc[Dbkeys.exInt18],
      exInt19: doc[Dbkeys.exInt19],
      exInt20: doc[Dbkeys.exInt20],
      exInt21: doc[Dbkeys.exInt21],
      exInt22: doc[Dbkeys.exInt22],
      exInt23: doc[Dbkeys.exInt23],
      exInt24: doc[Dbkeys.exInt24],
      exInt25: doc[Dbkeys.exInt25],
      exInt26: doc[Dbkeys.exInt26],
      exInt27: doc[Dbkeys.exInt27],
      exInt28: doc[Dbkeys.exInt28],
      exInt29: doc[Dbkeys.exInt29],
      exInt30: doc[Dbkeys.exInt30],
      exInt31: doc[Dbkeys.exInt31],
      exInt32: doc[Dbkeys.exInt32],
      exInt33: doc[Dbkeys.exInt33],
      exInt34: doc[Dbkeys.exInt34],
      exInt35: doc[Dbkeys.exInt35],
      exInt36: doc[Dbkeys.exInt36],
      exInt37: doc[Dbkeys.exInt37],
      exInt38: doc[Dbkeys.exInt38],
      exInt39: doc[Dbkeys.exInt39],
      exInt40: doc[Dbkeys.exInt40],
      exInt41: doc[Dbkeys.exInt41],
      exInt42: doc[Dbkeys.exInt42],
      exInt43: doc[Dbkeys.exInt43],
      exInt44: doc[Dbkeys.exInt44],
      exInt45: doc[Dbkeys.exInt45],
      exInt46: doc[Dbkeys.exInt46],
      exInt47: doc[Dbkeys.exInt47],
      exInt48: doc[Dbkeys.exInt48],
      exInt49: doc[Dbkeys.exInt49],
      exInt50: doc[Dbkeys.exInt50],
      exInt51: doc[Dbkeys.exInt51],
      exInt52: doc[Dbkeys.exInt52],
      exInt53: doc[Dbkeys.exInt53],
      exInt54: doc[Dbkeys.exInt54],

      personalcalltypeagents: doc[Dbkeys.personalcalltypeagents],
      exDouble1: doc[Dbkeys.exDouble1],
      exDouble2: doc[Dbkeys.exDouble2],
      exDouble3: doc[Dbkeys.exDouble3],
      exDouble4: doc[Dbkeys.exDouble4],
      exDouble5: doc[Dbkeys.exDouble5],
      exDouble6: doc[Dbkeys.exDouble6],
      exDouble7: doc[Dbkeys.exDouble7],
      exDouble8: doc[Dbkeys.exDouble8],
      exDouble9: doc[Dbkeys.exDouble9],
      exDouble10: doc[Dbkeys.exDouble10],

      exMap1: doc[Dbkeys.exMap1],
      exMap2: doc[Dbkeys.exMap2],
      exMap3: doc[Dbkeys.exMap3],
      exMap4: doc[Dbkeys.exMap4],
      exMap5: doc[Dbkeys.exMap5],
      exMap6: doc[Dbkeys.exMap6],
      exMap7: doc[Dbkeys.exMap7],
      exMap8: doc[Dbkeys.exMap8],
      exMap9: doc[Dbkeys.exMap9],
      notificationtitle: doc[Dbkeys.notificationtitle],
      notificationdesc: doc[Dbkeys.notificationdesc],
      notifcationpostedby: doc[Dbkeys.notifcationpostedby],
      agentsLandingCustomTabURL: doc[Dbkeys.agentsLandingCustomTabURL],
      customersLandingCustomTabURL: doc[Dbkeys.customersLandingCustomTabURL],
      agentCustomTabLabel: doc[Dbkeys.agentCustomTabLabel],
      customerCustomTabLabel: doc[Dbkeys.customerCustomTabLabel],
      exString8: doc[Dbkeys.exString8],
      exString9: doc[Dbkeys.exString9],
      exString10: doc[Dbkeys.exString10],
      exString11: doc[Dbkeys.exString11],
      exString12: doc[Dbkeys.exString12],
      exString13: doc[Dbkeys.exString13],
      exString14: doc[Dbkeys.exString14],
      exString15: doc[Dbkeys.exString15],
      exString16: doc[Dbkeys.exString16],
      exString17: doc[Dbkeys.exString17],
      exString18: doc[Dbkeys.exString18],
      exString19: doc[Dbkeys.exString19],
      exString20: doc[Dbkeys.exString20],
      exString21: doc[Dbkeys.exString21],
      exString22: doc[Dbkeys.exString22],
      exString23: doc[Dbkeys.exString23],
      exString24: doc[Dbkeys.exString24],
      exString25: doc[Dbkeys.exString25],
      exString26: doc[Dbkeys.exString26],
      exString27: doc[Dbkeys.exString27],
      exString28: doc[Dbkeys.exString28],
      exString29: doc[Dbkeys.exString29],
      exString30: doc[Dbkeys.exString30],
      exString31: doc[Dbkeys.exString31],
      exString32: doc[Dbkeys.exString32],
      exString33: doc[Dbkeys.exString33],
      exString34: doc[Dbkeys.exString34],

      istextmessageallowed: doc[Dbkeys.istextmessageallowed],
      iscallsallowed: doc[Dbkeys.iscallsallowed],
      ismediamessageallowed: doc[Dbkeys.ismediamessageallowed],

      isAllowCreatingGroups: doc[Dbkeys.isAllowCreatingGroups],
      isAllowCreatingBroadcasts: doc[Dbkeys.isAllowCreatingBroadcasts],
      isAllowCreatingStatus: doc[Dbkeys.isAllowCreatingStatus],
      statusDeleteAfterInHours: doc[Dbkeys.statusDeleteAfterInHours],
      updateV7done: doc[Dbkeys.updateV7done],
      isadmobshow: doc[Dbkeys.isadmobshow],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Dbkeys.companyName: this.companyName,
      Dbkeys.companyLogoUrl: this.companyLogoUrl,
      Dbkeys.preVerifiedAgents: this.preVerifiedAgents,
      Dbkeys.preVerifiedCustomers: this.preVerifiedCustomers,
      Dbkeys.customerUnderReviewAfterEditProfile:
          this.customerUnderReviewAfterEditProfile,
      Dbkeys.isTwoFactorAuthCompulsoryforAgents:
          this.isTwoFactorAuthCompulsoryforAgents,
      Dbkeys.isTwoFactorAuthCompulsoryforUsers:
          this.isTwoFactorAuthCompulsoryforUsers,
      Dbkeys.agentUnderReviewAfterEditProfile:
          this.agentUnderReviewAfterEditProfile,
      Dbkeys.agentsCanSeeCustomerStatisticsProfile:
          this.agentsCanSeeCustomerStatisticsProfile,
      Dbkeys.secondadminCanSeeCustomerStatisticsProfile:
          this.secondadminCanSeeCustomerStatisticsProfile,
      Dbkeys.secondadminCanSeeAgentStatisticsProfile:
          this.secondadminCanSeeAgentStatisticsProfile,
      Dbkeys.agentCanSeeAgentStatisticsProfile:
          this.agentCanSeeAgentStatisticsProfile,
      Dbkeys.deleteConversationEnabledInGroup:
          this.deleteConversationEnabledInGroup,
      Dbkeys.agentsCanCreateAgentsGroup: this.agentsCanCreateAgentsGroup,
      Dbkeys.secondadminCanCreateAgentsGroup:
          this.secondadminCanCreateAgentsGroup,
      Dbkeys.isMediaSendingAllowedInGroupChat:
          this.isMediaSendingAllowedInGroupChat,
      Dbkeys.defaultMessageDeletingTimeForGroup:
          this.defaultMessageDeletingTimeForGroup,
      Dbkeys.agentCanCreateBroadcastToAgents:
          this.agentCanCreateBroadcastToAgents,
      Dbkeys.secondadminCanCreateBroadcastToAgents:
          this.secondadminCanCreateBroadcastToAgents,
      Dbkeys.agentCancreateandViewNewIndividualChat:
          this.agentCancreateandViewNewIndividualChat,
      Dbkeys.secondadminCancreateandViewNewIndividualChat:
          this.secondadminCancreateandViewNewIndividualChat,
      Dbkeys.defaultMessageDeletingTimeForOneToOneChat:
          this.defaultMessageDeletingTimeForOneToOneChat,
      Dbkeys.isMediaSendingAllowedInOneToOneChat:
          this.isMediaSendingAllowedInOneToOneChat,
      Dbkeys.deleteConversationEnabledInPersonalChat:
          this.deleteConversationEnabledInPersonalChat,
      Dbkeys.agentCanCallAgents: this.agentCanCallAgents,
      Dbkeys.secondadminCanCallAgents: this.secondadminCanCallAgents,
      Dbkeys.customerCanSeeAgentNameInTicketCallScreen:
          this.customerCanSeeAgentNameInTicketCallScreen,
      Dbkeys.callTypeForAgents: this.callTypeForAgents,
      Dbkeys.customerCanCreateTicket: this.customerCanCreateTicket,
      Dbkeys.agentCanCreateTicket: this.agentCanCreateTicket,
      Dbkeys.secondadminCanCreateTicket: this.secondadminCanCreateTicket,
      Dbkeys.customerCanChangeTicketStatus: this.customerCanChangeTicketStatus,
      Dbkeys.agentCanChangeTicketStatus: this.agentCanChangeTicketStatus,
      Dbkeys.secondadminCanChangeTicketStatus:
          this.secondadminCanChangeTicketStatus,
      Dbkeys.defaultTicketMssgsDeletingTimeAfterClosing:
          this.defaultTicketMssgsDeletingTimeAfterClosing,
      Dbkeys.showIsTypingInTicketChatRoom: this.showIsTypingInTicketChatRoom,
      Dbkeys.showIsCustomerOnline: this.showIsCustomerOnline,
      Dbkeys.showIsAgentOnline: this.showIsAgentOnline,
      Dbkeys.isMediaSendingAllowedInTicketChatRoom:
          this.isMediaSendingAllowedInTicketChatRoom,
      Dbkeys.isCallAssigningAllowed: this.isCallAssigningAllowed,
      Dbkeys.callTypeForTicketChatRoom: this.callTypeForTicketChatRoom,
      Dbkeys.customerCanRateTicket: this.customerCanRateTicket,
      Dbkeys.reopenTicketTillDays: this.reopenTicketTillDays,

      Dbkeys.defaultTopicsOnLoginName: this.defaultTopicsOnLoginName,
      Dbkeys.departmentBasedContent: this.departmentBasedContent,
      Dbkeys.departmentList: this.departmentList,
      Dbkeys.autocreatesupportticket: this.autocreatesupportticket,
      Dbkeys.agentCanCreateInvoice: this.agentCanCreateInvoice,
      Dbkeys.secondadminCanCreateInvoice: this.secondadminCanCreateInvoice,
      Dbkeys.secondadminCanDeleteBroadcast: this.secondadminCanDeleteBroadcast,
      Dbkeys.showPaymentsTabInAgentAccount: this.showPaymentsTabInAgentAccount,
      Dbkeys.showPaymentsTabInCustomerAccount:
          this.showPaymentsTabInCustomerAccount,
      Dbkeys.allowedCurrencyList: this.allowedCurrencyList,
      Dbkeys.isCustomAppShareLink: this.isCustomAppShareLink,
      Dbkeys.appShareMessageStringAndroid: this.appShareMessageStringAndroid,
      Dbkeys.appShareMessageStringiOS: this.appShareMessageStringiOS,
      Dbkeys.isLogoutButtonShowInSettingsPage: isLogoutButtonShowInSettingsPage,
      Dbkeys.maxFileSizeAllowedInMB: this.maxFileSizeAllowedInMB,
      Dbkeys.maxNoOfFilesInMultiSharing: this.maxNoOfFilesInMultiSharing,
      Dbkeys.is24hrsTimeformat: this.is24hrsTimeformat,
      Dbkeys.isPercentProgressShowWhileUploading:
          isPercentProgressShowWhileUploading,
      Dbkeys.groupMemberslimit: this.groupMemberslimit,
      Dbkeys.broadcastMemberslimit: this.broadcastMemberslimit,
      Dbkeys.feedbackEmail: this.feedbackEmail,
//-------
      Dbkeys.demoIDsList: this.demoIDsList,
      Dbkeys.exList2: this.exList2,
      Dbkeys.exList3: this.exList3,
      Dbkeys.exList4: this.exList4,
      Dbkeys.exList5: this.exList5,
      Dbkeys.exList6: this.exList6,
      Dbkeys.exList7: this.exList7,
      Dbkeys.exList8: this.exList8,
      Dbkeys.exList9: this.exList9,
      Dbkeys.exList10: this.exList10,
      Dbkeys.exList11: this.exList11,
      Dbkeys.exList12: this.exList12,
      Dbkeys.exbool384: this.exbool384,
      Dbkeys.exbool1123: this.exbool1123,
      Dbkeys.customerCanSeeAgentStatisticsProfile:
          this.customerCanSeeAgentStatisticsProfile,
      Dbkeys.departmentmanagerCancreateandViewNewIndividualChat:
          this.departmentmanagerCancreateandViewNewIndividualChat,
      Dbkeys.departmentmanagerCanViewGlobalDepartments:
          this.departmentmanagerCanViewGlobalDepartments,
      Dbkeys.autoJoinNewAgentsToDefaultList:
          this.autoJoinNewAgentsToDefaultList,
      Dbkeys.secondadminCanViewGloabalBroadcast:
          this.secondadminCanViewGloabalBroadcast,
      Dbkeys.departmentManagerCanCreateAgentsGroup:
          this.departmentManagerCanCreateAgentsGroup,
      Dbkeys.secondadminCanViewAllGlobalChats:
          this.secondadminCanViewAllGlobalChats,
      Dbkeys.departmentmanagerCanDeleteBroadcast:
          this.departmentmanagerCanDeleteBroadcast,
      Dbkeys.departmentmanagerCanViewGloabalBroadcast:
          this.departmentmanagerCanViewGloabalBroadcast,
      Dbkeys.agentCanViewAllTicketGlobally: this.agentCanViewAllTicketGlobally,
      Dbkeys.departmentmanagerCanViewAllTicketGlobally:
          this.departmentmanagerCanViewAllTicketGlobally,
      Dbkeys.departmentManagerCanViewDepartmentGroups:
          this.departmentManagerCanViewDepartmentGroups,
      Dbkeys.secondadminCanViewDepartmentGroups:
          this.secondadminCanViewDepartmentGroups,
      Dbkeys.departmentManagerCanViewAllGlobalgroups:
          this.departmentManagerCanViewAllGlobalgroups,
      Dbkeys.agentsCanViewGlobalDepartments:
          this.agentsCanViewGlobalDepartments,
      Dbkeys.departmentmanagerCanDeleteDepartment:
          this.departmentmanagerCanDeleteDepartment,
      Dbkeys.departmentManagerCanCreateDepartmentGlobally:
          this.departmentManagerCanCreateDepartmentGlobally,
      Dbkeys.exBool20: this.exBool20,
      Dbkeys.agentCanDeleteBroadcast: this.agentCanDeleteBroadcast,
      Dbkeys.departmentmanagercanseeagentnameandphoto:
          this.departmentmanagercanseeagentnameandphoto,
      Dbkeys.departmentmanagercanseecustomernameandphoto:
          this.departmentmanagercanseecustomernameandphoto,
      Dbkeys.agentcanseecustomernameandphoto:
          this.agentcanseecustomernameandphoto,
      Dbkeys.secondadmincanseecustomernameandphoto:
          this.secondadmincanseecustomernameandphoto,
      Dbkeys.agentsCanSeeOwnDepartmentACustomer:
          this.agentsCanSeeOwnDepartmentACustomer,
      Dbkeys.agentCanSeeCustomerContactInfo:
          this.agentCanSeeCustomerContactInfo,
      Dbkeys.secondadminCanSeeCustomerContactInfo:
          this.secondadminCanSeeCustomerContactInfo,
      Dbkeys.departmentmanagerCanSeeCustomerStatisticsProfile:
          this.departmentmanagerCanSeeCustomerStatisticsProfile,
      Dbkeys.departmentmanagerCanSeeCustomerContactinfo:
          this.departmentmanagerCanSeeCustomerContactinfo,
      Dbkeys.exbool244: this.exbool244,
      Dbkeys.secondadminCanSeeCustomerContactinfo:
          this.secondadminCanSeeCustomerContactinfo,
      Dbkeys.departmentmanagerCanSeeAgentStatisticsProfile:
          this.departmentmanagerCanSeeAgentStatisticsProfile,
      Dbkeys.secondadminCanSeeAgentContactinfo:
          this.secondadminCanSeeAgentContactinfo,
      Dbkeys.departmentmanagerCanSeeAgentContactinfo:
          this.departmentmanagerCanSeeAgentContactinfo,
      Dbkeys.agentCanSeeAgentContactinfo: this.agentCanSeeAgentContactinfo,
      Dbkeys.customerCanSeeAgentContactinfo:
          this.customerCanSeeAgentContactinfo,
      Dbkeys.agentsCanSeeOwnDepartmentAgents:
          this.agentsCanSeeOwnDepartmentAgents,
      Dbkeys.departmentManagerCanViewAllGlobalChats:
          this.departmentManagerCanViewAllGlobalChats,
      Dbkeys.departmentmanagerCanViewAllAgentsGlobally:
          this.departmentmanagerCanViewAllAgentsGlobally,
      Dbkeys.agentsCanViewAllAgentsGlobally:
          this.agentsCanViewAllAgentsGlobally,
      Dbkeys.agentsCanViewAllCustomerGlobally:
          this.agentsCanViewAllCustomerGlobally,
      Dbkeys.departmentmanagerCanViewAllCustomerGlobally:
          this.departmentmanagerCanViewAllCustomerGlobally,
      Dbkeys.customerCanDialCallsInTicketChatroom:
          this.customerCanDialCallsInTicketChatroom,
      Dbkeys.agentCanReopenTicket: this.agentCanReopenTicket,
      Dbkeys.customerCanReopenTicket: this.customerCanReopenTicket,
      Dbkeys.customerCanCloseTicket: this.customerCanCloseTicket,
      Dbkeys.agentCanScheduleCalls: this.agentCanScheduleCalls,
      Dbkeys.customerCanViewAgentsListJoinedTicket:
          this.customerCanViewAgentsListJoinedTicket,
      Dbkeys.secondadmincanseeagentnameandphoto:
          this.secondadmincanseeagentnameandphoto,
      Dbkeys.agentcanseeagentnameandphoto: this.agentcanseeagentnameandphoto,
      Dbkeys.customercanseeagentnameandphoto:
          this.customercanseeagentnameandphoto,
      Dbkeys.departmentmanagerCanCreateBroadcastToAgents:
          this.departmentmanagerCanCreateBroadcastToAgents,
      Dbkeys.secondadminCanViewGlobalDepartments:
          this.secondadminCanViewGlobalDepartments,
      Dbkeys.customerCanViewGlobalDepartments:
          this.customerCanViewGlobalDepartments,
      Dbkeys.secondAdminCanviewDepartmentStatistics:
          this.secondAdminCanviewDepartmentStatistics,
      Dbkeys.departmentmanagerCanviewDepartmentStatistics:
          this.departmentmanagerCanviewDepartmentStatistics,
      Dbkeys.secondadminCanDeleteDepartment:
          this.secondadminCanDeleteDepartment,
      Dbkeys.secondAdminCanEditDepartment: this.secondAdminCanEditDepartment,
      Dbkeys.departmentManagerCanEditAddAgentstodepartment:
          this.departmentManagerCanEditAddAgentstodepartment,
      Dbkeys.secondAdminCanCreateDepartmentGlobally:
          this.secondAdminCanCreateDepartmentGlobally,
      Dbkeys.departmentManagerCanCreateTicket:
          this.departmentManagerCanCreateTicket,
      Dbkeys.secondadminCanViewAllTicketGlobally:
          this.secondadminCanViewAllTicketGlobally,
      Dbkeys.agentcanChatWithCustomerInTicket:
          this.agentcanChatWithCustomerInTicket,
      Dbkeys.secondadminCanChatWithCustomerInTicket:
          this.secondadminCanChatWithCustomerInTicket,
      Dbkeys.departmentmanagerCanChatWithCustomerInTicket:
          this.departmentmanagerCanChatWithCustomerInTicket,
      Dbkeys.departmentmanagerCanChangeTicketStatus:
          this.departmentmanagerCanChangeTicketStatus,
      Dbkeys.departmentmanagerCanViewAgentsListJoinedTicket:
          this.departmentmanagerCanViewAgentsListJoinedTicket,
      Dbkeys.secondadminCanViewAgentsListJoinedTicket:
          this.secondadminCanViewAgentsListJoinedTicket,
      Dbkeys.agentCanViewAgentsListJoinedTicket:
          this.agentCanViewAgentsListJoinedTicket,
      Dbkeys.secondadminCanScheduleCalls: this.secondadminCanScheduleCalls,
      Dbkeys.departmentManagerCanScheduleCalls:
          this.departmentManagerCanScheduleCalls,
      Dbkeys.agentCanCloseTicket: this.agentCanCloseTicket,
      Dbkeys.departmentmanagerCanCloseTicket:
          this.departmentmanagerCanCloseTicket,
      Dbkeys.secondAdminCanCloseTicket: this.secondAdminCanCloseTicket,
      Dbkeys.departmentManagerCanReopenTicket:
          this.departmentManagerCanReopenTicket,
      Dbkeys.secondadminCanReopenTicket: this.secondadminCanReopenTicket,
      Dbkeys.viewowntickets: this.viewowntickets,
      Dbkeys.secondadminCanViewAllCustomerGlobally:
          this.secondadminCanViewAllCustomerGlobally,
      Dbkeys.viewOwnCustomerWithinDepartments:
          this.viewOwnCustomerWithinDepartments,
      Dbkeys.viewOwnAgentsWithinDepartments:
          this.viewOwnAgentsWithinDepartments,
      Dbkeys.secondadminCanViewAllAgentsGlobally:
          this.secondadminCanViewAllAgentsGlobally,
      Dbkeys.departmentManagerCanSeeOwnDepartmentCustomers:
          this.departmentManagerCanSeeOwnDepartmentCustomers,
      Dbkeys.departmentManagerCanSeeOwnDepartmentAgents:
          this.departmentManagerCanSeeOwnDepartmentAgents,
      Dbkeys.isShowHeaderAgentsTab: this.isShowHeaderAgentsTab,
      Dbkeys.isShowHeaderCustomersTab: this.isShowHeaderCustomersTab,
      Dbkeys.isShowFooterAgentsTab: this.isShowFooterAgentsTab,
      Dbkeys.isShowFooterCustomersTab: this.isShowFooterCustomersTab,
      Dbkeys.exBool89: this.exBool89,
      Dbkeys.exBool90: this.exBool90,

      Dbkeys.notificationtime: this.notificationtime,
      Dbkeys.customerTabIndexPosition: this.customerTabIndexPosition,
      Dbkeys.agentTabIndexPosition: this.agentTabIndexPosition,
      Dbkeys.exInt5: this.exInt5,
      Dbkeys.exInt6: this.exInt6,
      Dbkeys.exInt7: this.exInt7,
      Dbkeys.exInt8: this.exInt8,
      Dbkeys.exInt9: this.exInt9,
      Dbkeys.exInt10: this.exInt10,
      Dbkeys.exInt11: this.exInt11,
      Dbkeys.exInt12: this.exInt12,
      Dbkeys.exInt13: this.exInt13,
      Dbkeys.exInt14: this.exInt14,
      Dbkeys.exInt15: this.exInt15,
      Dbkeys.exInt16: this.exInt16,
      Dbkeys.exInt17: this.exInt17,
      Dbkeys.exInt18: this.exInt18,
      Dbkeys.exInt19: this.exInt19,
      Dbkeys.exInt20: this.exInt20,
      Dbkeys.exInt21: this.exInt21,
      Dbkeys.exInt22: this.exInt22,
      Dbkeys.exInt23: this.exInt23,
      Dbkeys.exInt24: this.exInt24,
      Dbkeys.exInt25: this.exInt25,
      Dbkeys.exInt26: this.exInt26,
      Dbkeys.exInt27: this.exInt27,
      Dbkeys.exInt28: this.exInt28,
      Dbkeys.exInt29: this.exInt29,
      Dbkeys.exInt30: this.exInt30,
      Dbkeys.exInt31: this.exInt31,
      Dbkeys.exInt32: this.exInt32,
      Dbkeys.exInt33: this.exInt33,
      Dbkeys.exInt34: this.exInt34,
      Dbkeys.exInt35: this.exInt35,
      Dbkeys.exInt36: this.exInt36,
      Dbkeys.exInt37: this.exInt37,
      Dbkeys.exInt38: this.exInt38,
      Dbkeys.exInt39: this.exInt39,
      Dbkeys.exInt40: this.exInt40,
      Dbkeys.exInt41: this.exInt41,
      Dbkeys.exInt42: this.exInt42,
      Dbkeys.exInt43: this.exInt43,
      Dbkeys.exInt44: this.exInt44,
      Dbkeys.exInt45: this.exInt45,
      Dbkeys.exInt46: this.exInt46,
      Dbkeys.exInt47: this.exInt47,
      Dbkeys.exInt48: this.exInt48,
      Dbkeys.exInt49: this.exInt49,
      Dbkeys.exInt50: this.exInt50,
      Dbkeys.exInt51: this.exInt51,
      Dbkeys.exInt52: this.exInt52,
      Dbkeys.exInt53: this.exInt53,
      Dbkeys.exInt54: this.exInt54,

      Dbkeys.personalcalltypeagents: this.personalcalltypeagents,
      Dbkeys.exDouble1: this.exDouble1,
      Dbkeys.exDouble2: this.exDouble2,
      Dbkeys.exDouble3: this.exDouble3,
      Dbkeys.exDouble4: this.exDouble4,
      Dbkeys.exDouble5: this.exDouble5,
      Dbkeys.exDouble6: this.exDouble6,
      Dbkeys.exDouble7: this.exDouble7,
      Dbkeys.exDouble8: this.exDouble8,
      Dbkeys.exDouble9: this.exDouble9,
      Dbkeys.exDouble10: this.exDouble10,

      Dbkeys.exBool100: this.exBool100,
      Dbkeys.exBool101: this.exBool101,
      Dbkeys.exBool102: this.exBool102,
      Dbkeys.exBool103: this.exBool103,
      Dbkeys.exBool104: this.exBool104,
      Dbkeys.exBool105: this.exBool105,
      Dbkeys.exBool106: this.exBool106,
      Dbkeys.exBool107: this.exBool107,
      Dbkeys.exBool108: this.exBool108,
      Dbkeys.exBool109: this.exBool109,
      Dbkeys.exBool110: this.exBool110,
      Dbkeys.exBool111: this.exBool111,
      Dbkeys.exBool112: this.exBool112,
      Dbkeys.exBool113: this.exBool113,
      Dbkeys.exBool114: this.exBool114,
      Dbkeys.exBool115: this.exBool115,
      Dbkeys.exBool116: this.exBool116,
      Dbkeys.exBool117: this.exBool117,
      Dbkeys.exBool118: this.exBool118,
      Dbkeys.exBool119: this.exBool119,
      Dbkeys.exBool120: this.exBool120,
      Dbkeys.exBool121: this.exBool121,
      Dbkeys.exBool122: this.exBool122,
      Dbkeys.exBool123: this.exBool123,
      Dbkeys.exBool124: this.exBool124,
      Dbkeys.exBool125: this.exBool125,
      Dbkeys.exBool126: this.exBool126,
      Dbkeys.exBool127: this.exBool127,
      Dbkeys.exBool128: this.exBool128,
      Dbkeys.exBool129: this.exBool129,
      Dbkeys.exBool130: this.exBool130,
      Dbkeys.exBool131: this.exBool131,
      Dbkeys.exBool132: this.exBool132,
      Dbkeys.exBool133: this.exBool133,
      Dbkeys.exBool134: this.exBool134,
      Dbkeys.exBool135: this.exBool135,
      Dbkeys.exBool136: this.exBool136,
      Dbkeys.exBool137: this.exBool137,
      Dbkeys.exBool138: this.exBool138,
      Dbkeys.exBool139: this.exBool139,
      Dbkeys.exBool140: this.exBool140,
      Dbkeys.exBool141: this.exBool141,
      Dbkeys.exBool142: this.exBool142,
      Dbkeys.exBool143: this.exBool143,
      Dbkeys.exBool144: this.exBool144,
      Dbkeys.exBool145: this.exBool145,
      Dbkeys.exBool146: this.exBool146,
      Dbkeys.exBool147: this.exBool147,
      Dbkeys.exBool148: this.exBool148,
      Dbkeys.exBool149: this.exBool149,
      Dbkeys.exBool150: this.exBool150,
      Dbkeys.exBool151: this.exBool151,
      Dbkeys.exBool152: this.exBool152,
      Dbkeys.exBool153: this.exBool153,
      Dbkeys.exBool154: this.exBool154,
      Dbkeys.exBool156: this.exBool156,
      Dbkeys.exBool157: this.exBool157,
      Dbkeys.exBool158: this.exBool158,
      Dbkeys.exBool159: this.exBool159,
      Dbkeys.exBool160: this.exBool160,
      Dbkeys.exBool161: this.exBool161,
      Dbkeys.exBool162: this.exBool162,
      Dbkeys.exBool163: this.exBool163,
      Dbkeys.exBool164: this.exBool164,
      Dbkeys.exBool165: this.exBool165,
      Dbkeys.exBool166: this.exBool166,
      Dbkeys.exBool167: this.exBool167,
      Dbkeys.exBool168: this.exBool168,
      Dbkeys.exBool169: this.exBool169,
      Dbkeys.exBool170: this.exBool170,
      Dbkeys.exBool171: this.exBool171,
      Dbkeys.exBool172: this.exBool172,
      Dbkeys.exBool173: this.exBool173,
      Dbkeys.exBool174: this.exBool174,
      Dbkeys.exBool175: this.exBool175,
      Dbkeys.exBool176: this.exBool176,
      Dbkeys.exBool177: this.exBool177,
      Dbkeys.exBool178: this.exBool178,
      Dbkeys.exBool179: this.exBool179,
      Dbkeys.exBool180: this.exBool180,
      Dbkeys.exBool181: this.exBool181,
      Dbkeys.exBool182: this.exBool182,
      Dbkeys.exBool183: this.exBool183,
      Dbkeys.exBool184: this.exBool184,
      Dbkeys.exBool185: this.exBool185,
      Dbkeys.exBool186: this.exBool186,
      Dbkeys.exBool187: this.exBool187,
      Dbkeys.exBool188: this.exBool188,
      Dbkeys.exBool189: this.exBool189,
      Dbkeys.exBool190: this.exBool190,
      Dbkeys.exBool191: this.exBool191,
      Dbkeys.exBool192: this.exBool192,
      Dbkeys.exBool193: this.exBool193,
      Dbkeys.exBool194: this.exBool194,
      Dbkeys.exBool195: this.exBool195,
      Dbkeys.exBool196: this.exBool196,
      Dbkeys.exBool197: this.exBool197,
      Dbkeys.exBool198: this.exBool198,
      Dbkeys.exBool199: this.exBool199,
      Dbkeys.exBool200: this.exBool200,

      Dbkeys.exMap1: this.exMap1,
      Dbkeys.exMap2: this.exMap2,
      Dbkeys.exMap3: this.exMap3,
      Dbkeys.exMap4: this.exMap4,
      Dbkeys.exMap5: this.exMap5,
      Dbkeys.exMap6: this.exMap6,
      Dbkeys.exMap7: this.exMap7,
      Dbkeys.exMap8: this.exMap8,
      Dbkeys.exMap9: this.exMap9,
      Dbkeys.notificationtitle: this.notificationtitle,
      Dbkeys.notificationdesc: this.notificationdesc,
      Dbkeys.notifcationpostedby: this.notifcationpostedby,
      Dbkeys.agentsLandingCustomTabURL: this.agentsLandingCustomTabURL,
      Dbkeys.customersLandingCustomTabURL: this.customersLandingCustomTabURL,
      Dbkeys.agentCustomTabLabel: this.agentCustomTabLabel,
      Dbkeys.customerCustomTabLabel: this.customerCustomTabLabel,
      Dbkeys.exString8: this.exString8,
      Dbkeys.exString9: this.exString9,
      Dbkeys.exString10: this.exString10,
      Dbkeys.exString11: this.exString11,
      Dbkeys.exString12: this.exString12,
      Dbkeys.exString13: this.exString13,
      Dbkeys.exString14: this.exString14,
      Dbkeys.exString15: this.exString15,
      Dbkeys.exString16: this.exString16,
      Dbkeys.exString17: this.exString17,
      Dbkeys.exString18: this.exString18,
      Dbkeys.exString19: this.exString19,
      Dbkeys.exString20: this.exString20,
      Dbkeys.exString21: this.exString21,
      Dbkeys.exString22: this.exString22,
      Dbkeys.exString23: this.exString23,
      Dbkeys.exString24: this.exString24,
      Dbkeys.exString25: this.exString25,
      Dbkeys.exString26: this.exString26,
      Dbkeys.exString27: this.exString27,
      Dbkeys.exString28: this.exString28,
      Dbkeys.exString29: this.exString29,
      Dbkeys.exString30: this.exString30,
      Dbkeys.exString31: this.exString31,
      Dbkeys.exString32: this.exString32,
      Dbkeys.exString33: this.exString33,
      Dbkeys.exString34: this.exString34,

      Dbkeys.istextmessageallowed: this.istextmessageallowed,
      Dbkeys.iscallsallowed: this.iscallsallowed,
      Dbkeys.ismediamessageallowed: this.ismediamessageallowed,

      Dbkeys.isAllowCreatingGroups: this.isAllowCreatingGroups,
      Dbkeys.isAllowCreatingBroadcasts: this.isAllowCreatingBroadcasts,
      Dbkeys.isAllowCreatingStatus: this.isAllowCreatingStatus,
      Dbkeys.statusDeleteAfterInHours: this.statusDeleteAfterInHours,
      Dbkeys.updateV7done: this.updateV7done,
      Dbkeys.isadmobshow: this.isadmobshow,
    };
  }
}
