import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/palette.dart';
import '../../logic/internet/internet_cubit.dart';
import '../../logic/login/login_bloc.dart';

class AlternateLoginScreen extends StatefulWidget {
  const AlternateLoginScreen({Key? key}) : super(key: key);

  @override
  State<AlternateLoginScreen> createState() => _AlternateLoginScreenState();
}

class _AlternateLoginScreenState extends State<AlternateLoginScreen> {
  final _usernameFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  double kMargin = 20;
  bool username = true;
  String error = "";

  Widget usernameInput(){
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state){
        return Form(
          key: _usernameFormKey,
          child: Container(
            margin: EdgeInsets.all(kMargin),
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  autocorrect: false,
                  cursorColor: kBlack,
                  initialValue: state.usernameEmail.value,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: kBlack)
                    ),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: kBlack)
                    ),
                    errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: kRed)
                    ),
                    focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: kRed)
                    ),
                    contentPadding: EdgeInsets.all(kMargin),
                    labelText: "USERNAME",
                    labelStyle: const TextStyle(color: kBlack, fontSize: 10, fontWeight: FontWeight.w600)
                  ),
                  onChanged: (val) {
                    context.read<LoginBloc>().add(LoginUsernameEmailChange(val));
                    if (error == "No user was found") {
                      error = "";
                    }
                  },
                  validator: (val) => state.usernameEmailCorrect ? null : "Check your username",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                    ),
                    Container(child: Text("1/2", style: Theme.of(context).textTheme.bodySmall,),),
                    Container(
                      padding: EdgeInsets.all(0),
                      child: IconButton(
                        icon: FaIcon(FontAwesomeIcons.arrowRight),
                        onPressed: (){
                          if(_usernameFormKey.currentState!.validate()){
                            setState(() {
                              username = false;
                            });
                          }
                        },
                        padding: EdgeInsets.all(0),
                        iconSize: 20,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget passwordInput(){
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state){
        if(state.error == "No user was found"){
          setState(() {
            username = true;
          });
        }
      },
      builder: (context, state){
        return Form(
          key: _passwordFormKey,
          child: Container(
            margin: EdgeInsets.all(kMargin),
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  autocorrect: false,
                  cursorColor: kBlack,
                  initialValue: state.password.value,
                  decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kBlack)
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kBlack)
                      ),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kRed)
                      ),
                      focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kRed)
                      ),
                      contentPadding: EdgeInsets.all(kMargin),
                      labelText: "PASSWORD",
                      labelStyle: const TextStyle(color: kBlack, fontSize: 10, fontWeight: FontWeight.w600)
                  ),
                  obscureText: true,
                  onChanged: (val) {
                    context.read<LoginBloc>().add(LoginPasswordChange(val));
                    if (error == "Wrong password") {
                      error = "";
                    }
                  },
                  validator: (val) => state.passwordCorrect ? null : "Check your Password",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      child: IconButton(
                        icon: FaIcon(FontAwesomeIcons.arrowLeft),
                        onPressed: (){
                          setState(() {
                            username = true;
                          });
                        },
                        padding: EdgeInsets.all(0),
                        iconSize: 20,
                      ),
                    ),
                    Container(child: Text("2/2", style: Theme.of(context).textTheme.bodySmall,),),
                    Container(
                      padding: EdgeInsets.all(0),
                      child: state.status.isSubmissionInProgress
                          ? CircularProgressIndicator(color: kBlack,)
                          : IconButton(
                        icon: FaIcon(FontAwesomeIcons.circleCheck),
                        onPressed: () async {
                          if(error == "" && _passwordFormKey.currentState!.validate()){
                            context.read<LoginBloc>().add(LoginSubmitted());
                          }
                        },
                        padding: EdgeInsets.all(0),
                        iconSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget errorText(String error){
    return error != "" ? Row(
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
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: Container(
          height: size.height,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [kWhite, kBlack],
              radius: 3
            )
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(left: kMargin/2),
                height: size.height*0.1,
                width: size.width,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () => {Navigator.pop(context)},
                  splashRadius: 25,
                ),
              ),
              Container(
                height: size.height*0.2,
                alignment: Alignment.center,
                child: Text("Login", style: Theme.of(context).textTheme.displayLarge,),
              ),
              username ? usernameInput() : passwordInput(),
              Builder(
                builder: (context){
                  final loginState = context.watch<LoginBloc>();
                  final internetState = context.watch<InternetCubit>();
                  if(internetState.state is InternetDisconnected){
                    error = "No internet connection";
                    return errorText("No internet connection");
                  }else if(loginState.state.error != ""){
                    error = loginState.state.error;
                    return errorText(loginState.state.error);
                  }else{
                    error = "";
                    return Container();
                  }
                }
              )
            ],
          )
        ),
      ),
    );
  }
}
