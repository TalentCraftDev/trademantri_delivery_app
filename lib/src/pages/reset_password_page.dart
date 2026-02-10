import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/src/dialogs/index.dart';
import 'package:delivery_app/src/elements/BlockButtonWidget.dart';
import 'package:delivery_app/src/elements/keicy_progress_dialog.dart';
import 'package:delivery_app/src/pages/login.dart';
import 'package:delivery_app/src/providers/index.dart';
import 'package:delivery_app/src/helpers/helper.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? email;
  final Function? callback;

  ResetPasswordPage({@required this.email, this.callback});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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

  bool? passwordObscureText;
  bool? confirmObscureText;

  @override
  void initState() {
    super.initState();

    _keicyProgressDialog = KeicyProgressDialog.of(context);
    _authProvider = AuthProvider.of(context);

    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 0, message: "", callback: () {}),
      isNotifiable: false,
    );

    passwordObscureText = true;
    confirmObscureText = true;

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

    if (_authProvider!.authState.progressState == 5) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        callBack: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => LoginWidget(callback: widget.callback),
            ),
          );
        },
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
                        "Reset Password",
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
                              // TextFormField(
                              //   controller: oldPasswordController,
                              //   // onSaved: (input) {
                              //   //   authService.user.password = input;
                              //   // },
                              //   validator: (input) => input.length < 8 ? S.of(context).should_password_input : null,
                              //   obscureText: true,
                              //   keyboardType: TextInputType.text,
                              //   decoration: InputDecoration(
                              //     labelText: "Old Password",
                              //     labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              //     contentPadding: EdgeInsets.all(12),
                              //     hintText: '••••••••••••',
                              //     hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
                              //     prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.secondary),
                              //     // suffixIcon: Icon(Icons.remove_red_eye, color: Theme.of(context).colorScheme.primary),
                              //     border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                              //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5))),
                              //     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                              //   ),
                              // ),
                              // SizedBox(height: 20),
                              TextFormField(
                                controller: newPasswordController,
                                // onSaved: (input) {
                                //   authService.user.password = input;
                                // },
                                validator: (input) => !passwordValidation(input!) || input.length < 8
                                    ? "Password must have 1 letter, 1 digit and must be atleast 8 characters in length"
                                    : newPasswordController.text.trim() != confirmPasswordController.text.trim()
                                        ? "Should match the passwords"
                                        : null,
                                obscureText: passwordObscureText!,
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
                                        passwordObscureText = !passwordObscureText!;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: widthDp * 10),
                                      child: Image.asset(
                                        passwordObscureText! ? "img/show_password.png" : "img/hide-password.png",
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
                                ),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: confirmPasswordController,
                                // onSaved: (input) {
                                //   authService.user.password = input;
                                // },
                                validator: (input) => !passwordValidation(input!) || input.length < 8
                                    ? "Password must have 1 letter, 1 digit and must be atleast 8 characters in length"
                                    : newPasswordController.text.trim() != confirmPasswordController.text.trim()
                                        ? "Should match the passwords"
                                        : null,
                                obscureText: confirmObscureText!,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Confirm Password",
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: '••••••••••••',
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.secondary),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        confirmObscureText = !confirmObscureText!;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: widthDp * 10),
                                      child: Image.asset(
                                        confirmObscureText! ? "img/show_password.png" : "img/hide-password.png",
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

  _onLoginButtonPressed() async {
    if (!loginFormKey.currentState!.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();

    _authProvider!.setAuthState(
      _authProvider!.authState.update(
        progressState: 1,
        callback: () {
          _onLoginButtonPressed();
        },
      ),
      isNotifiable: false,
    );

    _authProvider!.changePassword(
      email: widget.email,
      // oldPassword: oldPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
    );
  }
}
