import 'package:cluves/constants/local_storage.dart';
import 'package:cluves/constants/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../constants/palette.dart';
import '../../../logic/user/user_bloc.dart';
import '../../../models/repoClass/dio_client.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({Key? key}) : super(key: key);

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {

  signOutAlertDialog(BuildContext context){
    return AlertDialog(
      title: const Text("Are you sure you want to sign out?"),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text("Cancel", style: TextStyle(color: kWhite, fontSize: 16, fontWeight: FontWeight.w200),),
        ),
        TextButton(
          onPressed: (){
            var box = Hive.box(localStorageKey);
            box.delete(localStorageJWT);
            Navigator.of(context).pushNamedAndRemoveUntil(meetPageRouteName, (route) => false);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
          ),
          child: const Text("Sign out", style: TextStyle(color: kBlack, fontSize: 16, fontWeight: FontWeight.w200),),
        )
      ],
    );
  }

  deleteAccountAlertDialog(BuildContext context, String nick){
    return AlertDialog(
      title: Text("Are you sure you want to delete your account?"),
      content: Text("You will not be able to restore any information about your account"),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text("Cancel", style: TextStyle(color: kWhite, fontSize: 16, fontWeight: FontWeight.w200),),
        ),
        TextButton(
          onPressed: () async {
            Map<String, dynamic> data = {"nick": nick};
            var result = await DioClient().deleteAccount(data);
            if(result != null){
              Navigator.pushNamedAndRemoveUntil(context, meetPageRouteName, (route) => false);
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
          ),
          child: const Text("Delete account", style: TextStyle(color: kRed, fontSize: 16, fontWeight: FontWeight.w200),),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(state.nick),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return signOutAlertDialog(context);
                    }
                  ),
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(size.width/2 - 24, 40),
                    side: const BorderSide(color: kBlack, width: 2),
                    backgroundColor: Colors.transparent
                  ),
                  child: const Text("Sign out", style: TextStyle(color: kBlack, fontSize: 16, fontWeight: FontWeight.w700),),
                ),
                OutlinedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return deleteAccountAlertDialog(context, state.nick);
                    }
                  ),
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(size.width/2 - 24, 40),
                    side: const BorderSide(color: kRed, width: 2),
                    backgroundColor: Colors.transparent
                  ),
                  child: const Text("Delete account", style: TextStyle(color: kRed, fontSize: 16, fontWeight: FontWeight.w700),),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
