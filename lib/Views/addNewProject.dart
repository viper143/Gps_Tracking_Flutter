import 'package:FleetTracker/Controllers/newProject.dart';
import 'package:FleetTracker/Views/CommonUI/button.dart';
import 'package:FleetTracker/Views/CommonUI/headerGIF.dart';
import 'package:FleetTracker/Views/CommonUI/headerText.dart';
import 'package:FleetTracker/Views/CommonUI/subHeader.dart';
import 'package:FleetTracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectPage extends StatelessWidget {
  final TextEditingController _projectName = TextEditingController();
  final NewProjectController _newProjectController =
      Get.put(NewProjectController());
  final _formKey = GlobalKey<FormState>();

  Widget _buildNewProject(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Form(
        key: _formKey,
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.name,
          controller: _projectName,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value.isEmpty == false) {
              return null;
            } else {
              return 'Enter Project Name';
            }
          },
          cursorColor: cursorColor,
          cursorWidth: 3,
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'New Project Name',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none)),
        ),
      ),
    );
  }

  Widget _buildSkipButton(context) {
    return FlatButton(
      onPressed: () {
        Navigator.pop(context);
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
    return Scaffold(
      backgroundColor: bodyBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  buildHeaderGif(context),
                  buildHeaderText(context),
                  buildSubHeaderText(
                      context, 'Manage your vehicles with project'),
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 30),
                        _buildNewProject(context),
                        SizedBox(height: 20),
                        FlatButton(onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _newProjectController
                                .addNewProject(_projectName.text.trim());
                          }
                        }, child: Obx(() {
                          return _newProjectController.isHavingAPICall.value ==
                                  false
                              ? buildButton(context, 'Confirm', 0.45)
                              : CircularProgressIndicator(
                                  backgroundColor: iconColor,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      bodyBgColor),
                                );
                        })),
                        _buildSkipButton(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
