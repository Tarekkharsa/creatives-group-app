import 'dart:io';

import 'package:creativesapp/core/enums/connectivity_status.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/viewmodels/register_model.dart';
import 'package:creativesapp/ui/themes/HexColor.dart';
import 'package:creativesapp/ui/views/home_view/home_design_course.dart';
import 'package:creativesapp/ui/widgets/CustomIcons.dart';
import 'package:creativesapp/ui/widgets/SocialIcon.dart';
import 'package:creativesapp/ui/widgets/connect_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../locator.dart';
import '../base_view.dart';
import './Widgets/FormCard.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  String firebaseToken;

  bool _isSelected = false;
  bool _isLoading = false;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    _fcm.getToken().then((token) {
      firebaseToken = token;
      print(token);
    });
    super.initState();
  }


  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2.0, color: Colors.black),
        ),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);


    return BaseView<RegisterModel>(
      onModelReady: (model) {
        model.getConfigurations();
      model.getUniversities();
      },
      builder: (context, model, child) => new Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Image.asset('assets/image_01.png')),
                  Expanded(
                    child: Container(),
                  ),
                  Image.asset('assets/image_02.png'),
                ],
              ),
              SingleChildScrollView(
                  child: Padding(
                      padding:
                          EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/design_course/logo-png.png',
                                width: ScreenUtil.getInstance().setWidth(110),
                                height: ScreenUtil.getInstance().setHeight(110),
                              ),
                              Text('LOGO',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Bold',
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(46),
                                    letterSpacing: .6,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(100),
                          ),
                          FormCard(
                            emailController: emailController,
                            passwordController: passwordController,
                            nameController: nameController,
                            phoneController: phoneController,
                            scaffoldKey: _scaffoldKey,
                            universities: model.universities,
                            model: model,
                            fbKey: _fbKey,
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(25),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width:
                                        ScreenUtil.getInstance().setWidth(12.0),
                                  ),
                                  GestureDetector(
                                    onTap: _radio,
                                    child: radioButton(_isSelected),
                                  ),
                                  SizedBox(
                                    width:
                                        ScreenUtil.getInstance().setWidth(8.0),
                                  ),
                                  Text('Remember me',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'Poppins-Medium',
                                      )),
                                ],
                              ),
                              InkWell(
                                child: Container(
                                    width:
                                        ScreenUtil.getInstance().setWidth(300),
                                    height:
                                        ScreenUtil.getInstance().setHeight(100),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color(0xFF17ead9),
                                        Color(0xFF6078ea)
                                      ]),
                                      borderRadius: BorderRadius.circular(6.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Color(0xFF6078ea).withOpacity(.3),
                                          offset: Offset(0.0, 8.0),
                                          blurRadius: 8.0,
                                        )
                                      ],
                                    ),
                                    child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            onTap: () async {
                                              print(model.UniversityId);
                                              final form = _fbKey.currentState;

                                              if (form.validate()) {
                                                _register(model);
                                              }
                                            },
                                            child: Center(
                                                child: model.state ==
                                                        ViewState.Busy
                                                    ? Shimmer.fromColors(
                                                        baseColor: Color(
                                                                0xFF6078ea)
                                                            .withOpacity(.3),
                                                        highlightColor:
                                                            Colors.white,
                                                        child: Text(
                                                          'SIGNIN',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Poppins-Bold',
                                                            fontSize: 18.0,
                                                            letterSpacing: 1.0,
                                                          ),
                                                        ),
                                                      )
                                                    : Text('SIGNUP',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Poppins-Bold',
                                                          fontSize: 18.0,
                                                          letterSpacing: 1.0,
                                                        )))))),
                              )
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(40),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              horizontalLine(),
                              Text('Social Links',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Poppins-Medium',
                                  )),
                              horizontalLine(),
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(40),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SocialIcon(
                                colors: [
                                  Color(0xFF102397),
                                  Color(0xFF187adf),
                                  Color(0xFF00eaf8),
                                ],
                                icondata: CustomIcons.facebook,
                                onPressed: () async {
                                  print('facbook');
                                  String fbProtocolUrl;
                                  if (Platform.isIOS) {
                                    fbProtocolUrl =
                                        'fb://profile/112407256798747';
                                  } else {
                                    fbProtocolUrl = 'fb://page/112407256798747';
                                  }
                                  String fallbackUrl =
                                      model.facLink;

                                  try {
                                    bool launched = await launch(fbProtocolUrl,
                                        forceSafariVC: false);

                                    if (!launched) {
                                      await launch(fallbackUrl,
                                          forceSafariVC: false);
                                    }
                                  } catch (e) {
                                    await launch(fallbackUrl,
                                        forceSafariVC: false);
                                  }
                                },
                              ),
                              SocialIcon(
                                colors: [
                                  Color(0xFFff4f38),
                                  Color(0xFFff355d),
                                ],
                                icondata: FontAwesomeIcons.youtube,
                                onPressed: () async {
                                  String fbProtocolUrl;
                                  if (Platform.isIOS) {
                                    fbProtocolUrl =
                                        'yb://profile/MohammedAltal96';
                                  } else {
                                    fbProtocolUrl = 'yb://page/MohammedAltal96';
                                  }
                                  String fallbackUrl =
                                      model.youtubeLink;

                                  try {
                                    bool launched = await launch(fbProtocolUrl,
                                        forceSafariVC: false);

                                    if (!launched) {
                                      await launch(fallbackUrl,
                                          forceSafariVC: false);
                                    }
                                  } catch (e) {
                                    await launch(fallbackUrl,
                                        forceSafariVC: false);
                                  }
                                },
                              ),
                              SocialIcon(
                                colors: [
                                  HexColor('#ffdc80'),
                                  HexColor('#fcaf45'),
                                  HexColor('#f77737'),
                                  HexColor('#f56040'),
                                  HexColor('#fd1d1d'),
                                  HexColor('#e1306c'),
                                  HexColor('#c13584'),
                                  HexColor('#833ab4'),
                                  HexColor('#5851db'),
                                  HexColor('#405de6'),
                                ],
                                icondata: FontAwesomeIcons.instagram,
                                onPressed: () async {
                                  String fbProtocolUrl;
                                  if (Platform.isIOS) {
                                    fbProtocolUrl =
                                        'In://profile/creativesgroupsy';
                                  } else {
                                    fbProtocolUrl =
                                        'In://page/creativesgroupsy';
                                  }
                                  String fallbackUrl =
                                     model.instagramLink;

                                  try {
                                    bool launched = await launch(fbProtocolUrl,
                                        forceSafariVC: false);

                                    if (!launched) {
                                      await launch(fallbackUrl,
                                          forceSafariVC: false);
                                    }
                                  } catch (e) {
                                    await launch(fallbackUrl,
                                        forceSafariVC: false);
                                  }
                                },
                              ),
                              SocialIcon(
                                colors: [
                                  HexColor('#075e54'),
                                  HexColor('#128c7e'),
                                  HexColor('#25d366'),
                                  HexColor('#ece5dd'),
                                ],
                                icondata: FontAwesomeIcons.whatsapp,
                                onPressed: () async {
                                  var whatsappUrl =
                                      "whatsapp://send?phone=963${model.whatsAppNum}";
                                  await canLaunch(whatsappUrl)
                                      ? launch(whatsappUrl)
                                      : print(
                                          "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Old User? ',
                                style: TextStyle(fontFamily: 'Poppins-Medium'),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, 'login');
                                },
                                child: Text('SignIn',
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Bold',
                                      color: Color(0xFF5d74e3),
                                    )),
                              )
                            ],
                          )
                        ],
                      ))),
            ],
          )),
    );
  }

  _register(model) async {
    var data;
    if(firebaseToken != null){
       data = {
        'email': emailController.text,
        'password': passwordController.text,
        'name': nameController.text,
        'phone': phoneController.text,
        'university_id': model.UniversityId,
        'firebase_token' : firebaseToken,

      };
    }else{
      data = {
        'email': emailController.text,
        'password': passwordController.text,
        'name': nameController.text,
        'phone': phoneController.text,
        'university_id': model.UniversityId,
      };
    }

    print(data);

    var res = await model.register(data);

    if (res == 200) {
      // store user
      moveTo(context);
    } else if (res == 404) {
      _msg(context, 'conection error!!', Icons.error_outline);
    } else if (res == 400) {
      _msg(context, 'Email or password not valid  !!', Icons.error_outline);
    }
  }

  Widget _msg(BuildContext context, String msg, IconData Myicon) {
    final snackbar = SnackBar(
      content: Row(
        children: <Widget>[
          Icon(Myicon),
          SizedBox(
            width: 10.0,
          ),
          Text(msg,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-Bold',
                fontSize: 14.0,
              )),
        ],
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  moveTo(BuildContext context) async {
    _msg(context, 'Register Successfully', Icons.check_circle);
    await Future<dynamic>.delayed(const Duration(milliseconds: 1500));
    Navigator.pushAndRemoveUntil<void>(context, MaterialPageRoute(builder: (_) => DesignCourseHomeScreen()), (_) => false);
  }
}
