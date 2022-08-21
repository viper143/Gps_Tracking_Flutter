import 'dart:convert';
import 'dart:io';
import 'package:FleetTracker/Controllers/editVehicle.dart';
import 'package:FleetTracker/Controllers/polylineController.dart';
import 'package:FleetTracker/Controllers/projectController.dart';
import 'package:FleetTracker/Controllers/search.dart';
import 'package:FleetTracker/Interceptors/newAccessToken.dart';
import 'package:FleetTracker/Model/detail.dart';
import 'package:FleetTracker/Views/CommonUI/snackBar.dart';
import 'package:FleetTracker/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/io.dart';

class DashBoardController extends GetxController {
  final VehicleProjectController _vehicleProjectController =
      Get.put(VehicleProjectController());

  final SearchController _searchController = Get.put(SearchController());

  final PolyLineController _polyLineController = Get.find();

  RxBool currentView =
      true.obs; // if true main map is shown else individual map is loaded.

  RxBool hasDataAlreadyRecieved = false.obs;

  List<DetailModel> allVehicleDetails = List<DetailModel>().obs;

  Rx<RxList<Marker>> allMarkers = RxList<Marker>().obs;

  RxInt onlineVehicles = 0.obs;
  RxInt offlineVehicles = 0.obs;

  FlutterSecureStorage _storage = FlutterSecureStorage();
  Dio _dio = Dio();

  BitmapDescriptor pinLocationIcon;

  BitmapDescriptor pinStartIcon;

  BitmapDescriptor pinEndIcon;

  final VehicleEditController _vehicleEditController =
      Get.put(VehicleEditController());

  IOWebSocketChannel channel =
      IOWebSocketChannel.connect("ws://167.71.225.146:3000/");

  GoogleMapController googleMapController;

