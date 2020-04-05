import 'dart:async';
import 'dart:io';

import 'package:creativesapp/core/api/category_api.dart';
import 'package:creativesapp/core/api/coaches_api.dart';
import 'package:creativesapp/core/api/course_api.dart';
import 'package:creativesapp/core/api/university_api.dart';
import 'package:creativesapp/core/api/user_api.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/category.dart';
import 'package:creativesapp/core/models/coach.dart';
import 'package:creativesapp/core/models/course.dart';
import 'package:creativesapp/core/models/university.dart';
import 'package:creativesapp/core/models/user.dart';
import 'package:creativesapp/core/services/user_manager.dart';
import 'package:creativesapp/core/utils/Constants.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../locator.dart';
import 'base_model.dart';

class ProfileModel extends BaseModel {
  UniversityApi _universityApi = locator<UniversityApi>();
  UserApi _userApi = locator<UserApi>();
  User _user = new User();
  int _id;
  List<University> _universities = [];
  String university_id;
  University _selectedUniversity;




  University get selectedUniversity => _selectedUniversity;

  void setSelectedUniversity(University value) {
    _selectedUniversity = value;
    notifyListeners();
  }






  String setUniversityId(String id) {
    print(id);
    university_id = id;
    notifyListeners();
  }

  String get UniversityId => university_id;

  get universities => _universities;

  void setUniversities(List<University> universitiesList) {
    _universities = universitiesList;
    notifyListeners();
  }

  get user => _user;

  void setUser(User user) {
    university_id = user?.university_id;
    _user = user;
    notifyListeners();
  }

  Future<List<University>> getUniversities() async {
    setState(ViewState.Busy);
    List<University> res = await _universityApi.getUniversities();

    print(res);
    setUniversities(res);
    setState(ViewState.Idle);
    return res;
  }

  Future<User> updateUser(data) async {
    print('update user');
    print(data);
    setState(ViewState.Busy);
    User res = await _userApi.updateUser(data);
    print(res);
    setUser(res);
    setState(ViewState.Idle);
    return res;
  }

  Future<User> getUser() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    if(user != null){
    _id = user.getInt(Constants.PREF_ID);
    if (_id != null) {
      setState(ViewState.Busy);
      User res = await _userApi.getUser(_id);
      setUser(res);
//      print(res.university_id);
      setState(ViewState.Idle);
      return res;
    }
    }
    return null;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      print('image null');
    }
    if (image != null) {

      this.uploadImage(image);
    }
  }

  Future<String> uploadImage(File file) async {
    print('upload image');
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path, filename: fileName),
      'id': _id,
    });
    setState(ViewState.imageUpload);
    User result = await _userApi.updateUser(formData);
    setUser(result);
    setState(ViewState.Idle);
    print(result);
    if (result != null) {
      print(result);
    } else {
      print('time out in update user');
    }
  }


}
