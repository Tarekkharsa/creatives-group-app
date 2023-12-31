import 'package:creativesapp/core/viewmodels/all_courses_model.dart';
import 'package:creativesapp/core/viewmodels/home_model.dart';
import 'package:creativesapp/ui/themes/HexColor.dart';
import 'package:creativesapp/ui/themes/design_course_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class SearchBarUI extends StatefulWidget {
  AllCoursesModel model;
  String courseName;
  SearchBarUI({this.model,this.courseName});

  @override
  _SearchBarUIState createState() => _SearchBarUIState();
}

class _SearchBarUIState extends State<SearchBarUI> {
  bool _buttonActive = false;

  final _controller = new TextEditingController();

  @override
  void initState() {
    if(widget.courseName != null ){
      setState(() {
        _controller.text = widget.courseName;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print(widget.model.isSearch);
    if(widget.model.isEmpty == 1){
     setState(() {
       _controller.clear();
     });
    }


    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor('#F8FAFB'),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Form(
                          child: TextFormField(

                            onFieldSubmitted: (v){
                              widget.model.search(v);
                              widget.model.setIsSearch(1);
                              widget.model.setIsEmpty(0);
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            controller: _controller,
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: DesignCourseAppTheme.nearlyBlue,
                            ),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Search for course',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: HexColor('#B9BABC'),
                              ),
                              border: InputBorder.none,

                            ),
                            onEditingComplete: () {},
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        icon: Icon(Icons.search),
                        color: HexColor('#B9BABC'),
                        onPressed: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            widget.model.setIsSearch(1);
                            widget.model.search(_controller.text);
                            widget.model.setIsEmpty(0);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

}
