import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

Widget getAssetImage(String assetName,
    {double? height, double? width, BoxFit? fit, double? scale}) {
  return Image.asset(
    "assets/images/$assetName",
    height: height,
    width: width,
    fit: fit,
    scale: scale,
  );
}








