

import 'dart:io';

import 'package:creativesapp/core/api/course_api.dart';
import 'package:creativesapp/core/api/question_api.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/course.dart';
import 'package:creativesapp/core/models/question.dart';
import 'package:creativesapp/core/models/user.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../locator.dart';
import 'base_model.dart';

import 'package:dio/dio.dart';

class QuestionModel extends BaseModel {
  CourseApi _apiCourse = locator<CourseApi>();
  QuestionApi _questionApi = locator<QuestionApi>();

  List<Course> courses;
  List<Question> questions;
  Question question;
  File img;
  int _id;
  String userImg,userName;

  Question get getQuestion => question;

  Future getMyQuestion() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    if (user != null) {
      _id = user.getInt(Constants.PREF_ID);
      setState(ViewState.Busy);
      questions = await _questionApi.getMyQuestion(_id);
      print('questions from model  = ${questions}');
      setState(ViewState.Idle);
    }
  }

  Future getCourses() async {
    setState(ViewState.Busy);
    courses = await _apiCourse.getCourses();
    setState(ViewState.Idle);
  }

  getUser() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    if(user != null){
      userImg =  user.getString(Constants.PREF_IMAGE);
      userName =  user.getString(Constants.PREF_NAME);

    }
  }



  Future<Question> sendQuestion(text, courseId) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    if (user != null) {
      int id = user.getInt(Constants.PREF_ID);
      String fileName;
      FormData formData;
      if(img != null){
       fileName = img.path.split('/').last;
         formData = FormData.fromMap({
          'student_id': id,
          'question':text,
          'course_id':courseId,
          "image": await MultipartFile.fromFile(img.path, filename: fileName) ,
        });
      }else{
         formData = FormData.fromMap({
          'student_id': id,
          'question':text,
          'course_id':courseId,
        });
      }

      setState(ViewState.Busy);
     var question = await _questionApi.sendQuestion(formData);
      setQuestion(question);
      print("model question ${question}");
      if(img != null){
//      this.uploadImage(img);

      }
      setState(ViewState.Idle);
      return question;
    }
  }



  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      print('image null');
    }
    if (image != null) {

      img = image;
    }
  }

  Future<String> uploadImage(File file) async {
    print('upload image');
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path, filename: fileName),
      'id': this.getQuestion.id,
    });
    setState(ViewState.imageUpload);
    Question result = await _questionApi.updateQuestion(formData);
    setState(ViewState.Idle);
    print(result);
    if (result != null) {
      print(result);
    } else {
      print('time out in update user');
    }
  }

  void setQuestion(Question value) {
    question =value;
    notifyListeners();
  }


}
