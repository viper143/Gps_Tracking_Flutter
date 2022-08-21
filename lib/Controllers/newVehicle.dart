import 'dart:io';
import 'package:FleetTracker/Controllers/dashboard.dart';
import 'package:FleetTracker/Interceptors/newAccessToken.dart';
import 'package:FleetTracker/Model/detail.dart';
import 'package:FleetTracker/Views/CommonUI/snackBar.dart';
import 'package:FleetTracker/Views/dashboard.dart';
import 'package:FleetTracker/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart';

class VehicleController extends GetxController {
  RxString fleetType = 'Car'.obs;
  RxString projectName = 'All'.obs;
  RxBool isHavingAPICall = false.obs;
  Dio _dio = new Dio();
  FlutterSecureStorage _storage = new FlutterSecureStorage();
  DashBoardController _dashBoardController = Get.find();

  registerNewVehicle(String driverName, String imeiNumber, String phoneNumber,
      String carModel) async {
    _dio.interceptors.add(RefreshTokenInterceptor());
    
    isHavingAPICall.value = true;
    try {
      String accessToken = await _storage.read(key: "accessToken");
      await _dio
          .postUri(Uri.parse(baseURL + "/add-new-device"),
              data: {
                "fleetName": driverName,
                "fleetIMEINumber": imeiNumber,
                "fleetPhoneNumber": phoneNumber,
                "fleetModel": carModel,
                "fleetType": fleetType.value,
                "projectName": projectName.value
              },
              options: Options(
                  contentType: "application/json",
                  headers: {"Authorization": "Bearer " + accessToken}))
          .then((value) {
        if (value.statusCode == HttpStatus.ok) {
          _dashBoardController.insertNewVehicletoList(DetailModel(
              driverName,
              imeiNumber,
              phoneNumber,
              fleetType.value,
              'companyID',
              false,
              carModel,
              false,
              projectName.value,
              '27.666',
              '85.288',
              ((DateTime.now().millisecondsSinceEpoch) / 1000).toString()));
          if (Get.previousRoute == null) {
            Get.offAll(DashBoard());
          } else {
            Get.back();
          }
          showSnackBaronServerResponse(
              'Register Vehicle', 'New Vehicle Registered Successfully');
        } else {
          showSnackBaronServerResponse(
              'Registration Unsuccessful', 'Error Adding Vehicle. Try Again!');
        }
        isHavingAPICall.value = false;
      });
    } on DioError catch (e) {
      isHavingAPICall.value = false;
      if (e.response.statusCode == HttpStatus.conflict) {
        showSnackBaronServerResponse(
            'Register Vehicle', 'Vehicle Already Exists!');
      } else {
        showSnackBaronServerResponse(
            'Register Vehicle', 'Error Adding Vehicle. Try Later!');
      }
    }
  }
}
