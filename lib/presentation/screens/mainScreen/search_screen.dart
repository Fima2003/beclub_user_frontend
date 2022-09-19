part of 'main_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  Timer? _timer;
  List<Map<String, String>> results = [];
  final searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Search", style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w700)),
          TextField(
            autofocus: true,
            controller: searchController,
            onChanged: (String val) {
              setState(() {});
              if(_timer != null && _timer!.isActive) _timer?.cancel();
              _timer = Timer(const Duration(milliseconds: 500), () async {
                if(val != "") {
                  var response = await fetchClubs(val);
                  List<dynamic> clubs = jsonDecode(response.toString())['clubs'];
                  setState((){
                    results = clubs.map((el){
                      return {
                        "_id": el['_id']! as String,
                        "nick": el['nick']! as String,
                        "profile_image": el['profile_image']! as String
                      };
                    }).toList();
                  });
                }
              });
            },
            decoration: InputDecoration(
              labelText: "Enter username of a club",
              labelStyle: Theme.of(context).textTheme.labelSmall!.copyWith(color: kBlack.withOpacity(0.5)),
              enabledBorder: const UnderlineInputBorder(
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
              contentPadding: EdgeInsets.all(11),
              suffixIcon: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.circleXmark,
                  color: searchController.text != "" ? kRed : kBlack.withOpacity(.5),
                ),
                onPressed: (){
                  if(_timer != null && _timer!.isActive) _timer?.cancel();
                  searchController.clear();
                  setState(() {});
                },
              )
            ),
          ),
          results.isNotEmpty
            ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: results.map((e) => SearchResult(
                  name: e['nick']!,
                  url: e['profile_image']!,
                  id: e['_id']!,
                )).toList(),
              ),
            )
            : Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Text("No results found", style: Theme.of(context).textTheme.bodyMedium)
              )
        ],
      ),
    );
  }

  @override
  void dispose() {
    if(_timer != null && _timer!.isActive) _timer!.cancel();
    super.dispose();
  }
}

class SearchResult extends StatelessWidget {
  final String name;
  final String url;
  final String id;
  const SearchResult({Key? key, required this.name, required this.url, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialButton(
      padding: EdgeInsets.all(0),
      onPressed: (){
        print(id);
      },
      minWidth: size.width*0.9,
      height: size.height*0.08,
      shape: Border(
        bottom: BorderSide(
          color: kBlack.withOpacity(.2)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(url),
            ),
          ),
          Text(name, style: Theme.of(context).textTheme.bodyMedium,)
        ],
      ),
    );
  }
}

