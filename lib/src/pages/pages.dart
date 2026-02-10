import 'package:delivery_app/src/elements/DrawerWidget.dart';
import 'package:delivery_app/src/pages/HomePage/index.dart';
import 'package:delivery_app/src/pages/NotificationListPage/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'DashboardPage/index.dart';
import 'OrderListPage/index.dart';
import 'ProfilePage/index.dart';

class PageWidget extends StatefulWidget {
  int? currentTab = 2;
  String currentTitle = 'Home';
  Widget currentPage = HomePage();
  Map<String, dynamic>? categoryData;

  PageWidget({
    Key? key,
    this.currentTab,
    this.categoryData,
  }) : super(key: key);

  @override
  _PageWidgetState createState() {
    return _PageWidgetState();
  }
}

class _PageWidgetState extends State<PageWidget> {
  @override
  void initState() {
    super.initState();

    _selectTab(widget.currentTab!);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentTitle = 'Orders';
          widget.currentPage = OrderListPage();
          break;
        case 1:
          widget.currentTitle = 'Profile';
          widget.currentPage = ProfilePage();

          break;
        case 2:
          widget.currentTitle = 'Home';
          widget.currentPage = HomePage();
          break;
        case 3:
          widget.currentTitle = 'Notifications';
          widget.currentPage = NotificationListPage();
          break;
        case 4:
          widget.currentTitle = 'Dashboard';
          widget.currentPage = DashboardPage();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          widget.currentTitle,
          style: Theme.of(context).textTheme.titleSmall!.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: widget.currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 22,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedItemColor: Theme.of(context).colorScheme.primary.withOpacity(1),
        currentIndex: widget.currentTab!,
        onTap: (int i) {
          widget.categoryData = null;
          this._selectTab(i);
        },
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
              label: '',
              icon: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    // BoxShadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
                    BoxShadow(color: Theme.of(context).colorScheme.secondary.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
                  ],
                ),
                child: new Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
              )),
          BottomNavigationBarItem(
            icon: new Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.dashboard),
            label: '',
          ),
        ],
      ),
    );
  }
}
