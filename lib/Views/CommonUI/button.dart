import 'package:flutter/material.dart';

import '../../constants.dart';

Widget buildButton(BuildContext context, String content, double widthValue) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
    width: MediaQuery.of(context).size.width * widthValue,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          buttonBeginColor,
          buttonEndColor,
        ],
        begin: FractionalOffset.centerLeft,
        end: FractionalOffset.centerRight,
      ),
      color: Colors.white,
      borderRadius: BorderRadius.circular(29),
    ),
    child: Center(
      child: FittedBox(
        child: Text(
          '$content',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}
