import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/palette.dart';
import '../../logic/internet/internet_cubit.dart';
import '../../logic/login/login_bloc.dart';
import '../../models/animations/shake_animation.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  double kMargin = 20;
  String error = "";
  final shakeKey = GlobalKey<ShakeWidgetState>();
  FocusNode originalFNode = FocusNode();
  FaIcon originalIcon = const FaIcon(
    FontAwesomeIcons.eyeSlash,
    color: kBlack,
  );
  bool originalObscure = true;

  @override
  void initState() {
    originalFNode.addListener(() {
      if(originalFNode.hasFocus){
        setState(() {
          if(originalObscure){
            originalIcon = const FaIcon(FontAwesomeIcons.eyeSlash, color: kGreen);
          }else{
            originalIcon = const FaIcon(FontAwesomeIcons.eye, color: kGreen);
          }
        });
      }else{
        setState(() {
          if(originalObscure){
            originalIcon = const FaIcon(FontAwesomeIcons.eyeSlash, color: kBlack);
          }else{
            originalIcon = const FaIcon(FontAwesomeIcons.eye, color: kBlack);
          }
        });
      }
    });
    super.initState();
  }

  Widget usernameInput(){
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(bottom: kMargin),
          child: TextFormField(
            autofocus: true,
            autocorrect: false,
            cursorColor: kGreen,
            decoration: const InputDecoration(
                labelText: "Enter your username or e-mail"
            ),
            validator: (val) => state.usernameEmailCorrect ? null : "Make sure you entered something",
            textInputAction: TextInputAction.next,
            onChanged: (val) => context.read<LoginBloc>().add(LoginUsernameEmailChange(val)),
          )
        );
      },
    );
  }

  Widget passwordInput(){
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(bottom: kMargin),
          child: TextFormField(
            focusNode: originalFNode,
            initialValue: state.password.value,
            autocorrect: false,
            cursorColor: kGreen,
            obscureText: originalObscure,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: "Enter your password",
              errorMaxLines: 3,
              suffixIcon: IconButton(
                icon: originalIcon,
                onPressed: (){
                  setState(() {
                    originalObscure = !originalObscure;
                    if(originalFNode.hasFocus){
                      originalIcon = originalObscure ? const FaIcon(FontAwesomeIcons.eyeSlash, color: kGreen,) : const FaIcon(FontAwesomeIcons.eye, color: kGreen,);
                    }else{
                      originalIcon = originalObscure ? const FaIcon(FontAwesomeIcons.eyeSlash, color: kBlack,) : const FaIcon(FontAwesomeIcons.eye, color: kBlack,);
                    }
                  });
                },
              )
            ),
            textInputAction: TextInputAction.done,
            validator: (val) => state.passwordCorrect ? null : "Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character(@\$!%*?&_.)",
            onChanged: (val) => context.read<LoginBloc>().add(LoginPasswordChange(val)),
          )
        );
      },
    );
  }

  Widget submitButton(Size size){
    return Builder(
      builder: (context) {
        final loginState = context.watch<LoginBloc>();
        final internetState = context.watch<InternetCubit>();
        if(loginState.state.status.isSubmissionInProgress){
          return Container(
            width: size.width,
            height: 50,
            color: kBlack,
            child: const Center(child: CircularProgressIndicator(color: kWhite,)),
          );
        } else {
          return Container(
            width: size.width,
            height: 50,
            child: TextButton(
              child: const Text("Log in", style: TextStyle(color: kWhite)),
              onPressed: () {
                if(internetState.state is InternetDisconnected || loginState.state.error != "") {
                  shakeKey.currentState?.shake();
                }else if(_formKey.currentState!.validate()){
                  context.read<LoginBloc>().add(LoginSubmitted());
                }
              },
            ),
          );
        }
      },
    );
  }

  Widget errorText(String error){
    return error != "" ? ShakeWidget(
      key: shakeKey,
      shakeOffset: 10,
      shakeDuration: const Duration(milliseconds: 500),
      child: Container(
          margin: const EdgeInsets.only(top: 10),
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
          )
      ),
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

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
        create: (context) => LoginBloc(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: kMargin),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Log In",
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.left
                    ),
                  ),
                ),
                usernameInput(),
                passwordInput(),
                submitButton(size),
                Builder(
                  builder: (context) {
                    final loginState = context.watch<LoginBloc>();
                    final internetState = context.watch<InternetCubit>();
                    if(internetState.state is InternetDisconnected){
                      return errorText("Could not connect to Internet");
                    } else if(loginState.state.error != ""){
                      return errorText(loginState.state.error);
                    } else {
                      error = "";
                      return Container();
                    }
                  },
                )
              ],
            ),
          ),
        ),
),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

