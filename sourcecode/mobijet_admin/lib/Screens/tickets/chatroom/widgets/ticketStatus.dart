//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Definition attached with source code. *********************

import 'package:thinkcreative_technologies/Configs/enum.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';

Color ticketStatusColorForAgents(int ticketStatus) {
  if (ticketStatus == TicketStatus.active.index) {
    return Mycolors.green;
  } else if (ticketStatus == TicketStatus.closedByAgent.index) {
    return Mycolors.red;
  } else if (ticketStatus == TicketStatus.closedByCustomer.index) {
    return Mycolors.red;
  } else if (ticketStatus == TicketStatus.mediaAutoDeleted.index) {
    return Mycolors.black;
  } else if (ticketStatus == TicketStatus.needsAttention.index) {
    return Colors.orange;
  } else if (ticketStatus == TicketStatus.canWeCloseByAgent.index) {
    return Mycolors.cyan;
  } else if (ticketStatus == TicketStatus.canWeCloseByCustomer.index) {
    return Mycolors.purple;
  } else if (ticketStatus == TicketStatus.reOpenedByCustomer.index) {
    return Mycolors.green;
  } else if (ticketStatus == TicketStatus.waitingForAgentsToJoinTicket.index) {
    return Colors.blue;
  } else if (ticketStatus == TicketStatus.reOpenedByAgent.index) {
    return Colors.green;
  }
  return Mycolors.grey;
}

Color ticketStatusColorForCustomers(int ticketStatus) {
  if (ticketStatus == TicketStatus.active.index) {
    return Mycolors.green;
  } else if (ticketStatus == TicketStatus.closedByAgent.index) {
    return Mycolors.red;
  } else if (ticketStatus == TicketStatus.closedByCustomer.index) {
    return Mycolors.red;
  } else if (ticketStatus == TicketStatus.mediaAutoDeleted.index) {
    return Mycolors.black;
  } else if (ticketStatus == TicketStatus.needsAttention.index) {
    return Colors.green;
  } else if (ticketStatus == TicketStatus.canWeCloseByAgent.index) {
    return Mycolors.cyan;
  } else if (ticketStatus == TicketStatus.canWeCloseByCustomer.index) {
    return Mycolors.purple;
  } else if (ticketStatus == TicketStatus.reOpenedByCustomer.index) {
    return Mycolors.green;
  } else if (ticketStatus == TicketStatus.waitingForAgentsToJoinTicket.index) {
    return Colors.blue;
  } else if (ticketStatus == TicketStatus.reOpenedByAgent.index) {
    return Colors.green;
  }
  return Mycolors.grey;
}

String ticketStatusTextShortForAgents(BuildContext context, int ticketStatus) {
  if (ticketStatus == TicketStatus.active.index) {
    return
        // 'ACTIVE';
        getTranslatedForCurrentUser(context, 'xxactivexx');
  } else if (ticketStatus == TicketStatus.closedByAgent.index) {
    return
        // 'CLOSED';
        getTranslatedForCurrentUser(context, 'xxclosedxx');
  } else if (ticketStatus == TicketStatus.closedByCustomer.index) {
    return
        // 'CLOSED';
        getTranslatedForCurrentUser(context, 'xxclosedxx');
  } else if (ticketStatus == TicketStatus.mediaAutoDeleted.index) {
    return
        // 'xxdeletedxx';
        getTranslatedForCurrentUser(context, 'xxdeletedstatusxx');
  } else if (ticketStatus == TicketStatus.needsAttention.index) {
    return
        // 'ATTENTION';
        getTranslatedForCurrentUser(context, 'xxattentionxx');
  } else if (ticketStatus == TicketStatus.canWeCloseByCustomer.index) {
    return
        // 'WAITING';
        getTranslatedForCurrentUser(context, 'xxwaitingxx');
  } else if (ticketStatus == TicketStatus.canWeCloseByAgent.index) {
    return
        // 'WAITING';
        getTranslatedForCurrentUser(context, 'xxwaitingxx');
  } else if (ticketStatus == TicketStatus.reOpenedByCustomer.index) {
    return
        // 'ACTIVE';
        getTranslatedForCurrentUser(context, 'xxactivexx');
  } else if (ticketStatus == TicketStatus.waitingForAgentsToJoinTicket.index) {
    return
        // 'WAITING';
        getTranslatedForCurrentUser(context, 'xxwaitingxx');
  } else if (ticketStatus == TicketStatus.reOpenedByAgent.index) {
    return
        // 'ACTIVE';
        getTranslatedForCurrentUser(context, 'xxactivexx');
  }
  return 'UNDEFINED';
}

