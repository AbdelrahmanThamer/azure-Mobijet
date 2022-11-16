import 'package:flutter/material.dart';

String reverse(String string) {
  if (string.length < 2) {
    return string;
  }

  final characters = Characters(string);
  return characters.toList().reversed.join();
}
