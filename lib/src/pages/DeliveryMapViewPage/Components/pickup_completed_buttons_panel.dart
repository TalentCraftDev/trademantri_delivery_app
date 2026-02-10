import 'package:delivery_app/src/dialogs/index.dart';
import 'package:delivery_app/src/elements/keicy_raised_button.dart';
import 'package:delivery_app/src/models/index.dart';
import 'package:delivery_app/src/models/order_model.dart';
import 'package:delivery_app/src/pages/ChatPage/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/config/app_config.dart' as config;
import 'package:map_launcher/map_launcher.dart';

class PickupCompletedButtonsPanel extends StatelessWidget {
  final OrderModel? orderModel;
  final Function()? sendDeliveryCompleteCodeCallback;

  PickupCompletedButtonsPanel({
    Key? key,
    @required this.orderModel,
    @required this.sendDeliveryCompleteCodeCallback,
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
              width: widthDp * 150,
              height: heightDp * 35,
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              color: config.AppColors().mainColor(1),
              child: Text(
                "Navigate",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
              onPressed: () {
                MapsSheet.show(
                  context: context,
                  onMapTap: (map) {
                    map.showMarker(
                      coords: Coords(
                        orderModel!.deliveryAddress!.address!.location!.latitude,
                        orderModel!.deliveryAddress!.address!.location!.longitude,
                      ),
                      title: "",
                    );
                  },
                );
              },
            ),
            SizedBox(height: heightDp * 15),
            KeicyRaisedButton(
              width: widthDp * 150,
              height: heightDp * 35,
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              color: config.AppColors().mainColor(1),
              child: Text(
                "Chat with user",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => ChatPage(
                      chatRoomType: ChatRoomTypes.d2c,
                      userData: orderModel!.userModel!.toJson(),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: heightDp * 15),
            KeicyRaisedButton(
              width: widthDp * 150,
              height: heightDp * 35,
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              color: config.AppColors().mainColor(1),
              child: Text(
                "Delivery Done",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
              onPressed: sendDeliveryCompleteCodeCallback,
            ),
          ],
        ),
      ),
    );
  }
}
