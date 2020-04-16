import 'package:creativesapp/core/enums/connectivity_status.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/category.dart';
import 'package:creativesapp/core/viewmodels/all_courses_model.dart';
import 'package:creativesapp/core/viewmodels/home_model.dart';
import 'package:creativesapp/ui/themes/design_course_app_theme.dart';
import 'package:creativesapp/ui/widgets/app_bar.dart';
import 'package:creativesapp/ui/widgets/connect_model.dart';
import 'package:creativesapp/ui/widgets/custom_drawer.dart';
import 'package:creativesapp/ui/widgets/search_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import 'base_view.dart';
import 'home_view/popular_course_list_view.dart';

class AllCourses extends StatefulWidget {
  String courseName;
  int category_id;
  List<Category> categoryList;
  AllCourses({this.courseName, this.categoryList ,this.category_id});
  @override
  _AllCoursesState createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> with TickerProviderStateMixin {
  AnimationController animationController;
  AllCoursesModel _model;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1300), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 100));
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return BaseView<AllCoursesModel>(
      onModelReady: (model) {
        if (widget.category_id != null) {
          model.getCoursesByCategory(widget.category_id);
        } else {
          model.search(widget.courseName);
        }
        _model = model;
      },
      builder: (context, model, child) => Container(
        color: DesignCourseAppTheme.nearlyWhite,
        child: Scaffold(
          
          drawer: DrawerWidget(),
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              AppBarUI(page: 3),
              SearchBarUI(model: model, courseName: widget.courseName),
              (widget.categoryList != null)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: getCategoryBtn(widget.categoryList),
                    )
                  : SizedBox(),
              Expanded(
                child: (model.courses?.length == 0 &&
                        model.state == ViewState.Idle)
                    ? Center(
                        child: Text('No Results'),
                      )
                    : Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: (model.state == ViewState.Idle &&
                                    model.courses != null)
                                ? FutureBuilder<bool>(
                                    future: getData(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<bool> snapshot) {
                                      if (!snapshot.hasData) {
                                        return const SizedBox();
                                      } else {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: LiquidPullToRefresh(
                                            color:
                                                DesignCourseAppTheme.nearlyBlue,
                                            onRefresh: _handleRefresh,
                                            showChildOpacityTransition: false,
                                            child: GridView(
                                              padding: const EdgeInsets.all(8),
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              children: List<Widget>.generate(
                                                model.courses.length,
                                                (int index) {
                                                  final int count =
                                                      model.courses.length;
                                                  final Animation<double>
                                                      animation = Tween<double>(
                                                              begin: 0.0,
                                                              end: 1.0)
                                                          .animate(
                                                    CurvedAnimation(
                                                      parent:
                                                          animationController,
                                                      curve: Interval(
                                                          (1 / count) * index,
                                                          1.0,
                                                          curve: Curves
                                                              .fastOutSlowIn),
                                                    ),
                                                  );
                                                  animationController.forward();
                                                  return CategoryView(
                                                    callback: () {
//                          widget.callBack();
                                                    },
                                                    course:
                                                        model.courses[index],
                                                    animation: animation,
                                                    animationController:
                                                        animationController,
                                                  );
                                                },
                                              ),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 32.0,
                                                crossAxisSpacing: 32.0,
                                                childAspectRatio: 0.8,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : const Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            180.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCategoryBtn2(String text, int id) {
    if(_model.isSearch ==1){
      widget.category_id = null;
    }
    return Container(
      decoration: BoxDecoration(
          color: (widget.category_id != null && widget.category_id == id)? DesignCourseAppTheme.nearlyWhite
         : DesignCourseAppTheme.nearlyBlue,
//                ? DesignCourseAppTheme.nearlyBlue
//                : DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          border: Border.all(color: DesignCourseAppTheme.nearlyBlue)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white24,
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          onTap: () {
            setState(() {
              widget.category_id = id;
              _model.setIsSearch(0);
            });
            FocusScope.of(context).requestFocus(FocusNode());
            _model.getCoursesByCategory(id);

          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.27,
                  color:(widget.category_id != null && widget.category_id == id)? DesignCourseAppTheme.nearlyBlue
                      :DesignCourseAppTheme.nearlyWhite,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCategoryBtn(List<Category> categoryListApi) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: SizedBox(
        height: 50.0,
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categoryListApi.length,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              children: <Widget>[
                getCategoryBtn2(
                    categoryListApi[index].name, categoryListApi[index].id),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    _model.search(widget.courseName);
  }
}
