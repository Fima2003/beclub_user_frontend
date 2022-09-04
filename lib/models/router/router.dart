import '../../presentation/screens/screens.dart';
import 'package:flutter/material.dart';

import '../../constants/routesNames.dart';

class GeneratedRouter{

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
      case meetPageRouteName:
        return MaterialPageRoute(builder: (_) => const MeetScreen());
      case logInPageRouteName:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signUpPageRouteName:
        return MaterialPageRoute(builder: (_) => const Scaffold());
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
