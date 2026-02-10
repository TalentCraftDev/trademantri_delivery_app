import 'dart:convert';

import 'package:delivery_app/src/entities/maintenance.dart';
import 'package:delivery_app/src/pages/IntroPage/index.dart';
import 'package:delivery_app/src/pages/maintenance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:delivery_app/config/app_config.dart' as config;
import 'package:delivery_app/src/providers/index.dart';

enum SplashStep {
  Welcome,
  Maintenance,
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AuthProvider? _authProvider;

  SplashStep _step = SplashStep.Welcome;
  Maintenance? _activeMaintenance;

  @override
  void initState() {
    super.initState();

    _authProvider = AuthProvider.of(context);

    _step = SplashStep.Welcome;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _authProvider!.addListener(_authProviderListener);

      await Future.delayed(
        Duration(
          seconds: 2,
        ),
      );
      Maintenance? maintenanceConfig = await AuthProvider.of(context).checkForMaintenance();

      if (maintenanceConfig != null) {
        setState(() {
          _activeMaintenance = maintenanceConfig;
          _step = SplashStep.Maintenance;
        });
      } else {
        _authProvider!.init();
      }
    });
  }

  void _authProviderListener() async {
    if (_authProvider!.authState.progressState == 2 && _authProvider!.authState.loginState == LoginState.IsLogin) {
      Navigator.of(context).pushNamedAndRemoveUntil('/Pages', (route) => false, arguments: {"currentTab": 2});
    } else if (_authProvider!.authState.progressState == 2 && _authProvider!.authState.loginState == LoginState.IsNotLogin) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => IntroPage()));
    } else if (_authProvider!.authState.progressState == -1) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => IntroPage()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => IntroPage()));
    }
  }

  @override
  void dispose() {
    _authProvider!.removeListener(_authProviderListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_step == SplashStep.Maintenance) {
      return MaintenanceWidget(
        activeMaintenance: _activeMaintenance,
        onSkip: () {
          _authProvider!.init();
        },
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              config.AppColors().mainColor(1).withOpacity(0.7),
              config.AppColors().mainColor(1),
              config.AppColors().mainColor(1).withOpacity(0.7),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Image.asset(
            "img/logo_small.png",
            height: MediaQuery.of(context).size.height * 0.2,
            fit: BoxFit.fitHeight,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
