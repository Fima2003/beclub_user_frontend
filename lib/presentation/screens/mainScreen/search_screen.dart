part of 'main_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  Timer? _timer;
  List<ClubListItem> results = [];
  final searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Search", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 36)),
        TextField(
          autofocus: true,
          controller: searchController,
          onChanged: (String val) {
            setState(() {});
            if(_timer != null && _timer!.isActive) _timer?.cancel();
            _timer = Timer(const Duration(milliseconds: 500), () async {
              if(val != "") {
                var response = await DioClient().fetchClubs(val);
                setState(() {
                  results = response;
                });
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
                  clubListItem: results[index],
                );
              },
            )
          : Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: Text("No results found", style: Theme.of(context).textTheme.bodyMedium)
            )
      ],
    );
  }

  @override
  void dispose() {
    if(_timer != null && _timer!.isActive) _timer!.cancel();
    super.dispose();
  }
}

class SearchResult extends StatelessWidget {
  final ClubListItem clubListItem;
  const SearchResult({Key? key, required this.clubListItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(clubListItem.profileImage),
      ),
      title: Text(clubListItem.nick),
      trailing: clubs()[clubListItem.type]?['icon'] as Widget,
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClubScreen(clubListItem.nick))
        );
      },
    );
  }
}

