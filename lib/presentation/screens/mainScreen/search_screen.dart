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
      padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
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
                  try {
                    var response = await DioClient().fetchClubs(val);
                    if(response != false) {
                      List<dynamic> clubs = jsonDecode(response.toString())['clubs'];
                      setState(() {
                        results = clubs != null ? clubs.map((el) {
                          return {
                            "_id": el['_id']! as String,
                            "nick": el['nick']! as String,
                            "profile_image": el['profile_image']! as String,
                            "type": el['type']! as String
                          };
                        }).toList() : [];
                      });
                    }
                  } on DioError catch(e){
                    // TODO add handling errors
                    print(e);
                  }
                }
              });
            },
            decoration: InputDecoration(
              hintText: "Enter username of a club",
              hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(color: kBlack.withOpacity(0.5)),
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
              contentPadding: const EdgeInsets.all(11),
              suffixIcon: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.circleXmark,
                  color: searchController.text != "" ? kRed : kBlack.withOpacity(.5),
                ),
                onPressed: (){
                  if(_timer != null && _timer!.isActive) _timer?.cancel();
                  searchController.clear();
                  setState(() {
                    results = [];
                  });
                },
              )
            ),
          ),
          results.isNotEmpty
            ? ListView.builder(
                itemCount: results.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return SearchResult(
                    nick: results[index]['nick']!,
                    url: results[index]['profile_image']!,
                    type: results[index]['type']!
                  );
                },
              )
            : Container(
                margin: const EdgeInsets.only(top: 20),
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
  final String nick;
  final String url;
  final String type;
  const SearchResult({Key? key, required this.nick, required this.url, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(url),
      ),
      title: Text(nick),
      trailing: clubs()[type]?['icon'] as Widget,
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClubScreen(nick))
        );
      },
    );
  }
}

