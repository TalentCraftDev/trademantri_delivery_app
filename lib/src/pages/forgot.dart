import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/config/app_config.dart' as config;
import 'package:delivery_app/src/dialogs/index.dart';
import 'package:delivery_app/src/elements/keicy_progress_dialog.dart';
import 'package:delivery_app/src/helpers/validators.dart';
import 'package:delivery_app/src/pages/login.dart';
import 'package:delivery_app/src/pages/otp_page.dart';
import 'package:delivery_app/src/providers/index.dart';

class ForgotWidget extends StatefulWidget {
  final Function? callback;

  ForgotWidget({this.callback});

  @override
  _ForgotWidgetState createState() => _ForgotWidgetState();
}

class _ForgotWidgetState extends State<ForgotWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

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

    if (_authProvider!.authState.progressState == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => OTPPage(
            email: emailController.text.trim(),
            callback: widget.callback!,
          ),
        ),
      );
    } else if (_authProvider!.authState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _authProvider!.authState.message!,
        callBack: _authProvider!.authState.callback,
        cancelCallback: () {
          _authProvider!.setAuthState(
            _authProvider!.authState.update(callback: () {}),
            isNotifiable: false,
          );
        },
      );
    }
  }

  _onForgotButtonPressed() async {
    if (!loginFormKey.currentState!.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();
    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 1, callback: _onForgotButtonPressed),
      isNotifiable: false,
    );
    _authProvider!.forgotPassword(email: emailController.text.trim());
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
            builder: (BuildContext context) => LoginWidget(callback: widget.callback),
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
                        "Forgot password ?",
                        style: Theme.of(context).textTheme.headlineMedium!.merge(TextStyle(color: Theme.of(context).colorScheme.primary)),
                      ),
                      SizedBox(height: heightDp1 * 20),
                      Container(
                        width: deviceWidth * 0.88,
                        margin: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        padding: EdgeInsets.symmetric(vertical: heightDp1 * 30, horizontal: widthDp * 20),
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
                              TextFormField(
                                controller: emailController,
                                // onSaved: (input) =>  authService.user.email  = input,
                                validator: (input) => !KeicyValidators.isValidEmail(input!) ? "Should be a valid email" : null,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: '',
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).colorScheme.secondary),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5))),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                                ),
                              ),
                              SizedBox(height: 30),
                              SizedBox(height: 30),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () {
                                  _onForgotButtonPressed();
                                },
                                child: Text(
                                  "Send OTP",
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                ),
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
                          builder: (BuildContext context) => LoginWidget(callback: widget.callback),
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
