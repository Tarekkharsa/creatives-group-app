import 'package:creativesapp/ui/themes/design_course_app_theme.dart';
import 'package:creativesapp/ui/views/home_view/home_design_course.dart';
import 'package:flutter/material.dart';

class AppBarUI extends StatelessWidget {
  final scaffoldKey;
  int page;

  AppBarUI({this.scaffoldKey, this.page});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          page != 2 && page != 3
              ? IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    scaffoldKey.currentState.openDrawer();
                  })
              : (page == 2)
                  ? new IconButton(
                      onPressed: () {
//                        Navigator.pushNamed(context, '/');

//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => DesignCourseHomeScreen()),
//                        );
                        Navigator.pushAndRemoveUntil<void>(context, MaterialPageRoute(builder: (_) => DesignCourseHomeScreen()), (_) => false);

                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 22.0,
                      ),
                    )
                  : new IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 22.0,
                      ),
                    ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Let\'s Study Together',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: DesignCourseAppTheme.grey,
                  ),
                ),
                Text(
                  'CREATIVES GROUP',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.darkerText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            child: Image.asset('assets/design_course/logo-png.png'),
          )
        ],
      ),
    );
  }
}
