import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/viewmodels/queries_model.dart';
import 'package:creativesapp/ui/themes/design_course_app_theme.dart';
import 'package:creativesapp/ui/views/base_view.dart';
import 'package:creativesapp/ui/widgets/app_bar.dart';
import 'package:creativesapp/ui/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class QueriesView extends StatefulWidget {
  @override
  _QueriesViewState createState() => _QueriesViewState();
}

class _QueriesViewState extends State<QueriesView> {

  TextEditingController questionController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<QueriesModel>(
      onModelReady: (model) {
        model.getCourses();
      },
      builder: (context, model, child) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton.extended(
                heroTag: 'fab_new_card',
                icon: Icon(Icons.add),
//            backgroundColor: taskColor,
                label: Text('Add New Question'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          CustomDialog(courses: model.courses,model: model));
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
                child: (model.state == ViewState.Busy)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : LiquidPullToRefresh(
                        color: DesignCourseAppTheme.nearlyBlue,
                        showChildOpacityTransition: false,
                        onRefresh: _handleRefresh,
                        child: new ListView.builder(
                          itemCount: model.queries.length,
                          itemBuilder:(context , index){
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    child: ListTile(
                                      leading: FlutterLogo(
                                        size: 50.0,
                                      ),
                                      title: Text(model.queries[index].question),
                                      subtitle: Text('20/4/2020'),
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          }




                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
//    _model.getUser();
//    _model.getUniversities();
  }
}
