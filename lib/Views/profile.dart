import 'package:FleetTracker/Controllers/authentication.dart';
import 'package:FleetTracker/Views/CommonUI/button.dart';
import 'package:FleetTracker/Views/changePassword.dart';
import 'package:FleetTracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfile extends StatelessWidget {
  final AuthenticationController _authenticationController = Get.find();
  Widget _buildUsernameSection() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          return Text(
            _authenticationController.name.value,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
          );
        }),
        SizedBox(
          height: 4.0,
        ),
        Text(
          "Name",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
        )
      ],
    ));
  }

  Widget _buildEmailSection() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          return Text(
            _authenticationController.email.value,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
          );
        }),
        SizedBox(
          height: 4.0,
        ),
        Text(
          "Email",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
        )
      ],
    ));
  }

  Widget _buildRoleSection() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          return Text(
            _authenticationController.accountType.value,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
          );
        }),
        SizedBox(
          height: 4.0,
        ),
        Text(
          "Account Type",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
        )
      ],
    ));
  }

  Widget _buildChangePasswordBtn(context) {
    return FlatButton(
      onPressed: () {
        Get.to(ChangePassword());
      },
      child: buildButton(context, 'Change Password', 0.5),
    );
  }

  Widget _buildLogoutBtn(context) {
    return FlatButton(
      onPressed: () {
        Get.bottomSheet(Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0))),
          height: 100.0,
          child: Column(
            children: [
              Text(
                'Are you sure want to logout?',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    color: bodyBgColor,
                    shape: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8)),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    elevation: 0,
                  ),
                  RaisedButton(
                      color: bodyBgColor,
                      shape: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {
                        _authenticationController.logoutCurrentUser();
                      },
                      child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.blue),
                      ),
                      elevation: 0)
                ],
              )
            ],
          ),
        ));
      },
      child: buildButton(context, 'Logout', 0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBgColor,
      appBar: AppBar(
          title: Text("My Account",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w400)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: bodyBgColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/profile.png',
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: MediaQuery.of(context).size.width * 0.45,
                ),
                _buildUsernameSection(),
                SizedBox(height: 6),
                Divider(thickness: 2),
                SizedBox(height: 6),
                _buildEmailSection(),
                SizedBox(height: 6),
                Divider(thickness: 2),
                SizedBox(height: 6),
                _buildRoleSection(),
                SizedBox(height: 6),
                Divider(thickness: 2),
                SizedBox(height: 6),
                _buildChangePasswordBtn(context),
                SizedBox(height: 20),
                _buildLogoutBtn(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
