import 'package:creativesapp/core/models/coach.dart';
import 'package:creativesapp/core/models/course.dart';
import 'package:creativesapp/ui/views/about_view.dart';
import 'package:creativesapp/ui/views/all_courses.dart';
import 'package:creativesapp/ui/views/coach_info_screen.dart';
import 'package:creativesapp/ui/views/course_info_screen.dart';
import 'package:creativesapp/ui/views/feedback_screen.dart';
import 'package:creativesapp/ui/views/home_view/home_design_course.dart';
import 'package:creativesapp/ui/views/pin_code_verification_view.dart';
import 'package:creativesapp/ui/widgets/image_view.dart';
import 'package:creativesapp/ui/views/login_view/login.dart';
import 'package:creativesapp/ui/views/profile_view.dart';
import 'package:creativesapp/ui/views/register_view/Register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


const String initialRoute = "/";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'aboutus':
        return MaterialPageRoute(builder: (_) => AboutUs());
        case 'feedBack':
        return MaterialPageRoute(builder: (_) => FeedbackScreen());
      case '/':
        return MaterialPageRoute(builder: (_) => DesignCourseHomeScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => DesignCourseHomeScreen());
      case 'login':
        return MaterialPageRoute(builder: (_) => Login());
      case 'profile':
        return MaterialPageRoute(builder: (_) => ProfilePage());
          case 'register':
        return MaterialPageRoute(builder: (_) => Register());
      case 'allCourses':
        var courseName = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => AllCourses( courseName :courseName));
      case 'pinCodeScreen':
        var Email = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => PinCodeVerificationScreen(email: Email,));
      case 'course':
        var id = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => CourseInfoScreen(id: id));
      case 'imageView':
        var img = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ImageView(img: img));
      case 'coach':
        var coach = settings.arguments as Coach;
        return MaterialPageRoute(builder: (_) => CoachInfoScreen(coach: coach));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
