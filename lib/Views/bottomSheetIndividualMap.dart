import 'package:FleetTracker/Controllers/dashboard.dart';
import 'package:FleetTracker/Controllers/editVehicle.dart';
import 'package:FleetTracker/Controllers/polylineController.dart';
import 'package:FleetTracker/Controllers/search.dart';
import 'package:FleetTracker/Views/vehicleEditor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetIndividualMap extends StatelessWidget {
  final DashBoardController _dashBoardController =
      Get.put(DashBoardController());
  final VehicleEditController _vehicleEditController = Get.find();
  final PolyLineController _polyLineController = Get.find();
  final SearchController _searchController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _searchController.currentVehicleSearchedName.value = '';
              _dashBoardController
                  .changeViewtoMainMap(); // move currentView to Main Map
              _dashBoardController.changeMapCameraView();
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4.5,
              height: 65.0,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 4.0,
                      blurRadius: 3.0,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset("assets/back.png"),
                    width: 35.0,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Go Back",
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              Get.bottomSheet(
                  Container(
                    padding: EdgeInsets.all(10.0),
                    height: 100,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[400],
                              blurRadius: 2.0,
                              spreadRadius: 5.0)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0))),
                    child: Column(
                      children: [
                        Text(
                          'Select Date',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlineButton(
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              onPressed: () {
                                Get.back();
                                final String date = DateTime.now()
                                    .subtract(Duration(days: 1))
                                    .toString()
                                    .split(' ')[0];
                                _polyLineController.callComputePolyLine(
                                    _vehicleEditController.imeiNumber.value,
                                    date);
                              },
                              child: Text('Yesterday'),
                            ),
                            OutlineButton(
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              onPressed: () {
                                Get.back();
                                final String date = DateTime.now()
                                    .subtract(Duration(days: 2))
                                    .toString()
                                    .split(' ')[0];
                                _polyLineController.callComputePolyLine(
                                    _vehicleEditController.imeiNumber.value,
                                    date);
                              },
                              child: Text('2 days ago'),
                            ),
                            OutlineButton.icon(
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                onPressed: () async {
                                  final DateTime _selectedDate =
                                      await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now()
                                              .subtract(Duration(days: 1)),
                                          firstDate: DateTime.now()
                                              .subtract(Duration(days: 14)),
                                          lastDate: DateTime.now());
                                  Get.back();
                                  if (_selectedDate != null) {
                                    _polyLineController.callComputePolyLine(
                                        _vehicleEditController.imeiNumber.value,
                                        _selectedDate.toString().split(' ')[0]);
                                  }
                                },
                                icon: Icon(Icons.calendar_today_outlined),
                                label: Text('Select Day'))
                          ],
                        ),
                      ],
                    ),
                  ),
                  barrierColor: Colors.white.withAlpha(1));
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4.5,
              height: 65.0,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 4.0,
                      blurRadius: 3.0,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset("assets/history.png"),
                    width: 35.0,
                  ),
                  SizedBox(height: 4.0),
                  Text("History")
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              vehicleEditBottomSheet(context);
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 4.5,
              height: 65.0,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 4.0,
                      blurRadius: 3.0,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset("assets/edit.png"),
                    width: 35.0,
                  ),
                  SizedBox(height: 4.0),
                  Text("Edit")
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              launch('tel:' + _vehicleEditController.phoneNumber.value);
            },
            child: Container(
              height: 65.0,
              width: MediaQuery.of(context).size.width / 4.5,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 4.0,
                      blurRadius: 3.0,
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset("assets/call.png", width: 30.0),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Call",
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
