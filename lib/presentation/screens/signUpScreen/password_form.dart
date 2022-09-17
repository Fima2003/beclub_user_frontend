part of 'signup_screen.dart';

class PasswordForm extends StatefulWidget {
  final GlobalKey<FormState> _key;
  const PasswordForm(this._key, {Key? key}) : super(key: key);

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {

  FocusNode originalFNode = FocusNode();
  FaIcon originalIcon = const FaIcon(
    FontAwesomeIcons.eyeSlash,
    color: kBlack,
  );
  bool originalObscure = true;
  FocusNode repeatFNode = FocusNode();
  FaIcon repeatIcon = const FaIcon(
    FontAwesomeIcons.eyeSlash,
    color: kBlack,
  );
  bool repeatObscure = true;

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
    repeatFNode.addListener(() {
      if(repeatFNode.hasFocus){
        setState(() {
          if(repeatObscure){
            repeatIcon = const FaIcon(FontAwesomeIcons.eyeSlash, color: kGreen);
          }else{
            repeatIcon = const FaIcon(FontAwesomeIcons.eye, color: kGreen);
          }
        });
      }else{
        setState(() {
          if(repeatObscure){
            repeatIcon = const FaIcon(FontAwesomeIcons.eyeSlash, color: kBlack);
          }else{
            repeatIcon = const FaIcon(FontAwesomeIcons.eye, color: kBlack);
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    originalFNode.dispose();
    repeatFNode.dispose();
    super.dispose();
  }

  Widget passwordInput(){
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Container(
            margin: const EdgeInsets.only(bottom: kMargin),
            child: Focus(
              child: TextFormField(
                focusNode: originalFNode,
                autofocus: true,
                initialValue: state.password.value,
                autocorrect: false,
                cursorColor: kGreen,
                obscureText: originalObscure,
                enableSuggestions: false,
                decoration: InputDecoration(
                    errorMaxLines: 3,
                    labelText: "Enter your password",
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
                onFieldSubmitted: (String value){
                  FocusScope.of(context).requestFocus(repeatFNode);
                },
                textInputAction: TextInputAction.next,
                validator: (val) => state.passwordCorrect ? null : "Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character(@\$!%*?&_.)",
                onChanged: (val) => context.read<SignUpBloc>().add(SignUpPasswordChange(val)),
              ),
            )
        );
      },
    );
  }

  Widget passwordRepeatInput(){
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Container(
            margin: const EdgeInsets.only(bottom: kMargin),
            child: TextFormField(
              focusNode: repeatFNode,
              autocorrect: false,
              cursorColor: kGreen,
              obscureText: repeatObscure,
              enableSuggestions: false,
              decoration: InputDecoration(
                  labelText: "Repeat your password",
                  suffixIcon: IconButton(
                    icon: repeatIcon,
                    onPressed: (){
                      setState(() {
                        repeatObscure = !repeatObscure;
                        repeatIcon = repeatObscure ? const FaIcon(FontAwesomeIcons.eyeSlash, color: kGreen,) : const FaIcon(FontAwesomeIcons.eye, color: kGreen,);
                      });
                    },
                  )
              ),
              textInputAction: TextInputAction.done,
              validator: (String? val) => val == state.password.value ? null : "Password does not match your original password",
            )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          passwordInput(),
          passwordRepeatInput()
        ],
      ),
    );
  }
}