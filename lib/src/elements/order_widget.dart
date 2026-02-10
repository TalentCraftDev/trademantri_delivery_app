import 'package:delivery_app/src/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:delivery_app/config/config.dart';
import 'package:delivery_app/src/dialogs/index.dart';
import 'package:delivery_app/src/elements/keicy_avatar_image.dart';
import 'package:delivery_app/src/helpers/date_time_convert.dart';
import 'package:delivery_app/src/providers/index.dart';
import 'package:delivery_app/config/app_config.dart' as config;
import 'package:url_launcher/url_launcher.dart';

import 'keicy_checkbox.dart';

class OrderWidget extends StatefulWidget {
  final OrderModel? orderModel;
  final bool? loadingStatus;
  final Function? detailCallback;
  final bool? batchOrder;

  OrderWidget({
    @required this.orderModel,
    @required this.loadingStatus,
    @required this.detailCallback,
    @required this.batchOrder,
  });

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
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
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        left: widthDp * 15,
        right: widthDp * 15,
        top: heightDp * 5,
        bottom: heightDp * 10,
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
        color: Colors.transparent,
        child: widget.loadingStatus! ? _shimmerWidget() : _orderWidget(),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.loadingStatus!,
      period: Duration(milliseconds: 1000),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: widthDp * 70,
                height: widthDp * 70,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightDp * 6)),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Store Name",
                        style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold, color: Colors.transparent),
                      ),
                    ),
                    SizedBox(height: heightDp * 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: Colors.white,
                          child: Text(
                            'Order Id 123123',
                            style: TextStyle(fontSize: fontSp * 12, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Text(
                            '2021-05-65',
                            style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "order city",
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                      ),
                    ),
                    SizedBox(height: heightDp * 5),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Store address sfsdf",
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(heightDp * 6),
                    bottomRight: Radius.circular(heightDp * 6),
                  ),
                ),
                child: Text(
                  "Not Paid",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: heightDp * 7),

          ///
          Column(
            children: [
              Container(
                width: deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Order Status:   ",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "orderStatus",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 7),
          Column(
            children: [
              Container(
                width: deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Order Type:   ",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "pick up",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///
          Column(
            children: [
              SizedBox(height: heightDp * 7),
              Container(
                width: deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Pickup Date:  ",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "2021-05-26",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "To Pay: ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "₹ 4163.25",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderWidget() {
    Color orderTypeColor;

    switch (widget.orderModel!.storeModel!.type) {
      case "Retailer":
        orderTypeColor = Colors.blue;
        break;
      case "Wholesaler":
        orderTypeColor = Colors.green;
        break;
      case "Service":
        orderTypeColor = Colors.red;
        break;
      default:
        orderTypeColor = Colors.white;
    }

    String orderStatus = "";
    for (var i = 0; i < AppConfig.orderStatusData.length; i++) {
      if (AppConfig.orderStatusData[i]["id"] == widget.orderModel!.status) {
        orderStatus = AppConfig.orderStatusData[i]["name"];
        break;
      }
    }

    String deliveryStatus = "";
    int? isOngoing;
    if (widget.orderModel!.deliveryDetail == null ||
        widget.orderModel!.deliveryDetail!.isEmpty ||
        (!widget.orderModel!.deliveryDetail!["ongoing"] && widget.orderModel!.deliveryDetail!["status"] != "delivery_complete")) {
      deliveryStatus = "Ready for Delivery";
      isOngoing = 0;
    } else if (widget.orderModel!.deliveryDetail != null &&
        widget.orderModel!.deliveryDetail!["ongoing"] &&
        widget.orderModel!.deliveryDetail!["status"] != "delivery_complete") {
      deliveryStatus = "On Going delivery";
      isOngoing = 1;
    } else if (widget.orderModel!.deliveryDetail != null && widget.orderModel!.deliveryDetail!["status"] == "delivery_complete") {
      deliveryStatus = "Delivery Completed";
      isOngoing = 2;
    }

    return GestureDetector(
      onTap: () {
        if (AuthProvider.of(context).authState.loginState == LoginState.IsNotLogin) {
          LoginAskDialog.show(context);
        } else {
          widget.detailCallback!();
        }
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                KeicyAvatarImage(
                  url: widget.orderModel!.storeModel!.profile!["image"],
                  width: widthDp * 70,
                  height: widthDp * 70,
                  backColor: Colors.grey.withOpacity(0.4),
                  borderRadius: heightDp * 6,
                  errorWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(heightDp * 6),
                    child: Image.asset(
                      "img/store-icon/${widget.orderModel!.storeModel!.subType.toString().toLowerCase()}-store.png",
                      width: widthDp * 70,
                      height: widthDp * 70,
                    ),
                  ),
                ),
                SizedBox(width: widthDp * 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.orderModel!.storeModel!.name} Store",
                        style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: heightDp * 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.orderModel!.orderId!,
                            style: TextStyle(fontSize: fontSp * 12, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            KeicyDateTime.convertDateTimeToDateString(
                              dateTime: widget.orderModel!.updatedAt,
                              formats: "Y-m-d H:i",
                              isUTC: false,
                            ),
                            style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.orderModel!.storeModel!.city}',
                            style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                          ),
                          SizedBox(width: widthDp * 15),
                          Text(
                            '${((widget.orderModel!.distance ?? 0) / 1000).toStringAsFixed(3)}Km',
                            style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 5),
                      Text(
                        "${widget.orderModel!.storeModel!.address}",
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // SizedBox(height: heightDp * 5),
                      // Container(
                      //   width: widthDp * 100,
                      //   padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                      //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 5), color: orderTypeColor.withOpacity(0.4)),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Icon(Icons.star, size: heightDp * 15, color: orderTypeColor),
                      //       SizedBox(width: widthDp * 5),
                      //       Text(
                      //         "${widget.orderModel!.storeModel["type"]}",
                      //         style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                  decoration: BoxDecoration(
                    color: isOngoing == 0
                        ? Colors.red
                        : isOngoing == 2
                            ? Colors.blue
                            : config.AppColors().mainColor(1),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(heightDp * 6),
                      bottomRight: Radius.circular(heightDp * 6),
                    ),
                  ),
                  child: Text(
                    deliveryStatus,
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                widget.orderModel!.cashOnDelivery!
                    ? KeicyCheckBox(
                        iconSize: heightDp * 20,
                        iconColor: Color(0xFF00D18F),
                        labelSpacing: widthDp * 10,
                        label: "Cash on Delivery",
                        labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                        value: widget.orderModel!.cashOnDelivery!,
                        readOnly: true,
                      )
                    : SizedBox(),
              ],
            ),

            ///
            SizedBox(height: heightDp * 7),
            Column(
              children: [
                Container(
                  width: deviceWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order Status:   ",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        orderStatus,
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 7),
            Column(
              children: [
                Container(
                  width: deviceWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pay Status:   ",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.orderModel!.payStatus! ? "Paid" : "Not Paid",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 7),
            Column(
              children: [
                Container(
                  width: deviceWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Distance - Store to Delivery Address:",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${(widget.orderModel!.deliveryAddress!.distance! / 1000).toStringAsFixed(3)} Km",
                        style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Column(
              children: [
                SizedBox(height: heightDp * 7),
                Container(
                  width: deviceWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Address:  ",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${widget.orderModel!.deliveryAddress!.addressType}",
                            style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 5),
                      Column(
                        children: [
                          if (widget.orderModel!.deliveryAddress!.building == "")
                            SizedBox()
                          else
                            Column(
                              children: [
                                Text(
                                  "${widget.orderModel!.deliveryAddress!.building}",
                                  style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: heightDp * 5),
                              ],
                            ),
                          Row(
                            children: [
                              SizedBox(width: widthDp * 10),
                              Expanded(
                                child: Text(
                                  "${widget.orderModel!.deliveryAddress!.address!.address}",
                                  style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: heightDp * 7),
                          KeicyCheckBox(
                            iconSize: heightDp * 20,
                            iconColor: Color(0xFF00D18F),
                            labelSpacing: widthDp * 10,
                            label: "No Contact Delivery",
                            labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                            value: widget.orderModel!.noContactDelivery!,
                            readOnly: true,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 7),
            widget.orderModel!.payStatus!
                ? SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "To Pay: ",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "₹ ${widget.orderModel!.paymentDetail!.toPay}",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
