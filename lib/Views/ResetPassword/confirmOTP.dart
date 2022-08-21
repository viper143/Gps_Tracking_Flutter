import 'package:FleetTracker/Controllers/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:FleetTracker/Views/CommonUI/button.dart';
import 'package:FleetTracker/Views/CommonUI/headerGIF.dart';
import 'package:FleetTracker/Views/CommonUI/headerText.dart';
import 'package:FleetTracker/constants.dart';
import 'package:get/get.dart';

class ConfirmOTP extends StatefulWidget {
  @override
  _ConfirmOTPState createState() => _ConfirmOTPState();
}

class _ConfirmOTPState extends State<ConfirmOTP> {
  final _formKey = GlobalKey<FormState>();

  final ResetPasswordController _resetPasswordController = Get.find();

  TextEditingController _otpController = TextEditingController();
  
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
                    'OTP Confirmation',
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

  Widget _buildDialogBox() {
    return Container(
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _otpController,
                validator: (value) {
                  if (value.isEmpty || value.length != 6) {
                    return 'Please Enter Valid OTP';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Enter OTP',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              )),
              SizedBox(height: 4,),
          Text('We have sent OTP in your Email Address'),
          SizedBox(height: 14),
          _buildBtnDesigns('Confirm', 0.3)
        ],
      ),
    );
  }

  Widget _buildBtnDesigns(String content, double widthValue) {
    return FlatButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          FocusScope.of(context).unfocus();
          _resetPasswordController.verifyOTP(_otpController.text.trim());
        }
      },
      child: buildButton(context, 'Confirm', 0.3),
    );
  }
}
