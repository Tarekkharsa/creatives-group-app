import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormCard extends StatelessWidget {


  TextEditingController emailController;
  TextEditingController passwordController;
  final GlobalKey<FormBuilderState> fbKey;
  FormCard({Key key, @required this.emailController,@required this.passwordController,this.fbKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(560),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 15.0),
              blurRadius: 15.0,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -10.0),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: FormBuilder(
            autovalidate: false,
            key: fbKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    'Login',
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(45),
                      fontFamily: 'Poppins-Bold',
                      letterSpacing: .6,
                    )
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(30),
                ),
                Text(
                    'Email',
                    style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: ScreenUtil.getInstance().setSp(26),
                    )
                ),
                FormBuilderTextField(
                  attribute: 'Email',
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0 )
                  ),
                  maxLines: 1,
                  validators: [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(30),
                ),
                Text(
                    'Password',
                    style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: ScreenUtil.getInstance().setSp(26),
                    )
                ),
                FormBuilderTextField(
                  attribute: 'password',
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'password',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0 )
                  ),
                  maxLines: 1,
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(35),
                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: <Widget>[
//                    Text(
//                        'Forgot Password?',
//                        style: TextStyle(
//                          color: Colors.blue,
//                          fontFamily: 'Poppins-Medium',
//                          fontSize: ScreenUtil.getInstance().setSp(28),
//                        )
//                    )
//                  ],
//                )
              ],
            ),
          ),
        )
    );
  }


}