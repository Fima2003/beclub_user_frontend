import 'package:beclub/constants/routesNames.dart';
import 'package:flutter/material.dart';

import '../../constants/palette.dart';

class MeetScreen extends StatelessWidget {
  const MeetScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(
                height: size.height*0.9,
                child: Center(
                    child: Text(
                        "Cluves",
                        style: Theme.of(context).textTheme.displayLarge
                    )
                )
            ),
            Container(
              height: size.height*0.1,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width*0.45,
                    height: size.height*0.05,
                    child: TextButton(
                      onPressed: (){
                        Navigator.of(context).pushNamed(logInPageRouteName);
                      },
                      child: const Text("Log In", style: TextStyle(color: kWhite)),
                    ),
                  ),
                  Container(
                    width: size.width*0.45,
                    height: size.height*0.05,
                    child: OutlinedButton(
                      onPressed: (){
                        Navigator.of(context).pushNamed(signUpPageRouteName);
                      },
                      child: const Text("Sign Up", style: TextStyle(color: kBlack))
                    )
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}
