import 'package:delivery_app/src/elements/keicy_raised_button.dart';
import 'package:delivery_app/src/elements/order_widget.dart';
import 'package:delivery_app/src/models/index.dart';
import 'package:delivery_app/src/pages/DeliveryMapViewPage/index.dart';
import 'package:delivery_app/src/pages/ErrorPage/index.dart';
import 'package:delivery_app/src/pages/MyDeliveryOrderListPage/index.dart';
import 'package:delivery_app/src/pages/OrderDetailPage/index.dart';
import 'package:delivery_app/src/providers/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/config/app_config.dart' as config;
import 'package:delivery_app/src/elements/total_deivered_widget.dart';
import 'package:delivery_app/src/elements/total_ongoing_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatefulWidget {
  final bool? haveAppBar;

  DashboardView({Key? key, this.haveAppBar}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
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

  MyDeliveryOrderProvider? _myDeliveryOrderProvider;
  MyDeliveryDashboardDataProvider? _myDeliveryDashboardDataProvider;

  Position? _position;

  AuthProvider? _authProvider;

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

    _myDeliveryDashboardDataProvider = MyDeliveryDashboardDataProvider.of(context);
    _myDeliveryOrderProvider = MyDeliveryOrderProvider.of(context);
    _authProvider = AuthProvider.of(context);

    _myDeliveryOrderProvider!.setMyDeliveryOrderState(
      _myDeliveryOrderProvider!.myDeliveryOrderState.update(
        myDeliveryOrderListData: [],
        myDeliveryOrderMetaData: Map<String, dynamic>(),
        progressState: 0,
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      var permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        _position = await Geolocator.getCurrentPosition();
        refreshList();
      } else {
        _myDeliveryOrderProvider!.setMyDeliveryOrderState(
          _myDeliveryOrderProvider!.myDeliveryOrderState.update(progressState: -1, message: "Location Permission was deny"),
        );
        return;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshList() {
    _myDeliveryDashboardDataProvider!.setMyDeliveryDashboardDataState(
      _myDeliveryDashboardDataProvider!.myDeliveryDashboardDataState.update(progressState: 1),
    );
    _myDeliveryDashboardDataProvider!.getMyDeliveryDashboardDataData(
      deliveryUserId: _authProvider!.authState.deliveryUserModel!.id,
    );

    _myDeliveryOrderProvider!.setMyDeliveryOrderState(_myDeliveryOrderProvider!.myDeliveryOrderState.update(progressState: 1));
    _myDeliveryOrderProvider!.getMyDeliveryOrderData(
      lat: _position!.latitude,
      lng: _position!.longitude,
      deliveryUserId: _authProvider!.authState.deliveryUserModel!.id,
      limit: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !widget.haveAppBar!
          ? null
          : AppBar(
              centerTitle: true,
              title: Text(
                "Dashboard",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              ),
              elevation: 0,
            ),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TotalDeliverdWidget(),
                      TotalOngoingWidget(),
                    ],
                  ),
                ),
                SizedBox(height: heightDp * 10),
                Consumer<MyDeliveryOrderProvider>(
                  builder: (context, myDeliveryOrderProvider, _) {
                    if (myDeliveryOrderProvider.myDeliveryOrderState.progressState == 0) {
                      return Container(
                        height: heightDp * 200,
                        child: Center(child: CupertinoActivityIndicator()),
                      );
                    }

                    if (myDeliveryOrderProvider.myDeliveryOrderState.progressState == -1) {
                      return ErrorPage(
                        message: myDeliveryOrderProvider.myDeliveryOrderState.message!,
                        callback: () {
                          myDeliveryOrderProvider.setMyDeliveryOrderState(myDeliveryOrderProvider.myDeliveryOrderState.update(progressState: 1));
                          myDeliveryOrderProvider.getMyDeliveryOrderData(
                            lat: _position!.latitude,
                            lng: _position!.longitude,
                            deliveryUserId: _authProvider!.authState.deliveryUserModel!.id,
                            limit: 2,
                          );
                        },
                      );
                    }

                    return Container(
                      width: deviceWidth,
                      child: _orderListPanel(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _orderListPanel() {
    List<dynamic>? orderList = [];
    Map<String, dynamic>? myDeliveryOrderMetaData = Map<String, dynamic>();

    if (_myDeliveryOrderProvider!.myDeliveryOrderState.myDeliveryOrderListData != null) {
      orderList = _myDeliveryOrderProvider!.myDeliveryOrderState.myDeliveryOrderListData;
    }
    if (_myDeliveryOrderProvider!.myDeliveryOrderState.myDeliveryOrderMetaData != null) {
      myDeliveryOrderMetaData = _myDeliveryOrderProvider!.myDeliveryOrderState.myDeliveryOrderMetaData;
    }

    int itemCount = 0;

    if (_myDeliveryOrderProvider!.myDeliveryOrderState.myDeliveryOrderListData != null) {
      itemCount += _myDeliveryOrderProvider!.myDeliveryOrderState.myDeliveryOrderListData!.length;
    }

    if (_myDeliveryOrderProvider!.myDeliveryOrderState.progressState == 1) {
      itemCount += 2;
    }

    // if (_myDeliveryOrderProvider!.myDeliveryOrderState.progressState == 2 && _myDeliveryOrderProvider!.myDeliveryOrderState.myDeliveryOrderListData.length == 0) {
    //   return Center(
    //     child: Text("No Order", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
    //   );
    // }

    return (_myDeliveryOrderProvider!.myDeliveryOrderState.progressState == 2 &&
            _myDeliveryOrderProvider!.myDeliveryOrderState.myDeliveryOrderListData!.length == 0)
        ? Center(
            child: Text("No Order", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
          )
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("My Deliveries", style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold)),
                    KeicyRaisedButton(
                      width: widthDp * 100,
                      height: heightDp * 35,
                      color: config.AppColors().mainColor(1),
                      borderRadius: heightDp * 8,
                      child: Text("Show All", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                      onPressed: () async {
                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => MyDeliveryOrderListPage(haveAppBar: true),
                          ),
                        );

                        if (result != null && result) {
                          refreshList();
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: heightDp * 10),
              Column(
                children: List.generate(itemCount, (index) {
                  Map<String, dynamic> orderData = (index >= orderList!.length) ? Map<String, dynamic>() : orderList[index];

                  return OrderWidget(
                    batchOrder: orderList.isNotEmpty && orderList[0]["deliveryDetail"] != null && orderList[0]["deliveryDetail"]["ongoing"],
                    orderModel: orderData.isEmpty ? null : OrderModel.fromJson(orderData),
                    loadingStatus: orderData.isEmpty,
                    detailCallback: () {
                      _detailCallback(
                        orderData: orderData,
                        batchOrder: orderList![0]["deliveryDetail"] != null && orderList[0]["deliveryDetail"]["ongoing"],
                      );
                    },
                  );
                }),
              ),
            ],
          );
  }

  void _detailCallback({@required Map<String, dynamic>? orderData, @required bool? batchOrder}) async {
    var result;
    if (orderData!["deliveryDetail"] == null ||
        (orderData["deliveryDetail"] != null &&
            (orderData["deliveryDetail"]["status"].isEmpty ||
                orderData["deliveryDetail"]["status"] == "delivery_assigned" ||
                orderData["deliveryDetail"]["status"] == "delivery_cancelled" ||
                orderData["deliveryDetail"]["status"] == "delivery_complete"))) {
      result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => OrderDetailPage(orderModel: OrderModel.fromJson(orderData), batchOrder: batchOrder!),
        ),
      );
    } else {
      result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => DeliveryMapViewPage(
            orderModel: OrderModel.fromJson(orderData),
          ),
        ),
      );
    }

    if (result != null && result) {
      refreshList();
    }
  }
}
