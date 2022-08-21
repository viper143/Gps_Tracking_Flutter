import 'dart:convert';
import 'dart:io';
import 'package:FleetTracker/Views/CommonUI/snackBar.dart';
import 'package:FleetTracker/Views/ResetPassword/confirmOTP.dart';
import 'package:FleetTracker/Views/ResetPassword/setNewPassword.dart';
import 'package:FleetTracker/Views/login.dart';
import 'package:FleetTracker/constants.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class ResetPasswordController extends GetxController {
  RxBool isOTPRequesting = false.obs;
  RxBool isOTPVerifying = false.obs;
  RxBool isPasswordResseting = false.obs;

  RxBool showNewPassword = false.obs;
  RxBool showConfirmPassword = false.obs;

  RxString email = ''.obs;
  RxString id = ''.obs;
  RxString otp = ''.obs;
  Dio _dio = new Dio();

  requestOTP(String emailAddress) async {
    isOTPRequesting.value = true;
    try {
      await _dio.post(baseURL + "/reset-password-request-otp",
          data: {"email": emailAddress}).then((value) {
        isOTPRequesting.value = false;
        if (value.statusCode == HttpStatus.ok) {
          var response = json.decode(value.data);
          email.value = response['email'];
          id.value = response['_id'];
          Get.off(ConfirmOTP());
        } else {
          showSnackBaronServerResponse(
              'Reset Password', 'Error Sending OTP. Try Again!');
        }
      });
    } catch (e) {
      isOTPRequesting.value = false;
      showSnackBaronServerResponse(
          'Reset Password', 'Error Sending OTP. Try Later!');
    }
  }

  verifyOTP(String otpText) async {
    isOTPVerifying.value = true;
    try {
      await _dio.post(baseURL + "/reset-password-verify-otp",
          options: Options(
            headers: {"Content-Type": "application/json"},
          ),
          data: {"companyID": id.value, "otp": otpText}).then((value) {
        isOTPVerifying.value = false;
        if (value.statusCode == HttpStatus.ok) {
          otp.value = otpText;
          Get.off(SetNewPassword());
        } else {
          showSnackBaronServerResponse(
              'Reset Password', 'Error Verifying OTP. Try Again!');
        }
      });
    } catch (e) {
      print(e);
      isOTPVerifying.value = false;
      showSnackBaronServerResponse(
          'Reset Password', 'Error Verifying OTP. Try Later!');
    }
  }

  resetPassword(String password) async {
    isPasswordResseting.value = true;
    try {
      await _dio.post(baseURL + "/reset-password", data: {
        "companyID": id.value,
        "otp": otp.value,
        "password": password
      }).then((value) {
        isPasswordResseting.value = false;
        if (value.statusCode == HttpStatus.ok) {
          Get.offAll(Login());
        } else {
          showSnackBaronServerResponse(
              'Reset Password', 'Error Resetting Password. Try Again!');
        }
      });
    } catch (e) {
      print(e);
      isPasswordResseting.value = false;
      showSnackBaronServerResponse(
          'Reset Password', 'Error Resetting Password. Try Later!');
    }
  }
}
