import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/local_storage.dart';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import './models/router/router.dart';
import './constants/palette.dart';
import './constants/routes_names.dart';
import './logic/internet/internet_cubit.dart';
import 'logic/user/user_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  var containsEncryptionKey = await secureStorage.containsKey(key: 'hiveEncryptionKey');
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: 'hiveEncryptionKey', value: base64UrlEncode(key));
  }
  var encryptionKey = base64Url.decode((await secureStorage.read(key: 'hiveEncryptionKey'))!);

  await Hive.initFlutter();
  await Hive.openBox(localStorageKey, encryptionCipher: HiveAesCipher(encryptionKey));

  runApp(MyApp(connectivity: Connectivity()));
}

class MyApp extends StatelessWidget {
  final Connectivity connectivity;
  const MyApp({required this.connectivity, super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetCubit>(
          lazy: false,
          create: (context) => InternetCubit(connectivity: connectivity),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cluvs',
        theme: ThemeData(
          fontFamily: 'Comfortaa',
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: kBlack, width: 2),
              borderRadius: BorderRadius.circular(0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: kGreen, width: 2),
              borderRadius: BorderRadius.circular(0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: kRed, width: 2),
              borderRadius: BorderRadius.circular(0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: kRed, width: 2),
              borderRadius: BorderRadius.circular(0),
            ),
            labelStyle: const TextStyle(color: kBlack)
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w500,
              color: kBlack
            ), // For Big-big names
            labelSmall: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: kRed
            ), // For Errors
            bodyMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: kBlack
            ), // For usual text
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: kBlack,
              textStyle: const TextStyle(color: kWhite, fontWeight: FontWeight.w700, fontSize: 20, fontFamily: 'Comfortaa'),
            )
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              backgroundColor: kWhite,
              side: const BorderSide(color: kBlack, width: 2),
              // textStyle: const TextStyle(color: kBlack, fontWeight: FontWeight.w700, fontSize: 20)
            )
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent
          )
        ),
        onGenerateRoute: GeneratedRouter.generateRoute,
        initialRoute: splashScreenRouteName,
      ),
    );
  }
}