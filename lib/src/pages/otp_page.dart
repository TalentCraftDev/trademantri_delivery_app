import 'package:delivery_app/src/helpers/helper.dart';
import 'package:delivery_app/src/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/config/app_config.dart' as config;
import 'package:delivery_app/src/dialogs/index.dart';
import 'package:delivery_app/src/elements/BlockButtonWidget.dart';
import 'package:delivery_app/src/elements/keicy_progress_dialog.dart';
import 'package:delivery_app/src/helpers/validators.dart';
import 'package:delivery_app/src/pages/forgot.dart';
import 'package:delivery_app/src/pages/reset_password_page.dart';
import 'package:delivery_app/src/providers/index.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPPage extends StatefulWidget {
  final String? email;
  final Function? callback;

  OTPPage({@required this.email, this.callback});

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordConfirmationController = TextEditingController();
  bool? obscureText;
  bool? obscureConfirmationText;

  KeicyProgressDialog? _keicyProgressDialog;
  AuthProvider? _authProvider;

  @override
  void initState() {
    super.initState();

    _keicyProgressDialog = KeicyProgressDialog.of(context);
    _authProvider = AuthProvider.of(context);

    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 0, message: "", callback: () {}),
      isNotifiable: false,
    );

    obscureText = true;
    obscureConfirmationText = true;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _authProvider!.addListener(_authProviderListener);
    });
  }

  @override
  void dispose() {
    _authProvider!.removeListener(_authProviderListener);
    super.dispose();
  }

  void _authProviderListener() async {
    if (_authProvider!.authState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_authProvider!.authState.progressState == 4) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginWidget(),
        ),
      );
      Fluttertoast.showToast(
        msg: "Password reset successfully.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 13.0,
      );
    } else if (_authProvider!.authState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _authProvider!.authState.message!,
        callBack: () {
          otpController.clear();
        },
        isTryButton: false,
      );
    }
  }

  _onLoginButtonPressed() async {
    if (!loginFormKey.currentState!.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();
    _authProvider!.verifyOTP(
      otp: int.parse(otpController.text.trim()),
      newPassword: newPasswordController.text.trim(),
      newPasswordConfirmation: newPasswordConfirmationController.text.trim(),
      email: widget.email,
    );
  }

  @override
  Widget build(BuildContext context) {
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

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => ForgotWidget(callback: widget.callback),
          ),
        );
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        body: Container(
          width: deviceWidth,
          height: deviceHeight,
          child: SingleChildScrollView(
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Container(width: deviceWidth, height: deviceHeight),
                Positioned(
                  top: 0,
                  child: Container(
                    width: deviceWidth,
                    height: heightDp1 * 250,
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Column(
                    children: [
                      SizedBox(height: statusbarHeight),
                      SizedBox(height: heightDp1 * 20),
                      Image.asset("img/logo_small.png", height: heightDp1 * 50, fit: BoxFit.fitHeight, color: Colors.white),
                      SizedBox(height: heightDp1 * 20),
                      Text(
                        "Email Verification OTP",
                        style: Theme.of(context).textTheme.headlineMedium!.merge(TextStyle(color: Theme.of(context).colorScheme.primary)),
                      ),
                      SizedBox(height: heightDp1 * 20),
                      Container(
                        width: deviceWidth * 0.88,
                        margin: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        padding: EdgeInsets.symmetric(vertical: heightDp1 * 30, horizontal: widthDp * 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [BoxShadow(blurRadius: 50, color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.2))],
                        ),
                        child: Form(
                          key: loginFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              PinCodeTextField(
                                length: 6,
                                keyboardType: TextInputType.number,
                                textStyle: TextStyle(fontSize: fontSp * 28, color: Colors.black),
                                pastedTextStyle: TextStyle(fontSize: fontSp * 28, color: Colors.black),
                                enablePinAutofill: false,
                                enableActiveFill: true,
                                autoDismissKeyboard: false,
                                autoFocus: true,
                                animationType: AnimationType.fade,
                                readOnly: false,
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
                                controller: otpController,
                                onCompleted: (v) {},
                                onChanged: (value) {},
                                beforeTextPaste: (text) {
                                  return true;
                                },
                                appContext: context,
                                validator: (value) => value!.length != 6 ? "Please enter 6 digits" : null,
                              ),
                              SizedBox(height: 30),
                              TextFormField(
                                controller: newPasswordController,
                                // onSaved: (input) {
                                //   authService.user.password = input;
                                // },
                                validator: (input) => !passwordValidation(input!) || input.length < 8
                                    ? "Password must have 1 letter, 1 digit and must be atleast 8 characters in length"
                                    : null,
                                obscureText: obscureText!,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "New Password",
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: '••••••••••••',
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.secondary),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        obscureText = !obscureText!;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: widthDp * 10),
                                      child: Image.asset(
                                        obscureText! ? "img/show_password.png" : "img/hide-password.png",
                                        width: heightDp * 20 / 3 * 4,
                                        height: heightDp * 20,
                                        fit: BoxFit.cover,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  suffixIconConstraints: BoxConstraints(
                                    maxWidth: heightDp * 20 / 3 * 4 + widthDp * 10,
                                    maxHeight: heightDp * 20,
                                  ),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5))),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                                  errorMaxLines: 2,
                                ),
                              ),
                              SizedBox(height: 30),
                              TextFormField(
                                controller: newPasswordConfirmationController,
                                // onSaved: (input) {
                                //   authService.user.password = input;
                                // },
                                validator: (input) => !passwordValidation(input!) || input.length < 8
                                    ? "Password must have 1 letter, 1 digit and must be atleast 8 characters in length"
                                    : null,
                                obscureText: obscureConfirmationText!,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "New Password Confirmation",
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: '••••••••••••',
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.secondary),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        obscureConfirmationText = !obscureConfirmationText!;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: widthDp * 10),
                                      child: Image.asset(
                                        obscureText! ? "img/show_password.png" : "img/hide-password.png",
                                        width: heightDp * 20 / 3 * 4,
                                        height: heightDp * 20,
                                        fit: BoxFit.cover,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  suffixIconConstraints: BoxConstraints(
                                    maxWidth: heightDp * 20 / 3 * 4 + widthDp * 10,
                                    maxHeight: heightDp * 20,
                                  ),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5))),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                                  errorMaxLines: 2,
                                ),
                              ),
                              SizedBox(height: 30),
                              SizedBox(height: 30),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                onPressed: () async {
                                  await _keicyProgressDialog!.show();
                                  _authProvider!.forgotPassword(email: widget.email);
                                },
                                child: Text("Resend"),
                              ),
                              BlockButtonWidget(
                                text: Text(
                                  "Send",
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                ),
                                color: Theme.of(context).colorScheme.secondary,
                                onPressed: () {
                                  _onLoginButtonPressed();
                                },
                              ),
                              SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: statusbarHeight + heightDp * 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => ForgotWidget(callback: widget.callback),
                        ),
                      );
                    },
                    child: Container(
                      width: deviceWidth,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: widthDp * 20),
                          Icon(Icons.arrow_back, size: heightDp * 30, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
