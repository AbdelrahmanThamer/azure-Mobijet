//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Definition attached with source code. *********************

import 'package:thinkcreative_technologies/Configs/enum.dart';

bool isRobotic(int i) {
  return i == MessageType.audio.index ||
          i == MessageType.video.index ||
          i == MessageType.doc.index ||
          i == MessageType.image.index ||
          i == MessageType.location.index ||
          i == MessageType.contact.index ||
          i == MessageType.text.index
      ? false
      : true;
}
