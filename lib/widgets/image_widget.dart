
import 'package:flutter/material.dart';

Widget imageWidget({required image, double? height, double? width}){
  return Image(
    image: AssetImage(
      image,
    ),
    height: height,
    width: width,
  );
}