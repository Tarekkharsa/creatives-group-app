import 'package:creativesapp/core/api/category_api.dart';
import 'package:creativesapp/core/api/coaches_api.dart';
import 'package:creativesapp/core/api/configuratio_api.dart';
import 'package:creativesapp/core/api/course_api.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/Configuration.dart';
import 'package:creativesapp/core/models/category.dart';
import 'package:creativesapp/core/models/coach.dart';
import 'package:creativesapp/core/models/course.dart';
import '../../locator.dart';
import 'base_model.dart';

class AboutModel extends BaseModel {

  ConfigurationApi _configurationApi = locator<ConfigurationApi>();
  List<Configuration> configurations ;
  String emailAddress ,metaTitle ,AboutDescription ,privacy,phone1;
  Future getConfigurations() async {
    setState(ViewState.Busy);
    configurations= await _configurationApi.getConfigurations();


    for (var x in configurations) {
      if(x.key == 'EmailAddress1'){
        emailAddress = x.value;
      }else if(x.key == 'MetaTitle'){
        metaTitle = x.value;
      }else if(x.key == 'About'){
        AboutDescription = x.value;
      }else if(x.key == 'Phone1'){
        phone1 = x.value;
      }else if(x.key == 'privacy'){
        privacy = x.value;
      }
    }
    setState(ViewState.Idle);
  }
}
