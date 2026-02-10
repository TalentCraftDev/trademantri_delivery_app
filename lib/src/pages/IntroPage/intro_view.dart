import 'package:delivery_app/src/elements/keicy_raised_button.dart';
import 'package:delivery_app/src/pages/login.dart';
import 'package:delivery_app/src/pages/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/config/app_config.dart' as config;

import 'index.dart';

class IntroView extends StatefulWidget {
  IntroView({Key? key}) : super(key: key);

  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> with SingleTickerProviderStateMixin {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 30),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("img/intor.png", width: deviceWidth * 0.8, fit: BoxFit.fitWidth),
                      SizedBox(height: heightDp * 30),
                      Text(
                        IntroPageString.description.toUpperCase(),
                        style: TextStyle(fontSize: fontSp * 24, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: heightDp * 50),
                    ],
                  ),
                ),
              ),
              KeicyRaisedButton(
                width: widthDp * 150,
                height: heightDp * 30,
                color: config.AppColors().mainColor(1),
                borderRadius: heightDp * 6,
                child: Text(
                  IntroPageString.login,
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginWidget(),
                    ),
                  );
                },
              ),
              SizedBox(height: heightDp * 20),
              KeicyRaisedButton(
                width: widthDp * 150,
                height: heightDp * 30,
                color: config.AppColors().mainColor(1),
                borderRadius: heightDp * 6,
                child: Text(
                  IntroPageString.register,
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => SignUpWidget(),
                    ),
                  );
                },
              ),
              SizedBox(height: heightDp * 40),
            ],
          ),
        ),
      ),
    );
  }
}
