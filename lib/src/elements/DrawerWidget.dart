import 'package:delivery_app/src/elements/DrawerFooter.dart';
import 'package:delivery_app/src/pages/AboutUsPage/index.dart';
import 'package:delivery_app/src/pages/ChatListPage/index.dart';
import 'package:delivery_app/src/pages/ContactUsPage/index.dart';
import 'package:delivery_app/src/pages/DashboardPage/index.dart';
import 'package:delivery_app/src/pages/LegalResourcesPage/index.dart';
import 'package:delivery_app/src/pages/MyDeliveryOrderListPage/index.dart';
import 'package:delivery_app/src/pages/NotificationListPage/index.dart';
import 'package:delivery_app/src/pages/ProfilePage/profile_page.dart';
import 'package:delivery_app/src/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/src/elements/keicy_avatar_image.dart';
import 'package:delivery_app/src/providers/index.dart';
import 'package:flutter_logs/flutter_logs.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.1),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
              ),
              accountName: Text(
                AuthProvider.of(context).authState.deliveryUserModel!.firstName! +
                    " " +
                    AuthProvider.of(context).authState.deliveryUserModel!.lastName!,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 20, color: Colors.black),
              ),
              accountEmail: Text(
                AuthProvider.of(context).authState.deliveryUserModel!.email ?? "",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 18, color: Colors.black),
              ),
              currentAccountPicture: AuthProvider.of(context).authState.deliveryUserModel!.id == ""
                  ? Image.asset("img/logo_small.png", height: 150, fit: BoxFit.fitHeight)
                  : CircleAvatar(
                      child: ClipOval(
                        child: KeicyAvatarImage(
                          url: AuthProvider.of(context).authState.deliveryUserModel!.imageUrl,
                          userName: AuthProvider.of(context).authState.deliveryUserModel!.firstName,
                          width: 135,
                          height: 135,
                          backColor: Colors.grey.withOpacity(0.5),
                          textStyle: TextStyle(fontSize: 25, color: Colors.black),
                        ),
                      ),
                      radius: 50.0,
                      // backgroundImage: NetworkImage('https://via.placeholder.com/300'),
                      backgroundColor: Colors.transparent,
                    ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/Pages',
                ModalRoute.withName('/'),
                arguments: {"currentTab": 2},
              );
            },
            leading: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.primary.withOpacity(1),
            ),
            title: Text(
              "Home",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => DashboardPage(haveAppBar: true),
                ),
              );
            },
            leading: Icon(
              Icons.dashboard,
              color: Theme.of(context).colorScheme.primary.withOpacity(1),
            ),
            title: Text(
              "Dashboard",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => MyDeliveryOrderListPage(haveAppBar: true),
                ),
              );
            },
            leading: Icon(
              Icons.fastfood,
              color: Theme.of(context).colorScheme.primary.withOpacity(1),
            ),
            title: Text(
              "My deliveries",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ChatListPage(),
                ),
              );
            },
            leading: Icon(
              Icons.chat,
              color: Theme.of(context).colorScheme.primary.withOpacity(1),
            ),
            title: Text(
              "Chats",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => ProfilePage(haveAppBar: true)),
              );
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.primary.withOpacity(1),
            ),
            title: Text(
              "Profile",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => NotificationListPage(haveAppBar: true)),
              );
            },
            leading: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.primary.withOpacity(1),
            ),
            title: Text(
              "Notifications",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => AboutUsPage()),
              );
            },
            leading: Image.asset(
              "img/aboutus.png",
              width: 25,
              height: 25,
            ),
            title: Text(
              "About us",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => ContactUsPage()),
              );
            },
            leading: Image.asset(
              "img/contactus.png",
              width: 25,
              height: 25,
            ),
            title: Text(
              "Contact us",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LegalResourcesPage()));
            },
            leading: Image.asset(
              "img/lega.png",
              width: 25,
              height: 25,
            ),
            title: Text(
              "Legal Resources",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            onTap: () async {
              // Navigator.of(context).pop();
              try {
                var result = await AuthProvider.of(context).logout(
                  fcmToken: AuthProvider.of(context).authState.deliveryUserModel!.fcmToken,
                  id: AuthProvider.of(context).authState.deliveryUserModel!.id,
                );
                if (result) {
                  _initProviderHandler(context);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (BuildContext context) => LoginWidget()),
                    (route) => false,
                  );
                }
              } catch (e) {
                FlutterLogs.logThis(
                  tag: "DrawerWidget",
                  level: LogLevel.ERROR,
                  subTag: "onTap:LogOut",
                  exception: e is Exception ? e : null,
                  error: e is Error ? e : null,
                  errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
                );
              }
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary.withOpacity(1),
            ),
            title: Text(
              "Log out",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Divider(),
          DrawerFooterWidget(),
        ],
      ),
    );
  }

  void _initProviderHandler(BuildContext context) {
    AuthProvider.of(context).setAuthState(AuthState.init(), isNotifiable: false);
    NotificationProvider.of(context).setNotificationState(NotificationState.init(), isNotifiable: false);
    OrderProvider.of(context).setOrderState(OrderState.init(), isNotifiable: false);
    MyDeliveryOrderProvider.of(context).setMyDeliveryOrderState(MyDeliveryOrderState.init(), isNotifiable: false);
  }
}