String ticketStatusTextShortForCustomers(
    BuildContext context, int ticketStatus) {
  if (ticketStatus == TicketStatus.active.index) {
    return
        // 'ACTIVE';
        getTranslatedForCurrentUser(context, 'xxactivexx');
  } else if (ticketStatus == TicketStatus.closedByAgent.index) {
    return
        // 'CLOSED';
        getTranslatedForCurrentUser(context, 'xxclosedxx');
  } else if (ticketStatus == TicketStatus.closedByCustomer.index) {
    return
        // 'CLOSED';
        getTranslatedForCurrentUser(context, 'xxclosedxx');
  } else if (ticketStatus == TicketStatus.mediaAutoDeleted.index) {
    return
        // 'xxdeletedxx';
        getTranslatedForCurrentUser(context, 'xxdeletedstatusxx');
  } else if (ticketStatus == TicketStatus.needsAttention.index) {
    return
        // 'ACTIVE';
        getTranslatedForCurrentUser(context, 'xxactivexx');
  } else if (ticketStatus == TicketStatus.canWeCloseByCustomer.index) {
    return
        // 'WAITING';
        getTranslatedForCurrentUser(context, 'xxwaitingxx');
  } else if (ticketStatus == TicketStatus.canWeCloseByAgent.index) {
    return
        // 'WAITING';
        getTranslatedForCurrentUser(context, 'xxwaitingxx');
  } else if (ticketStatus == TicketStatus.reOpenedByCustomer.index) {
    return
        // 'ACTIVE';
        getTranslatedForCurrentUser(context, 'xxactivexx');
  } else if (ticketStatus == TicketStatus.waitingForAgentsToJoinTicket.index) {
    return
        // 'WAITING';
        getTranslatedForCurrentUser(context, 'xxwaitingxx');
  } else if (ticketStatus == TicketStatus.reOpenedByAgent.index) {
    return
        // 'ACTIVE';
        getTranslatedForCurrentUser(context, 'xxactivexx');
  }
  return 'UNDEFINED';
}

String ticketStatusTextLongForCustomer(BuildContext context, int ticketStatus) {
  if (ticketStatus == TicketStatus.active.index) {
    return
        // 'Chat Support Ticket is Active';
        getTranslatedForCurrentUser(context, 'xxisactivexx').replaceAll(
            '(####)', getTranslatedForCurrentUser(context, 'xxsupporttktxx'));
  } else if (ticketStatus == TicketStatus.closedByAgent.index) {
    return
        // 'Chat Support Ticket is closed by Agent';
        getTranslatedForCurrentUser(context, 'xxclosedbyxx')
            .replaceAll('(####)',
                getTranslatedForCurrentUser(context, 'xxsupporttktxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxagentxx'));
  } else if (ticketStatus == TicketStatus.closedByCustomer.index) {
    return
        // 'Chat Support Ticket is closed by You';
        getTranslatedForCurrentUser(context, 'xxclosedbyxx')
            .replaceAll('(####)',
                getTranslatedForCurrentUser(context, 'xxsupporttktxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxyouxx'));
  }
  if (ticketStatus == TicketStatus.mediaAutoDeleted.index) {
    return
        // 'Media data of this Chat Support Ticket has been successfully deleted on its schedule time.';
        getTranslatedForCurrentUser(context, 'xxmediadeletedonscedulexx')
            .replaceAll('(####)',
                getTranslatedForCurrentUser(context, 'xxsupporttktxx'));
  } else if (ticketStatus == TicketStatus.needsAttention.index) {
    return
        // 'Chat Support Ticket is Active';
        getTranslatedForCurrentUser(context, 'xxisactivexx').replaceAll(
            '(####)', getTranslatedForCurrentUser(context, 'xxsupporttktxx'));
  } else if (ticketStatus == TicketStatus.canWeCloseByAgent.index) {
    return
        // 'Waiting for you to Close the Ticket';
        getTranslatedForCurrentUser(context, 'xxwaitingforxx')
            .replaceAll(
                '(####)', getTranslatedForCurrentUser(context, 'xxyouxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxtktsxx'));
  } else if (ticketStatus == TicketStatus.canWeCloseByCustomer.index) {
    return
        // 'Waiting for agent to Close the Ticket';
        getTranslatedForCurrentUser(context, 'xxwaitingforxx')
            .replaceAll(
                '(####)', getTranslatedForCurrentUser(context, 'xxagentsxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxtktsxx'));
  } else if (ticketStatus == TicketStatus.reOpenedByCustomer.index) {
    return
        // 'Chat Support is re-opened by the You';
        getTranslatedForCurrentUser(context, 'xxreopenedxx')
            .replaceAll('(####)',
                getTranslatedForCurrentUser(context, 'xxsupporttktxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxyouxx'));
  } else if (ticketStatus == TicketStatus.waitingForAgentsToJoinTicket.index) {
    return
        // 'Waiting for Agent to join this Support Ticket.';
        getTranslatedForCurrentUser(context, 'xxwaitingforxxtojoinxx')
            .replaceAll(
                '(####)', getTranslatedForCurrentUser(context, 'xxagentsxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxtktsxx'));
  } else if (ticketStatus == TicketStatus.reOpenedByAgent.index) {
    return
        // 'Chat Support is re-opened by the Agent';
        getTranslatedForCurrentUser(context, 'xxreopenedxx')
            .replaceAll('(####)',
                getTranslatedForCurrentUser(context, 'xxsupporttktxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxagentxx'));
  }
  return '';
}

