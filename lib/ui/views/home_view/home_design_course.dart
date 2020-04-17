import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:creativesapp/core/enums/connectivity_status.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/category.dart';
import 'package:creativesapp/core/services/alarmManager.dart';
import 'package:creativesapp/core/viewmodels/all_courses_model.dart';
import 'package:creativesapp/core/viewmodels/home_model.dart';
import 'package:creativesapp/ui/Themes/design_course_app_theme.dart';
import 'package:creativesapp/ui/themes/HexColor.dart';
import 'package:creativesapp/ui/views/home_view/category_list_view.dart';
import 'package:creativesapp/ui/views/home_view/popular_course_list_view.dart';
import 'package:creativesapp/ui/widgets/app_bar.dart';
import 'package:creativesapp/ui/widgets/connect_model.dart';
import 'package:creativesapp/ui/widgets/custom_drawer.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../all_courses.dart';
import '../base_view.dart';

class DesignCourseHomeScreen extends StatefulWidget {
  @override
  _DesignCourseHomeScreenState createState() => _DesignCourseHomeScreenState();
}

class _DesignCourseHomeScreenState extends State<DesignCourseHomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controller = new TextEditingController();

  HomeModel _model;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;
  NotificationManager notificationManager;
  @override
  void initState() {
    super.initState();
    _fcm.subscribeToTopic('all');

    _fcm.getToken().then((token) {
//      print(token);
    });

    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
//        _saveDeviceToken();
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
//      _saveDeviceToken();
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('message recieved');
        print("$message");
        _showDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch');
        print("$message");
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume');
        print(" $message");
      },
    );

     notificationManager = new NotificationManager();
    notificationManager.initNotificationManager();

  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (connectionStatus == ConnectivityStatus.Offline) {
      SnackBarConnection(_scaffoldKey);
    }

    final double right = MediaQuery.of(context).size.width * 0.65;

    int screenWidth = MediaQuery.of(context).size.width.floor();
    // 411

    return BaseView<HomeModel>(
      onModelReady: (model) {
        model.getCategories();
        model.getCourses();
        model.getCoaches();

        _model = model;
        show();
      },
      builder: (context, model, child) => Container(
        color: DesignCourseAppTheme.nearlyWhite,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: DrawerWidget(),
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              AppBarUI(scaffoldKey: _scaffoldKey),
              Expanded(
                child: LiquidPullToRefresh(
                  color: DesignCourseAppTheme.nearlyBlue,
                  onRefresh: _handleRefresh,
                  showChildOpacityTransition: false,
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: <Widget>[
                              getSearchBarUI(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: (screenWidth > 400 ? 0 : 18.0),
                                        top: 8.0,
                                        bottom: 8.0,
                                        right: right),
                                    child: Text(
                                      'Categories',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                        letterSpacing: 0.27,
                                        color: DesignCourseAppTheme.darkerText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              (model.state == ViewState.Idle &&
                                      model.categories != null)
                                  ? getCategoryBtn(model.categories)
                                  : CircularProgressIndicator(),
                              getCategoryUI(),
                              Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 17.0,
                                          top: 0.0,
                                          bottom: 0.0,
                                          right: 10.0),
                                      child: Text(
                                        'Popular Courses',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          letterSpacing: 0.27,
                                          color:
                                              DesignCourseAppTheme.darkerText,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color:
                                              DesignCourseAppTheme.nearlyWhite,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(24.0)),
                                          border: Border.all(
                                              color: DesignCourseAppTheme
                                                  .nearlyBlue)),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor: Colors.white24,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(24.0)),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllCourses(
                                                          courseName: '',
                                                          categoryList: _model
                                                              .categories)),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12,
                                                bottom: 12,
                                                left: 18,
                                                right: 18),
                                            child: Center(
                                              child: Text(
                                                'All Courses',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  letterSpacing: 0.27,
                                                  color: DesignCourseAppTheme
                                                      .nearlyBlue,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: getPopularCourseUI(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 18, right: 16),
          child: Text(
            'Coaches',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
        ),
//        const SizedBox(
//          height: 16,
//        ),
        CategoryListView(
          callBack: () {
//            moveTo();
          },
          model: _model,
        ),
      ],
    );
  }

  Widget getCategoryBtn(List<Category> categoryListApi) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: SizedBox(
        height: 50.0,
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categoryListApi.length,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              children: <Widget>[
                getCategoryBtn2(categoryListApi[index].name,
                    categoryListApi[index].id, categoryListApi),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getPopularCourseUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: PopularCourseListView(
              callBack: () {},
              model: _model,
            ),
          )
        ],
      ),
    );
  }

  Widget getButtonUI(String categoryTypeData) {
    String txt = categoryTypeData;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: DesignCourseAppTheme.nearlyBlue,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: DesignCourseAppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.nearlyWhite,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCategoryBtn2(String text, int id, List<Category> categoryListApi) {
    return Container(
      decoration: BoxDecoration(
          color: DesignCourseAppTheme.nearlyBlue,
//                ? DesignCourseAppTheme.nearlyBlue
//                : DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          border: Border.all(color: DesignCourseAppTheme.nearlyBlue)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white24,
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AllCourses(
                      category_id: id, categoryList: categoryListApi)),
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.nearlyWhite,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor('#F8FAFB'),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          onFieldSubmitted: (v) {
                            if (v != '') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllCourses(
                                        courseName: _controller.text,
                                        categoryList: _model.categories)),
                              );
                            }

                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          controller: _controller,
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: DesignCourseAppTheme.nearlyBlue,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Search for course',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: HexColor('#B9BABC'),
                            ),
                            border: InputBorder.none,
                          ),
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        icon: Icon(Icons.search),
                        color: HexColor('#B9BABC'),
                        onPressed: () {
                          if (_controller.text != '') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllCourses(
                                      courseName: _controller.text,
                                      categoryList: _model.categories)),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    _model.getCategories();
    _model.getCoaches();
    _model.getCourses();
  }

  Future<void> _showDialog(Map<String, dynamic> message) async {
    print(message.toString());

    var fetchedMessage;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('ios = ${iosInfo.identifierForVendor}');
      if (Platform.isIOS &&
          int.parse(iosInfo.systemVersion.split('.')[0]) < 13) {
        fetchedMessage = message['aps']['alert'];
      }
    } else {
      fetchedMessage = message['notification'];
    }

    notificationManager.showNotificationWithDefaultSound(fetchedMessage['title'], fetchedMessage['body']);

    showOverlayNotification((context) {

      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: SafeArea(
          child: ListTile(
            leading: SizedBox.fromSize(
                size: const Size(45, 45),
                child: ClipOval(
                    child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image:
                          new AssetImage('assets/design_course/logo-png.png'),
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.circle,
                  ),
                ))),
            title: Text(fetchedMessage['title']),
            subtitle: Text(fetchedMessage['body']),
          ),
        ),
      );
    }, duration: Duration(milliseconds: 4000));
  }

  Future<void> show() async {

    if (_model != null) {
      String msg = await _model.checkUpdates();
      if (msg != 'ok' && msg != null) {
        showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            String title = "New Update Available";
            String message =
                "There is a newer version of app available please update it now.";
            String btnLabel = "Update Now";
            String btnLabelCancel = "Later";
            return Platform.isIOS
                ? new CupertinoAlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(btnLabel),
                        onPressed: () => _launchURL(_model.versionCheck),
                      ),
                      FlatButton(
                        child: Text(btnLabelCancel),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  )
                : new AlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(btnLabel),
                        onPressed: () => _launchURL(_model.versionCheck),
                      ),
                      FlatButton(
                        child: Text(btnLabelCancel),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
          },
        );
      }
    }
  }
}
