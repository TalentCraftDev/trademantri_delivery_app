import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:delivery_app/src/elements/keicy_text_form_field.dart';
import 'package:delivery_app/src/elements/notification_widget.dart';
import 'package:delivery_app/src/providers/index.dart';
import 'package:delivery_app/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class NotificationListView extends StatefulWidget {
  final bool? haveAppBar;

  NotificationListView({Key? key, this.haveAppBar}) : super(key: key);

  @override
  _NotificationListViewState createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> with SingleTickerProviderStateMixin {
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
  NotificationProvider? _notificationProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  RefreshController? _refreshController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  String status = "ALL";

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

    _notificationProvider = NotificationProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    _notificationProvider!.setNotificationState(
      _notificationProvider!.notificationState.update(
        progressState: 0,
        notificationListData: Map<String, dynamic>(),
        notificationMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _notificationProvider!.addListener(_notificationProviderListener);

      _notificationProvider!.setNotificationState(_notificationProvider!.notificationState.update(progressState: 1));
      _notificationProvider!.getNotificationData(
        deliveryUserId: _authProvider!.authState.deliveryUserModel!.id,
        status: status,
      );
    });
  }

  @override
  void dispose() {
    _notificationProvider!.removeListener(_notificationProviderListener);

    super.dispose();
  }

  void _notificationProviderListener() async {
    if (_notificationProvider!.notificationState.progressState == -1) {
      if (_notificationProvider!.notificationState.isRefresh!) {
        _notificationProvider!.setNotificationState(
          _notificationProvider!.notificationState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_notificationProvider!.notificationState.progressState == 2) {
      if (_notificationProvider!.notificationState.isRefresh!) {
        _notificationProvider!.setNotificationState(
          _notificationProvider!.notificationState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? notificationListData = _notificationProvider!.notificationState.notificationListData;
    Map<String, dynamic>? notificationMetaData = _notificationProvider!.notificationState.notificationMetaData;

    notificationListData![status] = [];
    notificationMetaData![status] = Map<String, dynamic>();
    _notificationProvider!.setNotificationState(
      _notificationProvider!.notificationState.update(
        progressState: 1,
        notificationListData: notificationListData,
        notificationMetaData: notificationMetaData,
        isRefresh: true,
      ),
    );

    _notificationProvider!.getNotificationData(
      deliveryUserId: _authProvider!.authState.deliveryUserModel!.id,
      status: status,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _notificationProvider!.setNotificationState(
      _notificationProvider!.notificationState.update(progressState: 1),
    );
    _notificationProvider!.getNotificationData(
      deliveryUserId: _authProvider!.authState.deliveryUserModel!.id,
      status: status,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyNotificationListHandler() {
    Map<String, dynamic>? notificationListData = _notificationProvider!.notificationState.notificationListData;
    Map<String, dynamic>? notificationMetaData = _notificationProvider!.notificationState.notificationMetaData;

    notificationListData![status] = [];
    notificationMetaData![status] = Map<String, dynamic>();
    _notificationProvider!.setNotificationState(
      _notificationProvider!.notificationState.update(
        progressState: 1,
        notificationListData: notificationListData,
        notificationMetaData: notificationMetaData,
      ),
    );

    _notificationProvider!.getNotificationData(
      deliveryUserId: _authProvider!.authState.deliveryUserModel!.id,
      status: status,
      searchKey: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !widget.haveAppBar!
          ? null
          : AppBar(
              centerTitle: true,
              title: Text(
                "Notifications",
                style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
              ),
              elevation: 0,
            ),
      body: Consumer<NotificationProvider>(builder: (context, notificationProvider, _) {
        if (notificationProvider.notificationState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              _searchField(),
              Expanded(child: _notificationListPanel()),
            ],
          ),
        );
      }),
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: KeicyTextFormField(
        controller: _controller,
        focusNode: _focusNode,
        width: null,
        height: heightDp * 50,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: heightDp * 6,
        contentHorizontalPadding: widthDp * 10,
        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.6)),
        hintText: NotificationListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyNotificationListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyNotificationListHandler();
        },
      ),
    );
  }

  Widget _notificationListPanel() {
    List<dynamic> notificationList = [];
    Map<String, dynamic> notificationMetaData = Map<String, dynamic>();

    if (_notificationProvider!.notificationState.notificationListData![status] != null) {
      notificationList = _notificationProvider!.notificationState.notificationListData![status];
    }
    if (_notificationProvider!.notificationState.notificationMetaData![status] != null) {
      notificationMetaData = _notificationProvider!.notificationState.notificationMetaData![status];
    }

    int itemCount = 0;

    if (_notificationProvider!.notificationState.notificationListData![status] != null) {
      int length = _notificationProvider!.notificationState.notificationListData![status].length;
      itemCount += length;
    }

    if (_notificationProvider!.notificationState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return Column(
      children: [
        Expanded(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowIndicator();
              return true;
            },
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: (notificationMetaData["nextPage"] != null && _notificationProvider!.notificationState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.separated(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  Map<String, dynamic> notificationData = (index >= notificationList.length) ? Map<String, dynamic>() : notificationList[index];

                  // return Container(
                  //   child: Text(notificationData["storeName"] ?? ""),
                  // );
                  return NotificationWidget(
                    notificationData: notificationData,
                    isLoading: notificationData.isEmpty,
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(color: Colors.grey.withOpacity(0.3), height: 5, thickness: 5);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
