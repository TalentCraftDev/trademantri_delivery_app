import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/src/helpers/http_plus.dart';

class HeadersInterceptor implements InterceptorContract {
  @override
  bool shouldInterceptRequest() => true;

  @override
  bool shouldInterceptResponse() => true;

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final Map<String, String> headers = Map.from(request.headers);
    headers["x-source"] = "app";

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    headers["x-version"] = packageInfo.version;
    headers["x-build-number"] = packageInfo.buildNumber;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      headers["x-device-id"] = androidInfo.id;
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.identifierForVendor != null) {
        headers["x-device-id"] = iosInfo.identifierForVendor!;
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('session_id')) {
      String? sessionId = prefs.getString('session_id');
      if (sessionId != null) {
        headers["x-session-id"] = sessionId;
      }
    }

    Battery battery = Battery();
    int level = await battery.batteryLevel;
    headers["x-battery"] = level.toString();

    List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    String connectivityStr = results.isNotEmpty
        ? results.map((r) => r.toString().replaceAll("ConnectivityResult.", "")).join(",")
        : "none";
    headers["x-connectivity"] = connectivityStr;

    return request.copyWith(headers: headers);
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    return response;
  }
}
