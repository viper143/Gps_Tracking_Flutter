import 'package:FleetTracker/Controllers/dashboard.dart';
import 'package:FleetTracker/Controllers/editVehicle.dart';
import 'package:FleetTracker/Controllers/polylineController.dart';
import 'package:FleetTracker/Controllers/search.dart';
import 'package:FleetTracker/Views/bottomSheetIndividualMap.dart';
import 'package:FleetTracker/Views/bottomSheetMainMap.dart';
import 'package:FleetTracker/Views/profile.dart';
import 'package:FleetTracker/Views/searchPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashBoard extends StatelessWidget {
  final PolyLineController _polyLineController = Get.put(PolyLineController());

  final DashBoardController _dashBoardController =
      Get.put(DashBoardController());

  final SearchController _searchController = Get.find();

  final VehicleEditController _vehicleEditController = Get.find();

  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    _dashBoardController.hasDataAlreadyRecieved.value == false
        ? _dashBoardController.retrieveAllVehicleDetail()
        : null;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Obx(() {
                return GoogleMap(
                    mapToolbarEnabled: false,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(27.722576, 85.324765), zoom: 12.0),
                    markers: Set.from(_dashBoardController.allMarkers.value),
                    polylines: Set.from(_polyLineController.polylines),
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    onMapCreated: (GoogleMapController _controller) {
                      _dashBoardController.googleMapController = _controller;
                    });
              })),
          new Positioned(
              top: 40.0,
              right: 50.0,
              left: 20.0,
              child: GestureDetector(
                onTap: () {
                  showSearch(context: context, delegate: SearchPage());
                },
                child: Container(
                    height: 40.0,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 12.0),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _searchController.currentVehicleSearchedName.value ==
                                  ''
                              ? Text(
                                  'Search Vehicles...',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0),
                                )
                              : Text(
                                  _searchController
                                      .currentVehicleSearchedName.value,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0),
                                ),
                          _searchController.currentVehicleSearchedName.value !=
                                  ''
                              ? IconButton(
                                  iconSize: 20,
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    _searchController
                                        .currentVehicleSearchedName.value = '';
                                    _dashBoardController.changeViewtoMainMap();
                                    _dashBoardController.currentView.value =
                                        true;
                                  },
                                  padding: EdgeInsets.zero,
                                )
                              : IconButton(
                                  iconSize: 20,
                                  icon: Icon(Icons.search),
                                  onPressed: () {
                                    showSearch(
                                        context: context,
                                        delegate: SearchPage());
                                  },
                                  padding: EdgeInsets.zero,
                                )
                        ],
                      );
                    })),
              )),
          new Positioned(
            height: 40.0,
            top: 40.0,
            right: 0.0,
            child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.black,
                  size: 35.0,
                ),
                onPressed: () {
                  Get.to(UserProfile());
                }),
          ),
          Obx(() {
            return _dashBoardController.currentView.value == false
                ? Positioned(
                    bottom: 80,
                    right: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: _vehicleEditController.status.value
                                  ? Colors.green
                                  : Colors.red),
                          child: Text(
                              _vehicleEditController.status.value
                                  ? 'Online'
                                  : 'Offline',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                        Container(
                          child: Text(
                            _vehicleEditController.vehicleName.value,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          child: Text(_vehicleEditController.vehicleModel.value,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                        Container(
                          child: Text(_vehicleEditController.projectName.value,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                        Container(
                          child: Text(
                            _polyLineController.totalDistance.value
                                    .toStringAsFixed(2)
                                    .toString() +
                                " KM",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ))
                : Container();
          }),
          new Positioned(
            bottom: 8.0,
            left: 10.0,
            right: 10.0,
            child: Obx(() {
              return _dashBoardController.currentView.value == true
                  ? BottomSheetMainMap()
                  : BottomSheetIndividualMap();
            }),
          )
        ],
      ),
    );
  }
}
