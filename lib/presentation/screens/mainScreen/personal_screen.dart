import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/palette.dart';
import '../../../logic/user/user_bloc.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({Key? key}) : super(key: key);

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(state.nick),
              Column(
                children: [
                  OutlinedButton(
                    onPressed: (){},
                    style: OutlinedButton.styleFrom(
                        fixedSize: Size(size.width, 50),
                        side: const BorderSide(color: kBlack, width: 2),
                        backgroundColor: Colors.transparent
                    ),
                    child: const Text("Sign out", style: TextStyle(color: kBlack, fontSize: 22, fontWeight: FontWeight.w700),),
                  ),
                  SizedBox(
                    width: size.width,
                    height: 10,
                  ),
                  OutlinedButton(
                    onPressed: (){},
                    style: OutlinedButton.styleFrom(
                        fixedSize: Size(size.width, 50),
                        side: const BorderSide(color: kRed, width: 2),
                        backgroundColor: Colors.transparent
                    ),
                    child: const Text("Delete account", style: TextStyle(color: kRed, fontSize: 22, fontWeight: FontWeight.w700),),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
