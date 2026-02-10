import 'dart:convert';

import 'package:delivery_app/src/helpers/analytics_observer.dart';
import 'package:delivery_app/src/providers/BridgeProvider/bridge_provider.dart';
import 'package:delivery_app/src/providers/BridgeProvider/bridge_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:delivery_app/config/app_config.dart' as config;
import 'package:delivery_app/route_generator.dart';
import 'package:delivery_app/src/providers/index.dart';
import 'package:delivery_app/config/config.dart';
import 'package:delivery_app/src/services/keicy_fcm_for_mobile.dart';
import 'package:delivery_app/src/services/keicy_local_notification.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'config/config.dart';
import 'src/pages/OrderDetailPage/index.dart';
import 'src/pages/login.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    KeicyFCMForMobile.setNavigatorey(navigatorKey);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(AppConfig.mobileDesignWidth, AppConfig.mobileDesignHeight),
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => OrderProvider()),
            ChangeNotifierProvider(create: (_) => MyDeliveryOrderProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ChangeNotifierProvider(create: (_) => RefreshProvider()),
            ChangeNotifierProvider(create: (_) => MyDeliveryDashboardDataProvider()),
            ChangeNotifierProvider(create: (_) => DeliveryOTPProvider()),
            ChangeNotifierProvider(create: (_) => ContactUsRequestProvider()),
          ],
          child: MaterialApp(
            title: 'Delivery App',
            initialRoute: '/',
            navigatorKey: navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoute,
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              AnalyticsObserver(),
            ],
            localizationsDelegates: [
              RefreshLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            // darkTheme: ThemeData(
            //   fontFamily: 'Montserrat',
            //   primaryColor: Color(0xFF252525),
            //   brightness: Brightness.dark,
            //   scaffoldBackgroundColor: Color(0xFF2C2C2C),
            //   accentColor: config.AppColors().mainDarkColor(1),
            //   hintColor: config.AppColors().secondDarkColor(1),
            //   focusColor: config.AppColors().accentDarkColor(1),
            //   textTheme: TextTheme(
            //     headline: TextStyle(fontSize: 20.0, color: config.AppColors().secondDarkColor(1)),
            //     display1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: config.AppColors().secondDarkColor(1)),
            //     display2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: config.AppColors().secondDarkColor(1)),
            //     display3: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.AppColors().mainDarkColor(1)),
            //     display4: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: config.AppColors().secondDarkColor(1)),
            //     subhead: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.AppColors().secondDarkColor(1)),
            //     title: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.AppColors().mainDarkColor(1)),
            //     body1: TextStyle(fontSize: 12.0, color: config.AppColors().secondDarkColor(1)),
            //     body2: TextStyle(fontSize: 14.0, color: config.AppColors().secondDarkColor(1)),
            //     caption: TextStyle(fontSize: 12.0, color: config.AppColors().secondDarkColor(0.6)),
            //   ),
            // ),
            theme: ThemeData(
              fontFamily: 'Montserrat',
              brightness: Brightness.light,
              colorScheme: ColorScheme.light(
                primary: config.AppColors().mainColor(1),
                secondary: config.AppColors().mainColor(1),
                surface: Colors.white,
                onSurfaceVariant: config.AppColors().secondColor(1),
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              textTheme: TextTheme(
                titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: config.AppColors().secondColor(1)),
                titleMedium: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.AppColors().secondColor(1)),
                titleSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.AppColors().mainColor(1)),
                headlineLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: config.AppColors().secondColor(1)),
                headlineMedium: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.AppColors().mainColor(1)),
                headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: config.AppColors().secondColor(1)),
                bodyLarge: TextStyle(fontSize: 14.0, color: config.AppColors().secondColor(1)),
                bodyMedium: TextStyle(fontSize: 12.0, color: config.AppColors().secondColor(1)),
                bodySmall: TextStyle(fontSize: 12.0, color: config.AppColors().accentColor(1)),
              ),
            ),
            builder: (context, child) {
              return StreamBuilder<String>(
                stream: KeicyLocalNotification.instance.selectNotificationSubject,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null && snapshot.data != "") {
                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                      if (snapshot.data != null) {
                        var data = json.decode(snapshot.data!);
                        if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                          notificationHandler(context, data);
                        } else if (AuthProvider.of(context).authState.loginState == LoginState.IsNotLogin) {
                          navigatorKey.currentState!
                            ..push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => LoginWidget(
                                  callback: () {
                                    notificationHandler(context, data);
                                  },
                                ),
                              ),
                            );
                        }
                      }
                    });

                    KeicyLocalNotification.instance.selectNotificationSubject.add("");
                  }

                  return StreamBuilder<BridgeState>(
                    stream: BridgeProvider().getStream(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        FlutterLogs.logInfo(
                          "app",
                          "BridgeProvider:stream",
                          snapshot.data.toString(),
                        );
                      }
                      if (snapshot.hasData && snapshot.data != null && snapshot.data!.event == "log_out") {
                        AuthProvider.of(context).clearAuthState();
                        BridgeProvider().update(
                          BridgeState(
                            event: "init",
                            data: {
                              "message": "init",
                            },
                          ),
                        );

                        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                          navigatorKey.currentState!
                            ..pushAndRemoveUntil(
                              MaterialPageRoute(builder: (BuildContext context) => LoginWidget()),
                              (route) => false,
                            );
                        });
                      }
                      return child!;
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void notificationHandler(BuildContext context, Map<String, dynamic> data) {
    switch (data["type"]) {
      case "order":
        if (data["data"]["status"] == "delivery_ready") {
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (BuildContext context) => OrderDetailPage(
                orderId: data["data"]["orderId"],
                storeId: data["data"]["storeId"],
                userId: data["data"]["userId"],
              ),
            ),
          );
        }

        break;
      default:
    }
  }
}
