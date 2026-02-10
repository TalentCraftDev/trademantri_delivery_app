import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/src/elements/keicy_raised_button.dart';
import 'package:delivery_app/config/app_config.dart' as config;

class OTPInvalidDialog {
  static show(
    BuildContext context, {
    @required double? widthDp,
    @required double? heightDp,
    @required double? fontSp,
    EdgeInsets? insetPadding,
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    double? borderRadius,
    Color? barrierColor,
    text = "Something went wrong",
    bool barrierDismissible = false,
    @required Function? resendOTPCallback,
  }) async {
    var result = await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      // barrierColor: barrierColor,
      builder: (BuildContext context1) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp! * 10)),
          titlePadding: titlePadding ?? EdgeInsets.zero,
          contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: widthDp! * 20, vertical: heightDp * 20),
          children: [
            Transform.rotate(
              angle: pi / 4,
              child: Icon(Icons.add_circle, size: heightDp * 60, color: Colors.redAccent),
            ),
            SizedBox(height: heightDp * 20),
            Text(
              text,
              style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: heightDp * 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                KeicyRaisedButton(
                  width: heightDp * 120,
                  height: heightDp * 40,
                  color: config.AppColors().mainColor(1),
                  borderRadius: heightDp * 6,
                  padding: EdgeInsets.symmetric(horizontal: widthDp! * 5),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Colors.white, fontSize: fontSp * 14),
                  ),
                ),
                SizedBox(width: widthDp * 15),
                KeicyRaisedButton(
                  width: heightDp * 120,
                  height: heightDp * 40,
                  borderRadius: heightDp * 6,
                  color: Colors.white,
                  borderColor: Colors.grey.withOpacity(0.6),
                  borderWidth: 1,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    if (resendOTPCallback != null) resendOTPCallback();
                  },
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(color: Colors.black, fontSize: fontSp * 14),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    // if (result == null && cancelCallback != null) {
    //   cancelCallback();
    // }
  }
}
