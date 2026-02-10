import 'dart:convert';

import 'package:delivery_app/src/elements/order_status_steps_widget.dart';
import 'package:delivery_app/src/elements/qrcode_widget.dart';
import 'package:delivery_app/src/models/index.dart';
import 'package:delivery_app/src/pages/DeliveryMapViewPage/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:random_string/random_string.dart';
import 'package:delivery_app/config/config.dart';
import 'package:delivery_app/src/dialogs/index.dart';
import 'package:delivery_app/src/elements/keicy_progress_dialog.dart';
import 'package:delivery_app/src/elements/keicy_raised_button.dart';
import 'package:delivery_app/src/helpers/encrypt.dart';
import 'package:delivery_app/src/providers/index.dart';
import 'package:delivery_app/config/app_config.dart' as config;
import 'package:delivery_app/src/elements/keicy_checkbox.dart';

import 'index.dart';

class OrderDetailView extends StatefulWidget {
  final OrderModel? orderModel;
  final bool? isUpdated;
  final bool? batchOrder;

  OrderDetailView({Key? key, this.orderModel, this.isUpdated, this.batchOrder}) : super(key: key);

  @override
  _OrderDetailViewState createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
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
  KeicyProgressDialog? _keicyProgressDialog;

  OrderModel? _orderModel;

  bool? _isUpdated;
  bool? _isPickupStatus;

  List<dynamic>? _deliveredProductList;
  List<dynamic>? _nonDeliveredProductList;

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
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _orderModel = OrderModel.copy(widget.orderModel!);

    _deliveredProductList = [];
    _nonDeliveredProductList = [];

    _isUpdated = widget.isUpdated;
    _isPickupStatus = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deliveredProductList = [];
    _nonDeliveredProductList = [];

    // List deliverdProductListIDs = [];

    // if (_orderModel!.deliveryDetail != null && _orderModel!.deliveryDetail!["products"] != null) {
    //   for (var i = 0; i < _orderModel!.deliveryDetail!["products"].length; i++) {
    //     deliverdProductListIDs.add(_orderModel!.deliveryDetail!["products"][i]["id"]);
    //   }

