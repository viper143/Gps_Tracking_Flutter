import 'dart:io';

import 'package:FleetTracker/Views/CommonUI/snackBar.dart';
import 'package:FleetTracker/Views/dashboard.dart';
import 'package:FleetTracker/Views/login.dart';
import 'package:FleetTracker/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  FlutterSecureStorage _flutterSecureStorage = new FlutterSecureStorage();
  Dio _dio = new Dio();
  @override
  void initState() {
    userCheckandNewToken();
    super.initState();
  }

  userCheckandNewToken() async {
    if (await _flutterSecureStorage.read(key: 'accessToken') == null ||
        await _flutterSecureStorage.read(key: 'refreshToken') == null ||
        await _flutterSecureStorage.read(key: 'email') == null ||
        await _flutterSecureStorage.read(key: 'role') == null ||
        await _flutterSecureStorage.read(key: 'name') == null) {
      _flutterSecureStorage.deleteAll();
      Get.offAll(Login());
      return;
    }
    String refreshToken = await _flutterSecureStorage.read(key: 'refreshToken');

    try {
      await _dio
          .post(baseURL + '/new-access-token-request',
              data: {'refreshToken': refreshToken},
              options: Options(headers: {'Content-Type': 'application/json'}))
          .then((value) async {
        if (value.statusCode == HttpStatus.ok) {
          await _flutterSecureStorage.write(
              key: 'accessToken', value: value.data['access_token']);
          Get.offAll(DashBoard());
          return;
        } else {
          showSnackBaronServerResponse(
              'Error', 'Poor Internet Connection. Try Again!');
        }
      });
    } catch (e) {
      print(e);
      showSnackBaronServerResponse(
          'Error', 'Poor Internet Connection. Try Later!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
