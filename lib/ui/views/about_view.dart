import 'dart:io';

import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/viewmodels/about_model.dart';
import 'package:creativesapp/ui/themes/design_course_app_theme.dart';
import 'package:creativesapp/ui/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'base_view.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  static Color _textColor = Color(0xFF4e4e4e);
  bool _visible = false;
  bool _visible2 = false;

  AboutModel _model;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500) , (){
      setState(() {
        _visible = true;
      });
    }).then((value){
      setState(() {
        _visible2 = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseView<AboutModel>(
          onModelReady: (model) {
         model.getConfigurations();
         _model = model;
          },
          builder: (context, model, child) =>
          (model.state == ViewState.Busy)?
              Center(
                child: CircularProgressIndicator(),
              )
              :Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                Expanded(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
//                        height: 350.0,
                        ),
                        Scaffold(
                          backgroundColor: Colors.transparent,
                          appBar: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            leading: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
                            ),
                          ),
                          body: Stack(
                            children: <Widget>[
                              _profileTitle(context),
                              _bodyContent(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _profileTitle(BuildContext context) {
    return Positioned(
      top: 15,
      left: 0,
      right: 0,
      child: Column(
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 135,
                  height: 135,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      shape: BoxShape.circle),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 115,
                  height: 115,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  opacity: _visible ? 1 : 0,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: ExactAssetImage('assets/design_course/circle-cropped.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'CREATIVES GROUP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 0.27,
                color: DesignCourseAppTheme.darkerText,
              ),
            ),
          ),
          Text(
            _model.metaTitle,
            style: TextStyle(
              color: DesignCourseAppTheme.darkerText,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyContent(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10,),
            _divider(context),
            SizedBox(height: 25,),
            ..._aboutUs(context),
            SizedBox(height: 1,),
            ..._about(context),
            SizedBox(height: 16,),
            ..._about2(context),
            SizedBox(height: 16,),
            _divider(context),
           _aboutMe(context),
            SizedBox(height: 16,),
          ],
        ),
      ),
    );
  }

  TextStyle _bottomBarTitle = TextStyle(
    color: Colors.grey.shade400,
  );
  TextStyle _bottomBarCounter = TextStyle(
    color: _textColor,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );


  Widget _divider(BuildContext context) {
    return Container(
      height: 1,
      color: Colors.grey.shade200,
    );
  }



  List<Widget> _aboutUs(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Text(
          'ABOUT US',
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 26),
        child: Text(
          _model.AboutDescription,
          style: TextStyle(
            color: _textColor,
            fontSize: 16,
            height: 1.4,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      )
    ];
  }


  List<Widget> _about(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Text(
          'Phone',
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 26),
        child: Text(
          _model.phone1,
          style: TextStyle(
            color: _textColor,
            fontSize: 14,
            height: 1.4,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      )
    ];
  }

  List<Widget> _about2(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        child: Text(
          'Email Adderss',
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 26),
        child: Text(
          _model.emailAddress,
          style: TextStyle(
            color: _textColor,
            fontSize: 14,
            height: 1.4,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      )
    ];
  }


  Widget _aboutMe(BuildContext context) {
    return
      Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Developed By:',
                  style: TextStyle(
                    color: _textColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    fontSize: 14.0
                  ),
                ),
                InkWell(
                  onTap: () async {
                    String fbProtocolUrl;
                    if (Platform.isIOS) {
                      fbProtocolUrl = 'fb://profile/100005323807769';
                    } else {
                      fbProtocolUrl = 'fb://profile/100005323807769';
                    }
                    String fallbackUrl = 'https://www.facebook.com/tarek.karsa';

                    try {
                      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

                      if (!launched) {
                        await launch(fallbackUrl, forceSafariVC: false);
                      }
                    } catch (e) {
                      await launch(fallbackUrl, forceSafariVC: false);
                    }
                  },
                  child: Text(
                    'Tarek Kharsa',
                    style: TextStyle(
                      color: DesignCourseAppTheme.nearlyBlue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                        fontSize: 14.0
                    ),
                  ),

                ),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () async{

                    String fallbackUrl = 'https://api.creatives-group.sy/Privacy';

                    try {
                      await launch(fallbackUrl, forceSafariVC: false);
                    } catch (e) {

                    }
                  },
                  child: Text(
                    'Privacy & Terms',
                    style: TextStyle(
                      color: DesignCourseAppTheme.nearlyBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      letterSpacing: 1.1,
                    ),
                  ),

                ),
              ],
            ),
          ],
        ),
      );

  }
}
