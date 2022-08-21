import 'dart:io';
import 'package:FleetTracker/Controllers/authentication.dart';
import 'package:FleetTracker/Interceptors/newAccessToken.dart';
import 'package:FleetTracker/Views/CommonUI/snackBar.dart';
import 'package:FleetTracker/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart';

class NewProjectController extends GetxController {
  AuthenticationController _authenticationController = Get.find();
  RxBool isHavingAPICall = false.obs;
  Dio _dio = new Dio();
  FlutterSecureStorage _storage = new FlutterSecureStorage();

  addNewProject(String projectName) async {
    _dio.interceptors.add(RefreshTokenInterceptor());

    isHavingAPICall.value = true;
    if (_authenticationController.projects.value.contains(projectName)) {
      isHavingAPICall.value = false;
      showSnackBaronServerResponse(
          'New Project', 'Project Name Already Exists');
      return;
    }
    try {
      String accessToken = await _storage.read(key: "accessToken");
      await _dio
          .postUri(Uri.parse(baseURL + "/add-new-project"),
              data: {"projects": projectName},
              options: Options(
                  contentType: "application/json",
                  headers: {"Authorization": "Bearer " + accessToken}))
          .then((value) {
        if (value.statusCode == HttpStatus.ok) {
          _authenticationController.projects.value.add(projectName);
          Get.back();
          showSnackBaronServerResponse(
              'New Project', 'New Project Added Successfully');
        } else {
          showSnackBaronServerResponse(
              'New Project', 'Error Adding New Project. Try Again!');
        }
        isHavingAPICall.value = false;
      });
    } on DioError catch (e) {
      isHavingAPICall.value = false;
      if (e.response.statusCode == HttpStatus.conflict) {
        showSnackBaronServerResponse(
            'New Project', 'Error Adding New Project. Try Again!');
      } else {
        showSnackBaronServerResponse('New Project', 'Server Error. Try Later!');
      }
    }
  }
}
