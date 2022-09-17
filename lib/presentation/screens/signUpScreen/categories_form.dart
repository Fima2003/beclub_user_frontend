part of 'signup_screen.dart';

class CategoriesForm extends StatefulWidget {
  final GlobalKey<FormState> _key;
  const CategoriesForm(this._key, {Key? key}) : super(key: key);

  @override
  State<CategoriesForm> createState() => _CategoriesFormState();
}

class _CategoriesFormState extends State<CategoriesForm> {
  final List<String> categories = ["Cars", "Beauty", "Books", "Business", "Careers", "Education", "Family and parenting", "Food", "Gaming", "Movies", "Health", "Entertainment", "Music", "Science"];

  @override
  void initState() {
    super.initState();
  }

  Widget card(String category, BuildContext context, SignUpState state){
    return ChoiceChip(
      label: Text(category),
      labelStyle: state.categories.contains(category) ? Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhite) : Theme.of(context).textTheme.bodyMedium!.copyWith(color: kBlack),
      labelPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      selected: state.categories.contains(category),
      onSelected: (selectedChip){
        if(selectedChip){
          context.read<SignUpBloc>().add(SignUpCategoriesChange([...state.categories, category]));
        }else{
          List<String> selected = [...state.categories];
          selected.remove(category);
          context.read<SignUpBloc>().add(SignUpCategoriesChange(selected));
        }
      },
      selectedColor: kGreen,
      shadowColor: kBlack,
    );
  }

  @override
  Widget build(BuildContext context) {
    // selected = context.read<SignUpBloc>().state.categories;
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Form(
          key: widget._key,
          child: FormField(
            validator: (value) => state.categories.length >= 3 ? null : "Choose at least three categories",
            builder: (FormFieldState formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: categories.map((e) => card(e, context, state)).toList(),
                  ),
                  if(formState.hasError)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(formState.errorText!, style: Theme.of(context).textTheme.labelSmall),
                    )
                ],
              );
            }
          )
        );
      }
    );
  }
}
