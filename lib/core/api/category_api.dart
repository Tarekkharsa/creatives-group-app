import 'package:creativesapp/core/models/category.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';

class CategoryApi {
  Category category;
  List<Category> categoryListApi;



  Future<List<Category>> getCategories() async {
    print("getCategories");
    try {
      Response response = await Dio().get("${Constants.URL}getCategories");
      if (response.statusCode == 200) {
        categoryListApi = Category.fromJsonList(response.data['data']);
//        print(response);
      }
    } catch (e) {
      return null;
    }
    return categoryListApi;
  }
}
