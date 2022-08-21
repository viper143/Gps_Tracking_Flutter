import 'package:FleetTracker/Controllers/resetPassword.dart';
import 'package:FleetTracker/Views/CommonUI/button.dart';
import 'package:FleetTracker/Views/CommonUI/headerGIF.dart';
import 'package:FleetTracker/Views/CommonUI/headerText.dart';
import 'package:FleetTracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmEmail extends StatefulWidget {
  @override
  _ConfirmEmailState createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  ResetPasswordController _resetPasswordController =
      Get.put(ResetPasswordController());

  String confirmEmail;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();

  Widget _buildBtnDesigns(String content, double widthValue) {
    return FlatButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          FocusScope.of(context).unfocus();
          _resetPasswordController.requestOTP(_emailController.text.trim());
        }
      },
      child: buildButton(context, 'Confirm', 0.3),
    );
  }

  Widget _buildDialogBox() {
    return Container(
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter Valid Email Address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Enter Your Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              )),
          SizedBox(height: 14),
          Obx(() {
            return _resetPasswordController.isOTPRequesting.value
                ? CircularProgressIndicator()
                : _buildBtnDesigns('Confirm', 0.3);
          })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bodyBgColor,
        body: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  buildHeaderGif(context),
                  buildHeaderText(context),
                  SizedBox(height: 14),
                  Text(
                    'Reset Your Password',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 14),
                  Form(key: _formKey, child: _buildDialogBox()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
