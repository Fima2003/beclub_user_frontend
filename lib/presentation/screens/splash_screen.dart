import '../../models/repoClass/dio_client.dart';
import '../../presentation/screens/mainScreen/main_screen.dart';
import '../../presentation/screens/meet_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import '../../constants/palette.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  Future<Widget> loadFromFuture() async {
    return await DioClient().isAuthorized() ? Future.value(const MainScreen()) : Future.value(const MeetScreen());
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      navigateAfterFuture: loadFromFuture(),
      title: Text("Cluvs", style: Theme.of(context).textTheme.displayLarge,),
      backgroundColor: kWhite,
      loaderColor: kRed,
    );
  }
}
