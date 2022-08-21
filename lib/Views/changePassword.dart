import 'package:FleetTracker/Controllers/changePassword.dart';
import 'package:FleetTracker/Views/CommonUI/button.dart';
import 'package:FleetTracker/Views/CommonUI/headerGIF.dart';
import 'package:FleetTracker/Views/CommonUI/headerText.dart';
import 'package:FleetTracker/Views/CommonUI/subHeader.dart';
import 'package:FleetTracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class ChangePassword extends StatelessWidget {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final TextEditingController _oldPasswordController =
      new TextEditingController();
  final TextEditingController _newPasswordController =
      new TextEditingController();
  final TextEditingController _confirmPasswordController =
      new TextEditingController();

  final FocusNode _oldPasswordNode = new FocusNode();
  final FocusNode _newPasswordNode = new FocusNode();
  final FocusNode _confirmPasswordNode = new FocusNode();

  final _formKey = GlobalKey<FormState>();

  final ChangePasswordController _changePasswordController =
      Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  buildHeaderGif(context),
                  buildHeaderText(context),
                  buildSubHeaderText(context, 'Change your password'),
                  SizedBox(height: 40),
                  _buildOldPassword(context),
                  SizedBox(height: 20),
                  _buildNewPassword(context),
                  SizedBox(height: 20),
                  _buildConfirmPassword(context),
                  SizedBox(height: 20),
                  _buildChangePasswordBtn(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOldPassword(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Obx(() {
        return TextFormField(
          controller: _oldPasswordController,
          focusNode: _oldPasswordNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_newPasswordNode);
          },
          validator: (value) {
            if (value.isEmpty == false) {
              if (!passwordRegex.hasMatch(value)) {
                return 'Invalid password. Enter alphabets or numbers';
              } else if (value.length < 6) {
                return 'Password must be atleast 6 characters';
              } else {
                return null;
              }
            } else {
              return 'Enter old password';
            }
          },
          cursorColor: cursorColor,
          cursorWidth: 3,
          obscureText: !_changePasswordController.showOldPassword.value,
          decoration: InputDecoration(
              hintText: 'Old Password',
              prefixIcon: Icon(
                Icons.lock,
                color: iconColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _changePasswordController.showOldPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: iconColor,
                ),
                onPressed: () {
                  _changePasswordController.showOldPassword.value =
                      !_changePasswordController.showOldPassword.value;
                },
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none)),
        );
      }),
    );
  }

  Widget _buildNewPassword(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Obx(() {
        return TextFormField(
          controller: _newPasswordController,
          focusNode: _newPasswordNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_confirmPasswordNode);
          },
          validator: (value) {
            if (value.isEmpty == false) {
              if (!passwordRegex.hasMatch(value)) {
                return 'Invalid password. Enter alphabets or numbers';
              } else if (value.length < 6) {
                return 'Password must be atleast 6 characters';
              } else {
                return null;
              }
            } else {
              return 'Enter new password';
            }
          },
          cursorColor: cursorColor,
          cursorWidth: 3,
          obscureText: !_changePasswordController.showNewPassword.value,
          decoration: InputDecoration(
              hintText: 'New Password',
              prefixIcon: Icon(
                Icons.lock,
                color: iconColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _changePasswordController.showNewPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: iconColor,
                ),
                onPressed: () {
                  _changePasswordController.showNewPassword.value =
                      !_changePasswordController.showNewPassword.value;
                },
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none)),
        );
      }),
    );
  }

  Widget _buildConfirmPassword(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Obx(() {
        return TextFormField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordNode,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value.isEmpty == false) {
              if (!passwordRegex.hasMatch(value)) {
                return 'Invalid password. Enter alphabets or numbers';
              } else if (value.length < 6) {
                return 'Password must be atleast 6 characters';
              } else if (_newPasswordController.text.trim() !=
                  _confirmPasswordController.text.trim()) {
                return "Passwords do not match";
              } else {
                return null;
              }
            } else {
              return 'Enter confirm password';
            }
          },
          cursorColor: cursorColor,
          cursorWidth: 3,
          obscureText: !_changePasswordController.showConfirmPassword.value,
          decoration: InputDecoration(
              hintText: 'Confirm Password',
              prefixIcon: Icon(
                Icons.lock,
                color: iconColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _changePasswordController.showConfirmPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: iconColor,
                ),
                onPressed: () {
                  _changePasswordController.showConfirmPassword.value =
                      !_changePasswordController.showConfirmPassword.value;
                },
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none)),
        );
      }),
    );
  }

  Widget _buildChangePasswordBtn(context) {
    return FlatButton(onPressed: () {
      if (_formKey.currentState.validate()) {
        _changePasswordController.changePassword(
            _oldPasswordController.text.trim(),
            _newPasswordController.text.trim());
      }
    }, child: Obx(() {
      return _changePasswordController.isHavingAPICall.value == false
          ? buildButton(context, 'Change Password', 0.45)
          : CircularProgressIndicator(
              backgroundColor: iconColor,
              valueColor: new AlwaysStoppedAnimation<Color>(bodyBgColor),
            );
    }));
  }
}
