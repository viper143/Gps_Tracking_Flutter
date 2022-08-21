import 'dart:io';
import 'package:FleetTracker/Controllers/dashboard.dart';
import 'package:FleetTracker/Interceptors/newAccessToken.dart';
import 'package:FleetTracker/Views/CommonUI/snackBar.dart';
import 'package:FleetTracker/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart';

class VehicleEditController extends GetxController {
  RxString vehicleName = ''.obs;
  RxString vehicleModel = ''.obs;
  RxString projectName = 'All'.obs;
  RxString phoneNumber = ''.obs;
  RxString imeiNumber = ''.obs;
  RxBool status = false.obs;
  // RxString phoneNumber = ''.obs;

  editVehicleDetail() async {
    DashBoardController _dashBoardController = Get.find();

    FlutterSecureStorage _storage = new FlutterSecureStorage();
    Dio _dio = new Dio();

    try {
      String accessToken = await _storage.read(key: "accessToken");
    _dio.interceptors.add(RefreshTokenInterceptor());

      await _dio
          .postUri(Uri.parse(baseURL + "/edit-a-vehicle-details"),
              data: {
                'fleetIMEINumber': imeiNumber,
                'fleetName': vehicleName,
                'projectName': projectName,
                'phoneNumber': phoneNumber,
                'fleetModel': vehicleModel
              },
              options: Options(
                  contentType: "application/json",
                  headers: {"Authorization": "Bearer " + accessToken}))
          .then((value) {
        if (value.statusCode == HttpStatus.ok) {
          int updateIndex = _dashBoardController.allVehicleDetails.indexWhere(
              (element) => element.FleetIMEINumber == imeiNumber.value);
          _dashBoardController.allVehicleDetails[updateIndex].FleetName =
              vehicleName.value;
          _dashBoardController.allVehicleDetails[updateIndex].FleetModel =
              vehicleModel.value;
          _dashBoardController.allVehicleDetails[updateIndex].FleetPhoneNumber =
              phoneNumber.value;
          _dashBoardController.allVehicleDetails[updateIndex].ProjectName =
              projectName.value;
          Get.back();
          showSnackBaronServerResponse(
              'Edit Vehicle Details', 'Vehicle Detail Edited Successfully');
        } else {
          Get.back();
          showSnackBaronServerResponse('Edit Vehicle Details',
              'Error in Vehicle Detail Edit. Try Again!');
        }
      });
    } catch (e) {
      print(e);
      Get.back();
      showSnackBaronServerResponse(
          'Edit Vehicle Details', 'Error in Vehicle Detail Edit. Try Later!');
    }
  }
}
