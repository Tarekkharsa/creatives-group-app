import 'package:creativesapp/core/api/configuratio_api.dart';
import 'package:creativesapp/core/api/login_api.dart';
import 'package:creativesapp/core/api/register_api.dart';
import 'package:creativesapp/core/api/university_api.dart';
import 'package:creativesapp/core/enums/viewstate.dart';
import 'package:creativesapp/core/models/Configuration.dart';
import 'package:creativesapp/core/models/university.dart';
import 'package:creativesapp/core/services/authentication_service.dart';

import '../../locator.dart';
import 'base_model.dart';

class RegisterModel extends BaseModel {

RegisterApi _registerApi =locator<RegisterApi>();
UniversityApi _universityApi =locator<UniversityApi>();
List<University>  _universities = [];
int university_id = null;

List<Configuration> configurations ;
String facLink,whatsAppNum , youtubeLink, instagramLink;
ConfigurationApi _configurationApi =locator<ConfigurationApi>();


int setUniversityId(int id ){
  print(id);
  university_id = id;
  notifyListeners();
}

int get UniversityId => university_id;

get universities  => _universities;

void setUniversities(List<University>  universitiesList){
  _universities = universitiesList;
  notifyListeners();
}



  Future<int> register(data) async {
    setState(ViewState.Busy);
    var res = await _registerApi.register(data);
    setState(ViewState.Idle);
    return res;
  }

Future<List<University>> getUniversities() async {
  setState(ViewState.Busy);
  var res = await _universityApi.getUniversities();
  setUniversities(res);
  setState(ViewState.Idle);
  return res;

}


Future getConfigurations() async {
  setState(ViewState.Busy);
  configurations= await _configurationApi.getConfigurations();
  for (var x in configurations) {
    print(x.key);
    if(x.key == 'FacebookPage'){
      facLink = x.value;

    }else if(x.key == 'YoutubeChannel'){
      youtubeLink = x.value;
    }else if(x.key == 'WahtsappNumber'){
      whatsAppNum = x.value;
    }else if(x.key == 'InstagramAccount'){
      instagramLink = x.value;
    }
  }

  setState(ViewState.Idle);
}

}
