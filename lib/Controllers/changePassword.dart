import 'package:FleetTracker/Controllers/authentication.dart';
import 'package:FleetTracker/Interceptors/newAccessToken.dart';
import 'package:FleetTracker/Views/CommonUI/snackBar.dart';
import 'package:FleetTracker/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart';
import 'dart:io';

class ChangePasswordController extends GetxController {
  RxBool showNewPassword = false.obs;
  RxBool showOldPassword = false.obs;
  RxBool showConfirmPassword = false.obs;
  RxBool isHavingAPICall = false.obs;
  final AuthenticationController _authenticationController = Get.find();
  changePassword(String oldPassword, String newPassword) async {
    isHavingAPICall.value = true;
    FlutterSecureStorage _storage = new FlutterSecureStorage();
    Dio _dio = new Dio();
    _dio.interceptors.add(RefreshTokenInterceptor());

    try {
      String accessToken = await _storage.read(key: "accessToken");

      await _dio
          .postUri(Uri.parse(baseURL + "/changepassword"),
              data: {"oldpassword": oldPassword, "newpassword": newPassword},
              options: Options(
                  contentType: "application/json",
                  headers: {"Authorization": "Bearer " + accessToken}))
          .then((value) {
        isHavingAPICall.value = false;
        if (value.statusCode == HttpStatus.ok) {
          showSnackBaronServerResponse(
              'Password Change', 'Password Changed Successfully');
          _authenticationController.logoutCurrentUser();
        } else {
          showSnackBaronServerResponse(
              'Password Change', 'Error Changing Password. Try Again!');
        }
      });
    } on DioError catch (e) {
      isHavingAPICall.value = false;
      if (e.response.statusCode == HttpStatus.notAcceptable) {
        showSnackBaronServerResponse('Password Change', 'Incorrect Password');
      } else {
        showSnackBaronServerResponse(
            'Password Change', 'Error Changing Password. Try Later!');
      }
    }
  }
}
