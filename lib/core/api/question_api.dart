

import 'package:creativesapp/core/models/question.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';

class QuestionApi{

  Question question;
  Question question2;
  List<Question> questions;

  Future<List<Question>> getMyQuestion(int id) async {
    print('getMyQuestion');
    try {
      Response response =
      await Dio().get("${Constants.URL}getMyQuestions?id=${id}");
      print(response);
      if (response.statusCode == 200) {
        questions = Question.fromJsonList(response.data['data']);
        print(questions);
      }
    } catch (e) {
      return null;
    }
    return questions;
  }



  Future<Question> sendQuestion(data) async {
    print("sendQuestion");
    try {
      Response response = await Dio().post("${Constants.URL}student_question/add",data: data);
      print(response);
      if (response.statusCode == 200) {
        question = Question.fromJson(response.data['data']);

      }
    } catch (e) {
      return null;
    }
    return question;
  }

  Future<Question> updateQuestion(data) async {
    print(' updateQuestion');
    String url = '${Constants.URL}student_question/update';
    try {
      Response response = await Dio().post(url, data: data,);
      print(response.statusCode);
      if (response.statusCode == 200) {
        question2 = Question.fromJson(response.data['data']);
        print(response);
      }
    } catch (e) {
      return null;
    }
    return question2 ;
  }




}