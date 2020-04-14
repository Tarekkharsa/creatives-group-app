import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/course.dart';
import 'package:creativesapp/core/viewmodels/question_model.dart';
import 'package:creativesapp/ui/views/base_view.dart';
import 'package:creativesapp/ui/views/question_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CustomDialog extends StatefulWidget {
final GlobalKey<ScaffoldState> scaffoldKey;

  List<Course> courses;

  CustomDialog({this.courses,this.scaffoldKey});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  String text;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final  _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController questionController=new TextEditingController();
  String mySelection;
  QuestionModel _model;


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1364, allowFontScaling: true)
          ..init(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {

    return BaseView<QuestionModel>(
      onModelReady: (model) {
        model.getCourses();
        _model = model;

      },
      builder: (context, model, child) => SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 18.0,
              ),
              margin: EdgeInsets.only(top: 13.0, right: 8.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                    ),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0),
                    child: FormBuilder(
                      autovalidate: false,
//                    key: fbKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text('Add you Question ',
                                style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(35),
                                  fontFamily: 'Poppins-Bold',
                                  letterSpacing: .6,
                                )),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(16),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: FormBuilder(
                              key: _fbKey,
                              child: FormBuilderTextField(
                                      attribute: 'Question',
                                controller: questionController,
                                decoration: InputDecoration(
                                  hintText: 'Question...',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0)),
                                  ),
                                ),
                                maxLines: 6,
                                validators: [
                                  FormBuilderValidators.required(),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Send Image',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Bold',
                                    letterSpacing: .6,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12.0),
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus(focusPrevious: true);
                                      model.getImage();
                                    },
                                    backgroundColor: Color(0xFF6078ea),
                                    mini: true,
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.white,
                                      size: 18.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          (model.courses != null)
                              ? Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: _getCoursesDropDown(context),
                                )
                              : Center(child: SizedBox(
                              child: CircularProgressIndicator(),
                          height: 20.0,
                            width: 20.0,
                          ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30),
                            child: ButtonTheme(
                              height: 50,
                              child: FlatButton(
                                onPressed: () async {
                                  final form = _fbKey.currentState;
                                  if(form.validate()){
                                    var question = await model.sendQuestion(
                                        questionController.text, mySelection);
                                    if (question != null) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder:
                                      (context) => QuestionView() ));
                                    }else{
                                      _msg(context, 'conection error!!', Icons.error_outline,widget.scaffoldKey);
                                    }
                                  }
                                },
                                child: Center(
                                  child: model.state == ViewState.Busy
                                      ? Shimmer.fromColors(
                                          baseColor:
                                              Color(0xFF6078ea).withOpacity(.3),
                                          highlightColor: Colors.white,
                                          child: Text(
                                            'SIGNIN',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins-Bold',
                                              fontSize: 18.0,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          "SEND".toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
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
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(10),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 14.0,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, color: Color(0xFF6078ea)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCoursesDropDown(BuildContext context) {

    return FormBuilderDropdown(
      attribute: 'Course',
      onChanged: (value) {
        print(value);
        setState(() {
          mySelection = value.toString();
        });
      },
      isDense: true,
      isExpanded: true,
      style: TextStyle(
        fontFamily: 'Poppins-Medium',
        fontSize: ScreenUtil.getInstance().setSp(26),
      ),
      decoration: InputDecoration(
        labelText: "Select Course Name",
        labelStyle: TextStyle(
          fontFamily: 'Poppins-Bold',
          letterSpacing: .6,
        ),
        contentPadding: EdgeInsets.all(0),
      ),
      hint: Text('General Question'),
      validators: [FormBuilderValidators.required()],
      items: _model.courses
          .map(
            (item) => DropdownMenuItem(
              value: item.id,
              child: Text(
                item.title,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _msg(BuildContext context, String msg, IconData Myicon,scaffoldKey) {
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
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

}
