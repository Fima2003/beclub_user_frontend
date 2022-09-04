import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './models/router/router.dart';
import './constants/palette.dart';
import './constants/routesNames.dart';
import './logic/internet/internet_cubit.dart';

void main() {
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
          create: (context) => InternetCubit(connectivity: connectivity),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cluvs',
        theme: ThemeData(
          fontFamily: 'Comfortaa',
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: kBlack, width: 1),
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
            ),
            labelSmall: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: kRed
            )
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: kBlack,
              textStyle: const TextStyle(color: kWhite, fontWeight: FontWeight.w700, fontSize: 20),
            )
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              backgroundColor: kWhite,
              side: const BorderSide(color: kBlack, width: 2),
              textStyle: const TextStyle(color: kBlack, fontWeight: FontWeight.w700, fontSize: 20)
            )
          )
        ),
        onGenerateRoute: GeneratedRouter.generateRoute,
        initialRoute: meetPageRouteName,
      ),
    );
  }
}