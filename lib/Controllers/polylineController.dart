import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:FleetTracker/Controllers/dashboard.dart';
import 'package:FleetTracker/Interceptors/newAccessToken.dart';
import 'package:FleetTracker/Model/polyline.dart';
import 'package:FleetTracker/Views/CommonUI/snackBar.dart';
import 'package:FleetTracker/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolyLineController extends GetxController {
  RxSet<Polyline> polylines = Set<Polyline>().obs;
  RxDouble totalDistance = 0.0.obs;
  List<LatLng> allPoints;

  callComputePolyLine(String imeiNumber, String date) async {
    totalDistance.value = 0.0;
    DashBoardController _dashBoardController = Get.find();
    FlutterSecureStorage _storage = new FlutterSecureStorage();
    Dio _dio = Dio();
    _dio.interceptors.add(RefreshTokenInterceptor());

    try {
      String accessToken = await _storage.read(key: "accessToken");

      await _dio
          .get(
              baseURL +
                  "/one-vehicle-daily-history?vehicleID=" +
                  "0" +
                  imeiNumber.substring(4, 15) +
                  "&date=" +
                  date,
              options:
                  Options(headers: {"Authorization": "Bearer " + accessToken}))
          .then((value) async {
        if (value.statusCode == HttpStatus.ok) {
          final result = await compute(fetchPolylines, value.data.toString());
          polylines.clear();
          if (result[0].length < 2) {
            showSnackBaronServerResponse(
                'Routes', 'No Routes Available. Try Another Date');
            return;
          }
          allPoints = result[0];
          polylines.add(Polyline(
              startCap: Cap.customCapFromBitmap(
                  _dashBoardController.pinStartIcon,
                  refWidth: 15),
              endCap: Cap.customCapFromBitmap(_dashBoardController.pinEndIcon,
                  refWidth: 15),
              polylineId: PolylineId("0" + imeiNumber.substring(4, 15)),
              color: Colors.black,
              width: 6,
              patterns: [
                PatternItem.dash(30),
                PatternItem.dot,
                PatternItem.gap(10)
              ],
              jointType: JointType.mitered,
              points: allPoints));
          _dashBoardController.allMarkers.value.clear();
          totalDistance.value = result[1];
        } else if (value.statusCode == HttpStatus.noContent) {
          polylines.clear();
          showSnackBaronServerResponse(
              'Vehicle Routes', 'No Vehicle Route Available');
        } else {
          polylines.clear();
          showSnackBaronServerResponse(
              'Vehicle Routes', 'Error Loading Vehicle Routes. Try Again!');
        }
      });
    } catch (e) {
      polylines.clear();
      showSnackBaronServerResponse(
          'Vehicle Routes', 'Error Loading Vehicle Routes. Please Try Later!');
      return;
    }
  }
}

List fetchPolylines(String value) {
  List<LatLng> polyLineList = [];
  double totalDistance = 0;
  var allPolyLineDetails = (json.decode(value) as List)
      .map((e) => new PolyLineModel.fromJson(e))
      .toList();

  for (int i = 0; i < allPolyLineDetails.length - 1; i++) {
    double latitudeDifference = double.parse(allPolyLineDetails[i].Latitude) -
        double.parse(allPolyLineDetails[i + 1].Latitude);
    double longitudeDifference = double.parse(allPolyLineDetails[i].Longitude) -
        double.parse(allPolyLineDetails[i + 1].Longitude);
    if (latitudeDifference > 0.000010 || longitudeDifference > 0.000010) {
      polyLineList.add(LatLng(double.parse(allPolyLineDetails[i].Latitude),
          double.parse(allPolyLineDetails[i].Longitude)));
      totalDistance += calculateDistance(
          double.parse(allPolyLineDetails[i].Latitude),
          double.parse(allPolyLineDetails[i].Longitude),
          double.parse(allPolyLineDetails[i + 1].Latitude),
          double.parse(allPolyLineDetails[i + 1].Longitude));
    }
  }
  return [polyLineList, totalDistance];
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
