import 'package:delivery_app/src/elements/keicy_raised_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/config/app_config.dart' as config;

class ErrorDialog {
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
    String text = "Failed!",
    bool barrierDismissible = false,
    Function? callBack,
    Function? cancelCallback,
    int delaySecondes = 2,
    bool isTryButton = false,
  }) async {
    isTryButton = false;

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
            Icon(Icons.error_outline, size: heightDp * 60, color: Colors.redAccent),
            SizedBox(height: heightDp * 20),
            Text(
              text,
              style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: heightDp * 20),
            isTryButton
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      KeicyRaisedButton(
                        width: heightDp * 100,
                        height: heightDp * 40,
                        color: config.AppColors().mainColor(1),
                        borderRadius: heightDp * 6,
                        padding: EdgeInsets.symmetric(horizontal: widthDp! * 5),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          // if (callBack != null) {
                          //   callBack();
                          // }
                        },
                        child: Text(
                          'Try again',
                          style: TextStyle(color: Colors.white, fontSize: fontSp * 14),
                        ),
                      ),
                      SizedBox(width: widthDp * 15),
                      KeicyRaisedButton(
                        width: heightDp * 100,
                        height: heightDp * 40,
                        borderRadius: heightDp * 6,
                        color: Colors.white,
                        borderColor: Colors.grey.withOpacity(0.6),
                        borderWidth: 1,
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black, fontSize: fontSp * 14),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KeicyRaisedButton(
                        width: heightDp * 100,
                        height: heightDp * 40,
                        borderRadius: heightDp * 6,
                        color: config.AppColors().mainColor(1),
                        // borderColor: Colors.grey.withOpacity(0.6),
                        borderWidth: 1,
                        onPressed: () {
                          Navigator.of(context).pop();
                          // if (callBack != null) {
                          //   callBack();
                          // }
                        },
                        child: Text(
                          'Ok',
                          style: TextStyle(color: Colors.white, fontSize: fontSp * 14),
                        ),
                      ),
                    ],
                  ),
          ],
        );
      },
    );

    if (result == null && cancelCallback != null) {
      cancelCallback();
    }
  }
}
