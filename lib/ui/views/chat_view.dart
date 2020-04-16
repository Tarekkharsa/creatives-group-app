import 'package:cached_network_image/cached_network_image.dart';
import 'package:creativesapp/core/models/question.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:creativesapp/ui/themes/design_course_app_theme.dart';
import 'package:creativesapp/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  Question question;
  String userImg , userName;
  ChatScreen({this.question,this.userImg,this.userName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();



  LinearGradient _gradient = LinearGradient(
    colors: [
      Color(0xFFef1385),
      Color(0xFFf12280),
      Color(0XFFf63d76),
      Color(0xFFf84f70)
    ],
    stops: [0.2, 0.4, 0.6, 0.8],
  );

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
//          fontFamily: GoogleFonts.montserrat().fontFamily,
          ),
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
//            decoration: BoxDecoration(
//              gradient: _gradient,
//            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                AppBarUI(page: 2),
                Flexible(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int position) {
                      return Column(
                        children: <Widget>[
                          _rightMessage(
                            messageBody: widget.question.question,
                            messageDateTime: widget.question.created_at,
                            messageSenderAvatar:widget.question.user.image,
                            messageSenderName: widget.question.user.name,
                            messageSenderPhone: '',
                          ),


                          (widget.question.answer != null)
                              ? _leftMessage(
                                  messageDateTime: widget.question.updated_at,
                                  messageBody:widget.question.answer,
                                  messageReceiverAvatar:
                                      'assets/design_course/logo-png.png',
                                  messageReceiverName: 'CREATIVES GROUP',
                                  messageReceiverPhone: '',
                                )
                              : SizedBox()
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rightMessage(
      {String messageDateTime,
      String messageSenderName,
      String messageSenderPhone,
      String messageSenderAvatar,
      String messageBody}) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(32, 34),
                child: Text(
                  messageDateTime,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    messageSenderName,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    messageSenderPhone,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 16,
              ),
              Container(
                width: 75,
                height: 75,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: messageSenderAvatar != null ?
                CachedNetworkImageProvider(
                  '${Constants.StudentImage}' +
                      messageSenderAvatar,
                ):AssetImage(
                  'assets/design_course/userImage.png'
                ),
              ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
//                color: Colors.grey.withOpacity(0.1)
                color: DesignCourseAppTheme.nearlyBlue),
            child: Text(
              messageBody,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          (widget.question.image != null ) ? Container(
//            width: double.infinity,
            
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
//                color: Colors.grey.withOpacity(0.1)
                color: DesignCourseAppTheme.nearlyBlue),
            child: Image(
              fit: BoxFit.contain,
              image:
              CachedNetworkImageProvider(
                '${Constants.QuestionImage}' +
                    widget.question.image
              ),
            )
          ):SizedBox(),
        ],
      ),
    );
  }

  Widget _leftMessage(
      {String messageDateTime,
      String messageReceiverName,
      String messageReceiverPhone,
      String messageReceiverAvatar,
      String messageBody}) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ExactAssetImage(messageReceiverAvatar)),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    messageReceiverName,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    messageReceiverPhone,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
              Spacer(
                flex: 1,
              ),
              Transform.translate(
                offset: Offset(-32, 34),
                child: Text(
                  messageDateTime,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.grey.withOpacity(0.1)),
            child: Text(
              messageBody,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
