// widget method to build header gif section
import 'package:flutter/material.dart';

Widget buildHeaderGif(BuildContext context) {
  return Image.asset(
    'assets/mainHeader.gif',
    height: MediaQuery.of(context).size.height * 0.30,
    width: MediaQuery.of(context).size.width * 0.8,
  );
}