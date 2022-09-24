import '../../presentation/screens/signUpScreen/signup_screen.dart';

import '../../presentation/screens/screens.dart';
import 'package:flutter/material.dart';

import '../../constants/routes_names.dart';

class GeneratedRouter{

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
      case mainScreenRouteName:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case splashScreenRouteName:
        return MaterialPageRoute(builder: (_) => const SplashScreenPage());
      case meetPageRouteName:
        return MaterialPageRoute(builder: (_) => const MeetScreen());
      case logInPageRouteName:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case alternateMeetPageRouteName:
        return MaterialPageRoute(builder: (_) => const AlternateMeetScreen());
      case alternateLogInPageRouteName:
        return MaterialPageRoute(builder: (_) => const AlternateLoginScreen());
      case signUpPageRouteName:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/test':
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text("Success"))));
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text("No such route exists"))));
    }
  }
}


class Empty extends StatelessWidget {
  const Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text("Nothing yet")
      ),
    );
  }
}
