import 'package:creativesapp/core/models/university.dart';
import 'package:creativesapp/core/viewmodels/register_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../locator.dart';



class FormCard extends StatefulWidget {
  int mySelection;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController nameController;
  TextEditingController phoneController;
  List<University> universities ;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<FormBuilderState> fbKey;
  RegisterModel  model;

  FormCard({
    Key key,
    @required this.emailController,
    @required this.passwordController,
    this.nameController,
    this.phoneController,
    this.scaffoldKey,
    this.universities,
    this.model,
    this.fbKey
  }) : super(key: key);

  @override
  _FormCardState createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {


  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
//    getUniversity();
    super.initState();
  }


  timeOut() {
    setState(() {
      _isLoading = true;
    });
    _msg(context, 'conection error!!', Icons.error_outline);
  }

  @override
  Widget build(BuildContext context) {

    @override
    void dispose() {
      widget.fbKey.currentState.reset();
      super.dispose();
    }

    return Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(810),
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
          padding: EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
          child: Container(
            height: 1100.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Register',
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(45),
                      fontFamily: 'Poppins-Bold',
                      letterSpacing: .6,
                    )),
                FormBuilder(
                  key: widget.fbKey,
                  autovalidate: false,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        controller: widget.nameController,
                        attribute: "Name",
                        style: TextStyle(
                          fontFamily: 'Poppins-Medium',
                          fontSize: ScreenUtil.getInstance().setSp(26),
                        ),
                        decoration: InputDecoration(labelText: "Name"),
                        maxLines: 1,
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.max(70),
                        ],
                      ),
                      FormBuilderTextField(
                        controller: widget.emailController,
                        attribute: "Email",
                        style: TextStyle(
                          fontFamily: 'Poppins-Medium',
                          fontSize: ScreenUtil.getInstance().setSp(26),
                        ),
                        decoration: InputDecoration(labelText: "Email"),
                        maxLines: 1,
                        validators: [
                          FormBuilderValidators.email(),
                          FormBuilderValidators.required(),
                          FormBuilderValidators.max(1),
                        ],
                      ),
                      FormBuilderTextField(
                        controller: widget.passwordController,
                        attribute: "Password",
                        style: TextStyle(
                          fontFamily: 'Poppins-Medium',
                          fontSize: ScreenUtil.getInstance().setSp(26),
                        ),
                        decoration: InputDecoration(labelText: "Password"),
                        obscureText: true,
                        maxLines: 1,
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                      ),
                      FormBuilderTextField(
                        controller: widget.phoneController,
                        attribute: "Phone",
                        style: TextStyle(
                          fontFamily: 'Poppins-Medium',
                          fontSize: ScreenUtil.getInstance().setSp(26),
                        ),
                        decoration: InputDecoration(labelText: "Phone"),
                        maxLines: 1,
                        validators: [
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.required(),
                        ],
                      ),
                      widget.universities != null && widget.universities.length != 0
                          ? _getUniversityDropDown(context)
                          : Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: SizedBox(
                                child: _isLoading
                                    ? SizedBox()
                                    : CircularProgressIndicator(),
                                height: 20.0,
                                width: 20.0,
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

  Widget _msg(BuildContext context, String msg, IconData Myicon) {
    final snackbar = SnackBar(
      action: SnackBarAction(
        textColor: Colors.green,
        label: 'Refresh',
        onPressed: () {
          setState(() {
            _isLoading = false;
          });
//          getUniversity();
        },
      ),
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
    widget.scaffoldKey.currentState.showSnackBar(snackbar);
  }


  Widget _getUniversityDropDown(BuildContext context) {
    print('UniversityDropDown build called');
    return FormBuilderDropdown(
      onChanged: (value) {
        setState(() {

        widget.mySelection = value;
        });
        widget.model.setUniversityId(widget.mySelection);
      },

      isDense: true,
      isExpanded: true,
      attribute: "University",
      style: TextStyle(
        fontFamily: 'Poppins-Medium',
        fontSize: ScreenUtil.getInstance().setSp(26),
      ),
      decoration: InputDecoration(labelText: "University"),
      // initialValue: 'Male',
      hint: Text('Select University'),
      validators: [FormBuilderValidators.required()],
      items: widget.universities
          .map(
            (item) => DropdownMenuItem(
              value: item.id,
              child: Text(
                item.name,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
          .toList(),
    );
  }



bool validateForm(){
  final form = widget.fbKey.currentState;
  if(form.validate()){
    return true;
  }
  return false;
}
}
