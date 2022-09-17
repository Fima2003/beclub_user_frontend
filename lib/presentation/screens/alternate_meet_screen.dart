import 'package:beclub/constants/routesNames.dart';
import 'package:flutter/material.dart';

import '../../constants/palette.dart';

class AlternateMeetScreen extends StatelessWidget {
  const AlternateMeetScreen({Key? key}) : super(key: key);
  signUp(){

  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [kWhite, kBlack],
            radius: 3
          )
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 50),
              height: size.height*0.1,
              child: Center(
                child: Text(
                  "Cluves",
                  style: Theme.of(context).textTheme.displayLarge
                )
              )
            ),
            Container(
              width: size.width*0.45,
              height: size.height*0.05,
              margin: EdgeInsets.symmetric(vertical: 30),
              child: TextButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(alternateLogInPageRouteName);
                },
                child: const Text("Log In", style: TextStyle(color: kWhite)),
              ),
            ),
            Container(
                width: size.width*0.45,
                height: size.height*0.05,
                child: OutlinedButton(
                    onPressed: signUp,
                    child: const Text("Sign Up", style: TextStyle(color: kBlack))
                )
            )
          ],
        ),
      )
    );
  }
}
