import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:FleetTracker/Controllers/dashboard.dart';
import 'package:FleetTracker/Model/authentication.dart';
import 'package:FleetTracker/Views/CommonUI/snackBar.dart';
import 'package:FleetTracker/Views/addNewVehicle.dart';
import 'package:FleetTracker/Views/dashboard.dart';
import 'package:FleetTracker/Views/login.dart';
import 'package:FleetTracker/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  Dio _dio = new Dio();
  FlutterSecureStorage _storage = new FlutterSecureStorage();

  Rx<HashSet<String>> projects = HashSet<String>().obs;
  RxBool isHavingAPICall = false.obs;
  RxBool showLoginPassword = false.obs;
  RxBool showRegisterPassword = false.obs;
  RxString selectedRole = 'Personal'.obs;

  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString accountType = ''.obs;

  loginUser(String email, String password) async {
    isHavingAPICall.value = true;
    try {
      await _dio.postUri(Uri.parse(baseURL + "/login"),
          options: Options(
              headers: {"content-type": "application/json"}, receiveTimeout: 3),
          data: {"email": email, "password": password}).then((value) async {
        if (value.statusCode == HttpStatus.ok) {
          AuthenticationModel authenticationModel =
              AuthenticationModel.fromJson(json.decode(value.data));
          await _saveToSecureStorage(authenticationModel);
          isHavingAPICall.value = false;
          Get.offAll(DashBoard());
        } else {
          isHavingAPICall.value = false;
          showSnackBaronServerResponse(
              "Login Unsuccessful", "Error Logging In. Try Again!");
        }
      });
    } on DioError catch (e) {
      isHavingAPICall.value = false;
      if (e.response.statusCode == HttpStatus.notFound ||
          e.response.statusCode == HttpStatus.unauthorized) {
        showSnackBaronServerResponse(
            "Login Unsuccessful", "Invalid Username and Password");
      } else {
        showSnackBaronServerResponse(
            "Login Unsuccessful", "Server Error. Try Later!");
      }
    }
  }

  registerUser(
    String companyName,
    String email,
    String password,
    String phone,
  ) async {
    isHavingAPICall.value = true;
    try {
      await _dio.postUri(
          Uri.parse(
            baseURL + "/register",
          ),
          options: Options(
            headers: {"content-type": "application/json"},
          ),
          data: {
            "companyName": companyName,
            "email": email,
            "role": selectedRole,
            "phone": phone,
            "password": password,
          }).then((value) async {
        if (value.statusCode == 200) {
          AuthenticationModel authenticationModel =
              AuthenticationModel.fromJson(json.decode(value.data));
          await _saveToSecureStorage(authenticationModel);
          isHavingAPICall.value = false;
          Get.offAll(RegisterVehicle());
        } else {
          isHavingAPICall.value = false;
          showSnackBaronServerResponse(
              'Register Unsuccessful', 'Registration Error. Try Later!');
        }
      });
    } on DioError catch (e) {
      isHavingAPICall.value = false;
      if (e.response.statusCode == HttpStatus.found) {
        showSnackBaronServerResponse(
            'Register Unsuccessful', 'User Already Exists!');
      } else {
        showSnackBaronServerResponse(
            'Register Unsuccessful', 'Server Error. Try Later!');
      }
    }
  }

  _saveToSecureStorage(AuthenticationModel authenticationModel) async {
    await _storage.write(key: "name", value: authenticationModel.companyName);
    await _storage.write(key: "email", value: authenticationModel.email);
    await _storage.write(key: "role", value: authenticationModel.role);
    await _storage.write(
        key: "refreshToken", value: authenticationModel.refreshToken);
    await _storage.write(
        key: "accessToken", value: authenticationModel.accessToken);
    projects.value.addAll(authenticationModel.projectName);

    name.value = authenticationModel.companyName;
    email.value = authenticationModel.email;
    accountType.value = authenticationModel.role;
  }

  logoutCurrentUser() async {
    try {
      // await _dio.post(baseURL + '/logout',
      //     options: Options(
      //       headers: {"content-type": "application/json"},
      //     ),
      //     data: {
      //       "accessToken": await _storage.read(key: 'accessToken'),
      //       "refreshToken": await _storage.read(key: 'refreshToken')
      //     }).then((value) async {

      // });
      DashBoardController _dashBoardController = Get.find();
      _dashBoardController.currentView.value = true;
      _dashBoardController.channel.sink.close();
      _dashBoardController.currentView.value = true;
      Get.delete();
      await _storage.deleteAll();
      Get.offAll(Login());
    } catch (e) {
      showSnackBaronServerResponse(
          'Logout Error', 'Error Logging Out. Try Again!');
      return;
    }
  }

  refreshUserData() async {
    try {
      String accessToken = await _storage.read(key: "accessToken");

      await _dio
          .get(baseURL + '/user-data-refresh',
              options: Options(
                  contentType: "application/json",
                  headers: {"Authorization": "Bearer " + accessToken}))
          .then((value) async {
        if (value.statusCode == HttpStatus.ok) {
          final responseData = json.decode(value.data);
          name.value = responseData['companyName'];
          email.value = responseData['email'];
          accountType.value = responseData['role'];
          await _storage.write(key: "name", value: responseData['companyName']);
          await _storage.write(key: "email", value: responseData['email']);
          await _storage.write(key: "role", value: responseData['role']);
          projects.value.addAll(List<String>.from(responseData['projects']));
        } else {
          showSnackBaronServerResponse(
              'Fleet Tracker', 'Unable to Refresh Data');
        }
      });
    } catch (e) {
      showSnackBaronServerResponse('Fleet Tracker', 'Unable to Refresh Data');
    }
  }
}
