import 'package:delivery_app/src/elements/BlockButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/config/app_config.dart' as config;
import 'package:delivery_app/src/dialogs/index.dart';
import 'package:delivery_app/src/elements/keicy_progress_dialog.dart';
import 'package:delivery_app/src/helpers/validators.dart';
import 'package:delivery_app/src/pages/forgot.dart';
import 'package:delivery_app/src/pages/signup.dart';
import 'package:delivery_app/src/providers/index.dart';
import 'package:delivery_app/src/helpers/helper.dart';

class LoginWidget extends StatefulWidget {
  final Function? callback;

  LoginWidget({this.callback});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
  bool? obscureText;

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

    _keicyProgressDialog = KeicyProgressDialog(
      context,
      message: "Hang on!\nAwesomeness is Loading...",
    );
    _authProvider = AuthProvider.of(context);

    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 0, message: "", callback: () {}),
      isNotifiable: false,
    );

    obscureText = true;

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

    if (_authProvider!.authState.progressState == 2 && _authProvider!.authState.loginState == LoginState.IsLogin) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        callBack: () async {
          Navigator.of(context).pushNamedAndRemoveUntil('/Pages', (route) => false, arguments: {"currentTab": 2});
        },
      );
    } else if (_authProvider!.authState.progressState == -1) {
      if (_authProvider!.authState.errorCode == 402) {
        VerifyFailedDialog.show(
          context,
          heightDp: heightDp,
          fontSp: fontSp,
          text: _authProvider!.authState.message!,
          callBack: () async {
            await _keicyProgressDialog!.show();
            _authProvider!.resendVerifyLink(email: emailController.text.trim(), password: passwordController.text.trim());
          },
        );
      } else {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: _authProvider!.authState.message!,
          isTryButton: _authProvider!.authState.errorCode == 500,
          callBack: _authProvider!.authState.errorCode != 500
              ? () {
                  _authProvider!.setAuthState(
                    _authProvider!.authState.update(callback: () {}),
                    isNotifiable: false,
                  );
                }
              : _authProvider!.authState.callback,
          cancelCallback: () {
            _authProvider!.setAuthState(
              _authProvider!.authState.update(callback: () {}),
              isNotifiable: false,
            );
          },
        );
      }
    }
  }

  _onLoginButtonPressed() async {
    if (!loginFormKey.currentState!.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();
    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 1, callback: _onLoginButtonPressed),
      isNotifiable: false,
    );
    _authProvider!.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    ///////////////////////////////

    return Scaffold(
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
                      'Let\'s Start with Login!',
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
                              validator: (input) =>
                                  !((double.tryParse(input!.trim()) != null && input.trim().length == 10) || KeicyValidators.isValidEmail(input))
                                      ? "Should be a valid email or 10 digits phone number"
                                      : null,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                contentPadding: EdgeInsets.all(12),
                                hintText: '',
                                hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
                                prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).colorScheme.secondary),
                                border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: passwordController,
                              // onSaved: (input) {
                              //   authService.user.password = input;
                              // },
                              validator: (input) => !passwordValidation(input!) || input.length < 8
                                  ? "Password must have 1 letter, 1 digit and must be atleast 8 characters in length"
                                  : null,
                              obscureText: obscureText!,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Password",
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
                            BlockButtonWidget(
                              text: Text(
                                'Login',
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
                bottom: 10,
                child: Column(
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ForgotWidget(callback: widget.callback),
                          ),
                        );
                      },
                      child: Text('I forgot password ?'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) => SignUpWidget(callback: widget.callback),
                          ),
                        );
                      },
                      child: Text('I don\'t have an account?'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
