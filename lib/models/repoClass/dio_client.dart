import 'dart:convert';

import 'package:dio/dio.dart';

import '../../constants/local_storage.dart';
import 'package:hive/hive.dart';

import 'user.dart';

const String baseRoute = 'http://132.69.192.170:8080';

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
  var box = Hive.box(localStorageKey);
  String? _JWT;

  DioClient(){
    _JWT = box.get(localStorageJWT);
  }

  login(Map<String, dynamic> loginData) async {
    return await _dio.post(
      usersSignInRoute,
      data: loginData,
    );
  }

  signup(Map<String, dynamic> signUpData) async {
    return await _dio.post(
      usersRoute,
      data: signUpData,
    );
  }


  isAuthorized() async{
    if(_JWT == null){
      return Future.value(false);
    }
    try {
      await _dio.get(
        baseRoute,
        options: Options(
          headers: {
            "x-access-token": _JWT,
          },
        )
      );
      return Future.value(true);
    } on DioError catch(err){
      return Future.value(false);
    }
  }

  getSelf() async{
    if(_JWT == null){
      return User.unknown();
    }
    try{
      Response<dynamic> result = await _dio.get(
        usersRoute,
        options: Options(
          headers: {
            "x-access-token": _JWT,
          }
        )
      );
      User user = User.fromJson(result.data);
      return user;
    }catch (e) {
      return User.unknown();
    }
  }

  fetchClub(String nick) async {
    var box = Hive.box(localStorageKey);
    String? JWT = box.get(localStorageJWT);
    if(JWT == null){
      return Future.value(false);
    }
    return await _dio.get(
        clubsRoute,
        queryParameters: {
          'nick': nick
        },
        options: Options(
          headers: {
            "x-access-token": JWT
          },
        )
    );
  }

  fetchClubs(String key) async {
    var box = Hive.box(localStorageKey);
    String? JWT = box.get(localStorageJWT);
    if(JWT == null){
      return Future.value(false);
    }
    return await _dio.get(
      getClubsRoute,
      queryParameters: {
        'nick': key
      },
      options: Options(
        headers: {
          "x-access-token": JWT
        },
      )
    );
  }
}

class Login extends Interceptor{

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
