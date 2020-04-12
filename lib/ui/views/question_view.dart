import 'package:cached_network_image/cached_network_image.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:creativesapp/core/viewmodels/question_model.dart';
import 'package:creativesapp/ui/themes/design_course_app_theme.dart';
import 'package:creativesapp/ui/views/base_view.dart';
import 'package:creativesapp/ui/views/chat_view.dart';
import 'package:creativesapp/ui/widgets/app_bar.dart';
import 'package:creativesapp/ui/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class QuestionView extends StatefulWidget {
  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  TextEditingController questionController = new TextEditingController();
  QuestionModel _model;
  @override
  Widget build(BuildContext context) {
    return BaseView<QuestionModel>(
      onModelReady: (model) {
        model.getCourses();
        model.getMyQuestion();
        model.getUser();
        _model = model;
      },
      builder: (context, model, child) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton.extended(
                heroTag: 'fab_new_card',
                icon: Icon(Icons.add),
                label: Text('Add New Question'),
                onPressed: () {
                  if (model.state == ViewState.Idle) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            CustomDialog(courses: model.courses));
                  }
                });
          },
        ),
        body: Container(
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
                  child: (model.state == ViewState.Busy ||
                          model.questions == null)
                      ? ListView(
                          children: <Widget>[
                            Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                              height: MediaQuery.of(context).size.height / 2,
                            ),
                          ],
                        )
                      : (model.questions.length == 0)
                          ? ListView(
                              children: <Widget>[
                                Center(
                                  child: Text('not question avilable'),
                                ),
                              ],
                            )
                          : new ListView.builder(
                              itemCount: model.questions.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Container(
                                        child: ListTile(
                                          trailing: Icon(
                                            (model.questions[index].answer ==
                                                    null)
                                                ? Icons.history
                                                : Icons.check_circle,
                                            color: (model.questions[index]
                                                        .answer ==
                                                    null)
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                          leading: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(16.0)),
                                            child: AspectRatio(
                                              aspectRatio: 1.0,
                                              child: (model.questions[index]
                                                          ?.image !=
                                                      null)
                                                  ? Image(
                                                      fit: BoxFit.cover,
                                                      image:
                                                          CachedNetworkImageProvider(
                                                        '${Constants.QuestionImage}' +
                                                            model
                                                                .questions[
                                                                    index]
                                                                ?.image,
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      'assets/design_course/logo-png.png'),
                                            ),
                                          ),
                                          title: Text(
                                              model.questions[index].question),
                                          subtitle: Text(model
                                              .questions[index].created_at),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                          question:
                                                              model.questions[
                                                                  index],userName :model.userName,
                                                        userImg: model.userImg,
                                                      ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                );
                              }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    _model.getMyQuestion();
    _model.getCourses();
  }
}
