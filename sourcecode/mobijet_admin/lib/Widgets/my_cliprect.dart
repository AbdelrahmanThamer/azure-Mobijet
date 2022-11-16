import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/number_limits.dart';

myCliprectLogo(Widget widget) {
  return ClipRRect(
      borderRadius: BorderRadius.circular(Numberlimits.defaultclipradius),
      child: widget);
}
