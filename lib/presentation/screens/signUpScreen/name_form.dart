part of 'signup_screen.dart';

class NameForm extends StatefulWidget {
  final GlobalKey<FormState> _key;
  const NameForm(this._key, {Key? key}) : super(key: key);

  @override
  State<NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {

  Widget firstNameInput(){
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Container(
            margin: const EdgeInsets.only(bottom: kMargin),
            child: TextFormField(
              initialValue: state.firstName.value,
              autofocus: true,
              autocorrect: false,
              cursorColor: kGreen,
              decoration: const InputDecoration(
                  labelText: "Enter your first name"
              ),
              validator: (val) => state.firstNameCorrect ? null : "Your first name can include letters only",
              textInputAction: TextInputAction.next,
              onChanged: (val) => context.read<SignUpBloc>().add(SignUpFirstNameChange(val)),
            )
        );
      },
    );
  }

  Widget lastNameInput(){
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Container(
            margin: EdgeInsets.only(bottom: kMargin),
            child: TextFormField(
              initialValue: state.lastName.value,
              autofocus: true,
              autocorrect: false,
              cursorColor: kGreen,
              decoration: const InputDecoration(
                  labelText: "Enter your last name"
              ),
              validator: (val) => state.lastNameCorrect ? null : "Your last name can include letters only",
              textInputAction: TextInputAction.next,
              onChanged: (val) => context.read<SignUpBloc>().add(SignUpLastNameChange(val)),
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
          firstNameInput(),
          lastNameInput()
        ],
      ),
    );
  }
}