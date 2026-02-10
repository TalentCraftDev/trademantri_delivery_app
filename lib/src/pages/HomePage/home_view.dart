import 'package:delivery_app/src/dialogs/index.dart';
import 'package:delivery_app/src/elements/total_delivery_widget.dart';
import 'package:delivery_app/src/pages/OrderListPage/order_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/config/app_config.dart' as config;

import 'index.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            width: deviceWidth,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                  child: TotalDeliveryWidget(),
                ),

                // MaterialButton(
                //   onPressed: () {
                //     MapsSheet.show(
                //       context: context,
                //       onMapTap: (map) {},
                //     );
                //   },
                //   child: Text("test"),
                // ),

                ///
                SizedBox(height: heightDp * 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) => OrderListPage(haveAppBar: true)),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 5,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                          child: Container(
                            width: heightDp * 170,
                            height: heightDp * 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(heightDp * 10),
                              // color: Colors.red.withOpacity(0.3),
                              color: config.AppColors().mainColor(0.2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("img/order/order.png", width: heightDp * 80, height: heightDp * 80, fit: BoxFit.cover),
                                SizedBox(height: heightDp * 20),
                                Text(
                                  "Orders",
                                  style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
