import 'package:cluves/models/repoClass/club_list_item.dart';
import 'package:dio/dio.dart';

import '../../constants/local_storage.dart';
import 'package:hive/hive.dart';

import '../../constants/responses/general_responses.dart';
import '../../constants/responses/login_responses.dart';
import '../../constants/responses/sign_up_responses.dart';
import 'club.dart';
import 'user.dart';

const String baseRoute = 'http://192.168.26.96:8080';

const String apiRoute = '$baseRoute/api';

const String usersRoute = '$apiRoute/users';
const String usersSignInRoute = '$usersRoute/sign_in';

const String clubsRoute = '$apiRoute/clubs';
const String getClubsRoute = '$clubsRoute/get_clubs';

class DioClient{
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseRoute,
      connectTimeout: 4000
    )
  )..interceptors.add(Login());


  DioClient();

  login(Map<String, dynamic> loginData) async {
    try {
      Response result = await _dio.post(
        usersSignInRoute,
        data: loginData,
      );
      return result.data as Map<String, dynamic>;
    }on DioError catch(e){
      if(e.response == null){
        return {"error": generalErrorOccurred};
      }
      switch(e.response!.statusCode){
        case(404):
          return {"error": userDNE};
        case(700):
          return {"error": notAllFieldsAreFilled};
        case(704):
          return {"error": wrongPassword};
        default:
          return {"error": generalErrorOccurred};
      }
    } catch(e) {
      return {"error": generalErrorOccurred};
    }
  }

  signup(Map<String, dynamic> signUpData) async {
    try {
      return await _dio.post(
        usersRoute,
        data: signUpData,
      );
    } on DioError catch(e){
      if(e.response == null){
        return {"error": generalErrorOccurred};
      }
      switch(e.response!.statusCode){
        case(700):
          return {"error": notAllFieldsAreFilled};
        case(703):
          return {"error": userAlreadyExists};
        case(705):
          return {"error": emailAlreadyExists};
        default:
          return {"error": generalErrorOccurred};
      }
    } catch(e){
      return {"error": generalErrorOccurred};
    }
  }

  getSelf() async {
    try{
      Response<dynamic> result = await _dio.get(usersRoute);
      User user = User.fromJson(result.data);
      return user;
    } catch (e) {
      return User.unknown();
    }
  }

  Future<Club> fetchClub(String nick) async {
    try {
      Response response = await _dio.get(
          clubsRoute,
          queryParameters: {
            'nick': nick
          }
      );
      return Club.fromJson(response.data as Map<String, dynamic>);
    } catch(e){
      print(e);
      return Club.unknown();
    }
  }

  fetchClubs(String key) async {
    try {
      Response response = await _dio.get(
          getClubsRoute,
          queryParameters: {
            'nick': key
          }
      );
      return List<ClubListItem>.from(response.data['clubs'].map((el) => ClubListItem(nick: el['nick'], profileImage: el['profile_image'], type: el['type'])));
    }catch(e){
      return <ClubListItem>[];
    }
  }

  deleteAccount(Map<String, dynamic> data) async {
    try {
      return await _dio.delete(
        usersRoute,
        data: data,
      );
    } on DioError catch(err) {
      print(err.message);
    }
  }
}

class Login extends Interceptor{

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if(_needAuthorizationHeader(options)){
      var box = Hive.box(localStorageKey);
      String? jwt = box.get(localStorageJWT);
      options.headers['x-access-token'] = jwt;
    }
    return handler.next(options);
  }

  bool _needAuthorizationHeader(RequestOptions options) {
    if (usersSignInRoute == options.path ||
        (usersRoute == options.path && options.method == "POST")
    ) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // print(response);
    return handler.next(response);
  }
}
