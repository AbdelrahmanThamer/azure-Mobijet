//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Definition attached with source code. *********************

import 'package:flutter/services.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';

setStatusBarColor() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Mycolors.statusbarColor,
      statusBarIconBrightness:
          Mycolors.isStausbardarkIcons ? Brightness.dark : Brightness.light));
}
