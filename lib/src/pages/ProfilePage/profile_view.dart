import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/config/config.dart';
import 'package:delivery_app/src/dialogs/index.dart';
import 'package:delivery_app/src/elements/keicy_avatar_image.dart';
import 'package:delivery_app/src/elements/keicy_progress_dialog.dart';
import 'package:delivery_app/src/elements/keicy_raised_button.dart';
import 'package:delivery_app/src/models/index.dart';
import 'package:delivery_app/src/pages/MyDeliveryOrderListPage/index.dart';
import 'package:delivery_app/src/providers/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/src/dialogs/index.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/config/app_config.dart' as config;
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'index.dart';

class ProfileView extends StatefulWidget {
  final bool? haveAppBar;

  ProfileView({Key? key, this.haveAppBar}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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

  AuthProvider? _authProvider;
  File? _imageFile;
  KeicyProgressDialog? _keicyProgressDialog;
  DeliveryUserModel? _deliveryUserModel;

  final picker = ImagePicker();

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

    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

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
    super.dispose();
  }

  void _authProviderListener() async {
    if (_authProvider!.authState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_authProvider!.authState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _authProvider!.authState.message!,
        callBack: _authProvider!.authState.errorCode == 500 ? _authProvider!.authState.callback : () {},
        isTryButton: _authProvider!.authState.errorCode == 500,
        cancelCallback: () {
          _authProvider!.setAuthState(
            _authProvider!.authState.update(callback: () {}),
            isNotifiable: false,
          );
        },
      );
      _authProvider!.setAuthState(
        _authProvider!.authState.update(progressState: 0, message: ""),
        isNotifiable: false,
      );
    } else if (_authProvider!.authState.progressState == 2) {
      _deliveryUserModel = DeliveryUserModel.copy(_authProvider!.authState.deliveryUserModel!);
      _authProvider!.setAuthState(
        _authProvider!.authState.update(progressState: 0, message: "", callback: () {}),
        isNotifiable: false,
      );
    }
  }

  void _updateUser(DeliveryUserModel deliveryUserModel, {File? imageFile}) async {
    await _keicyProgressDialog!.show();
    _authProvider!.setAuthState(
      _authProvider!.authState.update(
        progressState: 1,
        callback: () {
          _updateUser(deliveryUserModel, imageFile: imageFile);
        },
      ),
      isNotifiable: false,
    );
    await _authProvider!.updateUser(deliveryUserModel, imageFile: imageFile);
  }

  void _changePasswordHandler(String oldPassword, String newPassword) async {
    await _keicyProgressDialog!.show();
    _authProvider!.setAuthState(
      _authProvider!.authState.update(
        progressState: 1,
        callback: () {
          _changePasswordHandler(oldPassword, newPassword);
        },
      ),
      isNotifiable: false,
    );
    _authProvider!.changePassword(email: _deliveryUserModel!.email, oldPassword: oldPassword, newPassword: newPassword);
  }

  bool _checkAddContactAvailable() {
    var contactsInfo = AuthProvider.of(context).prefs!.getString("contactsInfo") == null
        ? null
        : json.decode(AuthProvider.of(context).prefs!.getString("contactsInfo")!);

    if (contactsInfo == null) {
      AuthProvider.of(context).prefs!.setString(
            "contactsInfo",
            json.encode({
              "date": DateTime.now().millisecondsSinceEpoch,
              "count": 0,
            }),
          );
      return true;
    }
    if (DateTime.fromMillisecondsSinceEpoch(contactsInfo["date"]).year == DateTime.now().year &&
        DateTime.fromMillisecondsSinceEpoch(contactsInfo["date"]).month == DateTime.now().month &&
        DateTime.fromMillisecondsSinceEpoch(contactsInfo["date"]).day == DateTime.now().day) {
      if (contactsInfo["count"] >= AppConfig.supportRepeatCount) {
        return false;
      } else {
        return true;
      }
    } else {
      AuthProvider.of(context).prefs!.setString(
            "contactsInfo",
            json.encode({
              "date": DateTime.now().millisecondsSinceEpoch,
              "count": 0,
            }),
          );
      return true;
    }
  }

  void _addContact(ContactModel contactModel) async {
    await _keicyProgressDialog!.show();
    _authProvider!.setAuthState(
      _authProvider!.authState.update(
        progressState: 1,
        callback: () {
          _addContact(contactModel);
        },
      ),
      isNotifiable: false,
    );
    var result = await _authProvider!.addContact(contactModel: contactModel);

    if (result) {
      var contactsInfo = AuthProvider.of(context).prefs!.getString("contactsInfo") == null
          ? null
          : json.decode(AuthProvider.of(context).prefs!.getString("contactsInfo")!);
      AuthProvider.of(context).prefs!.setString(
            "contactsInfo",
            json.encode({
              "date": DateTime.now().millisecondsSinceEpoch,
              "count": contactsInfo["count"] + 1,
            }),
          );
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: heightDp,
        text: "Thanks for contacting us\nour help desk team will contact you.",
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !widget.haveAppBar!
          ? null
          : AppBar(
              centerTitle: true,
              title: Text(
                "My Deliveries",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              ),
              elevation: 0,
            ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          _deliveryUserModel = DeliveryUserModel.copy(authProvider.authState.deliveryUserModel!);

          return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 15),
              child: Container(
                width: deviceWidth,
                child: Column(
                  children: [
                    _userInfo(),
                    SizedBox(height: heightDp * 15),
                    // _panel1(),
                    // SizedBox(height: heightDp * 15),
                    _orderPanel(),
                    SizedBox(height: heightDp * 15),
                    _profileSettingPanel(),
                    SizedBox(height: heightDp * 15),
                    _accountSettingPanel(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _userInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            GestureDetector(
              onTap: () {
                _selectOptionBottomSheet();
              },
              child: Stack(
                children: [
                  KeicyAvatarImage(
                    url: _deliveryUserModel!.imageUrl,
                    userName: _deliveryUserModel!.firstName,
                    imageFile: _imageFile,
                    width: heightDp * 70,
                    height: heightDp * 70,
                    backColor: Colors.grey.withOpacity(0.5),
                    textStyle: TextStyle(fontSize: fontSp * 25, color: Colors.black),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(
                      Icons.photo_camera,
                      size: heightDp * 25,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: widthDp * 20),
            Column(
              children: <Widget>[
                Text(
                  "${_deliveryUserModel!.firstName} ${_deliveryUserModel!.lastName}",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  "${_deliveryUserModel!.email}",
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ],
        ),
        _imageFile == null
            ? SizedBox()
            : KeicyRaisedButton(
                width: widthDp * 80,
                height: heightDp * 30,
                borderRadius: heightDp * 6,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                ),
                onPressed: () {
                  _updateUser(DeliveryUserModel.copy(_deliveryUserModel!), imageFile: _imageFile);
                },
              ),
      ],
    );
  }

  void _selectOptionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              Container(
                child: Container(
                  padding: EdgeInsets.all(heightDp * 8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: deviceWidth,
                        padding: EdgeInsets.all(heightDp * 10.0),
                        child: Text(
                          "Choose Option",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _getAvatarImage(ImageSource.camera);
                        },
                        child: Container(
                          width: deviceWidth,
                          padding: EdgeInsets.all(heightDp * 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                color: Colors.black.withOpacity(0.7),
                                size: heightDp * 25.0,
                              ),
                              SizedBox(width: widthDp * 10.0),
                              Text(
                                "From Camera",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _getAvatarImage(ImageSource.gallery);
                        },
                        child: Container(
                          width: deviceWidth,
                          padding: EdgeInsets.all(heightDp * 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.photo, color: Colors.black.withOpacity(0.7), size: heightDp * 25),
                              SizedBox(width: widthDp * 10.0),
                              Text(
                                "From Gallery",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future _getAvatarImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, maxWidth: 500, maxHeight: 500);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      FlutterLogs.logInfo(
        "profile_view",
        "_getAvatarImage",
        "No image selected.",
      );
    }
  }

  Widget _panel1() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: widthDp * 20, horizontal: heightDp * 10),
              ),
              onPressed: () {},
              child: Row(
                children: <Widget>[
                  Icon(Icons.chat, color: Colors.black, size: heightDp * 25),
                  SizedBox(width: widthDp * 15),
                  Text(
                    'Messages',
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.fastfood, color: Colors.black, size: heightDp * 25),
            title: Text(
              'My Deliveries',
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            ),
            trailing: ButtonTheme(
              padding: EdgeInsets.all(0),
              minWidth: 50.0,
              height: 25.0,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MyDeliveryOrderListPage(haveAppBar: true)));
                },
                child: Text(
                  "View all",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileSettingPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Profile Settings',
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            ),
            trailing: ButtonTheme(
              padding: EdgeInsets.all(0),
              minWidth: 50.0,
              height: 25.0,
              child: ProfileSettingsDialog(
                userModel: DeliveryUserModel.copy(_deliveryUserModel!),
                onChanged: (DeliveryUserModel deliveryUserModel) {
                  _updateUser(deliveryUserModel);
                },
              ),
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'First Name',
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
            trailing: Text(
              _deliveryUserModel!.firstName!,
              style: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'Last Name',
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
            trailing: Text(
              _deliveryUserModel!.lastName!,
              style: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'PhoneNumber',
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
            trailing: Text(
              _deliveryUserModel!.mobile!,
              style: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountSettingPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Account Settings',
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {},
            dense: true,
            title: Text(
              'Notification',
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
            trailing: Switch(
              value: _deliveryUserModel!.isNotifiable!,
              onChanged: (value) {
                setState(() {
                  _deliveryUserModel!.isNotifiable = value;
                });
                _updateUser(_deliveryUserModel!);
              },
            ),
          ),
          ListTile(
            onTap: () {
              ChangePasswordDialog.show(context, callback: _changePasswordHandler);
            },
            dense: true,
            title: Text(
              'Change Password',
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
            trailing: Text(
              'Change',
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {
              if (_checkAddContactAvailable()) {
                ContactDialog.show(context, _deliveryUserModel!, callback: _addContact);
              } else {
                ErrorDialog.show(
                  context,
                  heightDp: heightDp,
                  fontSp: fontSp,
                  text: 'You can\'t contact to support.\nPlease try tomorrow.',
                  widthDp: widthDp,
                  callBack: null,
                  isTryButton: false,
                );
              }
            },
            dense: true,
            title: Row(
              children: <Widget>[
                Icon(Icons.info, size: heightDp * 22, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: 10),
                Text(
                  'Help & Support',
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: heightDp * 16, color: Theme.of(context).colorScheme.primary),
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }
}
