import 'dart:convert';
import 'dart:io';
import 'package:FleetTracker/Controllers/authentication.dart';
import 'package:FleetTracker/Views/CommonUI/snackBar.dart';
import 'package:FleetTracker/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart';

class VehicleProjectController extends GetxController {
  RxString currentSelectedProject = 'All'.obs;
  AuthenticationController _authenticationController = Get.find();

  loadAllProjectsName() async {
    Dio _dio = new Dio();
    FlutterSecureStorage _storage = new FlutterSecureStorage();
    String accessToken = await _storage.read(key: "accessToken");

    try {
      await _dio
          .get(baseURL + '/all-project-list',
              options:
                  Options(headers: {"Authorization": "Bearer " + accessToken}))
          .then((value) {
        if (value.statusCode == HttpStatus.ok) {
          List _list = json.decode(value.data);
          List<String> _list1 = List<String>.from(_list);
          _authenticationController.projects.value.addAll(_list1);
        } else {
          showSnackBaronServerResponse(
              'View Project', 'Unable to load project name. Try Again!');
        }
      });
    } catch (e) {
      showSnackBaronServerResponse(
          'View Project', 'Unable to load project name. Try Later!');
    }
  }
}
