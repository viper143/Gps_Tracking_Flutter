import 'package:FleetTracker/Controllers/resetPassword.dart';
import 'package:FleetTracker/Views/CommonUI/button.dart';
import 'package:FleetTracker/Views/CommonUI/headerGIF.dart';
import 'package:FleetTracker/Views/CommonUI/headerText.dart';
import 'package:FleetTracker/Views/CommonUI/subHeader.dart';
import 'package:FleetTracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetNewPassword extends StatefulWidget {
  @override
  _SetNewPasswordState createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _newPasswordNode = FocusNode();
  FocusNode _confirmPasswordNode = FocusNode();
  
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final ResetPasswordController _resetPasswordController =
      Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBgColor,
      body: Container(
        width: Get.width,
        height: Get.height,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildHeaderGif(context),
                  buildHeaderText(context),
                  buildSubHeaderText(context, 'Set New Password'),
                  SizedBox(height: 40),
                  _buildNewPasswordTextField(context),
                  SizedBox(height: 20),
                  _buildConfirmPasswordTextField(context),
                  SizedBox(height: 20),
                  _buildLoginBtn(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewPasswordTextField(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Obx(() {
        return TextFormField(
          focusNode: _newPasswordNode,
          controller: _newPasswordController,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
          validator: (value) {
            if (value.isEmpty ||
                !passwordRegex.hasMatch(value) ||
                value.length < 6) {
              return "Please Enter a Valid Password";
            }
            return null;
          },
          cursorColor: cursorColor,
          cursorWidth: 3,
          obscureText: !_resetPasswordController.showNewPassword.value,
          decoration: InputDecoration(
              hintText: 'New Password',
              prefixIcon: Icon(
                Icons.lock,
                color: iconColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _resetPasswordController.showNewPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: iconColor,
                ),
                onPressed: () {
                  _resetPasswordController.showNewPassword.value =
                      !_resetPasswordController.showNewPassword.value;
                },
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.0))),
        );
      }),
    );
  }

  Widget _buildConfirmPasswordTextField(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Obx(() {
        return TextFormField(
          focusNode: _confirmPasswordNode,
          controller: _confirmPasswordController,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
          validator: (value) {
            if (value.isEmpty ||
                !passwordRegex.hasMatch(value) ||
                value.length < 6 ||
                _newPasswordController.text.trim() !=
                    _confirmPasswordController.text.trim()) {
              return "Please Enter a Valid Password";
            }
            return null;
          },
          cursorColor: cursorColor,
          cursorWidth: 3,
          obscureText: !_resetPasswordController.showConfirmPassword.value,
          decoration: InputDecoration(
              hintText: 'Confirm Password',
              prefixIcon: Icon(
                Icons.lock,
                color: iconColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _resetPasswordController.showConfirmPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: iconColor,
                ),
                onPressed: () {
                  _resetPasswordController.showConfirmPassword.value =
                      !_resetPasswordController.showConfirmPassword.value;
                },
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.0))),
        );
      }),
    );
  }

  Widget _buildLoginBtn(context) {
    return FlatButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          FocusScope.of(context).unfocus();
          _resetPasswordController
              .resetPassword(_newPasswordController.text.trim());
        }
      },
      child: Obx(() {
        return _resetPasswordController.isPasswordResseting.value == false
            ? buildButton(context, 'Change Password', 0.45)
            : CircularProgressIndicator(
                backgroundColor: iconColor,
                valueColor: new AlwaysStoppedAnimation<Color>(bodyBgColor),
              );
      }),
    );
  }
}
