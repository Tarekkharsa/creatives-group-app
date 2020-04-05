import 'package:creativesapp/locator.dart';
import 'package:creativesapp/ui/router.dart';
import 'package:creativesapp/ui/themes/app_theme.dart';
import 'package:creativesapp/ui/themes/design_course_app_theme.dart';
import 'package:creativesapp/ui/views/home_view/home_design_course.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: DesignCourseAppTheme.nearlyWhite,
          primarySwatch: Colors.blue,
          textTheme: AppTheme.textTheme,
          platform: TargetPlatform.android,
        ),
        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
        home: SplashScreen.navigate(
            name: 'assets/splashScreen.flr',
            startAnimation: 'Untitled',
            next:(context)=> DesignCourseHomeScreen(),
          until: () => Future.delayed(Duration(seconds: 1)),
          backgroundColor: Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}




// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    print("Second text field: ${myController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (text) {
                print("First text field: $text");
              },
            ),
            TextField(
              controller: myController,
            ),
          ],
        ),
      ),
    );
  }
}