// widget method to build sub heading
import 'package:flutter/material.dart';

Widget buildSubHeaderText(BuildContext context, String subHeader) {
  return Container(
    padding: EdgeInsets.only(top: 8),
    child: Text(
      '$subHeader',
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.height / 40,
      ),
    ),
  );
}