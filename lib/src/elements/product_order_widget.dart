import 'dart:convert';

import 'package:delivery_app/src/models/index.dart';
import 'package:intl/intl.dart';
import 'package:delivery_app/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/src/helpers/price_functions.dart';

import 'keicy_avatar_image.dart';

class ProductOrderWidget extends StatefulWidget {
  final ProductOrderModel? productOrderModel;
  final bool isSelectable;
  final bool isSelected;
  final Function(Map<String, dynamic>, String)? refreshCallback;

  ProductOrderWidget({
    @required this.productOrderModel,
    this.isSelectable = false,
    this.isSelected = false,
    this.refreshCallback,
  });

  @override
  _ProductOrderWidgetState createState() => _ProductOrderWidgetState();
}

class _ProductOrderWidgetState extends State<ProductOrderWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 0, vertical: heightDp * 5),
      child: _productWidget(),
    );
  }

  Widget _productWidget() {
    return GestureDetector(
      onTap: widget.isSelectable
          ? () {
              if (widget.refreshCallback != null) widget.refreshCallback!(widget.productOrderModel!.toJson(), "product");
            }
          : null,
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Stack(
              children: [
                KeicyAvatarImage(
                  url: widget.productOrderModel!.productModel!.images!.isEmpty ? "" : widget.productOrderModel!.productModel!.images![0],
                  width: widthDp * 80,
                  height: widthDp * 80,
                  backColor: Colors.grey.withOpacity(0.4),
                ),
                widget.isSelected
                    ? Positioned(
                        child: Image.asset(
                          "img/check_icon.png",
                          width: heightDp * 20,
                          height: heightDp * 20,
                          fit: BoxFit.cover,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(width: widthDp * 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.productOrderModel!.productModel!.name}",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: heightDp * 3),
                              widget.productOrderModel!.productModel!.description == ""
                                  ? SizedBox()
                                  : Text(
                                      "${widget.productOrderModel!.productModel!.description}",
                                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              SizedBox(height: heightDp * 3),
                              widget.productOrderModel!.productModel!.quantity == null && widget.productOrderModel!.productModel!.quantityType == null
                                  ? SizedBox()
                                  : Text(
                                      "${widget.productOrderModel!.productModel!.quantity ?? ""} ${widget.productOrderModel!.productModel!.quantityType ?? ""}",
                                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                                    ),
                              SizedBox(height: heightDp * 5),
                              _categoryButton(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: widthDp * 5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _priceWidget(),
                          SizedBox(height: heightDp * 3),
                          _countButton(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(heightDp * 20),
        border: Border.all(color: Colors.blue),
      ),
      child: Text(
        "Product",
        style: TextStyle(fontSize: fontSp * 12, color: Colors.blue),
      ),
    );
  }

  Widget _countButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 2),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
            alignment: Alignment.center,
            child: Row(
              children: [
                Text(
                  "Quantities:  ",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                ),
                Text(
                  "${widget.productOrderModel!.couponQuantity}",
                  style: TextStyle(fontSize: fontSp * 18, color: config.AppColors().mainColor(1), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        widget.productOrderModel!.orderPrice == 0
            ? Text(
                "Not set price",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.red, fontWeight: FontWeight.w500),
              )
            : widget.productOrderModel!.promocodeDiscount == 0 && widget.productOrderModel!.couponDiscount == 0
                ? Text(
                    "₹ ${numFormat.format(widget.productOrderModel!.orderPrice! * widget.productOrderModel!.couponQuantity!)}",
                    style: TextStyle(fontSize: fontSp * 16, color: config.AppColors().mainColor(1), fontWeight: FontWeight.w500),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹ ${numFormat.format(
                          (widget.productOrderModel!.orderPrice! -
                                  widget.productOrderModel!.couponDiscount! -
                                  widget.productOrderModel!.promocodeDiscount!) *
                              widget.productOrderModel!.couponQuantity!,
                        )}",
                        style: TextStyle(fontSize: fontSp * 16, color: config.AppColors().mainColor(1), fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: widthDp * 3),
                      Text(
                        "₹ ${numFormat.format(widget.productOrderModel!.orderPrice! * widget.productOrderModel!.couponQuantity!)}",
                        style: TextStyle(
                          fontSize: fontSp * 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                        ),
                      ),
                    ],
                  ),
        widget.productOrderModel!.taxPriceAfterDiscount == 0
            ? Text(
                "Tax: ",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.transparent),
              )
            : Column(
                children: [
                  SizedBox(height: heightDp * 3),
                  Text(
                    "Tax: ₹ ${numFormat.format(widget.productOrderModel!.taxPriceAfterDiscount! * widget.productOrderModel!.couponQuantity!)}",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                  ),
                ],
              ),
      ],
    );
  }
}
