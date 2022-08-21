import 'dart:ui';

import 'package:FleetTracker/Controllers/authentication.dart';
import 'package:FleetTracker/Controllers/editVehicle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

vehicleEditBottomSheet(context) {
  TextEditingController _vehicleNameController = TextEditingController();
  TextEditingController _vehicleModelController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  AuthenticationController _authenticationController = Get.find();
  List<String> _list = _authenticationController.projects.value.toList();
  VehicleEditController _vehicleEditController = Get.find();
  final _formKey = GlobalKey<FormState>();

  String tempSelected = '';
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Vehicle Detail',
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 240,
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Obx(() {
                        return Container(
                          height: 50,
                          child: TextFormField(
                            controller: _vehicleNameController,
                            decoration: InputDecoration(
                              hintText:
                                  _vehicleEditController.vehicleName.value,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 0.5)),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 12.0),
                      Obx(() {
                        return Container(
                          height: 50,
                          child: TextFormField(
                            controller: _vehicleModelController,
                            decoration: InputDecoration(
                              hintText:
                                  _vehicleEditController.vehicleModel.value,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 0.5)),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 12.0),
                      Obx(() {
                        return Container(
                          height: 50,
                          child: TextFormField(
                            controller: _phoneNumberController,
                            decoration: InputDecoration(
                              hintText:
                                  _vehicleEditController.phoneNumber.value,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 0.5)),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 12.0),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Obx(() {
                            return DropdownButtonFormField(
                              isExpanded: true,
                              onChanged: (val) {
                                tempSelected = val;
                              },
                              hint: Text(
                                  _vehicleEditController.projectName.value),
                              items: _list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                            );
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                )),
            FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (_phoneNumberController.text.trim().length > 0) {
                      _vehicleEditController.phoneNumber.value =
                          _phoneNumberController.text.trim();
                    }
                    if (_vehicleModelController.text.trim().length > 0) {
                      _vehicleEditController.vehicleModel.value =
                          _vehicleModelController.text.trim();
                    }
                    if (_vehicleNameController.text.trim().length > 0) {
                      _vehicleEditController.vehicleName.value =
                          _vehicleNameController.text.trim();
                    }
                    _vehicleEditController.projectName.value = tempSelected;
                    _vehicleEditController.editVehicleDetail();
                  }
                },
                child: Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        );
      });
}
