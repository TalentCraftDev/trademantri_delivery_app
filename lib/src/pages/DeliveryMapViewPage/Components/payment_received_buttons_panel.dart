import 'package:delivery_app/src/elements/keicy_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/config/app_config.dart' as config;

class PaymentReceivedButtonsPanel extends StatelessWidget {
  final Function()? paymentReceivedCallback;

  PaymentReceivedButtonsPanel({
    Key? key,
    @required this.paymentReceivedCallback,
  }) : super(key: key);

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
  Widget build(BuildContext context) {
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

    return Positioned(
      bottom: 0,
      child: Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: widthDp * 30, vertical: heightDp * 20),
        child: Column(
          children: [
            KeicyRaisedButton(
              width: widthDp * 180,
              height: heightDp * 40,
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              color: config.AppColors().mainColor(1),
              child: Text(
                "Payment Received",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
              ),
              onPressed: paymentReceivedCallback,
            ),
          ],
        ),
      ),
    );
  }
}
