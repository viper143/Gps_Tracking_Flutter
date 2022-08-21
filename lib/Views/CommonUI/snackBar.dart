import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBaronServerResponse(String title, String message) {
  return Get.snackbar('', '',
      titleText: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        textAlign: TextAlign.center,
      ),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
      ),
      duration: Duration(milliseconds: 1800),
      snackPosition: SnackPosition.BOTTOM);
}