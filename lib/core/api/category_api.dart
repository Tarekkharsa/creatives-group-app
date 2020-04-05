import 'package:creativesapp/core/models/category.dart';
import 'package:creativesapp/core/services/CacheInterceptor.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';

class CategoryApi {
  Category category;
  List<Category> categoryListApi;
  final dio = Dio()..interceptors.add(CacheInterceptor());


  Future<List<Category>> getCategories() async {
    print("getCategories");
    try {
      Response response = await dio.get("${Constants.URL}getCategories",options: Options());
      if (response.statusCode == 200) {
        categoryListApi = Category.fromJsonList(response.data['data']);
        print(response);
      }
    } catch (e) {
      return null;
    }
    return categoryListApi;
  }
}
