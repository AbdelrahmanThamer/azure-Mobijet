//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

enum ChatStatus { blocked, waiting, requested, accepted, broadcast }
enum MessageType {
  text,
  image,
  video,
  doc,
  location,
  contact,
  audio,
  rROBOTticketcreated,
  rROBOTticketdescriptionupdated,
  // rROBOTgeneralmessage,
  rROBOTticketclosed,
  rROBOTagentsassigned,
  rROBOTrequestedtoclose,
  rROBOTrequireattention,
  rROBOTticketreopened,
  rROBOTclosingDeniedByCustomer,
  rROBOTclosingDeniedByAgent,
  rROBOTremovettention,
  rROBOTassignAgentForACustomerCall,
  rROBOTremoveAssignAgentForACustomerCall,
  rROBOTcallHistory,
  rROBOTdepartmentChanged,
}
enum AuthenticationType { passcode, biometric }
enum Themetype { messenger, whatsapp }
enum Usertype {
  customer,
  agent,
  secondadmin,
  departmentmanager,
}
enum Colortype { primary, secondary, button }
enum CallType { audio, video, both }
enum LoginType { phone, google, fb, email, apple }
enum TicketMssgPurposeType { commonrecord, google, fb, email, apple }
enum NotificationType { toAgent, toCustomer, toCommonagentcustomer, toAdmin }
enum WarningType {
  success,
  error,
  alert,
}
enum MssgSendFor {
  customer,
  agent,
}
// enum RatingRequirements { mandatory, video, both }
enum LoginStatus {
  sendSMScode,
  checkingname,
  entername,
  sendingSMScode,
  sentSMSCode,
  verifyingSMSCode,
  failure,
}

enum TicketStatus {
  waitingForAgentsToJoinTicket,
  active,
  canWeCloseByCustomer,
  canWeCloseByAgent,
  needsAttention,
  closedByCustomer,
  closedByAgent,
  // closedByManager,
  reOpenedByCustomer,
  reOpenedByAgent,
  mediaAutoDeleted,
}

enum TicketStatusShort {
  notstarted,
  active,
  close,
  expired,
}

enum TabName {
  chat,
  users,
  departments,
  payments,
}

enum CallTypeIndex {
  callToAgentFromAgentInPERSONAL,
  callToCustomerFromCustomerInPERSONAL,
  callToCustomerFromAgentInTICKET,
  callToAgentFromCustomerInTICKET,
}

enum DeletedType { peerHasAlreadyRead, peerHasNotReadYet, adminDeleted }