String ticketStatusTextLongForAgent(BuildContext context, int ticketStatus) {
  if (ticketStatus == TicketStatus.active.index) {
    return getTranslatedForCurrentUser(context, 'xxisactivexx').replaceAll(
        '(####)', getTranslatedForCurrentUser(context, 'xxsupporttktxx'));
  } else if (ticketStatus == TicketStatus.closedByAgent.index) {
    return
        // 'Chat Support Ticket is closed by Agent';
        getTranslatedForCurrentUser(context, 'xxclosedbyxx')
            .replaceAll('(####)',
                getTranslatedForCurrentUser(context, 'xxsupporttktxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxagentxx'));
  } else if (ticketStatus == TicketStatus.closedByCustomer.index) {
    return
        // 'Chat Support Ticket is closed by Customer';
        getTranslatedForCurrentUser(context, 'xxclosedbyxx')
            .replaceAll('(####)',
                getTranslatedForCurrentUser(context, 'xxsupporttktxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxcustomerxx'));
  }
  if (ticketStatus == TicketStatus.mediaAutoDeleted.index) {
    return
        // 'Media data of this Chat Support Ticket has been successfully deleted on its schedule time.';
        getTranslatedForCurrentUser(context, 'xxmediadeletedonscedulexx')
            .replaceAll('(####)',
                getTranslatedForCurrentUser(context, 'xxsupporttktxx'));
  } else if (ticketStatus == TicketStatus.needsAttention.index) {
    return
        // 'This Chat Support Need Attention From Agents';
        getTranslatedForCurrentUser(context, 'xxrequireattentionfromxx')
            .replaceAll(
                '(####)', getTranslatedForCurrentUser(context, 'xxagentsxx'));
  } else if (ticketStatus == TicketStatus.canWeCloseByAgent.index) {
    return
        // 'Waiting for the Customer To Close the Ticket';
        getTranslatedForCurrentUser(context, 'xxwaitingforxx')
            .replaceAll(
                '(####)', getTranslatedForCurrentUser(context, 'xxcustomerxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxtktsxx'));
  } else if (ticketStatus == TicketStatus.canWeCloseByCustomer.index) {
    return
        // 'Waiting for Agents To Close the Ticket';
        getTranslatedForCurrentUser(context, 'xxwaitingforxx')
            .replaceAll(
                '(####)', getTranslatedForCurrentUser(context, 'xxagentsxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxtktsxx'));
  } else if (ticketStatus == TicketStatus.reOpenedByCustomer.index) {
    return
        // 'Chat Support is re-opened by the Customer';
        getTranslatedForCurrentUser(context, 'xxreopenedxx')
            .replaceAll('(####)',
                getTranslatedForCurrentUser(context, 'xxsupporttktxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxcustomerxx'));
  } else if (ticketStatus == TicketStatus.waitingForAgentsToJoinTicket.index) {
    return
        // 'Waiting for Agents to join this Support Ticket.';
        getTranslatedForCurrentUser(context, 'xxwaitingforxxtojoinxx')
            .replaceAll(
                '(####)', getTranslatedForCurrentUser(context, 'xxagentsxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxtktsxx'));
  } else if (ticketStatus == TicketStatus.reOpenedByAgent.index) {
    return
        // 'Chat Support is re-opened by the Agent';
        getTranslatedForCurrentUser(context, 'xxreopenedxx')
            .replaceAll('(####)',
                getTranslatedForCurrentUser(context, 'xxsupporttktxx'))
            .replaceAll(
                '(###)', getTranslatedForCurrentUser(context, 'xxagentxx'));
  }
  return 'This status is not defined yet';
}
