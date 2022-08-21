import 'package:FleetTracker/Views/CommonUI/snackBar.dart';
import 'package:FleetTracker/Views/login.dart';
import 'package:FleetTracker/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:get/get.dart' hide Response;

class RefreshTokenInterceptor extends InterceptorsWrapper {
  FlutterSecureStorage storage = new FlutterSecureStorage();

  Dio dio = new Dio();

  @override
  Future onRequest(RequestOptions options) {
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) async {
    String refreshToken = await storage.read(key: 'refreshToken');
    RequestOptions requestOptions = err.request;
    if (err.response.statusCode == 401) {
      await dio
          .post(baseURL + '/new-access-token-request',
              data: {'refreshToken': refreshToken},
              options: Options(headers: {'Content-Type': 'application/json'}))
          .then((value) async {
        await storage.write(
            key: 'accessToken', value: value.data['access_token']);
      });

      Response newRequest = await dio.request(requestOptions.path,
          options: Options(method: requestOptions.method, headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + await storage.read(key: 'accessToken')
          }));
      if (newRequest.statusCode == 401) {
        showSnackBaronServerResponse('Session Expires', 'Please Re-Login Now!');
        Get.offAll(Login());
      }
    }
    return dio.resolve(err.response);
  }
}
