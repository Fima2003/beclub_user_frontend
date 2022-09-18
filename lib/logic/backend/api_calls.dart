import 'package:beclub/constants/api_routes.dart';
import 'package:beclub/constants/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

Future<bool> isAuthorized() async{
  var box = Hive.box(localStorageKey);
  String? JWT = box.get(localStorageJWT);
  if(JWT == null){
    return Future.value(false);
  }
  try {
    await Dio().get(
        baseRoute,
        options: Options(
            headers: {
              "x-access-token": JWT
            }
        )
    );
    return Future.value(true);
  } on DioError catch(err){
    return Future.value(false);
  }
}

login(Map<String, dynamic> loginData) async {
  return await Dio().post(
    usersSignInRoute,
    data: loginData
  );
}

signup(Map<String, dynamic> signUpData) async {
  return await Dio().post(
      usersRoute,
      data: signUpData
  );
}