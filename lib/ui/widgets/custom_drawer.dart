import 'package:cached_network_image/cached_network_image.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/services/user_manager.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:creativesapp/core/viewmodels/drawer_model.dart';
import 'package:creativesapp/core/viewmodels/login_model.dart';
import 'package:creativesapp/ui/Themes/design_course_app_theme.dart';
import 'package:creativesapp/ui/views/base_view.dart';
import 'package:creativesapp/ui/views/question_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  DrawerModel _model;

  setImage() async {
    SharedPreferences user = await SharedPreferences.getInstance();

    if (user != null) {

      if (_model.userImg == user.getString(Constants.PREF_IMAGE) ) {

      } else {
        _model.setUserImg(user.getString(Constants.PREF_IMAGE));
      }
      if (_model.userName == user.getString(Constants.PREF_NAME) ) {

      } else {
        _model.setUserName(user.getString(Constants.PREF_NAME));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    setImage();
    return BaseView<DrawerModel>(
        onModelReady: (model) {
          model.LoggedIn();
          model.getUserName();
          model.getUserImg();
          _model = model;
        },
        builder: (context, model, child) => model.state == ViewState.Idle
            ? Drawer(
                child: ListView(
                  children: <Widget>[
                    //Header
                    DrawerHeader(
                        padding: EdgeInsets.all(0),
                        child: Container(
                            margin: EdgeInsets.all(0),
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, right: 0, left: 0),
                            color: DesignCourseAppTheme.chipBackground,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 120.0,
                                  height: 120.0,
                                  child: model.userImg != null
                                      ? CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                            '${Constants.StudentImage}' +
                                                model.userImg,
                                          ),
                                        )
                                      : _imageProfile(),
                                ),
                                model.userName != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          model.userName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
//                            fontWeight: FontWeight.w600,
                                            fontSize: 19,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ))),

                    model.isLoggedIn
                        ? ListTile(
                            leading: IconButton(
                              icon: Icon(Icons.account_circle),
                              onPressed: () {},
                            ),
                            title: Text("Profile"),
                            onTap: () {
                              Navigator.pushNamed(context, 'profile');
                            },
                          )
                        : SizedBox(),
                    (model.isLoggedIn == false)
                        ? ListTile(
                            leading: IconButton(
                              icon: Icon(Icons.assignment_ind),
                              onPressed: () {},
                            ),
                            title: Text("Register"),
                            onTap: () {
                              Navigator.of(context).pop();

                              Navigator.pushNamed(
                                context,
                                'register',
                              );
                            },
                          )
                        : SizedBox(),
                    (model.isLoggedIn == false)
                        ? ListTile(
                            leading: IconButton(
                              icon: Icon(Icons.email),
                              onPressed: () {},
                            ),
                            title: Text("login"),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.pushNamed(context, 'login');
                            },
                          )
                        : SizedBox(),

                    model.isLoggedIn
                        ? ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.live_help),
                        onPressed: () {},
                      ),
                      title: Text("add Question"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionView() ),
                        );
                      },
                    )
                        : SizedBox(),

                    model.isLoggedIn
                        ? ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.feedback),
                        onPressed: () {},
                      ),
                      title: Text("FeedBack"),
                      onTap: () {
                        Navigator.pushNamed(context, 'feedBack');
                      },
                    )
                        : SizedBox(),

                    ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {},
                      ),
                      title: Text("About Us"),
                      onTap: () {
                        Navigator.pushNamed(context, 'aboutus');
                      },
                    ),

                    model.isLoggedIn == true
                        ? ListTile(
                            leading: IconButton(
                              icon: Icon(Icons.exit_to_app),
                              onPressed: () {},
                            ),
                            title: Text('logout'),
                            onTap: () {
                              Navigator.of(context).pop();

                              UserManager userManager2 = new UserManager();
                              userManager2.logout();

                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Row(
                                  children: <Widget>[
                                    Icon(Icons.check_circle_outline),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text('Logout Successfully',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins-Bold',
                                          fontSize: 14.0,
                                        )),
                                  ],
                                ),
                              ),);
                            },
                          )
                        : SizedBox(),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  _imageProfile() {
    return Image.asset('assets/design_course/user2.png');
  }
}
