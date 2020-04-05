
import 'package:creativesapp/core/models/university.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';

class UniversityApi {


  University university;
  List<University> universityList;

  Future<List<University>> getUniversities() async {

    String url = '${Constants.URL}getUniversities';

    try {
      var apiRespon = await Dio().get(url);

      if(apiRespon.statusCode == 200){
        universityList = University.fromJsonList(apiRespon.data['data']);
        print(apiRespon);
      }

    }on DioError catch (e) {
      if(e.type == DioErrorType.DEFAULT){
        print('timeout');
        return null;
      }
      if(e.response != null){

        if(e.response.statusCode == 404){
          print('404');
          print(e.response.statusCode);
        }else if(e.response.statusCode == 400){

          print(e.response.statusCode);
          print(e.request.data);
          print(e.response.data['message']);

        }

      }

    }


    return universityList;
  }

}