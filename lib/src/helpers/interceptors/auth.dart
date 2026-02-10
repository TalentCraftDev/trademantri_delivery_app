import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:delivery_app/config/config.dart';
import 'package:delivery_app/src/helpers/http_plus.dart';
import 'package:delivery_app/src/providers/BridgeProvider/bridge_provider.dart';
import 'package:delivery_app/src/providers/BridgeProvider/bridge_state.dart';
import 'package:delivery_app/environment.dart';

class AuthInterceptor implements InterceptorContract {
  //Note:: URLs for which should not send token in any case.
  List<String> blacklist = [
    "user/login",
    "user/register",
    "user/resend_verify_link",
    "user/forgot",
    "user/verify_otp",
  ];

  @override
  bool shouldInterceptRequest() => true;

  @override
  bool shouldInterceptResponse() => true;

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    String urlStr = request.url.toString();
    String currentRoute = urlStr.replaceAll(Environment.apiBaseUrl!, "");
    if (!blacklist.contains(currentRoute)) {
      String? authToken = await getAuthToken();
      if (authToken != null) {
        final Map<String, String> headers = Map.from(request.headers);
        headers["Authorization"] = "Bearer $authToken";
        return request.copyWith(headers: headers);
      }
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    if (response.statusCode == 401 && response is Response) {
      final String body = (response as Response).body;
      if (body.isNotEmpty) {
        try {
          final responseData = json.decode(body) as Map<String, dynamic>;
          if (responseData['message'] == "jwt expired") {
            BridgeProvider().update(
              BridgeState(
                event: "log_out",
                data: {
                  "message": "Invalid token",
                },
              ),
            );
          }
        } catch (_) {}
      }
    }
    return response;
  }
}
