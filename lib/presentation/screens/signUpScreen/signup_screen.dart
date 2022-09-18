import 'package:beclub/constants/responses/sign_up_responses.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../constants/palette.dart';
import '../../../constants/routes_names.dart';
import '../../../logic/internet/internet_cubit.dart';
import '../../../logic/signup/sign_up_bloc.dart';
import '../../../models/animations/shake_animation.dart';

part 'password_form.dart';
part 'username_email_form.dart';
part 'name_form.dart';
part 'extra_form.dart';
part 'categories_form.dart';

const kMargin = 20.0;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final List<GlobalKey<FormState>> keys;
  late final List<Widget> forms;
  final shakeKey = GlobalKey<ShakeWidgetState>();
  String error = "";
  int index = 0;
  late int prevIndex;

  @override
  void initState() {
    keys = List.generate(5, (index) => GlobalKey<FormState>());
    forms = [UsernameEmailForm(keys[0]), PasswordForm(keys[1]), NameForm(keys[2]), ExtraForm(keys[3]), CategoriesForm(keys[4])];
    super.initState();
  }

  Widget signUpButton(Size size){
    return Builder(
      builder: (context) {
        final signupState = context.watch<SignUpBloc>();
        final internetState = context.watch<InternetCubit>();
        if(signupState.state.status.isSubmissionInProgress){
          return Container(
            width: size.width,
            height: 50,
            color: kBlack,
            child: const Center(child: CircularProgressIndicator(color: kWhite,)),
          );
        } else {
          return SizedBox(
            width: size.width,
            height: 50,
            child: TextButton(
              child: const Text("Sign Up", style: TextStyle(color: kWhite)),
              onPressed: () {
                if(internetState.state is InternetDisconnected || signupState.state.error != "") {
                  shakeKey.currentState?.shake();
                }else if(keys.last.currentState!.validate()){
                  context.read<SignUpBloc>().add(SignUpSubmitted());
                }
              },
            ),
          );
        }
      },
    );
  }

  Widget errorText(String error, Size size){
    return error != "" ? Container(
        margin: const EdgeInsets.only(top: 10),
        child: ShakeWidget(
          key: shakeKey,
          shakeOffset: 10,
          shakeDuration: const Duration(milliseconds: 500),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const FaIcon(
                      FontAwesomeIcons.circleXmark,
                      color: kRed,
                      size: 15
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    error,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                )
              ]
          ),
        )
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => {Navigator.pop(context)},
          splashRadius: 25,
        ),
      ),
      body: BlocProvider(
        create: (context) => SignUpBloc(),
        child: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state){
            if(state.status.isSubmissionSuccess){
              Navigator.popAndPushNamed(context, mainScreenRouteName);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(kMargin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(bottom: kMargin),
                  child: Text("Register", style: Theme.of(context).textTheme.displayLarge)
                ),
                BlocListener<SignUpBloc, SignUpState>(
                  listener: (ctx, state){
                    if(state.error == userAlreadyExists || state.error == emailAlreadyExists){
                      setState(() {
                        prevIndex = index;
                        index = 0;
                      });
                    }
                  },
                  child: forms[index],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    index != 0 ? IconButton(
                      onPressed: (){
                        setState(() {
                          prevIndex = index;
                          index--;
                        });
                      },
                      icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 24,)
                    ) : const SizedBox(width: 50, height: 50,),
                    Text("${index + 1}/${forms.length}"),
                    index != forms.length - 1
                    ? IconButton(
                      onPressed: (){
                        if(keys[index].currentState!.validate()){
                          setState(() {
                            prevIndex = index;
                            index++;
                          });
                        }
                      },
                      icon: const FaIcon(FontAwesomeIcons.arrowRight)
                    )
                    : const SizedBox(
                      width: 50,
                      height: 50,
                    )
                  ],
                ),
                index == forms.length - 1 ? signUpButton(size) : Container(),
                Builder(
                  builder: (context) {
                    final signupState = context.watch<SignUpBloc>();
                    final internetState = context.watch<InternetCubit>();
                    if(internetState.state is InternetDisconnected){
                      return errorText("Could not connect to Internet", size);
                    } else if(signupState.state.error != ""){
                      return errorText(signupState.state.error, size);
                    } else {
                      error = "";
                      return Container();
                    }
                  },
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}