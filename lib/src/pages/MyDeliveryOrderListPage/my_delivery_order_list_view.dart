import 'package:delivery_app/src/elements/order_widget.dart';
import 'package:delivery_app/src/models/index.dart';
import 'package:delivery_app/src/pages/DeliveryMapViewPage/index.dart';
import 'package:delivery_app/src/pages/ErrorPage/index.dart';
import 'package:delivery_app/src/pages/OrderDetailPage/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/config/config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:delivery_app/src/providers/index.dart';

class MyDeliveryOrderListView extends StatefulWidget {
  final bool? haveAppBar;

  MyDeliveryOrderListView({Key? key, this.haveAppBar}) : super(key: key);

  @override
  _MyDeliveryOrderListViewState createState() => _MyDeliveryOrderListViewState();
}

class _MyDeliveryOrderListViewState extends State<MyDeliveryOrderListView> with SingleTickerProviderStateMixin {
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

  Position? _position;

  RefreshController? _refreshController;

  bool isUpdated = false;

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

    _myDeliveryOrderProvider = MyDeliveryOrderProvider.of(context);

    _refreshController = RefreshController();

    _myDeliveryOrderProvider!.setMyDeliveryOrderState(
      _myDeliveryOrderProvider!.myDeliveryOrderState.update(
        myDeliveryOrderListData: [],
        myDeliveryOrderMetaData: Map<String, dynamic>(),
        progressState: 0,
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _myDeliveryOrderProvider!.addListener(_myDeliveryOrderProviderListener);

      var permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        _position = await Geolocator.getCurrentPosition();

        _myDeliveryOrderProvider!.setMyDeliveryOrderState(_myDeliveryOrderProvider!.myDeliveryOrderState.update(progressState: 1));
        _myDeliveryOrderProvider!.getMyDeliveryOrderData(
          lat: _position!.latitude,
          lng: _position!.longitude,
          deliveryUserId: AuthProvider.of(context).authState.deliveryUserModel!.id,
        );
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
    _myDeliveryOrderProvider!.removeListener(_myDeliveryOrderProviderListener);

    super.dispose();
  }

  void _myDeliveryOrderProviderListener() async {
    if (_myDeliveryOrderProvider!.myDeliveryOrderState.progressState == -1) {
      if (_myDeliveryOrderProvider!.myDeliveryOrderState.isRefresh!) {
        _refreshController!.refreshFailed();
        _myDeliveryOrderProvider!.setMyDeliveryOrderState(
          _myDeliveryOrderProvider!.myDeliveryOrderState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_myDeliveryOrderProvider!.myDeliveryOrderState.progressState == 2) {
      if (_myDeliveryOrderProvider!.myDeliveryOrderState.isRefresh!) {
        _refreshController!.refreshCompleted();
        _myDeliveryOrderProvider!.setMyDeliveryOrderState(
          _myDeliveryOrderProvider!.myDeliveryOrderState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<dynamic> myDeliveryOrderListData = [];
    Map<String, dynamic> myDeliveryOrderMetaData = Map<String, dynamic>();

    _myDeliveryOrderProvider!.setMyDeliveryOrderState(
      _myDeliveryOrderProvider!.myDeliveryOrderState.update(
        progressState: 1,
        myDeliveryOrderListData: myDeliveryOrderListData,
        myDeliveryOrderMetaData: myDeliveryOrderMetaData,
        isRefresh: true,
      ),
    );

    _myDeliveryOrderProvider!.getMyDeliveryOrderData(
      lat: _position!.latitude,
      lng: _position!.longitude,
      deliveryUserId: AuthProvider.of(context).authState.deliveryUserModel!.id,
    );
  }

  void _onLoading() async {
    _myDeliveryOrderProvider!.setMyDeliveryOrderState(
      _myDeliveryOrderProvider!.myDeliveryOrderState.update(progressState: 1),
    );
    _myDeliveryOrderProvider!.getMyDeliveryOrderData(
      lat: _position!.latitude,
      lng: _position!.longitude,
      deliveryUserId: AuthProvider.of(context).authState.deliveryUserModel!.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(isUpdated);

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: !widget.haveAppBar!
            ? null
            : AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop(isUpdated);
                  },
                ),
                centerTitle: true,
                title: Text(
                  "My Deliveries",
                  style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                ),
                elevation: 0,
              ),
        body: Consumer<MyDeliveryOrderProvider>(builder: (context, myDeliveryOrderProvider, _) {
          if (myDeliveryOrderProvider.myDeliveryOrderState.progressState == 0) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (myDeliveryOrderProvider.myDeliveryOrderState.progressState == -1) {
            return ErrorPage(
              message: myDeliveryOrderProvider.myDeliveryOrderState.message,
              callback: () {
                _myDeliveryOrderProvider!.setMyDeliveryOrderState(_myDeliveryOrderProvider!.myDeliveryOrderState.update(progressState: 1));
                _myDeliveryOrderProvider!.getMyDeliveryOrderData(
                  lat: _position!.latitude,
                  lng: _position!.longitude,
                  deliveryUserId: AuthProvider.of(context).authState.deliveryUserModel!.id,
                );
              },
            );
          }

          return Container(
            width: deviceWidth,
            height: deviceHeight,
            child: _orderListPanel(),
          );
        }),
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
      itemCount += AppConfig.countLimitForList;
    }

    // if (_myDeliveryOrderProvider!.myDeliveryOrderState.progressState == 2 && _myDeliveryOrderProvider!.myDeliveryOrderState.myDeliveryOrderListData.length == 0) {
    //   return Center(
    //     child: Text("No Order", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
    //   );
    // }

    return Column(
      children: [
        Expanded(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowIndicator();
              return true;
            },
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: (myDeliveryOrderMetaData!["nextPage"] != null && _myDeliveryOrderProvider!.myDeliveryOrderState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: (_myDeliveryOrderProvider!.myDeliveryOrderState.progressState == 2 &&
                      _myDeliveryOrderProvider!.myDeliveryOrderState.myDeliveryOrderListData!.length == 0)
                  ? Center(
                      child: Text("No Order", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                    )
                  : ListView.separated(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
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
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox();
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void _detailCallback({
    @required Map<String, dynamic>? orderData,
    @required bool? batchOrder,
  }) async {
    _myDeliveryOrderProvider!.removeListener(_myDeliveryOrderProviderListener);
    var result;
    if (orderData!["deliveryDetail"] == null ||
        (orderData["deliveryDetail"] != null &&
            (orderData["deliveryDetail"]["status"].isEmpty ||
                orderData["deliveryDetail"]["status"] == "delivery_assigned" ||
                orderData["deliveryDetail"]["status"] == "delivery_cancelled" ||
                orderData["deliveryDetail"]["status"] == "delivery_complete"))) {
      result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => OrderDetailPage(
            orderModel: OrderModel.fromJson(orderData),
            batchOrder: batchOrder!,
          ),
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

    _myDeliveryOrderProvider!.addListener(_myDeliveryOrderProviderListener);
    if (result != null && result) {
      isUpdated = true;
      _onRefresh();
    }
  }
}
