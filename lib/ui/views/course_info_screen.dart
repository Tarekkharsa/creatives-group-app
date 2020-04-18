import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/course.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:creativesapp/core/viewmodels/course_model.dart';
import 'package:creativesapp/locator.dart';
import 'package:creativesapp/ui/themes/HexColor.dart';
import 'package:creativesapp/ui/themes/design_course_app_theme.dart';
import 'package:creativesapp/ui/widgets/SocialIcon.dart';
import 'package:creativesapp/ui/widgets/image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import 'package:url_launcher/url_launcher.dart';

import 'base_view.dart';



//CourseInfoScreen
class CourseInfoScreen extends StatefulWidget {

  final String id;

  CourseInfoScreen({this.id});

  @override
  _CourseInfoScreenState createState() => _CourseInfoScreenState();
}

class _CourseInfoScreenState extends State<CourseInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
        builder: Builder(
            builder : (context)=> ShowCourse(id: widget.id,)
    ),
    );
  }
}




class ShowCourse extends StatefulWidget {
  final String id;

  ShowCourse({Key key, this.id}) : super(key: key);

  @override
  _ShowCourseState createState() => _ShowCourseState();
}

class _ShowCourseState extends State<ShowCourse>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  bool showState = false ;
  CourseModel _model;


  GlobalKey _one = GlobalKey();

  ScrollController  _scrollController;

   _scrollToBottom() async{
     await Future<dynamic>.delayed(const Duration(milliseconds: 200));
     if(_scrollController.hasClients){
       _scrollController.animateTo(
         50,
         duration: const Duration(milliseconds: 1000),
         curve: Curves.easeOut,
       );
     }
  }



  @override
  void initState() {
    _scrollController = new ScrollController();

    animationController = AnimationController(

        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();

    super.initState();

  }


  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {



    SharedPreferences preferences ;
    displayShowCase() async{
      preferences = await SharedPreferences.getInstance();
      bool  showCaseState = preferences.getBool('dispayShowCase');

      if(showCaseState == null){
        preferences.setBool('dispayShowCase',false);

        return true;
      }
      return false;
    }

    displayShowCase().then((statues) {
      if(statues == true){

      showState = true;
      }
      if(statues){
        ShowCaseWidget.of(context).startShowCase( [_one]);
      }
    });


    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;

    return BaseView<CourseModel>(
      onModelReady: (model) {
        if(widget.id != null){

        model.getCourse(widget.id);
        }
        _model = model;


      },
      builder: (context, model, child) => Container(
        color: DesignCourseAppTheme.nearlyWhite,
        child: (model.course != null || model.state != ViewState.Busy)
            ? Scaffold(
                backgroundColor: Colors.transparent,
          body:  (model.state == ViewState.Busy)
              ? Center(child: CircularProgressIndicator())
              : Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  model.course?.cover != null
                      ? AspectRatio(
                    aspectRatio: 1.2,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: '${Constants.CourseImage}' +
                          model.course.cover,
                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error),
                    ),
                  )
                      : SizedBox(),
                ],
              ),
              Positioned(
                top: (MediaQuery.of(context).size.width / 1.2) -
                    24.0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: DesignCourseAppTheme.nearlyWhite,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32.0),
                        topRight: Radius.circular(32.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: DesignCourseAppTheme.grey
                              .withOpacity(0.2),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 8, right: 8),
                    child: SingleChildScrollView(
                      child: Container(
                        constraints: BoxConstraints(
                            minHeight: infoHeight,
                            maxHeight: tempHeight > infoHeight
                                ? tempHeight
                                : infoHeight),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 32.0, left: 18, right: 16),
                              child: Text(
                                model.course?.title != null
                                    ? model.course.title
                                    : '',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  letterSpacing: 0.27,
                                  color: DesignCourseAppTheme
                                      .darkerText,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 8,
                                  top: 16),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    model.course?.cost != null
                                        ? model.course.cost
                                        .toString() +
                                        " " +
                                        'SP'
                                        : '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 22,
                                      letterSpacing: 0.27,
                                      color: DesignCourseAppTheme
                                          .nearlyBlue,
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          '',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight:
                                            FontWeight.w200,
                                            fontSize: 22,
                                            letterSpacing: 0.27,
                                            color:
                                            DesignCourseAppTheme
                                                .grey,
                                          ),
                                        ),
                                        (model.course?.end_date ==
                                            null)
                                            ? Icon(
                                          Icons.star,
                                          color:
                                          DesignCourseAppTheme
                                              .nearlyBlue,
                                          size: 24,
                                        )
                                            : SizedBox(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            AnimatedOpacity(
                              duration:
                              const Duration(milliseconds: 500),
                              opacity: opacity1,
                              child: Showcase(
                                key: _one,
                                title: 'Course Info',
                                description: 'You Can Scroll To Show All Course Information ',
                               titleTextStyle: TextStyle(
                                 color: DesignCourseAppTheme.nearlyBlue,
                                 fontWeight: FontWeight.bold,
                                 height: 1,

                               ),
                                child: Container(
                                  height: 100.0,
                                  child: ListView(
                                    controller: _scrollController,
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      (model.course?.contact?.phone !=
                                          null)
                                          ? getTimeBoxUI(
                                              'Phone',
                                              model.course?.contact
                                                  ?.phone
                                                  .toString(),
                                              model.course?.contact
                                                  ?.phone)
                                          : Text(''),
                                      (model.course?.start_date !=
                                          null)
                                          ? getTimeBoxUI(
                                          'Start Date',
                                          model.course?.start_date
                                              .toString(),
                                          '')
                                          : Text(''),
                                      (model.course?.address != null)
                                          ? getTimeBoxUI(
                                          'Address',
                                          model.course?.address
                                              .toString(),
                                          '')
                                          : Text(''),
                                      (model.course?.location != null)
                                          ? getTimeBoxUI(
                                          'Location',
                                          model.course?.location
                                              ?.name
                                              .toString(),
                                          '')
                                          : Text(''),
                                      (model.course?.end_date != null)
                                          ? getTimeBoxUI(
                                          'End Date',
                                          model.course?.end_date
                                              .toString(),
                                          '')
                                          : Text(''),
                                      getTimeBoxUI(
                                          'Coach',
                                          model.course?.coaches !=
                                              null
                                              ? model.course
                                              ?.coaches[0]?.name
                                              : ''.toString(),
                                          ''),
                                      (model.course?.category?.name !=
                                          null)
                                          ? getTimeBoxUI(
                                          'Category',
                                          model.course?.category
                                              ?.name
                                              .toString(),
                                          '')
                                          : Text(''),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: AnimatedOpacity(
                                duration: const Duration(
                                    milliseconds: 500),
                                opacity: opacity2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      top: 0,
                                      bottom: 8),
                                  child: ListView(
                                    padding: EdgeInsets.only(
                                        left: 0,
                                        right: 0,
                                        top: 0,
                                        bottom: 0),
                                    children: <Widget>[
                                      Text(
                                        model.course?.description
                                            .toString(),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.w200,
                                          fontSize: 14,
                                          letterSpacing: 0.20,
                                          color:
                                          DesignCourseAppTheme
                                              .grey,
                                        ),
                                        maxLines: 50,
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              duration:
                              const Duration(milliseconds: 500),
                              opacity: opacity3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16,
                                    bottom: 16,
                                    right: 16),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 48,
                                      height: 48,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                          DesignCourseAppTheme
                                              .nearlyWhite,
                                          borderRadius:
                                          const BorderRadius
                                              .all(
                                            Radius.circular(16.0),
                                          ),
                                          border: Border.all(
                                              color:
                                              DesignCourseAppTheme
                                                  .grey
                                                  .withOpacity(
                                                  0.2)),
                                        ),
                                        child: Icon(
                                          (model
                                              .userState ==
                                              0)
                                              ? Icons.add
                                              : (model.userState ==
                                              1)
                                              ? Icons
                                              .access_time
                                              : (model.userState ==
                                              2)
                                              ? Icons
                                              .check_circle_outline
                                              : Icons
                                              .warning,
                                          color: (model.userState ==
                                              2)
                                              ? Colors.green
                                              : (model.userState ==
                                              3)
                                              ? Colors.red
                                              : DesignCourseAppTheme
                                              .nearlyBlue,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          SharedPreferences user =
                                          await SharedPreferences
                                              .getInstance();
                                          if (user.getInt(Constants
                                              .PREF_ID) !=
                                              null) {
                                            if (model.userState ==
                                                0) {
                                              var _id = user.getInt(
                                                  Constants
                                                      .PREF_ID);
                                              var data = {
                                                'course_id':
                                                widget.id,
                                                'student_id': _id
                                              };
                                              await model
                                                  .registerCourse(
                                                  data);
                                              await model.getCourse(
                                                  widget.id);
                                            }
                                          } else if (user.getInt(
                                              Constants
                                                  .PREF_ID) ==
                                              null) {
                                            _showDialog(context);
                                          }

                                        },
                                        child: Container(
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color:
//                                                            DesignCourseAppTheme
//                                                                .nearlyBlue,
                                            (model.userState ==
                                                0)
                                                ? DesignCourseAppTheme
                                                .nearlyBlue
                                                : (model.userState ==
                                                1)
                                                ? DesignCourseAppTheme
                                                .nearlyBlue
                                                : (model.userState ==
                                                2)
                                                ? Colors
                                                .green
                                                : Colors
                                                .red,
                                            borderRadius:
                                            const BorderRadius
                                                .all(
                                              Radius.circular(16.0),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: DesignCourseAppTheme
                                                      .nearlyBlue
                                                      .withOpacity(
                                                      0.5),
                                                  offset:
                                                  const Offset(
                                                      1.1, 1.1),
                                                  blurRadius: 10.0),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              (model.userState == 0)
                                                  ? 'Join Course'
                                                  : (model.userState ==
                                                  1)
                                                  ? 'pending'
                                                  : (model.userState ==
                                                  2)
                                                  ? 'accepted'
                                                  : 'rejected',
                                              textAlign:
                                              TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .w600,
                                                  fontSize: 18,
                                                  letterSpacing:
                                                  0.0,
                                                  color: DesignCourseAppTheme
                                                      .nearlyWhite),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context)
                                  .padding
                                  .bottom,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: (MediaQuery.of(context).size.width / 1.2) -
                    24.0 -
                    35,
                right: 35,
                child: ScaleTransition(
                  alignment: Alignment.center,
                  scale: CurvedAnimation(
                      parent: animationController,
                      curve: Curves.fastOutSlowIn),
                  child: Card(
                    color: DesignCourseAppTheme.nearlyBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    elevation: 10.0,
                    child: Container(
                      width: 60,
                      height: 60,
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.open_in_new,
                            size: 30,
                          ),
                          color: DesignCourseAppTheme.nearlyWhite,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageView(
                                    img:
                                    '${Constants.CourseImage}' +
                                        model.course.cover,
                                  )),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top),
                child: SizedBox(
                  width: AppBar().preferredSize.height,
                  height: AppBar().preferredSize.height,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                          AppBar().preferredSize.height),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: DesignCourseAppTheme.nearlyBlack,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
//                body:

              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2, String whatsAppNum) {
      if(showState == true){
     _scrollToBottom();
      }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DesignCourseAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 12.0, bottom: 12.0),
          child: Row(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    text1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 0.27,
                      color: DesignCourseAppTheme.nearlyBlue,
                    ),
                  ),
                  Text(
                    txt2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      letterSpacing: 0.27,
                      color: DesignCourseAppTheme.grey,
                    ),
                  ),
                ],
              ),
              (whatsAppNum != '')
                  ? SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.whatsapp),
                        onPressed: () async {
                          var whatsappUrl =
                              "whatsapp://send?phone=963${whatsAppNum}";
                          await canLaunch(whatsappUrl)
                              ? launch(whatsappUrl)
                              : print(
                                  "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                        },
                        color: DesignCourseAppTheme.nearlyBlue,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child:Container(
              height: 400.0,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                Container(
                  height: 200.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      'assets/design_course/logo-png.png',
                    ),
                  ),
                ),
              Text(
                'Please LOGIN ',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              Text(
                'to join course you need login or register !!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20),
                          child: ButtonTheme(
                            height: 40,
                            child: FlatButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                  "Cancel".toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.grey,
                              Colors.grey.withOpacity(0.5),
                            ]),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF6078ea).withOpacity(.3),
                                offset: Offset(0.0, 8.0),
                                blurRadius: 8.0,
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 20),
                          child: ButtonTheme(
                            height: 40,
                            child: FlatButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, 'login');
                              },
                              child: Text(
                                "Login".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xFF17ead9),
                              Color(0xFF6078ea)
                            ]),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF6078ea).withOpacity(.3),
                                offset: Offset(0.0, 8.0),
                                blurRadius: 8.0,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });

  }
}
