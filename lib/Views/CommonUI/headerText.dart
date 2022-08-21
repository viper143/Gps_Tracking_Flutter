// widget method to build header text
import 'package:flutter/material.dart';

Widget buildHeaderText(BuildContext context) {
  return Container(
    child: Text(
      'Fleet Tracker',
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.height / 16,
        letterSpacing: 2.5,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}