import 'package:FleetTracker/Controllers/authentication.dart';
import 'package:FleetTracker/Controllers/newVehicle.dart';
import 'package:FleetTracker/Views/CommonUI/button.dart';
import 'package:FleetTracker/Views/CommonUI/headerGIF.dart';
import 'package:FleetTracker/Views/CommonUI/headerText.dart';
import 'package:FleetTracker/Views/CommonUI/subHeader.dart';
import 'package:FleetTracker/Views/addNewProject.dart';
import 'package:FleetTracker/Views/dashboard.dart';
import 'package:FleetTracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegisterVehicle extends StatelessWidget {
  final AuthenticationController _authenticationController = Get.find();
  final VehicleController _vehicleController = Get.put(VehicleController());

  final TextEditingController _vehicleName = new TextEditingController();
  final TextEditingController _imeiNumber = new TextEditingController();
  final TextEditingController _phoneNumber = new TextEditingController();
  final TextEditingController _model = new TextEditingController();

  final FocusNode _vehicleNode = new FocusNode();
  final FocusNode _imeiNumberNode = new FocusNode();
  final FocusNode _phoneNumberNode = new FocusNode();
  final FocusNode _carModelNode = new FocusNode();

  final _formKey = GlobalKey<FormState>();

  Widget _buildvehicleName(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: _vehicleName,
        textCapitalization: TextCapitalization.sentences,
        focusNode: _vehicleNode,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_carModelNode);
        },
        validator: (value) {
          if (value.isEmpty == false) {
            if (!stringRegex.hasMatch(value)) {
              return 'Invalid Name';
            } else {
              return null;
            }
          } else {
            return 'Enter Vehicle name';
          }
        },
        cursorColor: cursorColor,
        cursorWidth: 3,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Vehicle Name',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _buildCarModel(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        focusNode: _carModelNode,
        controller: _model,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_imeiNumberNode);
        },
        validator: (value) {
          if (value.isEmpty == false) {
            if (!characterRegex.hasMatch(value)) {
              return 'Invalid model';
            } else {
              return null;
            }
          } else {
            return 'Enter Vehicle model';
          }
        },
        cursorColor: cursorColor,
        cursorWidth: 3,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Vehicle Model',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _buildImeiNumber(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        focusNode: _imeiNumberNode,
        controller: _imeiNumber,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
        ],
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_phoneNumberNode);
        },
        validator: (value) {
          if (value.trim().length == 15) {
            return null;
          } else {
            return 'Enter IMEI number(15 digits)';
          }
        },
        cursorColor: cursorColor,
        cursorWidth: 3,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'IMEI Number',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _buildphoneNumber(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: _phoneNumber,
        focusNode: _phoneNumberNode,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
        ],
        validator: (value) {
          if (value.trim().length == 10) {
            return null;
          } else {
            return 'Enter Phone number(10 digits)';
          }
        },
        cursorColor: cursorColor,
        cursorWidth: 3,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Phone Number',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _pickAFleetType(context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none),
                fillColor: Colors.white,
                filled: true),
            isExpanded: true,
            hint: Obx(() {
              return Text(_vehicleController.fleetType.value);
            }),
            onChanged: (String val) {
              _vehicleController.fleetType.value = val;
            },
            validator: (String value) {
              if (value == null) {
                return 'Please Select Vehicle Type';
              }
              return null;
            },
            value: 'Car',
            items: ["Car", "Motorbike", "Bus", "Truck"]
                .map<DropdownMenuItem<String>>((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
          ))),
    );
  }

  Widget _pickAProject(context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: DropdownButtonHideUnderline(child: Obx(() {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none),
                fillColor: Colors.white,
                filled: true),
            isExpanded: true,
            hint: Text('Select Project Name'),
            onChanged: (String val) {
              _vehicleController.projectName.value = val;
            },
            validator: (String value) {
              if (value == null) {
                return 'Please Select Project Name';
              }
              return null;
            },
            value: _vehicleController.projectName.value,
            items: _authenticationController.projects.value
                .map<DropdownMenuItem<String>>((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
          );
        })),
      ),
    );
  }

  Widget _buildRegisterBtn(context) {
    return FlatButton(
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          _vehicleController.registerNewVehicle(
              _vehicleName.text.trim(),
              _imeiNumber.text.trim(),
              _phoneNumber.text.trim(),
              _model.text.trim());
        }
      },
      child: Obx(() {
        return _vehicleController.isHavingAPICall.value == false
            ? buildButton(context, 'Register Vehicle', 0.45)
            : CircularProgressIndicator(
                backgroundColor: iconColor,
                valueColor: new AlwaysStoppedAnimation<Color>(bodyBgColor),
              );
      }),
    );
  }

  Widget _addAProject() {
    return FlatButton.icon(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.add_circle),
      label: Text(
        "Add a Project First",
        style: TextStyle(fontSize: 16.0),
      ),
      onPressed: () {
        Get.to(ProjectPage());
      },
    );
  }

  Widget _buildSkipButton(context) {
    return FlatButton(
      onPressed: () {
        if (Get.previousRoute == '/') {
          Get.offAll(DashBoard());
        } else {
          Get.back();
        }
      },
      child: Container(
        child: Text('Cancel',
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.height / 40)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('routes');
    print('routes rerun' + Get.previousRoute);
    return AbsorbPointer(
      absorbing: _vehicleController.isHavingAPICall.value,
      child: Scaffold(
        backgroundColor: bodyBgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    buildHeaderGif(context),
                    buildHeaderText(context),
                    buildSubHeaderText(context, 'Register your vehicle'),
                    Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 15),
                            _buildvehicleName(context),
                            SizedBox(height: 15),
                            _buildCarModel(context),
                            SizedBox(height: 15),
                            _buildImeiNumber(context),
                            SizedBox(height: 15),
                            _buildphoneNumber(context),
                            SizedBox(height: 15),
                            _pickAFleetType(context),
                            SizedBox(height: 15),
                            'Business' == "Business"
                                ? _pickAProject(context)
                                : Container(),
                            SizedBox(height: 20),
                            _buildRegisterBtn(context),
                            SizedBox(height: 10.0),
                            'Business' == "Business"
                                ? _addAProject()
                                : Container(),
                            _buildSkipButton(context),
                            Text(
                              "*You may need to relogin to see complete effect",
                              style: TextStyle(fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
