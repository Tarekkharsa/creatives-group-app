import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:creativesapp/core/api/university_api.dart';
import 'package:creativesapp/core/api/user_api.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/university.dart';
import 'package:creativesapp/core/models/user.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:creativesapp/core/viewmodels/profile_model.dart';
import 'package:creativesapp/ui/themes/design_course_app_theme.dart';
import 'package:creativesapp/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'base_view.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  bool ImageLoading = true;
  File _image;
  ProfileModel _model;
  var mySelection;
  String img;

  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  List<University> universitiesList = [];
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    emailController?.dispose();
    nameController?.dispose();
    phoneController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileModel>(onModelReady: (model) {
      model.getUser();
      model.getUniversities();
    }, builder: (context, model, child) {
      _model = model;
      if (_model.user != null) {
        img = _model.user.image;
        universitiesList = model.universities;
        mySelection = model?.user?.university_id;
      }

      return Scaffold(
          body: new Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            AppBarUI(page: 2),
            Expanded(
              child: LiquidPullToRefresh(
                color: DesignCourseAppTheme.nearlyBlue,
                showChildOpacityTransition: false,
                onRefresh: _handleRefresh,
                child: new ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        new Container(
                          height: 180.0,
                          color: Colors.white,
                          child: new Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child:
                                    new Stack(fit: StackFit.loose, children: <
                                        Widget>[
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      (img != null)
                                          ? Container(
                                              width: 140.0,
                                              height: 140.0,
                                              child: _model.state !=
                                                      ViewState.imageUpload
                                                  ? CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                        '${Constants.StudentImage}' +
                                                            img,
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      child: Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                      height: 10.0,
                                                      width: 10.0,
                                                    ),
                                            )
                                          : (_model.state !=
                                                      ViewState.imageUpload &&
                                                  _model.state !=
                                                      ViewState.Busy)
                                              ? _imageProfile()
                                              : Container(
                                                  width: 140.0,
                                                  height: 140.0,
                                                  child: SizedBox(
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                    height: 10.0,
                                                    width: 10.0,
                                                  ),
                                                ),
                                    ],
                                  ),
                                  _model.state == ViewState.Idle ||
                                          _model.state == ViewState.imageUpload
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              top: 90.0, right: 100.0),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              new CircleAvatar(
                                                backgroundColor:
                                                    DesignCourseAppTheme
                                                        .nearlyBlue,
                                                radius: 25.0,
                                                child: new IconButton(
                                                  icon: Icon(Icons.camera_alt),
                                                  color: Colors.white,
                                                  onPressed: _model.getImage,
                                                ),
                                              )
                                            ],
                                          ))
                                      : SizedBox(),
                                ]),
                              )
                            ],
                          ),
                        ),
                        (_model.state == ViewState.Busy &&
                                _model.state != ViewState.imageUpload)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 120.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : new Container(
                                color: Color(0xffFFFFFF),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 25.0),
                                  child: FormBuilder(
                                    key: _fbKey,
//                            autovalidate: true,
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 0.0),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    new Text(
                                                      'Parsonal Information',
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    _status
                                                        ? _getEditIcon()
                                                        : new Container(),
                                                  ],
                                                )
                                              ],
                                            )),
                                        Divider(),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 5.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    new Text(
                                                      'Name',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 0.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                new Flexible(
                                                  child:
                                                      new FormBuilderTextField(
                                                    readOnly: _status,
                                                    controller: nameController,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "${_model.user?.name}",
                                                    ),
                                                    enabled: !_status,
                                                    autofocus: !_status,
                                                    maxLines: 1,
//                                                  validators: [
//                                                    FormBuilderValidators
//                                                        .required(),
//                                                  ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 15.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    new Text(
                                                      'Email ID',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 0.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                new Flexible(
                                                  child:
                                                      new FormBuilderTextField(
                                                    readOnly: true,
                                                    initialValue:
                                                        model.user?.email,
                                                    controller: emailController,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            _model.user?.email),
//                                                  enabled: _status,
                                                    maxLines: 1,
                                                    validators: [
//                                                    FormBuilderValidators
//                                                        .required(),
                                                      FormBuilderValidators
                                                          .email(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 15.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    new Text(
                                                      'Mobile',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 0.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                new Flexible(
                                                  child:
                                                      new FormBuilderTextField(
                                                    initialValue:
                                                        model.user?.phone,
                                                    readOnly: _status,
                                                    controller: phoneController,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            _model.user?.phone),
//                                                  enabled: _status,
                                                    maxLines: 1,
                                                    validators: [
//                                                    FormBuilderValidators
//                                                        .required(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 15.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    new Text(
                                                      'Password',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 0.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                new Flexible(
                                                  child:
                                                      new FormBuilderTextField(
                                                    readOnly: _status,
                                                    controller:
                                                        passwordController,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            'Enter New Password'),
//                                                  enabled: !_status,
                                                  ),
                                                ),
                                              ],
                                            )),
                                        FormBuilder(
                                          autovalidate: true,
                                          child: IgnorePointer(
                                            ignoring: _status,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0,
                                                  right: 25.0,
                                                  top: 2.0),
                                              child:
//                                        universitiesList != null &&
//                                                _model.state != ViewState.Busy
                                                  _model?.universities !=
                                                              null &&
                                                          _model.universities
                                                                  .length !=
                                                              0 &&
                                                          _model.user
                                                                  ?.university_id !=
                                                              null
                                                      ? _getDropDown(context)
                                                      : SizedBox(),
                                            ),
                                          ),
                                        ),
                                        !_status
                                            ? _getActionButtons()
                                            : new Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
    });
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: DesignCourseAppTheme.nearlyBlue,
                onPressed: () {
                  var user = {
                    'id': _model.user?.id,
                    'password': passwordController.text,
//                    'email': emailController.text,
                    'name': nameController.text,
                    'phone': phoneController.text,
                    'university_id': _model.UniversityId,
                  };
                  print(user);
                  final form = _fbKey.currentState;
                  if (form.validate()) {
                    setState(() {
                      _status = true;
                    });
                    if (_model.state == ViewState.Idle) {
                      _model.updateUser(user);
                    }
                    FocusScope.of(context).requestFocus(new FocusNode());
                  }
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new OutlineButton(
                child: new Text("Cancel"),
                textColor: DesignCourseAppTheme.nearlyBlue,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: DesignCourseAppTheme.nearlyBlue,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  _imageProfile() {
    return _image == null
        ? Image.asset('assets/design_course/userImage.png')
        : Image.file(_image);
  }

  Widget _getDropDown(BuildContext context) {
//    if (_model.selectedUniversity == null) return SizedBox.shrink();
    List<University> universitiesList = _model.universities;
    return FormBuilderCustomField(
      validators: [
        FormBuilderValidators.required(),
      ],
      formField: FormField(
        initialValue: int.parse(_model.user.university_id),
        enabled: true,
        builder: (FormFieldState<dynamic> field) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: "Select University",
              contentPadding: EdgeInsets.only(top: 10.0, bottom: 0.0),
              border: InputBorder.none,
              errorText: field.errorText,
            ),
            child: DropdownButton(
              isExpanded: true,
              items: universitiesList.map((option) {
                return DropdownMenuItem(
                  child: Text(option.name),
                  value: option.id,
                );
              }).toList(),
              value: field.value,
              onChanged: (value) {
                print(value);
                field.didChange(value);
                _model.setUniversityId(value.toString());
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleRefresh() async {
    _model.getUser();
    _model.getUniversities();
  }
}
