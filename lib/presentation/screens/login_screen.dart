import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/palette.dart';
import '../../logic/internet/internet_cubit.dart';
import '../../logic/login/login_bloc.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  double kMargin = 20;
  String error = "";

  @override
  void initState() {
    super.initState();
  }

  Widget usernameInput(){
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(bottom: kMargin),
          child: TextFormField(
            focusNode: _usernameFocusNode,
            autofocus: true,
            autocorrect: false,
            cursorColor: kGreen,
            decoration: const InputDecoration(
                labelText: "Enter your nick or e-mail"
            ),
            validator: (val) => state.usernameCorrect ? null : "Ensure you entered correct username or e-mail",
            textInputAction: TextInputAction.next,
            onChanged: (val) => context.read<LoginBloc>().add(LoginUsernameChange(val)),
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
            focusNode: _passwordFocusNode,
            autocorrect: false,
            cursorColor: kGreen,
            obscureText: true,
            enableSuggestions: false,
            decoration: const InputDecoration(
                labelText: "Enter your password",
            ),
            textInputAction: TextInputAction.done,
            validator: (val) => state.passwordCorrect ? null : "Ensure you entered correct password",
            onChanged: (val) => context.read<LoginBloc>().add(LoginPasswordChange(val)),
          )
        );
      },
    );
  }

  Widget submitButton(Size size){
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if(state.status.isSubmissionInProgress){
          return Container(
            width: size.width,
            height: 50,
            color: kBlack,
            child: const Center(child: CircularProgressIndicator(color: kWhite,)),
          );
        }else {
          return Container(
            width: size.width,
            height: 50,
            child: TextButton(
              child: const Text("Log in", style: TextStyle(color: kWhite)),
              onPressed: () {
                if(_formKey.currentState!.validate()){
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
    return error != "" ? Container(
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
              Text(
                error,
                style: Theme.of(context).textTheme.labelSmall,
              )
            ]
        )
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
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}

