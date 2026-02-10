import 'package:delivery_app/src/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/config/app_config.dart' as config;
import 'package:delivery_app/src/dialogs/index.dart';
import 'package:delivery_app/src/dialogs/success_dialog.dart';
import 'package:delivery_app/src/elements/BlockButtonWidget.dart';
import 'package:delivery_app/src/elements/keicy_progress_dialog.dart';
import 'package:delivery_app/src/pages/login.dart';
import 'package:delivery_app/src/providers/index.dart';
import 'package:delivery_app/src/services/keicy_fcm_for_mobile.dart';
import 'package:delivery_app/src/helpers/helper.dart';

class SignUpWidget extends StatefulWidget {
  final Function? callback;

  SignUpWidget({this.callback});

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
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

  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> navigatorKey = GlobalKey<ScaffoldState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  DeliveryUserModel _deliveryUserModel = DeliveryUserModel();
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

    if (_authProvider!.authState.progressState == 2 && _authProvider!.authState.loginState == LoginState.IsNotLogin) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Signup Success!\nPlease check your email to verify",
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

  _onSignUpButtonPressed() async {
    if (!signUpFormKey.currentState!.validate()) return;

    signUpFormKey.currentState!.save();

    await _keicyProgressDialog!.show();

    _deliveryUserModel.fcmToken = KeicyFCMForMobile.token;

    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 1, callback: _onSignUpButtonPressed),
      isNotifiable: false,
    );

    _authProvider!.registerDeliveryUser(_deliveryUserModel);
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

    return Scaffold(
      key: navigatorKey,
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
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
                child: Container(
                  width: deviceWidth,
                  height: deviceHeight,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: statusbarHeight),
                        SizedBox(height: heightDp1 * 20),
                        Image.asset("img/logo_small.png", height: heightDp1 * 50, fit: BoxFit.fitHeight, color: Colors.white),
                        SizedBox(height: heightDp1 * 20),
                        Text(
                          'Let\'s Start with register!',
                          style: Theme.of(context).textTheme.headlineMedium!.merge(TextStyle(color: Theme.of(context).colorScheme.primary)),
                        ),
                        SizedBox(height: heightDp1 * 20),
                        Container(
                          width: deviceWidth * 0.88,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [BoxShadow(blurRadius: 50, color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.2))],
                          ),
                          margin: EdgeInsets.symmetric(horizontal: widthDp * 20),
                          padding: EdgeInsets.symmetric(vertical: heightDp1 * 20, horizontal: widthDp * 20),
                          child: Form(
                            key: signUpFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: firstNameController,
                                  focusNode: _firstNameFocusNode,
                                  validator: (input) => input!.length < 1 ? "Input first name" : null,
                                  decoration: InputDecoration(
                                    labelText: "First Name",
                                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.person_rounded, color: Theme.of(context).colorScheme.secondary),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                                  ),
                                  onSaved: (input) => _deliveryUserModel.firstName = input!.trim(),
                                  onFieldSubmitted: (input) {
                                    FocusScope.of(context).requestFocus(_lastNameFocusNode);
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: lastNameController,
                                  focusNode: _lastNameFocusNode,
                                  validator: (input) => input!.length < 1 ? "Input last name" : null,
                                  decoration: InputDecoration(
                                    labelText: "Last Name",
                                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).colorScheme.secondary),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                                  ),
                                  onSaved: (input) => _deliveryUserModel.lastName = input!.trim(),
                                  onFieldSubmitted: (input) {
                                    FocusScope.of(context).requestFocus(_emailFocusNode);
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  focusNode: _emailFocusNode,
                                  validator: (input) => !input!.contains('@') ? "Should be a valid email" : null,
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
                                  onSaved: (input) => _deliveryUserModel.email = input!.trim(),
                                  onFieldSubmitted: (input) {
                                    FocusScope.of(context).requestFocus(_phoneFocusNode);
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: phoneController,
                                  focusNode: _phoneFocusNode,
                                  validator: (input) => input!.length != 10 ? "Should be 10 numbers" : null,
                                  decoration: InputDecoration(
                                    labelText: "Phone Number",
                                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.phone_android_outlined, color: Theme.of(context).colorScheme.secondary),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
                                  ),
                                  onSaved: (input) => _deliveryUserModel.mobile = input!.trim(),
                                  onFieldSubmitted: (input) {
                                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: passwordController,
                                  focusNode: _passwordFocusNode,
                                  validator: (input) => !passwordValidation(input!) || input.length < 8
                                      ? "Password must have 1 letter, 1 digit and must be atleast 8 characters in length"
                                      : passwordController.text.trim() != confirmPasswordController.text.trim()
                                          ? "Should match the passwords"
                                          : null,
                                  obscureText: passwordObscureText!,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '••••••••••••',
                                    errorMaxLines: 2,
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
                                  onSaved: (input) => _deliveryUserModel.password = input!.trim(),
                                  onFieldSubmitted: (input) {
                                    FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: confirmPasswordController,
                                  focusNode: _confirmPasswordFocusNode,
                                  validator: (input) => !passwordValidation(input!) || input.length < 8
                                      ? "Password must have 1 letter, 1 digit and must be atleast 8 characters in length"
                                      : passwordController.text.trim() != confirmPasswordController.text.trim()
                                          ? "Should match the passwords"
                                          : null,
                                  obscureText: confirmObscureText!,
                                  decoration: InputDecoration(
                                    labelText: "Confirm Password",
                                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '••••••••••••',
                                    errorMaxLines: 2,
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
                                  onSaved: (input) => _deliveryUserModel.password = input!.trim(),
                                  onFieldSubmitted: (input) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                  },
                                ),
                                SizedBox(height: 30),
                                BlockButtonWidget(
                                  text: Text(
                                    "Register",
                                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                  ),
                                  color: Theme.of(context).colorScheme.secondary,
                                  onPressed: () {
                                    _onSignUpButtonPressed();
                                  },
                                ),
                                SizedBox(height: 10),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => LoginWidget(callback: widget.callback),
                                      ),
                                    );
                                  },
                                  child: Text('I have account? Back to login'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 10,
              //   child: TextButton(
              //     onPressed: () {
              //       Navigator.of(context).pushReplacement(
              //         MaterialPageRoute(
              //           builder: (BuildContext context) => LoginWidget(callback: widget.callback),
              //         ),
              //       );
              //     },
              //     textColor: Theme.of(context).colorScheme.onSurfaceVariant,
              //     child: Text('I have account? Back to login'),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