    //   for (var i = 0; i < _orderModel!.products.length; i++) {
    //     if (deliverdProductListIDs.contains(_orderModel!.products[i]["id"])) {
    //       _deliveredProductList!.add(_orderModel!.products[i]);
    //     } else {
    //       _nonDeliveredProductList!.add(_orderModel!.products[i]);
    //     }
    //   }
    // }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_isUpdated);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
            onPressed: () {
              Navigator.of(context).pop(_isUpdated);
            },
          ),
          title: Text("Order Detail", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
          elevation: 0,
        ),
        body: Container(
          width: deviceWidth,
          height: deviceHeight,
          child: _mainPanel(),
        ),
      ),
    );
  }

  Widget _mainPanel() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Text(
                "${_orderModel!.orderId}",
                style: TextStyle(fontSize: fontSp * 23, color: Colors.black),
              ),
            ),

            ///
            SizedBox(height: heightDp * 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: QrCodeWidget(
                code: Encrypt.encryptString(
                  "Order_${_orderModel!.orderId}_StoreId-${_orderModel!.storeModel!.id}_UserId-${_orderModel!.userModel!.id}",
                ),
                width: heightDp * 150,
                height: heightDp * 150,
              ),
            ),

            if (_orderModel!.orderHistorySteps!.isNotEmpty || _orderModel!.orderFutureSteps!.isNotEmpty)
              Column(
                children: [
                  SizedBox(height: heightDp * 15),
                  OrderStatusStepsWidget(orderModel: _orderModel),
                ],
              ),

            if (_orderModel!.deliveryDetail != null && _orderModel!.deliveryDetail!["status"] == "delivery_complete")
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Column(
                  children: [
                    SizedBox(height: heightDp * 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_box_rounded, color: Colors.green, size: heightDp * 25),
                        SizedBox(width: widthDp * 10),
                        Text(
                          "Completed Delivery",
                          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ///
            SizedBox(height: heightDp * 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: StoreInfoPanel(storeModel: _orderModel!.storeModel, orderModel: _orderModel),
            ),

            ///
            SizedBox(height: heightDp * 30),
            _orderModel!.deliveryDetail != null && _orderModel!.deliveryDetail!["status"] != "delivery_complete"
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                    child: Column(
                      children: [
                        if (_isPickupStatus!)
                          Column(
                            children: [
                              KeicyCheckBox(
                                width: double.infinity,
                                height: heightDp * 25,
                                iconSize: heightDp * 25,
                                iconColor: Color(0xFF00D18F),
                                labelSpacing: widthDp * 10,
                                label:
                                    "Please select all the products you are picking up from store as part of the order, you can select all if you picked up everything",
                                labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                                value: _orderModel!.deliveryDetail!["products"] != null &&
                                    _orderModel!.products!.length == _orderModel!.deliveryDetail!["products"].length,
                                onChangeHandler: (value) {
                                  _orderModel!.deliveryDetail!["products"] = [];
                                  if (value) {
                                    for (var i = 0; i < _orderModel!.products!.length; i++) {
                                      _orderModel!.deliveryDetail!["products"].add({"id": _orderModel!.products![i].productModel!.id});
                                    }
                                  }
                                  setState(() {});
                                },
                              ),
                              SizedBox(height: heightDp * 15),
                            ],
                          ),
                        CartListPanel(
                          orderModel: _orderModel,
                          isSelectable: _isPickupStatus,
                          refreshCallback: (Map<String, dynamic> item, String type) {
                            if (_orderModel!.deliveryDetail!["products"] == null) _orderModel!.deliveryDetail!["products"] = [];
                            // if (_orderModel!.deliveryDetail!["services"] == null) _orderModel!.deliveryDetail!["services"] = [];
                            if (type == "product") {
                              bool isExist = false;
                              int index = -1;
                              for (var i = 0; i < _orderModel!.deliveryDetail!["products"].length; i++) {
                                if (_orderModel!.deliveryDetail!["products"][i]["id"] == item["data"]["_id"]) {
                                  isExist = true;
                                  index = i;
                                  break;
                                }
                              }
                              if (isExist) {
                                _orderModel!.deliveryDetail!["products"].removeAt(index);
                              } else {
                                _orderModel!.deliveryDetail!["products"].add({"id": item["data"]["_id"]});
                              }
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                    child: Column(
                      children: [
                        if (_deliveredProductList!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Deliveried Product List",
                                style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: heightDp * 5),
                              DeliveryProductListPanel(
                                orderModel: _orderModel,
                                productList: _deliveredProductList,
                              ),
                            ],
                          ),
                        if (_nonDeliveredProductList!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Non Deliveried Product List",
                                style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: heightDp * 5),
                              DeliveryProductListPanel(
                                orderModel: _orderModel,
                                productList: _nonDeliveredProductList,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

            ///
            Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
            SizedBox(height: heightDp * 20),
            _orderModel!.instructions == ""
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                    child: Column(
                      children: [
                        SizedBox(height: heightDp * 10),
                        Container(
                          width: deviceWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.event_note, size: heightDp * 25, color: Colors.black.withOpacity(0.7)),
                                  SizedBox(width: widthDp * 10),
                                  Text(
                                    "Instruction",
                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              SizedBox(height: heightDp * 5),
                              Text(
                                _orderModel!.instructions!,
                                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: heightDp * 10),
                        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                      ],
                    ),
                  ),

            SizedBox(height: heightDp * 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Container(
                width: deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Distance - Store to Delivery Address:",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${(_orderModel!.deliveryAddress!.distance! / 1000).toStringAsFixed(3)} Km",
                      style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Column(
                children: [
                  SizedBox(height: heightDp * 10),
                  Container(
                    width: deviceWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery Address:",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "${_orderModel!.deliveryAddress!.addressType}",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        SizedBox(height: heightDp * 5),
                        Row(
                          children: [
                            SizedBox(width: widthDp * 15),
                            Expanded(
                              child: Text(
                                "${_orderModel!.deliveryAddress!.address!.address}",
                                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: heightDp * 10),
                        KeicyCheckBox(
                          iconSize: heightDp * 25,
                          iconColor: Color(0xFF00D18F),
                          labelSpacing: widthDp * 20,
                          label: "No Contact Delivery",
                          labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                          value: _orderModel!.noContactDelivery!,
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: heightDp * 10),
                  Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                ],
              ),
            ),

            if (_orderModel!.cashOnDelivery!)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Column(
                  children: [
                    SizedBox(height: heightDp * 10),
                    KeicyCheckBox(
                      iconSize: heightDp * 25,
                      iconColor: Color(0xFF00D18F),
                      labelSpacing: widthDp * 20,
                      label: "Cash on Delivery",
                      labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                      value: _orderModel!.cashOnDelivery!,
                      readOnly: true,
                    ),
                    SizedBox(height: heightDp * 10),
                    Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ],
                ),
              )
            else
              SizedBox(),

            //////
            SizedBox(height: heightDp * 10),
            if (_orderModel!.cashOnDelivery!)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Column(
                  children: [
                    PaymentDetailPanel(orderModel: _orderModel),
                    SizedBox(height: heightDp * 10),
                    Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ],
                ),
              )
            else
              SizedBox(),

            ///
            SizedBox(height: heightDp * 10),
            if (_orderModel!.deliveryDetail == null ||
                _orderModel!.deliveryDetail!.isEmpty ||
                (!_orderModel!.deliveryDetail!["ongoing"] && _orderModel!.deliveryDetail!["status"] != "delivery_complete"))
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: _initButtonGroup(),
              )
            else if (_orderModel!.deliveryDetail != null &&
                _orderModel!.deliveryDetail!["ongoing"] &&
                !_isPickupStatus! &&
                _orderModel!.deliveryDetail!["status"] == "delivery_assigned")
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: _acceptedButtonGroup(),
              )
            else if (_orderModel!.deliveryDetail != null &&
                _orderModel!.deliveryDetail!["ongoing"] &&
                _isPickupStatus! &&
                _orderModel!.deliveryDetail!["status"] == "delivery_assigned")
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: _pickupButtonGroup(),
              ),

            ///
            SizedBox(height: heightDp * 20),
          ],
        ),
      ),
    );
  }

  Widget _initButtonGroup() {
    return KeicyRaisedButton(
      width: widthDp * 140,
      height: heightDp * 35,
      color: config.AppColors().mainColor(1),
      borderRadius: heightDp * 35,
      child: Text("Accept", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
      onPressed: () {
        if ((_orderModel!.distance ?? 0) / 1000 >= AppConfig.deliveryDistanceLimit) {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "The distance to travel to store is very long, please consider accepting another order near to you",
            isTryButton: false,
            callBack: null,
          );
        } else {
          NormalAskDialog.show(
            context,
            title: "Delivery Order Accept",
            content: widget.batchOrder!
                ? "If you accept this order also, this order is considered as batch order for delivery, would you like to do it?"
                : "Do you really want to accept the order.",
            okayButtonString: "Accept",
            callback: _acceptedCallback,
          );
        }
      },
    );
  }

  Widget _acceptedButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        runSpacing: heightDp * 10,
        children: [
          KeicyRaisedButton(
            width: widthDp * 150,
            height: heightDp * 35,
            color: config.AppColors().mainColor(1),
            borderRadius: heightDp * 35,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text("Navigate to Store", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
            onPressed: () {
              MapsSheet.show(
                context: context,
                onMapTap: (map) {
                  map.showMarker(
                    coords: Coords(
                      _orderModel!.storeModel!.location!.latitude,
                      _orderModel!.storeModel!.location!.longitude,
                    ),
                    title: "",
                  );
                },
              );
            },
          ),
          KeicyRaisedButton(
            width: widthDp * 150,
            height: heightDp * 35,
            color: config.AppColors().mainColor(1),
            borderRadius: heightDp * 35,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text("Pickup Items", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
            onPressed: () {
              NormalDialog.show(context, content: "Please click on the items you picked up from the store");
              setState(() {
                _isPickupStatus = true;
              });
            },
          ),
          KeicyRaisedButton(
            width: widthDp * 150,
            height: heightDp * 35,
            color: config.AppColors().mainColor(1),
            borderRadius: heightDp * 35,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text("Cancel", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
            onPressed: _cancelAcceptCallback,
          ),
        ],
      ),
    );
  }

  Widget _pickupButtonGroup() {
    bool pickupAvailable = true;

    if (_orderModel!.deliveryDetail!["products"] == null || _orderModel!.deliveryDetail!["products"].isEmpty) {
      pickupAvailable = false;
    }

    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        runSpacing: heightDp * 10,
        children: [
          KeicyRaisedButton(
            width: widthDp * 150,
            height: heightDp * 35,
            color: pickupAvailable ? config.AppColors().mainColor(1) : Colors.grey.withOpacity(0.6),
            borderRadius: heightDp * 35,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text("Confirm Pickup", style: TextStyle(fontSize: fontSp * 14, color: pickupAvailable ? Colors.white : Colors.black)),
            onPressed: !pickupAvailable
                ? null
                : () {
                    NormalAskDialog.show(
                      context,
                      title: "Confirm Pickup",
                      content: "Are you sure you picked up all the items",
                      callback: _sendPickupCodeCallback,
                    );
                  },
          ),
          KeicyRaisedButton(
            width: widthDp * 150,
            height: heightDp * 35,
            color: config.AppColors().mainColor(1),
            borderRadius: heightDp * 35,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text("Cancel", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
            onPressed: () {
              NormalAskDialog.show(
                context,
                title: "Pickup Cancel",
                content: "Are you sure to cancel pickup",
                callback: () {
                  setState(() {
                    _orderModel!.deliveryDetail!["products"] = [];
                    _isPickupStatus = false;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _acceptedCallback() async {
    Map<String, dynamic> newOrderData = json.decode(json.encode(_orderModel!.toJson()));
    List<dynamic> historyData = [];
    if (newOrderData["deliveryDetail"] != null) {
      historyData = newOrderData["deliveryDetail"]["historyData"] ?? [];
    }

    historyData.add({
      "title": AppConfig.deliveryOrderHistory["delivery_assigned"]["title"],
      "desc": AppConfig.deliveryOrderHistory["delivery_assigned"]["desc"].toString().replaceAll("orderId", _orderModel!.orderId!).replaceAll(
            "delivery_user_name",
            "${AuthProvider.of(context).authState.deliveryUserModel!.firstName} "
                "${AuthProvider.of(context).authState.deliveryUserModel!.lastName}",
          ),
      "data": {
        "orderId": newOrderData["_id"],
        "deliveryUserId": AuthProvider.of(context).authState.deliveryUserModel!.id,
      }
    });

    newOrderData["deliveryDetail"] = {
      "ongoing": true,
      "batchOrder": widget.batchOrder,
      "status": "delivery_assigned",
      "assignedDeliveryUserId": AuthProvider.of(context).authState.deliveryUserModel!.id,
      "assignedDeliveryUserName": "${AuthProvider.of(context).authState.deliveryUserModel!.firstName} "
          "${AuthProvider.of(context).authState.deliveryUserModel!.lastName}",
      "storeDeliveryCode": "",
      "customerDeliveryCode": "",
      "historyData": historyData,
      "createdAt": _orderModel!.deliveryDetail != null ? _orderModel!.deliveryDetail!["createdAt"] : null,
    };
    newOrderData["user"] = _orderModel!.userModel!.toJson();
    newOrderData["store"] = _orderModel!.storeModel!.toJson();

    await _keicyProgressDialog!.show();
    var result = await _orderProvider!.updateOrderData(
      orderModel: OrderModel.fromJson(newOrderData),
      status: "delivery_assigned",
      changedStatus: false,
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "The Delivery Order is accepted",
        callBack: () {
          _orderModel = OrderModel.fromJson(result["data"]);
          _orderModel!.userModel = widget.orderModel!.userModel;
          _orderModel!.storeModel = widget.orderModel!.storeModel;
          _isUpdated = true;
          setState(() {});
        },
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        isTryButton: result["type"] != "notError",
        callBack: result["type"] != "notError"
            ? () {
                _acceptedCallback();
              }
            : null,
      );
    }
  }

  void _cancelAcceptCallback() async {
    Map<String, dynamic> newOrderData = json.decode(json.encode(_orderModel!.toJson()));
    List<dynamic> historyData = [];
    if (newOrderData["deliveryDetail"] != null) {
      historyData = newOrderData["deliveryDetail"]["historyData"];
    }

    historyData.add({
      "title": AppConfig.deliveryOrderHistory["delivery_cancelled"]["title"],
      "desc": AppConfig.deliveryOrderHistory["delivery_cancelled"]["desc"].toString().replaceAll("orderId", _orderModel!.orderId!).replaceAll(
            "delivery_user_name",
            "${AuthProvider.of(context).authState.deliveryUserModel!.firstName} "
                "${AuthProvider.of(context).authState.deliveryUserModel!.lastName}",
          ),
      "data": {
        "orderId": newOrderData["_id"],
        "deliveryUserId": AuthProvider.of(context).authState.deliveryUserModel!.id,
      }
    });

    newOrderData["deliveryDetail"] = {};

    newOrderData["deliveryDetail"]["ongoing"] = false;
    newOrderData["deliveryDetail"]["historyData"] = historyData;
    newOrderData["deliveryDetail"]["assignedDeliveryUserId"] = "";
    newOrderData["user"] = _orderModel!.userModel!.toJson();
    newOrderData["store"] = _orderModel!.storeModel!.toJson();

    NormalAskDialog.show(
      context,
      title: "Delivery Order Cancel",
      content: "Do you really want to cancel the order.",
      callback: () async {
        await _keicyProgressDialog!.show();

        var result = await _orderProvider!.updateOrderData(
          orderModel: OrderModel.fromJson(newOrderData),
          status: "delivery_cancelled",
          changedStatus: false,
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _orderModel = OrderModel.fromJson(result["data"]);
          _orderModel!.userModel = widget.orderModel!.userModel;
          _orderModel!.storeModel = widget.orderModel!.storeModel;
          _isUpdated = true;
          setState(() {});
          SuccessDialog.show(
            context,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "The Delivery Order is cancelled",
          );
        } else {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: result["message"],
            callBack: () {
              _cancelAcceptCallback();
            },
          );
        }
      },
    );
  }

  void _sendPickupCodeCallback() async {
    Map<String, dynamic> newOrderData = json.decode(json.encode(_orderModel!.toJson()));
    String storeDeliveryCode = randomNumeric(4);
    List<dynamic> historyData = [];
    if (newOrderData["deliveryDetail"] != null) {
      historyData = newOrderData["deliveryDetail"]["historyData"];
    }

    historyData.add({
      "title": AppConfig.deliveryOrderHistory["sent_delivery_pickup_code"]["title"],
      "desc": AppConfig.deliveryOrderHistory["sent_delivery_pickup_code"]["desc"].toString().replaceAll("orderId", _orderModel!.orderId!).replaceAll(
            "delivery_user_name",
            "${AuthProvider.of(context).authState.deliveryUserModel!.firstName} "
                "${AuthProvider.of(context).authState.deliveryUserModel!.lastName}",
          ),
      "data": {
        "orderId": newOrderData["_id"],
        "deliveryUserId": AuthProvider.of(context).authState.deliveryUserModel!.id,
        "storeDeliveryCode": storeDeliveryCode,
      }
    });

    newOrderData["deliveryDetail"]["status"] = "sent_delivery_pickup_code";
    newOrderData["deliveryDetail"]["historyData"] = historyData;
    newOrderData["deliveryDetail"]["storeDeliveryCode"] = storeDeliveryCode;
    newOrderData["user"] = _orderModel!.userModel!.toJson();
    newOrderData["store"] = _orderModel!.storeModel!.toJson();

    await _keicyProgressDialog!.show();
    var result = await _orderProvider!.updateOrderData(
      orderModel: OrderModel.fromJson(newOrderData),
      status: "sent_delivery_pickup_code",
      changedStatus: false,
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _orderModel = OrderModel.fromJson(result["data"]);
      _orderModel!.userModel = widget.orderModel!.userModel;
      _orderModel!.storeModel = widget.orderModel!.storeModel;
      _isUpdated = true;
      setState(() {});
      SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp, text: "The Delivery Order is picked up", callBack: () {
        Navigator.of(context).pop(_isUpdated);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => DeliveryMapViewPage(
              orderModel: _orderModel,
            ),
          ),
        );
      });
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _sendPickupCodeCallback();
        },
      );
    }
  }
}
