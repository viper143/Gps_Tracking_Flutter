import 'package:FleetTracker/Controllers/authentication.dart';
import 'package:FleetTracker/Views/allVehicleList.dart';
import 'package:FleetTracker/Views/dashboard.dart';
import 'package:FleetTracker/Views/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

bool isUserLoggedIn = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();
    String accessToken = await _flutterSecureStorage.read(key: 'accessToken');
    String refreshToken = await _flutterSecureStorage.read(key: 'refreshToken');
    if (accessToken != null && refreshToken != null) {
      final AuthenticationController _authenticationController =
          Get.put(AuthenticationController());
      _authenticationController.email.value =
          await _flutterSecureStorage.read(key: 'email');
      _authenticationController.name.value =
          await _flutterSecureStorage.read(key: 'name');
      _authenticationController.accountType.value =
          await _flutterSecureStorage.read(key: 'role');
      _authenticationController.refreshUserData();
      isUserLoggedIn = true;
    }
  } catch (_) {
    isUserLoggedIn = false;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      smartManagement: SmartManagement.full,
      title: 'Fleet Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isUserLoggedIn == false ? Login() : DashBoard(),
    );
  }
}
