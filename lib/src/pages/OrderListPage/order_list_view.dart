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

class OrderListView extends StatefulWidget {
  final bool? haveAppBar;

  OrderListView({Key? key, this.haveAppBar}) : super(key: key);

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> with SingleTickerProviderStateMixin {
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

  OrderProvider? _orderProvider;

  Position? _position;

  RefreshController? _refreshController;

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

    _orderProvider = OrderProvider.of(context);

    _refreshController = RefreshController();

    _orderProvider!.setOrderState(
      _orderProvider!.orderState.update(
        orderListData: [],
        orderMetaData: Map<String, dynamic>(),
        progressState: 0,
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _orderProvider!.addListener(_orderProviderListener);

      _initHandler();
    });
  }

  void _initHandler() async {
    var permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      _position = await Geolocator.getCurrentPosition();

      _orderProvider!.setOrderState(_orderProvider!.orderState.update(progressState: 1));
      _orderProvider!.getOrderData(
        lat: _position!.latitude,
        lng: _position!.longitude,
        deliveryUserId: AuthProvider.of(context).authState.deliveryUserModel!.id,
        deliveryPartnerIds: AuthProvider.of(context).authState.deliveryUserModel!.deliveryPartnerIds,
      );
    } else {
      _orderProvider!.setOrderState(
        _orderProvider!.orderState.update(progressState: -1, message: "Location Permission was deny"),
      );
      return;
    }
  }

  @override
  void dispose() {
    _orderProvider!.removeListener(_orderProviderListener);

    super.dispose();
  }

  void _orderProviderListener() async {
    if (_orderProvider!.orderState.progressState == -1) {
      if (_orderProvider!.orderState.isRefresh!) {
        _refreshController!.refreshFailed();
        _orderProvider!.setOrderState(
          _orderProvider!.orderState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_orderProvider!.orderState.progressState == 2) {
      if (_orderProvider!.orderState.isRefresh!) {
        _refreshController!.refreshCompleted();
        _orderProvider!.setOrderState(
          _orderProvider!.orderState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<dynamic> orderListData = [];
    Map<String, dynamic> orderMetaData = Map<String, dynamic>();

    _orderProvider!.setOrderState(
      _orderProvider!.orderState.update(
        progressState: 1,
        orderListData: orderListData,
        orderMetaData: orderMetaData,
        isRefresh: true,
      ),
    );

    _orderProvider!.getOrderData(
      lat: _position!.latitude,
      lng: _position!.longitude,
      deliveryUserId: AuthProvider.of(context).authState.deliveryUserModel!.id,
      deliveryPartnerIds: AuthProvider.of(context).authState.deliveryUserModel!.deliveryPartnerIds,
    );
  }

  void _onLoading() async {
    _orderProvider!.setOrderState(
      _orderProvider!.orderState.update(progressState: 1),
    );
    _orderProvider!.getOrderData(
      lat: _position!.latitude,
      lng: _position!.longitude,
      deliveryUserId: AuthProvider.of(context).authState.deliveryUserModel!.id,
      deliveryPartnerIds: AuthProvider.of(context).authState.deliveryUserModel!.deliveryPartnerIds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !widget.haveAppBar!
          ? null
          : AppBar(
              centerTitle: true,
              title: Text(
                "Delivery Orders",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              ),
              elevation: 0,
            ),
      body: Consumer<OrderProvider>(builder: (context, orderProvider, _) {
        if (orderProvider.orderState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (orderProvider.orderState.progressState == -1) {
          return ErrorPage(
            message: orderProvider.orderState.message,
            callback: _initHandler,
          );
        }

        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: _orderListPanel(),
        );
      }),
    );
  }

  Widget _orderListPanel() {
    List<dynamic>? orderList = [];
    Map<String, dynamic>? orderMetaData = Map<String, dynamic>();

    if (_orderProvider!.orderState.orderListData != null) {
      orderList = _orderProvider!.orderState.orderListData;
    }
    if (_orderProvider!.orderState.orderMetaData != null) {
      orderMetaData = _orderProvider!.orderState.orderMetaData;
    }

    int itemCount = 0;

    if (_orderProvider!.orderState.orderListData != null) {
      itemCount += _orderProvider!.orderState.orderListData!.length;
    }

    if (_orderProvider!.orderState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    // if (_orderProvider!.orderState.progressState == 2 && _orderProvider!.orderState.orderListData.length == 0) {
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
              enablePullUp: (orderMetaData!["nextPage"] != null && _orderProvider!.orderState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: (_orderProvider!.orderState.progressState == 2 && _orderProvider!.orderState.orderListData!.length == 0)
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

  void _detailCallback({@required Map<String, dynamic>? orderData, @required bool? batchOrder}) async {
    _orderProvider!.removeListener(_orderProviderListener);
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

    _orderProvider!.addListener(_orderProviderListener);
    if (result != null && result) {
      _onRefresh();
    }
  }
}
