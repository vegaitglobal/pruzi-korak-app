import 'package:flutter/material.dart';

class UiConstants {

  static OutlineInputBorder outlineInputBorder(
      {required Color borderColor, double borderRadius = 12.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: borderColor),
    );
  }

  static BoxShadow boxShadow(Color color) {
    return BoxShadow(
      color: color.withOpacity(0.15),
      spreadRadius: 1,
      blurRadius: 4,
      offset: const Offset(0, 2),
    );
  }
}
