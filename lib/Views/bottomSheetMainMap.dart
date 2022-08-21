import 'package:FleetTracker/Controllers/authentication.dart';
import 'package:FleetTracker/Controllers/dashboard.dart';
import 'package:FleetTracker/Controllers/projectController.dart';
import 'package:FleetTracker/Views/CommonUI/snackBar.dart';
import 'package:FleetTracker/Views/addNewProject.dart';
import 'package:FleetTracker/Views/addNewVehicle.dart';
import 'package:FleetTracker/Views/allVehicleList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetMainMap extends StatelessWidget {
  final AuthenticationController _authenticationController = Get.find();
  final DashBoardController _dashBoardController = Get.find();
  final VehicleProjectController _vehicleProjectController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(RegisterVehicle());
            },
            child: Container(
                padding: EdgeInsets.all(6.0),
                width: MediaQuery.of(context).size.width / 4.5,
                alignment: Alignment.center,
                height: 65.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 4.0,
                      blurRadius: 3.0,
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          child: Image.asset("assets/add-vehicle.png",
                              height: 35.0)),
                      FittedBox(
                          fit: BoxFit.contain,
                          child: Text("Add Vehicle",
                              style: TextStyle(fontSize: 14.0))),
                    ])),
          ),
          _authenticationController.accountType.value == "Business"
              ? GestureDetector(
                  onTap: () async {
                    if (_authenticationController.projects.value.length == 0) {
                      showSnackBaronServerResponse('View Projects',
                          'Loading Project Name. Please Wait...');
                      // VehicleProjectController _vehicleProjectController =
                      //     Get.put(VehicleProjectController());
                      // await _vehicleProjectController.loadAllProjectsName();
                    }
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text("Select Project"),
                            content: Container(
                                height: _authenticationController
                                        .projects.value.length *
                                    40.0,
                                child: Obx(() {
                                  List<String> _list = _authenticationController
                                      .projects.value
                                      .toList();
                                  return ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      height: 25.0,
                                    ),
                                    itemCount: _list.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          _vehicleProjectController
                                              .currentSelectedProject
                                              .value = _list[index];
                                          Get.back();
                                          _dashBoardController
                                              .changeViewtoMainMap();
                                        },
                                        child: Container(
                                          width: Get.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _list[index],
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                              SizedBox(width: 16.0),
                                              _list[index] ==
                                                      _vehicleProjectController
                                                          .currentSelectedProject
                                                          .value
                                                  ? Icon(Icons.check,
                                                      size: 20.0,
                                                      color: Colors.blue)
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                })),
                            actions: [
                              FlatButton.icon(
                                  onPressed: () {
                                    Get.to(ProjectPage());
                                  },
                                  icon: Icon(Icons.add, color: Colors.blue),
                                  label: FittedBox(
                                      child: Text(
                                    "Add Project",
                                    style: TextStyle(color: Colors.blue),
                                  ))),
                              FlatButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close, color: Colors.red),
                                  label: Text("Close",
                                      style: TextStyle(color: Colors.red))),
                            ],
                          );
                        });
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width / 4.5,
                      alignment: Alignment.center,
                      height: 65.0,
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 4.0,
                            blurRadius: 3.0,
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                child: Image.asset("assets/project.png",
                                    height: 35.0)),
                            FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  "View Projects",
                                  style: TextStyle(fontSize: 14.0),
                                ))
                          ])),
                )
              : Container(),
          GestureDetector(
            onTap: () => Get.to(AllVehicleList(1)),
            child: Container(
                width: MediaQuery.of(context).size.width / 4.5,
                alignment: Alignment.center,
                height: 65.0,
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 4.0,
                      blurRadius: 3.0,
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() {
                        return Text(
                            _dashBoardController.onlineVehicles.value
                                .toString(),
                            style:
                                TextStyle(color: Colors.green, fontSize: 26.0));
                      }),
                      SizedBox(height: 4.0),
                      FittedBox(
                          fit: BoxFit.contain,
                          child: Text("Online",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.green))),
                    ])),
          ),
          GestureDetector(
            onTap: () => Get.to(AllVehicleList(2)),
            child: Container(
                width: MediaQuery.of(context).size.width / 4.5,
                alignment: Alignment.center,
                height: 65.0,
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 4.0,
                      blurRadius: 3.0,
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() {
                        return Text(
                            _dashBoardController.offlineVehicles.value
                                .toString(),
                            style:
                                TextStyle(color: Colors.red, fontSize: 26.0));
                      }),
                      SizedBox(height: 4.0),
                      FittedBox(
                          fit: BoxFit.contain,
                          child: Text("Offline",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.red))),
                    ])),
          ),
        ],
      ),
    );
  }
}
