import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';

Widget sectionHeader(String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 27, 7, 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 12.5,
                letterSpacing: 0.9,
                color: Mycolors.grey,
                fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}