  Future<void> changeMapCameraView() async {
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(27.722576, 85.324765), zoom: 12.0)));
  }

  retrieveAllVehicleDetail() async {
    _dio.interceptors.add(RefreshTokenInterceptor());
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 50), 'assets/start_icon.png')
        .then((onValue) {
      pinStartIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 50), 'assets/stop_icon.png')
        .then((onValue) {
      pinEndIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(15, 15)), 'assets/pin_icon.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });

    try {
      String accessToken = await _storage.read(key: "accessToken");
      await _dio
          .get(baseURL + "/all-vehicle-last-position-with-details",
              options:
                  Options(headers: {"Authorization": "Bearer " + accessToken}))
          .then((value) {
        if (value.statusCode == HttpStatus.ok) {
          hasDataAlreadyRecieved.value = true;
          allVehicleDetails = (json.decode(value.data) as List)
              .map((e) => new DetailModel.fromJson(e))
              .toList();
          allVehicleDetails.forEach((element) {
            if (element.Status == true) {
              onlineVehicles.value++;
            } else {
              offlineVehicles.value++;
            }
            if (element.Latitude != "" && element.Longitude != "") {
              allMarkers.value.add(markerMaker(
                  element.FleetIMEINumber,
                  element.Latitude,
                  element.Longitude,
                  element.FleetName,
                  element.FleetPhoneNumber,
                  element.ProjectName,
                  element.FleetModel,
                  element.Status,
                  true));
            }
            String topic = '{"action": "subscribe", "topic": "0' +
                element.FleetIMEINumber.substring(4, 15) +
                '"}';
            channel.sink.add(topic);
          });
          _updateMarker();
        } else {
          showSnackBaronServerResponse(
              'DashBoard', 'Error Loading Vehicles. Try Again!');
        }
      });
    } on DioError catch (_) {
      showSnackBaronServerResponse(
          'DashBoard', 'Error Loading Vehicles. Try Later!');
    }
  }

  _updateMarker() {
    channel.stream.listen((event) {
      var data = json.decode(event);
      int updateIndex = allVehicleDetails.indexWhere((element) =>
          "0" + element.FleetIMEINumber.substring(4, 15) == data['deviceID']);
      allVehicleDetails[updateIndex].Latitude = data['latitude'];
      allVehicleDetails[updateIndex].Longitude = data['longitude'];
      allVehicleDetails[updateIndex].TimeStamp = data['timestamp'];
      if (allVehicleDetails[updateIndex].Status == false) {
        onlineVehicles.value++;
        offlineVehicles.value--;
        allVehicleDetails[updateIndex].Status = true;
      }
      final marker = allMarkers.value
          .toList()
          .firstWhere((e) => e.markerId == MarkerId(data['deviceID']));
      allMarkers.value.add(Marker(
          onTap: marker.onTap,
          icon: marker.icon,
          markerId: marker.markerId,
          position: LatLng(double.parse(data['latitude']),
              double.parse(data['longitude']))));
      if (currentView.value == false) {
        _polyLineController.allPoints.add(LatLng(
            double.parse(data['latitude']), double.parse(data['longitude'])));
      }
    });
  }

  insertNewVehicletoList(DetailModel detailModel) {
    allVehicleDetails.add(detailModel);
    allMarkers.value.add(markerMaker(
        detailModel.FleetIMEINumber,
        detailModel.Latitude,
        detailModel.Longitude,
        detailModel.FleetName,
        detailModel.FleetPhoneNumber,
        detailModel.ProjectName,
        detailModel.FleetModel,
        detailModel.Status,
        true));
    String topic = '{"action": "subscribe", "topic": "0' +
        detailModel.FleetIMEINumber.substring(4, 15) +
        '"}';
    offlineVehicles.value++;
    channel.sink.add(topic);
  }

  changeViewtoIndividualMap() async {
    allMarkers.value.clear();
    int index = allVehicleDetails.indexWhere((element) =>
        element.FleetIMEINumber == _vehicleEditController.imeiNumber.value);

    _polyLineController.callComputePolyLine(
        _vehicleEditController.imeiNumber.value,
        DateTime.now().toString().split(' ')[0]);

    allMarkers.value.add(markerMaker(
        allVehicleDetails[index].FleetIMEINumber,
        allVehicleDetails[index].Latitude,
        allVehicleDetails[index].Longitude,
        allVehicleDetails[index].FleetName,
        allVehicleDetails[index].FleetPhoneNumber,
        allVehicleDetails[index].ProjectName,
        allVehicleDetails[index].FleetModel,
        allVehicleDetails[index].Status,
        true));
  }

  changeViewtoMainMap() {
    currentView.value = true;
    allMarkers.value.clear();
    _polyLineController.polylines.clear();
    if (_vehicleProjectController.currentSelectedProject.value == 'All') {
      allVehicleDetails.forEach((element) {
        if (element.Latitude != "" && element.Longitude != "") {
          allMarkers.value.add(markerMaker(
              element.FleetIMEINumber,
              element.Latitude,
              element.Longitude,
              element.FleetName,
              element.FleetPhoneNumber,
              element.ProjectName,
              element.FleetModel,
              element.Status,
              true));
        }
      });
    } else {
      allVehicleDetails.forEach((element) {
        if (_vehicleProjectController.currentSelectedProject.value ==
            element.ProjectName) {
          if (element.Latitude != "" && element.Longitude != "") {
            allMarkers.value.add(markerMaker(
                element.FleetIMEINumber,
                element.Latitude,
                element.Longitude,
                element.FleetName,
                element.FleetPhoneNumber,
                element.ProjectName,
                element.FleetModel,
                element.Status,
                true));
          }
        }
      });
    }
  }

  Marker markerMaker(
      String imeiNumber,
      String latitude,
      String longitude,
      String fleetName,
      String phoneNumber,
      String projectName,
      String fleetModel,
      bool status,
      bool visible) {
    return Marker(
        markerId: MarkerId('0' + imeiNumber.substring(4, 15)),
        position: LatLng(
          double.parse(latitude),
          double.parse(longitude),
        ),
        visible: visible,
        icon: pinLocationIcon,
        onTap: () {
          _vehicleEditController.vehicleName.value = fleetName;
          _vehicleEditController.imeiNumber.value = imeiNumber;
          _vehicleEditController.phoneNumber.value = phoneNumber;
          _vehicleEditController.projectName.value = projectName;
          _vehicleEditController.vehicleModel.value = fleetModel;
          _vehicleEditController.status.value = status;
          if (currentView.value != false) {
            changeViewtoIndividualMap();
          }
          currentView.value = false;
        });
  }
}
