import 'package:creativesapp/core/api/course_api.dart';
import 'package:creativesapp/core/enums/connectivity_status.dart';
import 'package:creativesapp/core/viewmodels/course_model.dart';
import 'package:creativesapp/locator.dart';
import 'package:creativesapp/ui/router.dart';
import 'package:creativesapp/ui/themes/app_theme.dart';
import 'package:creativesapp/ui/themes/design_course_app_theme.dart';
import 'package:creativesapp/ui/views/home_view/home_design_course.dart';
import 'package:creativesapp/ui/views/pin_code_verification_view.dart';
import 'package:creativesapp/ui/views/queries_view.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import 'core/services/connectivity_provider.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return OverlaySupport(
      child: StreamProvider<ConnectivityStatus>(
        create: (_) => ConnectivityService().connectionStatusController.stream,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            backgroundColor: DesignCourseAppTheme.nearlyWhite,
            primarySwatch: Colors.blue,
            textTheme: AppTheme.textTheme,
            platform: TargetPlatform.android,
          ),
//        initialRoute: '/',
          onGenerateRoute: Router.generateRoute,
          home: SplashScreen.navigate(
              name: 'assets/splashScreen.flr',
              startAnimation: 'Untitled',
              next:(context)=> DesignCourseHomeScreen(),
            until: () => Future.delayed(Duration(seconds: 1)),
            backgroundColor: Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}


