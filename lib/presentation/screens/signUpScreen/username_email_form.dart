part of 'signup_screen.dart';

class UsernameEmailForm extends StatefulWidget {
  final GlobalKey<FormState> _key;
  const UsernameEmailForm(this._key, {Key? key}) : super(key: key);

  @override
  State<UsernameEmailForm> createState() => _UsernameEmailFormState();
}

class _UsernameEmailFormState extends State<UsernameEmailForm> {

  Widget emailInput(){
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Container(
            margin: const EdgeInsets.only(bottom: kMargin),
            child: TextFormField(
              initialValue: state.email.value,
              autofocus: (state.error != userAlreadyExists) ? true : false,
              autocorrect: false,
              cursorColor: kGreen,
              decoration: const InputDecoration(
                labelText: "Enter your e-mail",
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (val) => state.emailCorrect ? null : "Not a valid e-mail address",
              textInputAction: TextInputAction.next,
              onChanged: (val) => context.read<SignUpBloc>().add(SignUpEmailChange(val)),
            )
        );
      },
    );
  }

  Widget usernameInput(){
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Container(
            margin: const EdgeInsets.only(bottom: kMargin),
            child: TextFormField(
              initialValue: state.username.value,
              autofocus: state.error == userAlreadyExists ? true : false,
              autocorrect: false,
              cursorColor: kGreen,
              decoration: const InputDecoration(
                  labelText: "Enter your username",
                  errorMaxLines: 2
              ),
              validator: (val) => state.usernameCorrect ? null : "Lowercase letters, underscore and dots only. At least 3 characters, at most 12.",
              textInputAction: TextInputAction.done,
              onChanged: (val) => context.read<SignUpBloc>().add(SignUpUsernameChange(val)),
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
          emailInput(),
          usernameInput()
        ],
      ),
    );
  }

  @override
  void dispose(){
    print("Hello");
    super.dispose();
  }
}
