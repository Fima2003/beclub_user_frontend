part of 'signup_screen.dart';

class ExtraForm extends StatefulWidget {
  final GlobalKey<FormState> _key;
  const ExtraForm(this._key, {Key? key}) : super(key: key);

  @override
  State<ExtraForm> createState() => _ExtraFormState();
}

class _ExtraFormState extends State<ExtraForm> {
  final List<String> genders = <String>["Male", "Female", "Other"];
  final DateRangePickerController _controller = DateRangePickerController();

  Widget genderInput(){
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state){
        return FormField<String>(
          autovalidateMode: AutovalidateMode.always,
          validator: (value) {
            return ['Male', 'Female', 'Other'].contains(context.read<SignUpBloc>().state.gender)
                ? null
                : "Select appropriate gender";
          },
          builder: (FormFieldState<String> formState){
            return Padding(
              padding: const EdgeInsets.only(bottom: kMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Gender: "),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<String>(
                        value: state.gender,
                        items: genders.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (val) => context.read<SignUpBloc>().add(SignUpGenderChange(val!)),
                        underline: Container(
                          height: 1,
                          color: formState.hasError ? kRed : kBlack
                        ),
                      ),
                      if (formState.hasError)
                        Text(formState.errorText!, style: Theme.of(context).textTheme.labelSmall)
                    ],
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }

  Widget datePicker(){
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        _controller.selectedDate = state.birth;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Date of birth: "),
            FormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (val) => context.read<SignUpBloc>().state.birth != null && context.read<SignUpBloc>().state.birthCorrect ? null : "You must be at least 18 years old",
              builder: (FormFieldState formState){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 5,
                      child: SfDateRangePicker(
                        selectionTextStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 15),
                        initialDisplayDate: _controller.selectedDate,
                        controller: _controller,
                        onSelectionChanged: (args) {
                          var dateArr = DateFormat("y-M-d")
                              .format(args.value)
                              .toString()
                              .split("-");
                          var date = DateTime.utc(int.parse(dateArr[0]),
                              int.parse(dateArr[1]), int.parse(dateArr[2]));
                          context.read<SignUpBloc>().add(SignUpDateChange(date));
                        }
                      ),
                    ),
                    if (formState.hasError)
                      Container(
                        child: Text(formState.errorText!, style: Theme.of(context).textTheme.labelSmall),
                        padding: EdgeInsets.symmetric(vertical: 20),
                      )
                  ],
                );
              }
            ),
          ],
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
          genderInput(),
          datePicker()
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}