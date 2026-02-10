import 'package:flutter_logs/flutter_logs.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:delivery_app/src/helpers/helper.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  bool shouldInterceptRequest() => true;

  @override
  bool shouldInterceptResponse() => true;

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    if (isProd()) {
      FlutterLogs.logInfo(
        "LoggingInterceptor",
        "interceptRequest",
        {"url": request.url.toString()}.toString(),
      );
    }
    if (!isProd()) {
      FlutterLogs.logInfo(
        "LoggingInterceptor",
        "interceptRequest",
        request.toString(),
      );
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    if (!isProd() && response is Response) {
      FlutterLogs.logInfo(
        "LoggingInterceptor",
        "interceptResponse:body",
        (response as Response).body.toString(),
      );
    }
    FlutterLogs.logInfo(
      "LoggingInterceptor",
      "interceptResponse:status",
      {"status": response.statusCode.toString()}.toString(),
    );
    final Map<String, String> headers = response.headers;
    if (headers.containsKey('trace-id')) {
      FlutterLogs.logInfo(
        "LoggingInterceptor",
        "interceptResponse:traceId",
        {"traceId": headers['trace-id'].toString()}.toString(),
      );
    }
    return response;
  }
}
