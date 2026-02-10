import 'package:delivery_app/src/dialogs/index.dart';
import 'package:delivery_app/src/elements/keicy_raised_button.dart';
import 'package:delivery_app/src/models/order_model.dart';
import 'package:delivery_app/src/providers/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:delivery_app/config/app_config.dart' as config;
import 'package:provider/provider.dart';

class PickupCompleteOTPPanel extends StatefulWidget {
  final OrderModel? orderModel;
  final Function? resendPickupCodeCallback;
  final Function? deliveryPickupCompleteCallback;

  PickupCompleteOTPPanel({
    Key? key,
    @required this.orderModel,
    @required this.resendPickupCodeCallback,
    @required this.deliveryPickupCompleteCallback,
  }) : super(key: key);

  @override
  _PickupCompleteOTPPanelState createState() => _PickupCompleteOTPPanelState();
}

class _PickupCompleteOTPPanelState extends State<PickupCompleteOTPPanel> {
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

  TextEditingController _otpController = TextEditingController();

  DeliveryOTPProvider? _deliveryOTPProvider;

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

    DeliveryOTPProvider.of(context).setDeliveryOTPState(
      DeliveryOTPState.init(),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      DeliveryOTPProvider.of(context).getOTP(orderId: widget.orderModel!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Consumer<DeliveryOTPProvider>(builder: (context, deliveryOTPProvider, _) {
        return Container(
          width: deviceWidth,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(heightDp * 30), topRight: Radius.circular(heightDp * 30)),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), offset: Offset(0, -3), blurRadius: 3)],
          ),
          child: Column(
            children: [
              SizedBox(height: heightDp * 10),
              Text(
                "Enter Pickup Point OTP",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
              SizedBox(height: heightDp * 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: PinCodeTextField(
                  length: 4,
                  keyboardType: TextInputType.number,
                  textStyle: TextStyle(fontSize: fontSp * 28, color: Colors.black),
                  pastedTextStyle: TextStyle(fontSize: fontSp * 28, color: Colors.black),
                  enablePinAutofill: false,
                  enableActiveFill: true,
                  autoDismissKeyboard: false,
                  autoFocus: false,
                  animationType: AnimationType.fade,
                  readOnly: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(widthDp * 10),
                    fieldHeight: widthDp * 60,
                    fieldWidth: widthDp * 50,
                    activeColor: Colors.transparent,
                    inactiveColor: Colors.transparent,
                    selectedColor: Colors.transparent,
                    selectedFillColor: config.AppColors().mainColor(0.6),
                    inactiveFillColor: Color(0xFFF0F2F7),
                    activeFillColor: config.AppColors().mainColor(0.6),
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  // errorAnimationController: errorController,
                  controller: _otpController,
                  onCompleted: (v) {},
                  onChanged: (value) {
                    setState(() {});
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                  appContext: context,
                  validator: (value) => value!.length != 6 ? "Please enter 4 digits" : null,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      _otpController.clear();
                      widget.resendPickupCodeCallback!();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(heightDp * 8),
                      ),
                      child: Text(
                        "Resend OTP",
                        style: TextStyle(
                          fontSize: fontSp * 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightDp * 10),
              if (deliveryOTPProvider.deliveryOTPState.progressState != 2)
                KeicyRaisedButton(
                  width: widthDp * 120,
                  height: heightDp * 40,
                  borderRadius: heightDp * 8,
                  color: config.AppColors().mainColor(1),
                  child: deliveryOTPProvider.deliveryOTPState.progressState == 0 || deliveryOTPProvider.deliveryOTPState.progressState == 1
                      ? Theme(
                          data: Theme.of(context).copyWith(brightness: Brightness.dark),
                          child: CupertinoActivityIndicator(),
                        )
                      : Text("Try Again", style: TextStyle(fontSize: fontSp * 16, color: Colors.white)),
                  onPressed: deliveryOTPProvider.deliveryOTPState.progressState == 0 || deliveryOTPProvider.deliveryOTPState.progressState == 1
                      ? null
                      : () {
                          deliveryOTPProvider.setDeliveryOTPState(deliveryOTPProvider.deliveryOTPState.update(progressState: 1));
                          deliveryOTPProvider.getOTP(orderId: widget.orderModel!.id);
                        },
                ),
              if (deliveryOTPProvider.deliveryOTPState.progressState == 2)
                KeicyRaisedButton(
                  width: widthDp * 120,
                  height: heightDp * 40,
                  borderRadius: heightDp * 8,
                  color: _otpController.text.length == 4 ? config.AppColors().mainColor(1) : Colors.grey.withOpacity(0.6),
                  child: Text("Verify", style: TextStyle(fontSize: fontSp * 16, color: Colors.white)),
                  onPressed: _otpController.text.length != 4
                      ? null
                      : () {
                          if (deliveryOTPProvider.deliveryOTPState.storeDeliveryCode != _otpController.text) {
                            OTPInvalidDialog.show(
                              context,
                              widthDp: widthDp,
                              heightDp: heightDp,
                              fontSp: fontSp,
                              text: "The Pickup OTP is incorrect. Please check with store person and enter or re-send OTP again.",
                              resendOTPCallback: () {
                                _otpController.clear();
                                widget.resendPickupCodeCallback!();
                              },
                            );
                          } else {
                            widget.deliveryPickupCompleteCallback!();
                          }
                        },
                ),
            ],
          ),
        );
      }),
    );
  }
}
