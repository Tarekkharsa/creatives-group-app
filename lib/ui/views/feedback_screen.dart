import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/viewmodels/feed_back_model.dart';
import 'package:creativesapp/ui/themes/app_theme.dart';
import 'package:creativesapp/ui/views/base_view.dart';
import 'package:creativesapp/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shimmer/shimmer.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _fbKey = GlobalKey<FormBuilderState>();
  TextEditingController _controller = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BaseView<FeedBackModel>(
      onModelReady: (model) {},
      builder: (context, model, child) => Container(
        color: AppTheme.nearlyWhite,
        child: SafeArea(
          top: false,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppTheme.nearlyWhite,
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    AppBarUI(page: 2),
                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top,
                          left: 16,
                          right: 16),
                      child: Image.asset('assets/image_01.png'),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Your FeedBack',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      child: const Text(
                        'Give your best time for this moment.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    _buildComposer(),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30),
                      child: ButtonTheme(
                        height: 50,
                        child: FlatButton(
                          onPressed: () async {
                            final form = _fbKey.currentState;
                            if (form.validate()) {
                            var res =await  model.sendFeedBack(_controller.text);
                            if (res != null ) {
                              _controller.text = '';
                            _msg(context, 'Thanks .... :)', Icons.check_circle,_scaffoldKey);
                            }else{
                               _msg(context, 'conection error!!', Icons.error_outline,_scaffoldKey);
                          
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
                                      'SEND',
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
                        gradient: LinearGradient(
                            colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                offset: const Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
            color: AppTheme.white,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              child: FormBuilder(
                key: _fbKey,
                child: FormBuilderTextField(
                  attribute: 'feedback',
                  controller: _controller,
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                  maxLines: null,
//                onChanged: (String txt) {},
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontSize: 16,
                    color: AppTheme.dark_grey,
                  ),
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your feedback...',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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
